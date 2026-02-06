<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Reservation for Billing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        /* Match the blue header style from reference */
        .card-header { background-color: #0d6efd; color: white; } 
        .table thead { background-color: #212529; color: white; }
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
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-list-task me-2"></i>Select a Reservation for Billing</h5>
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
                    
                    <%-- Empty State Handling --%>
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
        <a href="staff-dashboard.jsp" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>