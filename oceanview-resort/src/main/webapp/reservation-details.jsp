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
    <title>Reservation Details</title>
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
    <h2 class="mb-4">Reservation Details</h2>

    <div class="card shadow">
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3">Reservation Number</dt>
                <dd class="col-sm-9">${reservation.reservationNumber}</dd>

                <dt class="col-sm-3">Guest Name</dt>
                <dd class="col-sm-9">${guest.guestName}</dd>

                <dt class="col-sm-3">NIC</dt>
                <dd class="col-sm-9">${guest.nic}</dd>

                <dt class="col-sm-3">Phone</dt>
                <dd class="col-sm-9">${reservation.phoneNumber}</dd>

                <dt class="col-sm-3">Address</dt>
                <dd class="col-sm-9">${guest.address}</dd>

                <dt class="col-sm-3">Room Type</dt>
                <dd class="col-sm-9">${roomType.typeName} - $${roomType.ratePerNight}/night</dd>

                <dt class="col-sm-3">Check-in Date</dt>
                <dd class="col-sm-9">${reservation.checkInDate}</dd>

                <dt class="col-sm-3">Check-out Date</dt>
                <dd class="col-sm-9">${reservation.checkOutDate}</dd>

                <dt class="col-sm-3">Status</dt>
                <dd class="col-sm-9">
                    <span class="badge bg-${reservation.status == 'CONFIRMED' ? 'success' : 
                        reservation.status == 'CHECKED_IN' ? 'primary' : 
                        reservation.status == 'CHECKED_OUT' ? 'secondary' : 'danger'}">
                        ${reservation.status}
                    </span>
                </dd>

                <dt class="col-sm-3">Created At</dt>
                <dd class="col-sm-9">${reservation.createdAt}</dd>
            </dl>

            <div class="mt-4">
                <a href="view-reservation" class="btn btn-secondary">Back to List</a>
                <a href="view-reservation?action=edit&reservationNumber=${reservation.reservationNumber}" 
                   class="btn btn-warning">Edit Reservation</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>