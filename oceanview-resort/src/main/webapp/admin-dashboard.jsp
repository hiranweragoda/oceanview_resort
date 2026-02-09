<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String displayName = "Administrator";

    if (userObj == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (userObj instanceof User) {
        displayName = ((User) userObj).getUsername();
    } else if (userObj instanceof Admin) {
        displayName = ((Admin) userObj).getFullname();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .navbar-brand { font-weight: 700; }
        .card {
            transition: all 0.3s ease;
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            height: 100%;
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
        }
        .icon-blue { color: #0d6efd; }
        .icon-green { color: #198754; }
        .icon-red { color: #dc3545; }
        
        .quick-stats {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }
        .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: #0d6efd;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="admin-dashboard.jsp">
                <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <span class="nav-link fw-bold text-white">
                            <i class="bi bi-person-circle me-2"></i><%= displayName %> (Admin)
                        </span>
                    </li>
                    <li class="nav-item ms-3">
                        <a class="btn btn-danger btn-sm" href="logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row mb-5">
            <div class="col-12 text-center">
                <h1 class="display-5 fw-bold text-dark mb-2">Admin Control Panel</h1>
                <p class="lead text-muted">Complete system overview and management</p>
            </div>
        </div>

        <div class="row mb-5 quick-stats mx-auto" style="max-width: 1000px;">
            <div class="col-md-3 text-center border-end">
                <div class="stat-number">142</div>
                <div class="text-muted small fw-bold text-uppercase">Active Bookings</div>
            </div>
            <div class="col-md-3 text-center border-end">
                <div class="stat-number">87%</div>
                <div class="text-muted small fw-bold text-uppercase">Occupancy</div>
            </div>
            <div class="col-md-3 text-center border-end">
                <div class="stat-number">$12,450</div>
                <div class="text-muted small fw-bold text-uppercase">Daily Revenue</div>
            </div>
            <div class="col-md-3 text-center">
                <div class="stat-number">28</div>
                <div class="text-muted small fw-bold text-uppercase">Check-ins</div>
            </div>
        </div>

        <div class="row g-4">
            
            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-cash-stack card-icon icon-green"></i>
                        <h5 class="card-title fw-bold">Financial Records</h5>
                        <p class="card-text text-muted mb-4">View payment history and manage transactions</p>
                        <a href="payment?action=list" class="btn btn-success btn-lg w-75 shadow-sm">
                            View Payments
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5 border-top border-danger border-5 rounded-top">
                        <i class="bi bi-shield-lock-fill card-icon icon-red"></i>
                        <h5 class="card-title fw-bold">System Admins</h5>
                        <p class="card-text text-muted mb-4">Manage high-level administrator access</p>
                        <a href="admin-manage?action=list" class="btn btn-outline-danger btn-lg w-75">
                            Manage Admins
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-people-fill card-icon icon-blue"></i>
                        <h5 class="card-title fw-bold">Staff Directory</h5>
                        <p class="card-text text-muted mb-4">Add, edit, or remove staff accounts</p>
                        <a href="staff" class="btn btn-primary btn-lg w-75 shadow-sm">Manage Staff</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-door-open-fill card-icon icon-blue"></i>
                        <h5 class="card-title fw-bold">Room Categories</h5>
                        <p class="card-text text-muted mb-4">Update room types, pricing, and status</p>
                        <a href="roomType" class="btn btn-primary btn-lg w-75 shadow-sm">Manage Rooms</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-calendar-check card-icon icon-blue"></i>
                        <h5 class="card-title fw-bold">All Reservations</h5>
                        <p class="card-text text-muted mb-4">Monitor and search all guest bookings</p>
                        <a href="view-reservation" class="btn btn-primary btn-lg w-75 shadow-sm">Search Bookings</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 col-lg-4">
                <div class="card text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-bar-chart-line-fill card-icon icon-blue"></i>
                        <h5 class="card-title fw-bold">Analytics</h5>
                        <p class="card-text text-muted mb-4">Review revenue reports and performance</p>
                        <a href="admin-reports" class="btn btn-primary btn-lg w-75 shadow-sm">View Reports</a>
                    </div>
                </div>
            </div>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>