<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.oceanview.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Occupancy - Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .status-badge { font-size: 0.8rem; padding: 5px 12px; border-radius: 20px; }
        .btn-checkin { background-color: #0d6efd; color: white; border-radius: 8px; } /* Blue */
        .btn-checkout { background-color: #198754; color: white; border-radius: 8px; } /* Green */
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="mb-4 text-center fw-bold">
        <h2 class="mb-4 text-center fw-bold"></i>Guest Check-In / Out</h2>
      
    </div>

    <div class="card table-card">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Res #</th>
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
                    <tr>
                        <td class="ps-4 fw-bold text-primary"><%= resNum %></td>
                        <td><%= rs.getString("guest_name") %></td>
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
                                    class="btn btn-sm btn-checkin me-2" 
                                    <%= (!"PENDING".equals(status)) ? "disabled" : "" %>>
                                    Check-In
                                </button>

                                <button type="submit" name="action" value="CHECK_OUT" 
                                    class="btn btn-sm btn-checkout" 
                                    <%= (!"CHECKED_IN".equals(status)) ? "disabled" : "" %>>
                                    Check-Out
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <% String role = (String) session.getAttribute("role"); %>
    <div class="text-center mt-4">
        <a href="<%= "ADMIN".equals(role) ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>