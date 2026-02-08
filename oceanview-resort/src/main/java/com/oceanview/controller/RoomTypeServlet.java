package com.oceanview.controller;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.impl.RoomTypeDAOImpl;
import com.oceanview.model.RoomType;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/roomType")
public class RoomTypeServlet extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // FIX: Generic session check to support both User and Admin models
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listRoomTypes(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteRoomType(request, response);
                    break;
                default:
                    listRoomTypes(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            listRoomTypes(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // FIX: Applied same generic security check for POST
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addRoomType(request, response);
        } else if ("update".equals(action)) {
            updateRoomType(request, response);
        }
    }

    private void listRoomTypes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
        // Forward to the correct management JSP
        request.getRequestDispatcher("/room-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            RoomType roomType = roomTypeDAO.getRoomTypeById(id);
            
            if (roomType != null) {
                request.setAttribute("roomType", roomType);
                request.getRequestDispatcher("/room-type-form.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Room type not found.");
                listRoomTypes(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid Room Type ID.");
            listRoomTypes(request, response);
        }
    }

    private void addRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeName = request.getParameter("typeName");
        String rateStr = request.getParameter("ratePerNight");

        if (typeName == null || typeName.trim().isEmpty()) {
            request.setAttribute("error", "Room category is required.");
            listRoomTypes(request, response);
            return;
        }

        try {
            BigDecimal rate = new BigDecimal(rateStr);
            
            // Check for duplicates before adding
            if (roomTypeDAO.getRoomTypeByName(typeName) != null) {
                request.setAttribute("error", "Category '" + typeName + "' already exists.");
            } else {
                RoomType rt = new RoomType(typeName, rate);
                
                // FIXED: Called void method and set success manually to avoid Type Mismatch
                roomTypeDAO.addRoomType(rt); 
                request.setAttribute("success", "Room type added successfully!");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid rate format or database error.");
            e.printStackTrace();
        }
        listRoomTypes(request, response);
    }

    private void updateRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String typeName = request.getParameter("typeName");
            BigDecimal rate = new BigDecimal(request.getParameter("ratePerNight"));

            RoomType rt = new RoomType();
            rt.setId(id);
            rt.setTypeName(typeName);
            rt.setRatePerNight(rate);

            // FIXED: Handling updateRoomType as void
            roomTypeDAO.updateRoomType(rt);
            request.setAttribute("success", "Room type updated successfully.");
            
        } catch (Exception e) {
            request.setAttribute("error", "Update failed: " + e.getMessage());
        }
        listRoomTypes(request, response);
    }

    private void deleteRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // FIXED: Handling deleteRoomType as void
            roomTypeDAO.deleteRoomType(id);
            request.setAttribute("success", "Room type deleted.");
            
        } catch (Exception e) {
            request.setAttribute("error", "Could not delete. Check if rooms are still assigned to this type.");
        }
        listRoomTypes(request, response);
    }
}