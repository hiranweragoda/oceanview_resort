<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Staff" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    Staff staff = (Staff) request.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect("staff");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff Member - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .card-header { font-weight: 600; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>

    <div class="container mt-5">
        <div class="card mx-auto" style="max-width: 600px;">
            <div class="card-header bg-warning text-dark text-center">
                <h4 class="mb-0"><i class="bi bi-person-fill-gear me-2"></i>Edit Staff Member</h4>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="staff" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${staff.id}">

                    <!-- Username (read-only) -->
                    <div class="mb-4">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control bg-light" value="${staff.username}" disabled>
                        <small class="text-muted">Username cannot be changed</small>
                    </div>

                    <!-- Full Name -->
                    <div class="mb-4">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="${staff.fullName}" required>
                    </div>

                    <!-- Contact Number -->
                    <div class="mb-4">
                        <label for="contactNumber" class="form-label">Contact Number</label>
                        <input type="text" class="form-control" id="contactNumber" name="contactNumber" 
                               value="${staff.contactNumber}">
                    </div>

                    <!-- New Password (optional) -->
                    <div class="mb-4">
                        <label for="newPassword" class="form-label">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                               placeholder="Enter new password (optional)">
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="staff" class="btn btn-secondary">
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