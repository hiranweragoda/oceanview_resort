<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.*, java.time.temporal.ChronoUnit, java.math.BigDecimal" %>
<%@ page isELIgnored="false" %>
<%
    Reservation res = (Reservation) request.getAttribute("reservation");
    RoomType rt = (RoomType) request.getAttribute("roomType");
    
    long nights = ChronoUnit.DAYS.between(res.getCheckInDate(), res.getCheckOutDate());
    if(nights <= 0) nights = 1; 
    
    BigDecimal rate = rt.getRatePerNight();
    BigDecimal total = rate.multiply(new BigDecimal(nights));
    
    request.setAttribute("nights", nights);
    request.setAttribute("rate", rate);
    request.setAttribute("total", total);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice Preview - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .bill-card { max-width: 650px; margin: 40px auto; border-radius: 12px; overflow: hidden; }
        .resort-header { background-color: #157347; color: white; padding: 30px; text-align: center; }
        .resort-name { font-size: 26px; font-weight: 800; letter-spacing: 2px; margin-bottom: 5px; }
        .resort-info { font-size: 14px; opacity: 0.9; line-height: 1.5; }
        .invoice-label { color: #6c757d; font-size: 0.85rem; text-transform: uppercase; font-weight: 700; }
        .invoice-value { font-weight: 600; color: #212529; }
        .total-section { background-color: #f1f8f5; border-radius: 8px; padding: 25px; display: none; border: 1px solid #d1e7dd; }
        
        @media print {
            .no-print { display: none !important; }
            body { background-color: white; }
            .bill-card { margin: 0; max-width: 100%; border: none; box-shadow: none; }
            .total-section { display: block !important; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card bill-card shadow-lg border-0">
        <div class="resort-header">
            <div class="resort-name">OCEAN VIEW RESORT</div>
            <div class="resort-info">
                123 Gnanobasha Mawatha, Oroppuwatta, Galle, Sri Lanka<br>
                <i class="bi bi-telephone-fill"></i> +94 91 222233 | <i class="bi bi-envelope-fill"></i> info@oceanviewresort.com
            </div>
        </div>

        <div class="card-body p-4 p-md-5 bg-white">
            <h5 class="text-center mb-4 text-uppercase fw-bold text-success">Invoice Preview</h5>
            
            <div class="row mb-3">
                <div class="col-5 invoice-label">Reservation No:</div>
                <div class="col-7 text-end invoice-value">${reservation.reservationNumber}</div>
            </div>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Guest Name:</div>
                <div class="col-7 text-end invoice-value text-capitalize">${guest.guestName}</div>
            </div>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Contact Number:</div>
                <div class="col-7 text-end invoice-value">${guest.phoneNumber}</div>
            </div>
            <hr>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Room Type:</div>
                <div class="col-7 text-end invoice-value">${roomType.typeName}</div>
            </div>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Rate per Night:</div>
                <div class="col-7 text-end invoice-value">$${rate}</div>
            </div>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Check-in Date:</div>
                <div class="col-7 text-end invoice-value">${reservation.checkInDate}</div>
            </div>
            <div class="row mb-3">
                <div class="col-5 invoice-label">Check-out Date:</div>
                <div class="col-7 text-end invoice-value">${reservation.checkOutDate}</div>
            </div>

            <div id="calcResult" class="total-section mt-4 shadow-sm">
                <div class="row align-items-center">
                    <div class="col-6">
                        <span class="text-muted d-block small text-uppercase fw-bold">Nights Stayed</span>
                        <span class="fs-5 fw-bold">${nights} Night(s)</span>
                    </div>
                    <div class="col-6 text-end">
                        <span class="text-muted d-block small text-uppercase fw-bold">Total Balance</span>
                        <h2 class="mb-0 fw-bold text-success">$${total}</h2>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4 no-print">
                <button type="button" id="calcBtn" class="btn btn-success btn-lg py-3 fw-bold" onclick="showPaymentOptions()">
                    <i class="bi bi-calculator me-2"></i>Calculate Total
                </button>

                <a href="generate-bill?action=goToPayment&resNum=${reservation.reservationNumber}" 
                   id="payBtn" class="btn btn-primary btn-lg py-3 fw-bold d-none">
                    <i class="bi bi-credit-card me-2"></i>Proceed to Payments
                </a>

                <div class="d-flex gap-2">
                    <a href="generate-bill?action=list" class="btn btn-outline-secondary w-50 py-2">
                        <i class="bi bi-list"></i> Back to List
                    </a>
                    <button class="btn btn-dark w-50 py-2" onclick="window.print()">
                        <i class="bi bi-printer"></i> Print Bill
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showPaymentOptions() {
        document.getElementById('calcResult').style.display = 'block';
        document.getElementById('calcBtn').classList.add('d-none');
        document.getElementById('payBtn').classList.remove('d-none');
    }
</script>
</body>
</html>