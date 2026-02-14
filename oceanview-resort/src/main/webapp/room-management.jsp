<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    HttpSession sess = request.getSession(false);
    Object sessionUser = (sess != null) ? sess.getAttribute("user") : null;
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String displayName = "Admin";

    if (sess == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (sessionUser instanceof User) displayName = ((User) sessionUser).getUsername();
    else if (sessionUser instanceof Admin) displayName = ((Admin) sessionUser).getFullname();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Type Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        /* Consistent Cyan Header Style */
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }
        /* Form Header Style */
        .header-blue { background-color: #0d6efd; color: white; padding: 12px; border-radius: 8px 8px 0 0; font-weight: bold; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="admin-dashboard.jsp">
            <i class="bi bi-building-fill-add me-2"></i>Ocean View Resort
        </a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link fw-bold text-white">
                <i class="bi bi-person-circle me-2"></i><%= displayName %>
            </span>
            <a class="nav-link btn btn-outline-light ms-2 px-3" href="logout" onclick="return confirm('Are you sure you want to logout?');">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4 text-center fw-bold">Room Type Management</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm">
            <i class="bi bi-check-circle-fill me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card mb-4 table-card shadow-sm">
        <div class="header-blue">
            <i class="bi bi-plus-square-fill me-2"></i>Add New Room Type
        </div>
        <div class="card-body bg-white">
            <form action="roomType" method="post">
                <input type="hidden" name="action" value="add">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="typeName" class="form-label small fw-bold text-muted text-uppercase">Room Type Name</label>
                        <select class="form-select" id="typeName" name="typeName" required>
                            <option value="" disabled selected>Select room type...</option>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Luxury">Luxury</option>
                            <option value="Suite">Suite</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="ratePerNight" class="form-label small fw-bold text-muted text-uppercase">Rate per Night (USD)</label>
                        <div class="input-group">
                            <span class="input-group-text">$</span>
                            <input type="number" step="0.01" min="0.01" class="form-control" id="ratePerNight" name="ratePerNight" required>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-success w-100 shadow-sm">
                            <i class="bi bi-plus-circle me-2"></i>Add Type
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card table-card shadow-sm border-0">
        <div class="list-header">
            <i class="bi bi-door-open-fill me-2"></i>Existing Room Types
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type Name</th>
                            <th>Rate per Night</th>
                            <th style="width: 200px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rt" items="${roomTypes}">
                            <tr>
                                <td class="fw-bold">#${rt.id}</td>
                                <td><span class="badge bg-light text-primary border px-3">${rt.typeName}</span></td>
                                <td class="fw-bold text-success">$${rt.ratePerNight}</td>
                                <td>
                                    <a href="roomType?action=edit&id=${rt.id}" class="btn btn-sm btn-warning text-white shadow-sm me-1">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                    <a href="roomType?action=delete&id=${rt.id}" class="btn btn-sm btn-danger shadow-sm" onclick="return confirm('Delete ${rt.typeName}?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty roomTypes}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">
                                    <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                    No room categories defined yet.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="text-center mt-4 mb-5">
        <a href="admin-dashboard.jsp" class="btn btn-secondary px-4 shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>