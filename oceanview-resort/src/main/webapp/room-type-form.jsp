<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>  <!-- Force EL to be evaluated -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.oceanview.model.User, com.oceanview.model.RoomType" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Get the room type object passed by the servlet
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    if (roomType == null) {
        request.setAttribute("error", "Room type not found.");
        response.sendRedirect("roomType");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Room Type - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .card-header { font-weight: 600; }
    </style>
</head>
<body>

    <div class="container mt-5">
        <div class="card mx-auto" style="max-width: 600px;">
            <div class="card-header bg-warning text-dark text-center">
                <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Room Type</h4>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="roomType" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${roomType.id}">

                    <div class="mb-4">
                        <label for="typeName" class="form-label fw-bold">Room Type Name</label>
                        <select class="form-select" id="typeName" name="typeName" required>
                            <option value="Standard" ${roomType.typeName == 'Standard' ? 'selected' : ''}>Standard</option>
                            <option value="Deluxe"   ${roomType.typeName == 'Deluxe'   ? 'selected' : ''}>Deluxe</option>
                            <option value="Luxury"   ${roomType.typeName == 'Luxury'   ? 'selected' : ''}>Luxury</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="ratePerNight" class="form-label fw-bold">Rate per Night (USD)</label>
                        <input type="number" step="0.01" min="0.01" class="form-control" 
                               id="ratePerNight" name="ratePerNight" 
                               value="${roomType.ratePerNight}" required>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="roomType" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>