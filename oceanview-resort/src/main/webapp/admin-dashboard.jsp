<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
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
        .navbar-brand {
            font-weight: 700;
        }
        .card {
            transition: all 0.3s ease;
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
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #0d6efd;
        }
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

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="admin-dashboard.jsp">
                <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort - Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <span class="nav-link fw-bold text-white">
                            <i class="bi bi-person-circle me-2"></i><%= user.getUsername() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light ms-2" href="logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container py-5">
        <div class="row mb-5">
            <div class="col-12 text-center">
                <h1 class="display-5 fw-bold text-dark mb-2">Admin Control Panel</h1>
                <p class="lead text-muted">Manage the entire resort system from one place</p>
            </div>
        </div>

        <!-- Quick Stats (placeholders – replace with real queries later) -->
        <div class="row mb-5 quick-stats mx-auto" style="max-width: 900px;">
            <div class="col-md-3 text-center">
                <div class="stat-number">142</div>
                <div class="text-muted">Active Bookings</div>
            </div>
            <div class="col-md-3 text-center">
                <div class="stat-number">87%</div>
                <div class="text-muted">Occupancy Rate</div>
            </div>
            <div class="col-md-3 text-center">
                <div class="stat-number">$12,450</div>
                <div class="text-muted">Today's Revenue</div>
            </div>
            <div class="col-md-3 text-center">
                <div class="stat-number">28</div>
                <div class="text-muted">Check-ins Today</div>
            </div>
        </div>

        <!-- Management Cards -->
        <div class="row g-4 justify-content-center">
            <!-- Reservations -->
            <div class="col-md-4 col-lg-3">
                <div class="card h-100 text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-calendar-check card-icon"></i>
                        <h5 class="card-title fw-bold">Manage Reservations</h5>
                        <p class="card-text text-muted mb-4">View, modify, cancel bookings</p>
                        <a href="view-all-reservations.jsp" class="btn btn-primary btn-lg w-75">
                            Manage Reservations
                        </a>
                    </div>
                </div>
            </div>

            <!-- Room Types -->
            <div class="col-md-4 col-lg-3">
                <div class="card h-100 text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-house-door-fill card-icon"></i>
                        <h5 class="card-title fw-bold">Room Management</h5>
                        <p class="card-text text-muted mb-4">Add, edit, delete room types & rates</p>
                        <a href="roomType" class="btn btn-primary btn-lg w-75">
                            Manage Rooms
                        </a>
                    </div>
                </div>
            </div>

            <!-- Reports -->
            <div class="col-md-4 col-lg-3">
                <div class="card h-100 text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-graph-up-arrow card-icon"></i>
                        <h5 class="card-title fw-bold">Reports & Analytics</h5>
                        <p class="card-text text-muted mb-4">Revenue, occupancy, performance</p>
                        <a href="reports.jsp" class="btn btn-primary btn-lg w-75">
                            View Reports
                        </a>
                    </div>
                </div>
            </div>

            <!-- Staff Management -->
         <div class="col-md-4 col-lg-3">
    <div class="card h-100 text-center">
        <div class="card-body py-5">
            <i class="bi bi-people-fill card-icon"></i>
            <h5 class="card-title fw-bold">Manage Staff</h5>
            <p class="card-text text-muted mb-4">Add, edit, delete staff accounts</p>
            <a href="staff" class="btn btn-primary btn-lg w-75">Manage Staff</a>
        </div>
    </div>
</div>

            <!-- System Settings -->
            <div class="col-md-4 col-lg-3">
                <div class="card h-100 text-center">
                    <div class="card-body py-5">
                        <i class="bi bi-gear-fill card-icon"></i>
                        <h5 class="card-title fw-bold">System Settings</h5>
                        <p class="card-text text-muted mb-4">Taxes, policies, notifications</p>
                        <a href="settings.jsp" class="btn btn-primary btn-lg w-75">
                            Settings
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>