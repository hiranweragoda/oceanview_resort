<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Session and Role Security Check
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
        /* Matching the header color from your reference image */
        .card-header.bg-info { background-color: #0dcaf0 !important; }
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="staff-dashboard.jsp">
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
    <h2 class="mb-4 text-center fw-bold">View & Manage Reservations</h2>

    <%-- Success Message Notification --%>
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <%-- Search Bar Section (Updated to method="get" to fix search reliability) --%>
    <div class="card mb-4 shadow-sm border-0">
        <div class="card-body p-4 bg-white rounded">
            <form action="view-reservation" method="get" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="search">
                <div class="col-md-4">
                    <label class="form-label fw-bold small text-uppercase text-muted">Search By</label>
                    <select class="form-select" name="searchType" required>
                        <option value="reservationNumber" ${param.searchType == 'reservationNumber' ? 'selected' : ''}>Reservation Number</option>
                        <option value="phoneNumber" ${param.searchType == 'phoneNumber' ? 'selected' : ''}>Phone Number</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold small text-uppercase text-muted">Search Value</label>
                    <input type="text" class="form-control" name="searchValue" value="${param.searchValue}" required placeholder="Enter number or phone">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100 py-2">
                        <i class="bi bi-search me-1"></i> Search
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- Reservation List Table --%>
    <div class="card shadow-sm border-0">
        <div class="list-header">
            <h5 class="mb-0"><i class="bi bi-list-task me-2"></i>Reservation List</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead class="table-dark">
                        <tr>
                            <th>Res. Number</th>
                            <th>Guest Name</th>
                            <th>Room Type & Price</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservations}">
                            <tr>
                                <td class="fw-bold text-primary">${r.reservationNumber}</td>
                                <td>
                                    <c:set var="gName" value="Guest ID: ${r.guestId}"/>
                                    <c:forEach var="g" items="${guests}">
                                        <c:if test="${g.id == r.guestId}">
                                            <c:set var="gName" value="${g.guestName}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${gName}
                                </td>
                                <td>
                                    <c:set var="rtInfo" value="Room ID: ${r.roomTypeId}"/>
                                    <c:forEach var="rt" items="${roomTypes}">
                                        <c:if test="${rt.id == r.roomTypeId}">
                                            <c:set var="rtInfo" value="${rt.typeName} ($${rt.ratePerNight})"/>
                                        </c:if>
                                    </c:forEach>
                                    ${rtInfo}
                                </td>
                                <td>${r.checkInDate}</td>
                                <td>${r.checkOutDate}</td>
                                <td>${r.phoneNumber}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="view-reservation?action=edit&reservationNumber=${r.reservationNumber}" 
                                           class="btn btn-sm btn-warning text-white px-3" title="Update">
                                            <i class="bi bi-pencil-square me-1"></i> Update
                                        </a>
                                        
                                        <%-- Cancel Button fixed to pass action parameter via GET --%>
                                        <a href="view-reservation?action=cancel&reservationNumber=${r.reservationNumber}" 
                                           class="btn btn-sm btn-danger px-3" 
                                           onclick="return confirm('Are you sure you want to cancel this reservation?')" 
                                           title="Cancel">
                                            <i class="bi bi-x-circle me-1"></i> Cancel
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty reservations}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                    No reservations found matching your criteria.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <a href="staff-dashboard.jsp" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>