<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Import both models to support the new admin table and prevent ClassCastException --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin, com.oceanview.model.RoomType" %>
<%
    // Fix: Use a generic Object to safely retrieve the session user
    Object sessionUser = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    // Security Check: Verify login and ADMIN role using the role string
    if (sessionUser == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Get the room type object passed by the servlet
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    if (roomType == null) {
        // Use session attribute for error to survive the redirect if needed, 
        // but here we redirect back to the list
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