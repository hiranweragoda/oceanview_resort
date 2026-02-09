<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String username = (sess != null) ? (String) sess.getAttribute("username") : null;

    if (sess == null || !"STAFF".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Guidelines - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .help-card {
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .help-card:hover {
            transform: translateY(-5px);
        }
        .help-icon {
            font-size: 2.5rem;
            color: #0d6efd;
        }
        .section-title {
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="staff-dashboard.jsp">
            <i class="bi bi-building me-2"></i>Ocean View Resort - Staff
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= username %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2" href="logout"
               onclick="return confirm('Are you sure you want to logout?');">
                <i class="bi bi-box-arrow-right me-2"></i>Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h1 class="text-center mb-5">Help & Guidelines</h1>

    <!-- Quick Start -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card help-card text-center h-100">
                <div class="card-body py-5">
                    <i class="bi bi-rocket-takeoff-fill help-icon mb-3"></i>
                    <h5 class="card-title">Quick Start</h5>
                    <p class="card-text">
                        1. Login with your staff credentials<br>
                        2. Go to Dashboard<br>
                        3. Choose your task from the cards
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card help-card text-center h-100">
                <div class="card-body py-5">
                    <i class="bi bi-shield-lock-fill help-icon mb-3"></i>
                    <h5 class="card-title">Security</h5>
                    <p class="card-text">
                        Never share your login details.<br>
                        Logout when leaving the system.<br>
                        Report suspicious activity immediately.
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card help-card text-center h-100">
                <div class="card-body py-5">
                    <i class="bi bi-question-circle-fill help-icon mb-3"></i>
                    <h5 class="card-title">Need Help?</h5>
                    <p class="card-text">
                        Contact IT support:<br>
                        Phone: 077-1234567<br>
                        Email: support@oceanview.lk
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Guidelines -->
    <div class="row g-4">
        <!-- Guest Management -->
        <div class="col-md-6">
            <div class="card help-card">
                <div class="card-body">
                    <h4 class="section-title"><i class="bi bi-people-fill me-2"></i>Guest Management</h4>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-check2 me-2 text-success"></i>Register new guests with NIC</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Update guest information when needed</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Delete guests only if no active reservations</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Reservation Management -->
        <div class="col-md-6">
            <div class="card help-card">
                <div class="card-body">
                    <h4 class="section-title"><i class="bi bi-calendar-event-fill me-2"></i>Reservations</h4>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-check2 me-2 text-success"></i>Only registered guests can be booked</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Check-in & Check-out dates must be valid</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Cancel reservations before check-in</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Check-in / Check-out (NEW) -->
        <div class="col-md-6">
            <div class="card help-card">
                <div class="card-body">
                    <h4 class="section-title"><i class="bi bi-door-open-fill me-2"></i>Check-in / Check-out</h4>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-check2 me-2 text-success"></i>Verify guest identity before check-in</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Assign room and update status to CHECKED_IN</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Calculate final bill before check-out</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Update status to CHECKED_OUT and mark room available</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Use today's date filter for quick access</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Billing -->
        <div class="col-md-6">
            <div class="card help-card">
                <div class="card-body">
                    <h4 class="section-title"><i class="bi bi-receipt me-2"></i>Billing</h4>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-check2 me-2 text-success"></i>Select reservation first</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Bill = Rate × Nights</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Verify dates before generating</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- General Tips -->
        <div class="col-md-6">
            <div class="card help-card">
                <div class="card-body">
                    <h4 class="section-title"><i class="bi bi-lightbulb-fill me-2"></i>General Tips</h4>
                    <ul class="list-unstyled">
                        <li><i class="bi bi-check2 me-2 text-success"></i>Always logout when leaving the desk</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Use search to find reservations quickly</li>
                        <li><i class="bi bi-check2 me-2 text-success"></i>Contact support for technical issues</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-5">
        <p class="text-muted">Ocean View Resort Staff Portal v1.0 • © 2025</p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>