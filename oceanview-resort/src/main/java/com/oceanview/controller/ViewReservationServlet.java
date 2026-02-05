package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.impl.ReservationDAOImpl;
import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.impl.GuestDAOImpl;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.impl.RoomTypeDAOImpl;
import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
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

@WebServlet("/view-reservation")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAOImpl();
    private final GuestDAO guestDAO = new GuestDAOImpl();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STAFF".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                listReservations(request, response);
                break;
            case "view":
                viewReservation(request, response);
                break;
            case "cancel":
                cancelReservation(request, response);
                break;
            default:
                listReservations(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("search".equals(action)) {
            searchReservations(request, response);
        }
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Fetch all data for the table
        List<Reservation> reservations = reservationDAO.getAllReservations();
        List<Guest> guests = guestDAO.getAllGuests();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();

        request.setAttribute("reservations", reservations);
        request.setAttribute("guests", guests);
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/view-reservation.jsp").forward(request, response);
    }

    private void searchReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");

        List<Reservation> results = null;

        if ("reservationNumber".equals(searchType) && searchValue != null && !searchValue.trim().isEmpty()) {
            Reservation res = reservationDAO.getReservationByNumber(searchValue.trim());
            if (res != null) results = List.of(res);
        } else if ("phoneNumber".equals(searchType) && searchValue != null && !searchValue.trim().isEmpty()) {
            results = reservationDAO.searchByPhone(searchValue.trim());
        }

        // Must provide lookup lists even for search results
        request.setAttribute("reservations", results);
        request.setAttribute("guests", guestDAO.getAllGuests());
        request.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchValue", searchValue);
        request.getRequestDispatcher("/view-reservation.jsp").forward(request, response);
    }

    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resNumber = request.getParameter("reservationNumber");
        Reservation reservation = reservationDAO.getReservationByNumber(resNumber);
        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            request.setAttribute("guest", guestDAO.getGuestById(reservation.getGuestId()));
            request.setAttribute("roomType", roomTypeDAO.getRoomTypeById(reservation.getRoomTypeId()));
            request.getRequestDispatcher("/reservation-details.jsp").forward(request, response);
        } else {
            listReservations(request, response);
        }
    }

    private void cancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resNumber = request.getParameter("reservationNumber");
        if (reservationDAO.cancelReservation(resNumber)) {
            request.setAttribute("success", "Reservation cancelled.");
        }
        listReservations(request, response);
    }
}