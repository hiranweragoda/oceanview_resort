<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.*, java.time.temporal.ChronoUnit, java.math.BigDecimal" %>
<%@ page isELIgnored="false" %>
<%
    Reservation res = (Reservation) request.getAttribute("reservation");
    RoomType rt = (RoomType) request.getAttribute("roomType");
    
    // Calculate Stay Duration
    long nights = ChronoUnit.DAYS.between(res.getCheckInDate(), res.getCheckOutDate());
    if(nights <= 0) nights = 1; // Minimum 1 night charge
    
    // Calculate Final Price (Price * Nights)
    BigDecimal total = rt.getRatePerNight().multiply(new BigDecimal(nights));
    
    request.setAttribute("nights", nights);
    request.setAttribute("total", total);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bill Calculation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .bill-card { max-width: 550px; margin: 50px auto; border-radius: 15px; }
        #calcResult { display: none; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="card bill-card shadow border-0">
        <div class="card-header bg-success text-white text-center py-3">
            <h4 class="mb-0">Invoice Preview</h4>
        </div>
        <div class="card-body p-4">
            <div class="mb-3 d-flex justify-content-between">
                <span class="text-muted">Reservation:</span>
                <span class="fw-bold">${reservation.reservationNumber}</span>
            </div>
            <div class="mb-3 d-flex justify-content-between">
                <span class="text-muted">Guest Name:</span>
                <span class="fw-bold">${guest.guestName}</span>
            </div>
            
            <div class="mb-3 d-flex justify-content-between">
                <span class="text-muted">Room Type:</span>
                <span class="fw-bold">${roomType.typeName}</span>
            </div>
            <div class="mb-3 d-flex justify-content-between">
                <span class="text-muted">Check-in:</span>
                <span>${reservation.checkInDate}</span>
            </div>
            <div class="mb-3 d-flex justify-content-between">
                <span class="text-muted">Check-out:</span>
                <span>${reservation.checkOutDate}</span>
            </div>

            <hr>

            <div id="calcResult" class="alert alert-success mt-4">
                <div class="text-center">
                    <p class="mb-1">Total Stay: <strong>${nights} Night(s)</strong></p>
                    <h2 class="mb-0 fw-bold">Total: $${total}</h2>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="button" class="btn btn-success btn-lg" onclick="document.getElementById('calcResult').style.display='block'">
                    <i class="bi bi-calculator me-2"></i>Calculate Bill
                </button>
                <div class="d-flex gap-2">
                    <a href="generate-bill?action=list" class="btn btn-outline-secondary w-50">Back to List</a>
                    <button class="btn btn-dark w-50" onclick="window.print()">Print</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>