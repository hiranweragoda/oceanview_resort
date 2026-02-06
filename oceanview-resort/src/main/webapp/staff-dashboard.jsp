<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Staff Dashboard - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .navbar-brand {
            font-weight: 700;
        }
        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        .card-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
        }
        .card-title {
            font-weight: 700;
        }
        .card-text {
            color: #6c757d;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="staff-dashboard.jsp">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort - Staff
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <span class="nav-link fw-bold text-white">
                        <i class="bi bi-person-circle me-2"></i><%= username %>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-light ms-2" href="logout" 
                       onclick="return confirm('Are you sure you want to logout?');">
                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row mb-5">
        <div class="col-12 text-center">
            <h1 class="display-5 fw-bold text-dark mb-2">Staff Dashboard</h1>
            <p class="lead text-muted">Manage daily operations and guest services</p>
        </div>
    </div>

    <div class="row g-4 justify-content-center">
        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-calendar-plus-fill card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">New Reservation</h5>
                    <p class="card-text text-muted">Create booking for registered guests</p>
                    <a href="guests-for-reservation" class="btn btn-primary btn-lg w-75">Create Booking</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-search card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">Find Reservation</h5>
                    <p class="card-text text-muted">Search & manage existing bookings</p>
                    <a href="view-reservation" class="btn btn-primary btn-lg w-75">Search</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-receipt-cutoff card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">Generate Bill</h5>
                    <p class="card-text text-muted">Calculate and print guest invoice</p>
                    <a href="generate-bill?action=list" class="btn btn-primary btn-lg w-75">Generate</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-door-open-fill card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">Check-in / Check-out</h5>
                    <p class="card-text text-muted">Update reservation status</p>
                    <a href="checkin-checkout.jsp" class="btn btn-primary btn-lg w-75">Manage</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-people-fill card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">Guest Management</h5>
                    <p class="card-text text-muted">Register, update & manage guests</p>
                    <a href="guest" class="btn btn-primary btn-lg w-75">Manage Guests</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-lg-3">
            <div class="card h-100 text-center">
                <div class="card-body py-5">
                    <i class="bi bi-question-circle-fill card-icon text-primary"></i>
                    <h5 class="card-title fw-bold">Help & Guidelines</h5>
                    <p class="card-text text-muted">View system usage instructions</p>
                    <a href="help.jsp" class="btn btn-primary btn-lg w-75">View Help</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>