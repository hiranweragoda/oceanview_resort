<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Overview - Circular Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        /* Adjusted container size for better visibility */
        .chart-container { position: relative; height: 350px; width: 350px; margin: auto; }
        .stat-card { border-radius: 15px; border: none; transition: 0.3s; color: white; }
        .bg-admin { background-color: #0d6efd; }
        .bg-staff { background-color: #198754; }
        .bg-guests { background-color: #0dcaf0; }
        .bg-rooms { background-color: #6c757d; }
        .bg-res { background-color: #ffc107; color: #000; }
        .bg-rev { background-color: #dc3545; }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center mb-5 fw-bold">System Distribution</h2>

    <div class="row mb-5">
        <div class="col-12 text-center">
            <div class="chart-container">
                <canvas id="overviewChart"></canvas>
            </div>
            <p class="mt-3 text-muted">Data proportional to total system entities</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card stat-card bg-admin shadow-sm p-3">
                <div class="card-body">
                    <h6>Total Administrators</h6>
                    <h2>${stats.totalAdmins}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-staff shadow-sm p-3">
                <div class="card-body">
                    <h6>Active Staff</h6>
                    <h2>${stats.totalStaff}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-guests shadow-sm p-3">
                <div class="card-body">
                    <h6>Total Guests</h6>
                    <h2>${stats.totalGuests}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-rooms shadow-sm p-3">
                <div class="card-body">
                    <h6>Room Categories</h6>
                    <h2>${stats.totalRooms}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-res shadow-sm p-3">
                <div class="card-body">
                    <h6>Total Reservations</h6>
                    <h2>${stats.totalReservations}</h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-rev shadow-sm p-3">
                <div class="card-body">
                    <h6>Total Revenue (USD)</h6>
                    <h2>$${stats.totalRevenue}</h2>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Custom Plugin to display Revenue inside the center of the ring
    const centerRevenuePlugin = {
        id: 'centerRevenue',
        beforeDraw(chart) {
            const { width, height, ctx } = chart;
            ctx.restore();
            
            // Text for Revenue
            const revenueText = "$${stats.totalRevenue}";
            const labelText = "TOTAL REVENUE";
            
            ctx.textBaseline = "middle";
            
            // Draw Revenue Amount
            ctx.font = "bold 1.8rem sans-serif";
            ctx.fillStyle = "#dc3545"; // Red color to match Revenue card
            const textX = Math.round((width - ctx.measureText(revenueText).width) / 2);
            const textY = height / 2 - 10;
            ctx.fillText(revenueText, textX, textY);

            // Draw Sub-label
            ctx.font = "bold 0.8rem sans-serif";
            ctx.fillStyle = "#6c757d";
            const labelX = Math.round((width - ctx.measureText(labelText).width) / 2);
            ctx.fillText(labelText, labelX, textY + 35);
            
            ctx.save();
        }
    };

    const ctx = document.getElementById('overviewChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Admins', 'Staff', 'Guests', 'Rooms', 'Reservations'],
            datasets: [{
                data: [
                    ${stats.totalAdmins}, 
                    ${stats.totalStaff}, 
                    ${stats.totalGuests}, 
                    ${stats.totalRooms}, 
                    ${stats.totalReservations}
                ],
                backgroundColor: [
                    '#0d6efd', // Blue
                    '#198754', // Green
                    '#0dcaf0', // Cyan
                    '#6c757d', // Gray
                    '#ffc107'  // Yellow
                ],
                hoverOffset: 15,
                borderWidth: 0
            }]
        },
        options: {
            cutout: '80%', // Thinner ring to look like reference
            plugins: {
                legend: { display: false }
            }
        },
        plugins: [centerRevenuePlugin] // Add the custom revenue text plugin here
    });
</script>
</body>
</html>