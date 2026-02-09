<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- CRITICAL: You must include this taglib for <c:forEach> and EL to work --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %> 

<!DOCTYPE html>
<html>
<head>
    <title>Payment Records</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <%-- Use the session cleanup logic to fix persisting messages --%>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show">
            ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>

    <h2>Payment Records <span class="badge bg-secondary">Total: ${paymentList.size()}</span></h2>
    
    <div class="card shadow-sm mt-3">
        <table class="table table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
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
                        <td>#${p.id}</td>
                        <td class="fw-bold text-primary">${p.reservationNumber}</td>
                        <td>$${p.amount}</td>
                        <td><span class="badge bg-info text-dark">${p.paymentMethod}</span></td>
                        <td>${p.paymentDate}</td>
                        <td>
                            <a href="payment?action=delete&id=${p.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete record?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>