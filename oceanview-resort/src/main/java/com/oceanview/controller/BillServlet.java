package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.dao.impl.*;
import com.oceanview.model.*;
import com.oceanview.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet("/generate-bill")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReservationDAO resDAO = new ReservationDAOImpl();
    private final GuestDAO guestDAO = new GuestDAOImpl();
    private final RoomTypeDAO roomDAO = new RoomTypeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // 1. Navigation to the Payment Processing page
        if ("goToPayment".equals(action)) {
            String resNum = request.getParameter("resNum");
            Reservation res = resDAO.getReservationByNumber(resNum);
            RoomType rt = roomDAO.getRoomTypeById(res.getRoomTypeId());
            
            // Calculation for assignment: Stay Duration * Rate per Night
            long nights = ChronoUnit.DAYS.between(res.getCheckInDate(), res.getCheckOutDate());
            if (nights <= 0) nights = 1; 
            BigDecimal total = rt.getRatePerNight().multiply(new BigDecimal(nights));
            
            request.setAttribute("resNum", resNum);
            request.setAttribute("totalAmount", total);
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
            
        } 
        // 2. View full bill details for a specific reservation
        else if ("view".equals(action)) {
            String resNum = request.getParameter("reservationNumber");
            Reservation res = resDAO.getReservationByNumber(resNum);
            
            request.setAttribute("reservation", res);
            request.setAttribute("guest", guestDAO.getGuestById(res.getGuestId()));
            request.setAttribute("roomType", roomDAO.getRoomTypeById(res.getRoomTypeId()));
            request.getRequestDispatcher("/bill.jsp").forward(request, response);
        }
        // 3. Search and List Logic (Using the working logic you provided)
        else {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            List<Reservation> reservations;

            // Verified logic for Reservation Number and Phone Number searching
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                if ("phoneNumber".equals(searchType)) {
                    reservations = resDAO.searchByPhone(searchValue.trim());
                } else {
                    reservations = resDAO.searchByNumber(searchValue.trim());
                }
                // Feedback for UI badge
                request.setAttribute("filterStatus", searchValue);
            } else {
                reservations = resDAO.getAllReservations();
            }

            // Always include these to populate Guest Name and Price columns in the table
            request.setAttribute("reservations", reservations);
            request.setAttribute("guests", guestDAO.getAllGuests());
            request.setAttribute("roomTypes", roomDAO.getAllRoomTypes());
            request.getRequestDispatcher("/bill-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Handle processing of payments and generating final receipt
        if ("processPayment".equals(action)) {
            String resNum = request.getParameter("resNum");
            String method = request.getParameter("method");
            String amount = request.getParameter("total");

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO payments (reservation_number, amount, payment_method) VALUES (?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, resNum);
                ps.setBigDecimal(2, new BigDecimal(amount));
                ps.setString(3, method);
                ps.executeUpdate();

                // Load all details required for the Receipt screen
                Reservation res = resDAO.getReservationByNumber(resNum);
                request.setAttribute("reservation", res);
                request.setAttribute("guest", guestDAO.getGuestById(res.getGuestId()));
                request.setAttribute("roomType", roomDAO.getRoomTypeById(res.getRoomTypeId()));
                request.setAttribute("paymentMethod", method);
                request.setAttribute("total", amount);
                
                request.getRequestDispatcher("/receipt.jsp").forward(request, response);
            } catch (SQLException e) { 
                throw new ServletException("Database Payment Error", e); 
            }
        }
    }
}