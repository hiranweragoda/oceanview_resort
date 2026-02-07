<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.*, java.time.temporal.ChronoUnit, java.math.BigDecimal" %>
<%@ page isELIgnored="false" %>
<%
    Reservation res = (Reservation) request.getAttribute("reservation");
    RoomType rt = (RoomType) request.getAttribute("roomType");
    long nights = ChronoUnit.DAYS.between(res.getCheckInDate(), res.getCheckOutDate());
    if(nights <= 0) nights = 1; 
%>
<!DOCTYPE html>
<html>
<head>
    <title>Official Receipt - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .bill-card { max-width: 650px; margin: 40px auto; border-radius: 12px; overflow: hidden; position: relative; border: none; background: white; }
        .resort-header { background-color: #157347; color: white; padding: 30px; text-align: center; }
        .resort-name { font-size: 28px; font-weight: 800; text-transform: uppercase; margin-bottom: 5px; }
        .invoice-label { color: #6c757d; font-size: 0.85rem; text-transform: uppercase; font-weight: 700; }
        .invoice-value { font-weight: 600; color: #212529; }
        .status-badge { background-color: #157347; color: white; padding: 12px; border-radius: 5px; font-weight: bold; text-align: center; margin-bottom: 25px; text-transform: uppercase; }
        .total-box { background-color: #f1f8f5; border-radius: 8px; padding: 25px; border: 1px solid #d1e7dd; margin-top: 20px; }
        .watermark { position: absolute; top: 45%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 110px; font-weight: 900; color: rgba(21, 115, 71, 0.06); z-index: 0; pointer-events: none; }
        
        /* Hides elements during Print or PDF Download */
        @media print {
            .no-print { display: none !important; }
            body { background: white; }
            .bill-card { margin: 0; box-shadow: none; }
        }
    </style>
</head>
<body>
<div class="container">
    <div id="receipt-content" class="card bill-card shadow-lg">
        <div class="watermark">PAID</div>
        <div class="resort-header">
            <div class="resort-name">OCEAN VIEW RESORT</div>
            <div class="small">123 Coastal Drive, Colombo, Sri Lanka<br>+94 11 234 5678 | info@oceanviewresort.com</div>
        </div>

        <div class="card-body p-5">
            <div class="status-badge">Official Payment Receipt</div>
            
            <div class="row mb-3">
                <div class="col-6 invoice-label">Reservation No:</div>
                <div class="col-6 text-end invoice-value">${reservation.reservationNumber}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Guest Name:</div>
                <div class="col-6 text-end invoice-value">${guest.guestName}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Contact Number:</div>
                <div class="col-6 text-end invoice-value">${guest.phoneNumber}</div>
            </div>
            <hr>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Room Type:</div>
                <div class="col-6 text-end invoice-value">${roomType.typeName}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Rate per Night:</div>
                <div class="col-6 text-end invoice-value">$${roomType.ratePerNight}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Check-in Date:</div>
                <div class="col-6 text-end invoice-value">${reservation.checkInDate}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Check-out Date:</div>
                <div class="col-6 text-end invoice-value">${reservation.checkOutDate}</div>
            </div>
            <div class="row mb-3">
                <div class="col-6 invoice-label">Payment Method:</div>
                <div class="col-6 text-end invoice-value text-success fw-bold">${paymentMethod}</div>
            </div>

            <div class="total-box">
                <div class="row align-items-center text-center text-md-start">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <span class="invoice-label">Stay Duration</span><br>
                        <span class="fs-4 fw-bold"><%= nights %> Night(s)</span>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <span class="invoice-label text-success">Total Amount Paid</span><br>
                        <h2 class="mb-0 fw-bold text-success">$${total}</h2>
                    </div>
                </div>
            </div>

            <div class="mt-5 d-grid gap-3 no-print">
                <button class="btn btn-success btn-lg py-3 fw-bold" onclick="downloadReceipt()">Download PDF Receipt</button>
                <button class="btn btn-dark btn-lg py-3 fw-bold" onclick="window.print()">Print Receipt</button>
                <a href="generate-bill?action=list" class="btn btn-outline-secondary py-2">Return to List</a>
            </div>
        </div>
    </div>
</div>

<script>
    function downloadReceipt() {
        const element = document.getElementById('receipt-content');
        const options = {
            margin:       0.5,
            filename:     'Receipt_${reservation.reservationNumber}.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2, useCORS: true },
            jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
        };

        // This removes the "no-print" elements temporarily during download
        const buttons = element.querySelector('.no-print');
        buttons.style.display = 'none';

        html2pdf().set(options).from(element).save().then(() => {
            // Restore buttons after download is triggered
            buttons.style.display = 'grid';
        });
    }
</script>
</body>
</html>