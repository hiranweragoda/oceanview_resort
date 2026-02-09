<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || !"STAFF".equals(sess.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Reservation - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
        }
        .readonly-field {
            background-color: #f8f9fa !important;
            border: 1px solid #dee2e6;
            color: #6c757d;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .btn-success {
            background-color: #198754;
            border: none;
            border-radius: 12px;
            padding: 12px 20px;
            transition: 0.3s;
        }
        .btn-success:hover {
            background-color: #157347;
            transform: translateY(-2px);
        }
        .input-group-text {
            background-color: #f1f3f5;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="staff-dashboard.jsp">
            <i class="bi bi-water me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= sess.getAttribute("username") %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2 px-3" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="text-center mb-4">
        <h2 class="fw-bold">Create New Reservation</h2>
        <p class="text-muted">Fill in the details to book a room for the guest</p>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0">
            <i class="bi bi-check-circle-fill me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card mx-auto" style="max-width: 750px;">
        <div class="card-body p-5">
            <form action="add-reservation" method="post" id="reservationForm">

                <input type="hidden" name="guestId" value="${preSelectedGuest.id}">

                <div class="row mb-4">
                    <div class="col-md-12">
                        <label class="form-label">Guest Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control readonly-field"
                                   value="${preSelectedGuest.guestName}" readonly>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Address</label>
                        <textarea class="form-control readonly-field" rows="2" readonly><c:out value="${preSelectedGuest.address}"/></textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-primary">Phone Number</label>
                        <input type="text" class="form-control shadow-sm" name="phoneNumber"
                               value="${preSelectedGuest.phoneNumber}" placeholder="07XXXXXXXX" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Select Room Type</label>
                    <div class="input-group shadow-sm">
                        <span class="input-group-text bg-light"><i class="bi bi-door-open"></i></span>
                        <select class="form-select" name="roomTypeId" required>
                            <option value="">-- Choose room type --</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}">
                                    ${rt.typeName} - $${rt.ratePerNight}/night
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <small class="text-muted mt-1 d-block">
                        All room types are shown. Availability check coming soon.
                    </small>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Check-in Date</label>
                        <input type="date" class="form-control shadow-sm" name="checkInDate" id="checkInDate" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Check-out Date</label>
                        <input type="date" class="form-control shadow-sm" name="checkOutDate" id="checkOutDate" required>
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-success btn-lg shadow">
                        <i class="bi bi-calendar-plus me-2"></i>Confirm Reservation
                    </button>
                    <a href="staff-dashboard.jsp" class="btn btn-link text-muted text-decoration-none small">Cancel and Return</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Validation: Check-out must be after Check-in
    document.getElementById('reservationForm').addEventListener('submit', function(e) {
        const checkIn = new Date(document.getElementById('checkInDate').value);
        const checkOut = new Date(document.getElementById('checkOutDate').value);

        if (checkIn >= checkOut) {
            alert("Error: Check-out date must be at least one day after the check-in date.");
            e.preventDefault();
        }
    });

    // Prevent selecting past dates
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('checkInDate').setAttribute('min', today);
    document.getElementById('checkOutDate').setAttribute('min', today);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>