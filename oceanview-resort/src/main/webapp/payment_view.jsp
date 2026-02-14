<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %> 
<%-- Import models to handle the session user object correctly --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    // Initializing session variables for the header
    HttpSession sess = request.getSession(false);
    Object sessionUser = (sess != null) ? sess.getAttribute("user") : null;
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    
    // Logic to prevent "null" display by checking all possible session sources
    String displayName = "User"; 

    if (sess == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Extraction logic: Check for Admin/User objects first, then fallback to username string
    if (sessionUser instanceof Admin) {
        displayName = ((Admin) sessionUser).getFullname();
    } else if (sessionUser instanceof User) {
        displayName = ((User) sessionUser).getUsername();
    } else if (sess.getAttribute("username") != null) {
        displayName = (String) sess.getAttribute("username");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Records - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="<%= "ADMIN".equals(role) ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= displayName %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2 px-3" href="logout" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>

    <h2 class="mb-4 text-center fw-bold text-dark">Payment Records</h2>
    
    <div class="card table-card shadow-sm">
        <div class="list-header">
            <h5 class="mb-0"><i class="bi bi-cash-stack me-2"></i>Transaction History</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead>
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>Reservation #</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Payment Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${paymentList}">
                        <tr>
                            <td class="ps-4">#${p.id}</td>
                            <td class="fw-bold text-primary">${p.reservationNumber}</td>
                            <td class="fw-bold">$${p.amount}</td>
                            <td><span class="badge bg-info text-dark" style="font-size: 0.85rem;">${p.paymentMethod}</span></td>
                            <td>${p.paymentDate}</td>
                            <td>
                                <a href="payment?action=delete&id=${p.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete this payment record?')">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty paymentList}">
                        <tr>
                            <td colspan="6" class="py-5 text-muted">
                                <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                No payment records found.
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