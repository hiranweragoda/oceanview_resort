<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Reservation for Billing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; height: 100vh; display: flex; align-items: center; }
        .search-card { max-width: 500px; margin: auto; border-radius: 15px; border: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="card search-card shadow-lg p-4">
        <h3 class="text-center mb-4 text-primary"><i class="bi bi-receipt me-2"></i>Generate Bill</h3>
        <p class="text-center text-muted">Search for a reservation to start billing.</p>
        <form action="bill.jsp" method="get">
            <div class="mb-3">
                <label class="form-label fw-bold">Reservation Number</label>
                <input type="text" name="reservationNumber" class="form-control form-control-lg" placeholder="e.g. RES-20260205-0001" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg">View Details</button>
                <a href="staff-dashboard.jsp" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>