<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Import both models to avoid casting errors --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    // Get the generic object from session
    Object sessionUser = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String displayName = "";

    // Verify if the user is logged in and has the ADMIN role
    if (sessionUser == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Logic to determine display name from either Admin table or User table
    if (sessionUser instanceof User) {
        displayName = ((User) sessionUser).getUsername();
    } else if (sessionUser instanceof Admin) {
        displayName = ((Admin) sessionUser).getFullname();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="admin-dashboard.jsp">Ocean View Resort - Admin</a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link text-white fw-bold">
                <i class="bi bi-person-badge me-1"></i>Welcome, <%= displayName %>
            </span>
            <a class="nav-link" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4 text-center fw-bold">Staff Management</h2>

    <%-- FIXED: Success/Error Alerts with Automatic Cleanup --%>
    <%-- This prevents messages from showing on the Reservation List or other pages --%>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>

    <div class="card mb-4 shadow-sm border-0">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Add New Staff Member</h5>
        </div>
        <div class="card-body">
            <form action="staff" method="post">
                <input type="hidden" name="action" value="add">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="col-md-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="col-md-3">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>
                    <div class="col-md-2">
                        <label for="contactNumber" class="form-label">Contact Number</label>
                        <input type="text" class="form-control" id="contactNumber" name="contactNumber">
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-plus-circle"></i> Add
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Current Staff Members</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Contact Number</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${staffList}">
                            <tr>
                                <td>${s.id}</td>
                                <td><span class="badge bg-light text-dark border">${s.username}</span></td>
                                <td>${s.fullName}</td>
                                <td>${s.contactNumber}</td>
                                <td class="text-center">
                                    <a href="staff?action=edit&id=${s.id}" class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                    <a href="staff?action=delete&id=${s.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Delete ${s.username}?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty staffList}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">
                                    No staff members found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>