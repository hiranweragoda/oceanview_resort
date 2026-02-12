<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;

    if (sess == null || !"STAFF".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Guest for Reservation - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>

    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        /* Matching the header color from your reference image */
        .card-header.bg-info { background-color: #0dcaf0 !important; }
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; }
    </style>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="staff-dashboard.jsp">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= sess.getAttribute("username") %>
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
    <h2 class="mb-4 text-center fw-bold">Select Guest to Create Reservation</h2>

    <div class="card shadow-sm border-0">
        <div class="list-header">
            <h5 class="mb-0"><i class="bi bi-list-task me-2"></i>Guest List</h5>
        </div>
        
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Guest Name</th>
                            <th>NIC</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="g" items="${guests}">
                            <tr>
                                <td>${g.id}</td>
                                <td>${g.guestName}</td>
                                <td>${g.nic}</td>
                                <td>${g.phoneNumber}</td>
                                <td>${g.address}</td>
                                <td>
                                    <a href="add-reservation?guestId=${g.id}" 
                                       class="btn btn-success btn-sm">
                                        <i class="bi bi-plus-circle"></i> Add Reservation
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty guests}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    No registered guests found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <a href="<%= "ADMIN".equals(role) ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>