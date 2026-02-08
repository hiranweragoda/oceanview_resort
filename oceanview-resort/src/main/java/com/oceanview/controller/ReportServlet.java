package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin-reports")
public class ReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Security check using the 'role' string to avoid ClassCastException
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Querying based on your provided schema
            stats.put("totalAdmins", getCount(conn, "SELECT COUNT(*) FROM admins"));
            stats.put("totalStaff", getCount(conn, "SELECT COUNT(*) FROM staff"));
            stats.put("totalGuests", getCount(conn, "SELECT COUNT(*) FROM guests"));
            stats.put("totalRooms", getCount(conn, "SELECT COUNT(*) FROM room_types"));
            stats.put("totalReservations", getCount(conn, "SELECT COUNT(*) FROM reservations"));
            
            // Using COALESCE to ensure we don't return null for revenue
            stats.put("totalRevenue", getSum(conn, "SELECT COALESCE(SUM(amount), 0) FROM payments"));

            // Sending the 'stats' map to the JSP
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/reports.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        }
    }

    private int getCount(Connection conn, String sql) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private double getSum(Connection conn, String sql) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
}