<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.oceanview.util.DBConnection" %>
<%
    // Initializing session variables for the header
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String username = (sess != null) ? (String) sess.getAttribute("username") : "Guest";

    if (sess == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Occupancy - Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* Provided Gradient Background and Layout Styles */
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        
        /* Table and Header Styles */
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }
        
        /* Matching the cyan header color from the reference image */
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; }
        
        /* Status and Button Styles */
        .status-badge { font-size: 0.8rem; padding: 5px 12px; border-radius: 20px; }
        .btn-checkin { background-color: #0d6efd; color: white; border-radius: 8px; border: none; }
        .btn-checkout { background-color: #198754; color: white; border-radius: 8px; border: none; }
        .btn-sm { padding: 0.25rem 0.5rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="staff-dashboard.jsp">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= username %>
            </span>
             <li class="nav-item">
                    <a class="nav-link btn btn-outline-light ms-2" href="logout" 
                       onclick="return confirm('Are you sure you want to logout?');">
                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                    </a>
                </li>
        </div>
    </div>
</nav>

<div class="container mt-5">

    <h2 class="mb-4 text-center fw-bold">Guest Check-In / Out</h2>
    <div class="card table-card border-0">
        <div class="list-header d-flex align-items-center">
            <h4 class="mb-0 fw-bold"><i class="bi bi-list-check me-2"></i>Guest Check-In / Out</h4>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th class="ps-4">Res. Number</th>
                        <th>Guest Name</th>
                        <th>Room Type</th>
                        <th>Dates</th>
                        <th>Status</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String sql = "SELECT r.*, g.guest_name, rt.type_name " +
                                         "FROM reservations r " +
                                         "JOIN guests g ON r.guest_id = g.id " +
                                         "JOIN room_types rt ON r.room_type_id = rt.id " +
                                         "ORDER BY r.created_at DESC";
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);

                            while (rs.next()) {
                                String status = rs.getString("status");
                                String resNum = rs.getString("reservation_number");
                    %>
                    <tr class="align-middle">
                        <td class="ps-4 fw-bold text-primary"><%= resNum %></td>
                        <td class="fw-bold"><%= rs.getString("guest_name") %></td>
                        <td><span class="badge bg-secondary"><%= rs.getString("type_name") %></span></td>
                        <td class="small">
                            <%= rs.getDate("check_in_date") %> <i class="bi bi-arrow-right mx-1"></i> <%= rs.getDate("check_out_date") %>
                        </td>
                        <td>
                            <% if ("PENDING".equals(status)) { %>
                                <span class="badge bg-warning text-dark status-badge">Pending</span>
                            <% } else if ("CHECKED_IN".equals(status)) { %>
                                <span class="badge bg-primary status-badge">Checked In</span>
                            <% } else { %>
                                <span class="badge bg-success status-badge">Checked Out</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <form action="UpdateStatusServlet" method="POST" class="d-inline">
                                <input type="hidden" name="resNumber" value="<%= resNum %>">
                                
                                <button type="submit" name="action" value="CHECK_IN" 
                                    class="btn btn-sm btn-checkin me-2 shadow-sm" 
                                    <%= (!"PENDING".equals(status)) ? "disabled" : "" %>>
                                    <i class="bi bi-box-arrow-in-right me-1"></i>Check-In
                                </button>

                                <button type="submit" name="action" value="CHECK_OUT" 
                                    class="btn btn-sm btn-checkout shadow-sm" 
                                    <%= (!"CHECKED_IN".equals(status)) ? "disabled" : "" %>>
                                    <i class="bi bi-box-arrow-left me-1"></i>Check-Out
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-center text-danger py-4'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <a href="<%= "ADMIN".equals(role) ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>" class="btn btn-secondary px-5 py-2 fw-bold shadow-sm">
            <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>