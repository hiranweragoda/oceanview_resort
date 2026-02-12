<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Ensure session and role logic is available for the header and dashboard button
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    
    if (sess == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Select Reservation for Billing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        /* ADDED CSS START */
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        /* Matching the header color from your reference image */
        .card-header.bg-info { background-color: #0dcaf0 !important; }
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; }
        /* ADDED CSS END */

        .search-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .btn-success { background-color: #198754; border: none; }
        .btn-success:hover { background-color: #157347; }
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
    <h2 class="text-center mb-4 fw-bold">Generate Guest Bill</h2>

    <div class="search-container">
        <form action="generate-bill" method="get" class="row g-3 align-items-end">
            <input type="hidden" name="action" value="list">
            
            <div class="col-md-4">
                <label class="form-label fw-bold small text-uppercase text-muted">Search By</label>
                <select class="form-select" name="searchType">
                    <option value="reservationNumber" ${param.searchType == 'reservationNumber' ? 'selected' : ''}>Reservation Number</option>
                    <option value="phoneNumber" ${param.searchType == 'phoneNumber' ? 'selected' : ''}>Phone Number</option>
                </select>
            </div>
            
            <div class="col-md-5">
                <label class="form-label fw-bold small text-uppercase text-muted">Search Value</label>
                <input type="text" class="form-control" name="searchValue" 
                       value="${param.searchValue}" placeholder="Enter number or phone">
            </div>
            
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">
                    <i class="bi bi-search me-2"></i>Search
                </button>
                <a href="generate-bill?action=list" class="btn btn-outline-secondary" title="Reset Search">
                    <i class="bi bi-arrow-clockwise"></i>
                </a>
            </div>
        </form>
    </div>
    
    <div class="card shadow-sm border-0">
        <div class="list-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold"><i class="bi bi-list-task me-2"></i>Select a Reservation for Billing</h5>
            <c:if test="${not empty param.searchValue}">
                <span class="badge bg-light text-dark">Filtering by: ${param.searchValue}</span>
            </c:if>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead>
                    <tr>
                        <th>Res. Number</th>
                        <th>Guest Name</th>
                        <th>Room Type & Price</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Phone</th> 
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reservations}">
                        <tr>
                            <td class="fw-bold text-primary">${r.reservationNumber}</td>
                            <td>
                                <c:forEach var="g" items="${guests}">
                                    <c:if test="${g.id == r.guestId}">${g.guestName}</c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="rt" items="${roomTypes}">
                                    <c:if test="${rt.id == r.roomTypeId}">
                                        ${rt.typeName} <span class="text-muted">($${rt.ratePerNight})</span>
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>${r.checkInDate}</td>
                            <td>${r.checkOutDate}</td>
                            <td>${r.phoneNumber}</td> 
                            <td>
                                <a href="generate-bill?action=view&reservationNumber=${r.reservationNumber}" 
                                   class="btn btn-success btn-sm px-3 shadow-sm">
                                   <i class="bi bi-calculator me-1"></i> Generate Bill
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty reservations}">
                        <tr>
                            <td colspan="7" class="py-5 text-muted">
                                <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                No reservations found matching your criteria.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="text-center mt-4 mb-5">
        <a href="<%= "ADMIN".equals(role) ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>