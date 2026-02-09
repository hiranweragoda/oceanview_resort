package com.oceanview.controller;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.impl.RoomTypeDAOImpl;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.impl.ReservationDAOImpl;
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
    private final ReservationDAO reservationDAO = new ReservationDAOImpl();  // Used to check active reservations

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteRoomType(request, response);
        } else {
            listRoomTypes(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                addRoomType(request, response);
            } else if ("update".equals(action)) {
                updateRoomType(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        // After add/update/delete, redirect to list
        response.sendRedirect("roomType");
    }

    private void listRoomTypes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);
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

        if (typeName == null || typeName.trim().isEmpty() || rateStr == null || rateStr.trim().isEmpty()) {
            request.setAttribute("error", "Room type name and rate are required.");
            listRoomTypes(request, response);
            return;
        }

        try {
            BigDecimal rate = new BigDecimal(rateStr.trim());
            RoomType roomType = new RoomType(typeName.trim(), rate);
            boolean added = roomTypeDAO.addRoomType(roomType);

            if (added) {
                request.setAttribute("success", "Room type added successfully!");
            } else {
                request.setAttribute("error", "Failed to add room type.");
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
            BigDecimal rate = new BigDecimal(request.getParameter("ratePerNight").trim());

            RoomType roomType = new RoomType(typeName.trim(), rate);
            roomType.setId(id);

            boolean updated = roomTypeDAO.updateRoomType(roomType);

            if (updated) {
                request.setAttribute("success", "Room type updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update room type.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Update failed: " + e.getMessage());
            e.printStackTrace();
        }

        listRoomTypes(request, response);
    }

    private void deleteRoomType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            // Check if there are any active (CHECKED_IN) reservations for this room type
            boolean hasActiveReservations = reservationDAO.hasActiveReservationsForRoomType(id);

            if (hasActiveReservations) {
                request.setAttribute("error", "Could not delete. Ensure no active reservations are linked to this type.");
            } else {
                boolean deleted = roomTypeDAO.deleteRoomType(id);
                if (deleted) {
                    request.setAttribute("success", "Room type deleted successfully.");
                } else {
                    request.setAttribute("error", "Could not delete. Ensure no active reservations are linked to this type.");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting room type: " + e.getMessage());
            e.printStackTrace();
        }

        listRoomTypes(request, response);
    }
}