package com.oceanview.controller;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.impl.RoomTypeDAOImpl;
import com.oceanview.model.RoomType;
import com.oceanview.model.User;

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
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "list";
        }

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
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
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
        request.getRequestDispatcher("/room-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "Room type ID is missing.");
            listRoomTypes(request, response);
            return;
        }

        int id = Integer.parseInt(idParam);
        RoomType roomType = roomTypeDAO.getRoomTypeById(id);
        if (roomType == null) {
            request.setAttribute("error", "Room type not found.");
            listRoomTypes(request, response);
            return;
        }

        request.setAttribute("roomType", roomType);
        request.getRequestDispatcher("/room-type-form.jsp").forward(request, response);
    }

    private void addRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeName = request.getParameter("typeName");
        String rateStr = request.getParameter("ratePerNight") != null 
                         ? request.getParameter("ratePerNight").trim() 
                         : "";

        // Validate dropdown selection
        if (typeName == null || typeName.trim().isEmpty()) {
            request.setAttribute("error", "Please select a room type.");
            request.setAttribute("ratePerNight", rateStr);
            listRoomTypes(request, response);
            return;
        }

        typeName = typeName.trim();

        // Enforce only allowed values
        if (!("Standard".equals(typeName) || "Deluxe".equals(typeName) || "Luxury".equals(typeName))) {
            request.setAttribute("error", "Invalid room type selected.");
            request.setAttribute("ratePerNight", rateStr);
            listRoomTypes(request, response);
            return;
        }

        String error = null;

        if (rateStr.isEmpty()) {
            error = "Rate per night is required.";
        }

        BigDecimal rate = null;

        if (error == null) {
            try {
                rate = new BigDecimal(rateStr);
                if (rate.compareTo(BigDecimal.ZERO) <= 0) {
                    error = "Rate must be greater than zero.";
                }
            } catch (NumberFormatException e) {
                error = "Invalid rate format. Please enter a valid number.";
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("ratePerNight", rateStr);
            listRoomTypes(request, response);
            return;
        }

        // Check for duplicate
        if (roomTypeDAO.getRoomTypeByName(typeName) != null) {
            request.setAttribute("error", "Room type '" + typeName + "' already exists.");
            request.setAttribute("ratePerNight", rateStr);
            listRoomTypes(request, response);
            return;
        }

        RoomType roomType = new RoomType(typeName, rate);
        roomTypeDAO.addRoomType(roomType);

        request.setAttribute("success", "Room type '" + typeName + "' added successfully.");
        listRoomTypes(request, response);
    }

    private void updateRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "Room type ID is missing.");
            listRoomTypes(request, response);
            return;
        }

        int id = Integer.parseInt(idParam);
        String typeName = request.getParameter("typeName") != null 
                          ? request.getParameter("typeName").trim() 
                          : "";
        String rateStr = request.getParameter("ratePerNight") != null 
                         ? request.getParameter("ratePerNight").trim() 
                         : "";

        String error = null;

        if (typeName.isEmpty()) {
            error = "Room type name is required.";
        }
        if (rateStr.isEmpty()) {
            error = "Rate per night is required.";
        }

        BigDecimal rate = null;

        if (error == null) {
            try {
                rate = new BigDecimal(rateStr);
                if (rate.compareTo(BigDecimal.ZERO) <= 0) {
                    error = "Rate must be greater than zero.";
                }
            } catch (NumberFormatException e) {
                error = "Invalid rate format. Please enter a valid number.";
            }
        }

        if (error != null) {
            RoomType rt = new RoomType();
            rt.setId(id);
            rt.setTypeName(typeName);
            request.setAttribute("roomType", rt);
            request.setAttribute("error", error);
            request.getRequestDispatcher("/room-type-form.jsp").forward(request, response);
            return;
        }

        RoomType roomType = new RoomType();
        roomType.setId(id);
        roomType.setTypeName(typeName);
        roomType.setRatePerNight(rate);

        boolean updated = roomTypeDAO.updateRoomType(roomType);

        if (updated) {
            request.setAttribute("success", "Room type updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update room type.");
        }

        listRoomTypes(request, response);
    }

    private void deleteRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "Room type ID is missing.");
            listRoomTypes(request, response);
            return;
        }

        int id = Integer.parseInt(idParam);

        boolean deleted = roomTypeDAO.deleteRoomType(id);

        if (deleted) {
            request.setAttribute("success", "Room type deleted successfully.");
        } else {
            request.setAttribute("error", "Failed to delete room type (may be in use by existing reservations).");
        }

        listRoomTypes(request, response);
    }
}