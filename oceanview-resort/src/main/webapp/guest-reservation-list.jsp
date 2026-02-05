<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
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
    <title>Guests - Create Reservation - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="staff-dashboard.jsp">Ocean View Resort - Staff</a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link">Welcome, <%= sess.getAttribute("username") %></span>
            <a class="nav-link" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Registered Guests – Create Reservation</h2>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Guest Name</th>
                            <th>NIC / Passport</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th style="width: 180px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="g" items="${guests}" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>
                                <td>${g.guestName}</td>
                                <td>${g.nic}</td>
                                <td>${g.phoneNumber}</td>
                                <td>${g.address}</td>
                                <td>
                                    <a href="add-reservation?guestId=${g.id}" 
                                       class="btn btn-sm btn-success w-100">
                                        <i class="bi bi-plus-circle me-1"></i>Add Reservation
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

    <div class="mt-4 text-center">
        <a href="staff-dashboard.jsp" class="btn btn-secondary">
            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>