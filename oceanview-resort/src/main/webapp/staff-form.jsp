<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Import both models to handle multi-admin types and prevent casting errors --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin, com.oceanview.model.Staff" %>
<%
    // Fix: Use a generic Object to prevent ClassCastException
    Object sessionUser = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    // Security Check: Verify logged-in status and ADMIN role
    if (sessionUser == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Retrieve staff object passed from StaffServlet
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
        .card { border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); border: none; }
        .card-header { font-weight: 600; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>

    <div class="container mt-5">
        <div class="card mx-auto" style="max-width: 600px;">
            <div class="card-header bg-warning text-dark text-center py-3">
                <h4 class="mb-0"><i class="bi bi-person-fill-gear me-2"></i>Edit Staff Member</h4>
            </div>
            
            <div class="card-body p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="staff" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${staff.id}">

                    <div class="mb-4">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control bg-light" value="${staff.username}" readonly>
                        <small class="text-muted">Username cannot be modified.</small>
                    </div>

                    <div class="mb-4">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="${staff.fullName}" required>
                    </div>

                    <div class="mb-4">
                        <label for="contactNumber" class="form-label">Contact Number</label>
                        <input type="text" class="form-control" id="contactNumber" name="contactNumber" 
                               value="${staff.contactNumber}">
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Enter new password (optional)">
                        <small class="text-info"><i class="bi bi-info-circle me-1"></i>Only fill this to reset the password.</small>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end pt-2">
                        <a href="staff" class="btn btn-secondary px-4">
                            <i class="bi bi-arrow-left me-2"></i>Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-save me-2"></i>Update Staff
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>