<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.oceanview.model.User" %>
<%
    HttpSession sess = request.getSession(false);
    User user = (sess != null) ? (User) sess.getAttribute("user") : null;

    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="staff-dashboard.jsp">Ocean View Resort - Staff</a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link">Welcome, <%= user.getUsername() %></span>
            <a class="nav-link" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Edit Reservation</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card shadow">
        <div class="card-body">
            <form action="view-reservation" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="reservationNumber" value="${reservation.reservationNumber}">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Reservation Number</label>
                        <input type="text" class="form-control" value="${reservation.reservationNumber}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Guest ID</label>
                        <input type="text" class="form-control" value="${reservation.guestId}" readonly>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Check-in Date</label>
                        <input type="date" class="form-control" name="checkInDate" 
                               value="${reservation.checkInDate}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Check-out Date</label>
                        <input type="date" class="form-control" name="checkOutDate" 
                               value="${reservation.checkOutDate}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Phone Number</label>
                    <input type="text" class="form-control" name="phoneNumber" 
                           value="${reservation.phoneNumber}" required>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="view-reservation" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>