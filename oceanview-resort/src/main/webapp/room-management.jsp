<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    Object sessionUser = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String username = "Admin";

    if (sessionUser == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (sessionUser instanceof User) username = ((User) sessionUser).getUsername();
    else if (sessionUser instanceof Admin) username = ((Admin) sessionUser).getFullname();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Type Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="admin-dashboard.jsp">Ocean View Resort - Admin</a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link">Welcome, <%= username %></span>
            <a class="nav-link" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4">Room Type Management</h2>

    <c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show">${success}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show">${error}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Add New Room Type</h5>
        </div>
        <div class="card-body">
            <form action="roomType" method="post">
                <input type="hidden" name="action" value="add">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="typeName" class="form-label">Room Type</label>
                        <select class="form-select" id="typeName" name="typeName" required>
                            <option value="" disabled selected>Select room type...</option>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Luxury">Luxury</option>
                            <option value="Suite">Suite</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="ratePerNight" class="form-label">Rate per Night (USD)</label>
                        <input type="number" step="0.01" min="0.01" class="form-control" id="ratePerNight" name="ratePerNight" required>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-plus-circle me-2"></i>Add Room Type
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Existing Room Types</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0 text-center align-middle">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Type Name</th><th>Rate per Night (USD)</th><th style="width: 180px;">Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rt" items="${roomTypes}">
                            <tr>
                                <td>${rt.id}</td>
                                <td>${rt.typeName}</td>
                                <td>${rt.ratePerNight}</td>
                                <td>
                                    <a href="roomType?action=edit&id=${rt.id}" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> Edit</a>
                                    <a href="roomType?action=delete&id=${rt.id}" class="btn btn-sm btn-danger" onclick="return confirm('Delete ${rt.typeName}?')"><i class="bi bi-trash"></i> Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>