package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.dao.impl.*;
import com.oceanview.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/generate-bill")
public class BillServlet extends HttpServlet {
    private final ReservationDAO resDAO = new ReservationDAOImpl();
    private final GuestDAO guestDAO = new GuestDAOImpl();
    private final RoomTypeDAO roomDAO = new RoomTypeDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            
            List<Reservation> reservations;

            // Logic to handle the Search Bar
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                if ("phoneNumber".equals(searchType)) {
                    reservations = resDAO.searchByPhone(searchValue);
                } else {
                    reservations = resDAO.searchByNumber(searchValue);
                }
            } else {
                // If no search value, show all
                reservations = resDAO.getAllReservations();
            }

            request.setAttribute("reservations", reservations);
            request.setAttribute("guests", guestDAO.getAllGuests());
            request.setAttribute("roomTypes", roomDAO.getAllRoomTypes());
            request.getRequestDispatcher("/bill-list.jsp").forward(request, response);
        } 
        else if ("view".equals(action)) {
            String resNum = request.getParameter("reservationNumber");
            Reservation res = resDAO.getReservationByNumber(resNum);
            
            request.setAttribute("reservation", res);
            request.setAttribute("roomType", roomDAO.getRoomTypeById(res.getRoomTypeId()));
            request.setAttribute("guest", guestDAO.getGuestById(res.getGuestId()));
            request.getRequestDispatcher("/bill.jsp").forward(request, response);
        }
    }
}