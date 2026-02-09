package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Security Check: Only STAFF or ADMIN can update statuses
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || role == null || (!"STAFF".equals(role) && !"ADMIN".equals(role))) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Get parameters from the Check-in/Out JSP
        String resNumber = request.getParameter("resNumber");
        String action = request.getParameter("action");
        
        if (resNumber == null || action == null) {
            response.sendRedirect("check-in-checkout.jsp");
            return;
        }

        // 3. Map the action to the Database ENUM status
        String newStatus;
        if ("CHECK_IN".equals(action)) {
            newStatus = "CHECKED_IN";
        } else if ("CHECK_OUT".equals(action)) {
            newStatus = "CHECKED_OUT";
        } else {
            response.sendRedirect("check-in-checkout.jsp");
            return;
        }

        // 4. Database Update Logic
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE reservations SET status = ? WHERE reservation_number = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setString(2, resNumber);
                
                int rowsUpdated = ps.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Success: Redirect back with a success message
                    response.sendRedirect("check-in-checkout.jsp?success=Status updated to " + newStatus);
                } else {
                    // Failure: Reservation number not found
                    response.sendRedirect("check-in-checkout.jsp?error=Reservation not found");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Database Error: Redirect back with error details
            response.sendRedirect("check-in-checkout.jsp?error=Database error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If someone tries to access via URL directly, send them back to the list
        response.sendRedirect("check-in-checkout.jsp");
    }
}