<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String username = (sess != null) ? (String) sess.getAttribute("username") : null;

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
    <title>View Reservations - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        .badge { font-size: 0.9rem; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="staff-dashboard.jsp">
            <i class="bi bi-building me-2"></i>Ocean View Resort - Staff
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= username %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2" href="logout"
               onclick="return confirm('Are you sure you want to logout?');">
                <i class="bi bi-box-arrow-right me-2"></i>Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4 text-center">View & Manage Reservations</h2>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form action="view-reservation" method="post" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="search">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Search By</label>
                    <select class="form-select" name="searchType" required>
                        <option value="reservationNumber">Reservation Number</option>
                        <option value="phoneNumber">Phone Number</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Search Value</label>
                    <input type="text" class="form-control" name="searchValue" required placeholder="Enter number or phone">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Search</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Reservation List</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0 text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Res. Number</th>
                            <th>Guest Name</th>
                            <th>Room Type</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservations}">
                            <tr>
                                <td>${r.reservationNumber}</td>
                                <td>
                                    <c:set var="gName" value="ID: ${r.guestId}"/>
                                    <c:forEach var="g" items="${guests}">
                                        <c:if test="${g.id == r.guestId}"><c:set var="gName" value="${g.guestName}"/></c:if>
                                    </c:forEach>
                                    ${gName}
                                </td>
                                <td>
                                    <c:set var="rtName" value="ID: ${r.roomTypeId}"/>
                                    <c:forEach var="rt" items="${roomTypes}">
                                        <c:if test="${rt.id == r.roomTypeId}"><c:set var="rtName" value="${rt.typeName}"/></c:if>
                                    </c:forEach>
                                    ${rtName}
                                </td>
                                <td>${r.checkInDate}</td>
                                <td>${r.checkOutDate}</td>
                                <td>${r.phoneNumber}</td>
                                <td>
                                    <a href="view-reservation?action=view&reservationNumber=${r.reservationNumber}" 
                                       class="btn btn-sm btn-info">
                                        <i class="bi bi-eye"></i> View
                                    </a>
                                    <a href="view-reservation?action=cancel&reservationNumber=${r.reservationNumber}" 
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Are you sure to cancel this reservation?')">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty reservations}">
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    No reservations found in the database.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>