package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.dao.impl.*;
import com.oceanview.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/view-reservation")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAOImpl();
    private final GuestDAO guestDAO = new GuestDAOImpl();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            String resNumber = request.getParameter("reservationNumber");
            Reservation res = reservationDAO.getReservationByNumber(resNumber);
            request.setAttribute("reservation", res);
            request.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
            request.getRequestDispatcher("/edit-reservation.jsp").forward(request, response);
        } 
        else if ("cancel".equals(action)) {
            // FIX: Added Cancel Logic
            String resNumber = request.getParameter("reservationNumber");
            if (reservationDAO.deleteReservation(resNumber)) {
                request.setAttribute("success", "Reservation " + resNumber + " cancelled successfully!");
            }
            listReservations(request, response);
        } 
        else if ("search".equals(action)) {
            // FIX: Added Search Logic for GET (optional, but good for UX)
            handleSearch(request, response);
        }
        else {
            listReservations(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            String resNumber = request.getParameter("reservationNumber");
            Reservation res = reservationDAO.getReservationByNumber(resNumber);
            
            res.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            res.setCheckInDate(LocalDate.parse(request.getParameter("checkInDate")));
            res.setCheckOutDate(LocalDate.parse(request.getParameter("checkOutDate")));
            res.setPhoneNumber(request.getParameter("phoneNumber"));

            if (reservationDAO.updateReservation(res)) {
                request.setAttribute("success", "Reservation " + resNumber + " updated successfully!");
            }
            listReservations(request, response);
        } 
        else if ("search".equals(action)) {
            // FIX: Handled Search in POST
            handleSearch(request, response);
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String type = request.getParameter("searchType");
        String value = request.getParameter("searchValue");
        
        List<Reservation> filteredList;
        if ("phoneNumber".equals(type)) {
            filteredList = reservationDAO.searchByPhone(value);
        } else {
            filteredList = reservationDAO.searchByNumber(value);
        }
        
        request.setAttribute("reservations", filteredList);
        request.setAttribute("guests", guestDAO.getAllGuests());
        request.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        request.getRequestDispatcher("/view-reservation.jsp").forward(request, response);
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("reservations", reservationDAO.getAllReservations());
        request.setAttribute("guests", guestDAO.getAllGuests());
        request.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        request.getRequestDispatcher("/view-reservation.jsp").forward(request, response);
    }
}