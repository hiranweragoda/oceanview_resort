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
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;  // ← THIS LINE FIXES YOUR ERROR
import java.util.List;
import java.util.stream.Collectors;

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

        List<RoomType> allRoomTypes = roomTypeDAO.getAllRoomTypes();

        List<Reservation> activeReservations = reservationDAO.getReservationsByStatus("CHECKED_IN");

        java.util.Set<Integer> occupiedRoomTypeIds = activeReservations.stream()
                .map(Reservation::getRoomTypeId)
                .collect(Collectors.toSet());

        List<RoomType> availableRoomTypes = allRoomTypes.stream()
                .filter(rt -> !occupiedRoomTypeIds.contains(rt.getId()))
                .collect(Collectors.toList());

        request.setAttribute("roomTypes", availableRoomTypes);

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
                warning = "Invalid guest ID format.";
            }
        }

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
            int guestId = Integer.parseInt(request.getParameter("guestId").trim());
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId").trim());

            LocalDate checkIn = LocalDate.parse(request.getParameter("checkInDate").trim());
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOutDate").trim());

            if (!checkOut.isAfter(checkIn)) {
                throw new IllegalArgumentException("Check-out date must be after the check-in date.");
            }

            String phoneNumber = request.getParameter("phoneNumber");

            Reservation reservation = new Reservation();
            reservation.setReservationNumber(reservationDAO.generateReservationNumber());
            reservation.setGuestId(guestId);
            reservation.setRoomTypeId(roomTypeId);
            reservation.setCheckInDate(checkIn);
            reservation.setCheckOutDate(checkOut);
            reservation.setPhoneNumber(phoneNumber);
            reservation.setStatus("CHECKED_IN");

            if (reservationDAO.addReservation(reservation)) {
                successMsg = "Reservation successful! ID: " + reservation.getReservationNumber();
            } else {
                errorMsg = "System error: Could not save reservation.";
            }

        } catch (NumberFormatException e) {
            errorMsg = "Invalid number format in form data.";
            e.printStackTrace();
        } catch (DateTimeParseException e) {
            errorMsg = "Invalid date format.";
            e.printStackTrace();
        } catch (Exception e) {
            errorMsg = "Booking Error: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("error", errorMsg);
        request.setAttribute("success", successMsg);

        doGet(request, response);
    }
}