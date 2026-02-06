<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .card { max-width: 600px; margin: 50px auto; border-radius: 15px; border: none; }
        .btn-warning { background-color: #ffc107; color: white; font-weight: bold; }
    </style>
</head>
<body>
<div class="card shadow">
    <div class="card-body p-5">
        <h2 class="text-center text-warning mb-4">Update Reservation</h2>
        <form action="view-reservation" method="post">
            <input type="hidden" name="action" value="update">
            
            <div class="mb-3">
                <label class="form-label fw-bold">Reservation Number</label>
                <input type="text" name="reservationNumber" class="form-control bg-light" 
                       value="${reservation.reservationNumber}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Room Type & Price</label>
                <select name="roomTypeId" class="form-select">
                    <c:forEach var="rt" items="${roomTypes}">
                        <option value="${rt.id}" ${rt.id == reservation.roomTypeId ? 'selected' : ''}>
                            ${rt.typeName} - $${rt.ratePerNight} / night
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Check-in Date</label>
                <input type="date" name="checkInDate" class="form-control" value="${reservation.checkInDate}" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Check-out Date</label>
                <input type="date" name="checkOutDate" class="form-control" value="${reservation.checkOutDate}" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Phone Number</label>
                <input type="text" name="phoneNumber" class="form-control" value="${reservation.phoneNumber}" required>
            </div>

            <div class="text-center mt-4">
                <a href="view-reservation" class="btn btn-secondary px-4 me-2">Back</a>
                <button type="submit" class="btn btn-warning px-4">Save Changes</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>