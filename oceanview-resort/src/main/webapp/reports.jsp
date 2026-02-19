<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Import models to handle the session user object --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    // Get the session and verify role
    HttpSession sess = request.getSession(false);
    Object sessionUser = (sess != null) ? sess.getAttribute("user") : null;
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    
    // Logic to prevent "null" display by checking various session sources
    String displayAdminName = "Admin"; 

    if (sess == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Extract name from Admin object or username string to fix the null bug
    if (sessionUser instanceof Admin) {
        displayAdminName = ((Admin) sessionUser).getFullname();
    } else if (sess.getAttribute("username") != null) {
        displayAdminName = (String) sess.getAttribute("username");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Overview - Circular Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Gradient background and consistent styling */
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .chart-container { position: relative; height: 350px; width: 350px; margin: auto; }
        .stat-card { border-radius: 15px; border: none; transition: 0.3s; color: white; }
        .bg-admin { background-color: #0d6efd; }
        .bg-staff { background-color: #198754; }
        .bg-guests { background-color: #0dcaf0; }
        .bg-rooms { background-color: #6c757d; }
        .bg-res { background-color: #ffc107; color: #000; }
        .bg-rev { background-color: #dc3545; }
        
        .report-wrapper {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-top: 30px;
        }
    </style>
</head>
<body>

<%-- Updated Blue Header with dynamic name --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="admin-dashboard.jsp">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= displayAdminName %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2 px-3" href="logout" 
               onclick="return confirm('Are you sure you want to logout?');">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4 mb-5">
    <div class="report-wrapper">
        <h2 class="text-center mb-5 fw-bold text-dark">System Distribution Report</h2>

        <div class="row mb-5">
            <div class="col-12 text-center">
                <div class="chart-container">
                    <canvas id="overviewChart"></canvas>
                </div>
                <p class="mt-4 text-muted fw-bold">Proportional System Entity Overview</p>
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

        <div class="text-center mt-5">
            <a href="admin-dashboard.jsp" class="btn btn-secondary px-4">
                <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>
    </div>
</div>

<script>
    const centerRevenuePlugin = {
        id: 'centerRevenue',
        beforeDraw(chart) {
            const { width, height, ctx } = chart;
            ctx.restore();
            
            const revenueText = "$${stats.totalRevenue}";
            const labelText = "TOTAL REVENUE";
            
            ctx.textBaseline = "middle";
            ctx.font = "bold 1.8rem sans-serif";
            ctx.fillStyle = "#dc3545"; 
            const textX = Math.round((width - ctx.measureText(revenueText).width) / 2);
            const textY = height / 2 - 10;
            ctx.fillText(revenueText, textX, textY);

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
                backgroundColor: ['#0d6efd', '#198754', '#0dcaf0', '#6c757d', '#ffc107'],
                hoverOffset: 15,
                borderWidth: 0
            }]
        },
        options: {
            cutout: '80%', 
            plugins: { legend: { display: false } }
        },
        plugins: [centerRevenuePlugin]
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>