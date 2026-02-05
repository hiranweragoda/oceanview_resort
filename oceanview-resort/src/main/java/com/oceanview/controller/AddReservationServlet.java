package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.impl.GuestDAOImpl;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.impl.ReservationDAOImpl;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.impl.RoomTypeDAOImpl;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.model.RoomType;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAOImpl();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAOImpl();
    private final ReservationDAO reservationDAO = new ReservationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STAFF".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);

        String guestIdStr = request.getParameter("guestId");
        Guest preSelectedGuest = null;
        String warning = null;

        if (guestIdStr != null && !guestIdStr.trim().isEmpty()) {
            try {
                int guestId = Integer.parseInt(guestIdStr.trim());
                preSelectedGuest = guestDAO.getGuestById(guestId);
                if (preSelectedGuest == null) {
                    warning = "The selected guest was not found.";
                }
            } catch (NumberFormatException e) {
                warning = "Invalid guest ID in URL.";
            }
        }

        // Using "preSelectedGuest" as the key
        request.setAttribute("preSelectedGuest", preSelectedGuest);
        if (warning != null) request.setAttribute("warning", warning);

        request.getRequestDispatcher("/add-reservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STAFF".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String errorMsg = null;
        String successMsg = null;

        try {
            String guestIdStr = request.getParameter("guestId");
            if (guestIdStr == null || guestIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Guest ID is missing.");
            }
            int guestId = Integer.parseInt(guestIdStr.trim());

            String roomTypeIdStr = request.getParameter("roomTypeId");
            int roomTypeId = Integer.parseInt(roomTypeIdStr.trim());

            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            LocalDate checkIn = LocalDate.parse(checkInStr.trim());
            LocalDate checkOut = LocalDate.parse(checkOutStr.trim());

            if (checkIn.isAfter(checkOut) || checkIn.isEqual(checkOut)) {
                throw new IllegalArgumentException("Check-out must be after check-in.");
            }

            String phoneNumber = request.getParameter("phoneNumber");

            Reservation reservation = new Reservation();
            reservation.setReservationNumber(reservationDAO.generateReservationNumber());
            reservation.setGuestId(guestId);
            reservation.setRoomTypeId(roomTypeId);
            reservation.setCheckInDate(checkIn);
            reservation.setCheckOutDate(checkOut);
            reservation.setPhoneNumber(phoneNumber);

            if (reservationDAO.addReservation(reservation)) {
                successMsg = "Reservation created! No: " + reservation.getReservationNumber();
            } else {
                errorMsg = "Database error.";
            }

        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        request.setAttribute("error", errorMsg);
        request.setAttribute("success", successMsg);
        doGet(request, response);
    }
}