<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    Object sessionUser = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String displayName = "Admin";
    if (sessionUser == null || !"ADMIN".equals(role)) {
        response.sendRedirect("index.jsp"); return;
    }
    if (sessionUser instanceof User) displayName = ((User) sessionUser).getUsername();
    else if (sessionUser instanceof Admin) displayName = ((Admin) sessionUser).getFullname();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Management - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh; }
        .table thead th { background-color: #0d6efd; color: white; vertical-align: middle; }
        .btn-sm { padding: 0.25rem 0.5rem; }
        /* Consistent Cyan Header Style */
        .list-header { background-color: #00bcd4; color: white; padding: 12px 20px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }
        /* Registration Header Style */
        .header-blue { background-color: #0d6efd; color: white; padding: 12px; border-radius: 8px 8px 0 0; font-weight: bold; }
    </style>
</head>
<body>

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
    <h2 class="mb-4 text-center fw-bold">Admin Management</h2>

    <div class="card mb-4 table-card">
        <div class="header-blue"><i class="bi bi-person-plus-fill me-2"></i>Add New Admin Member</div>
        <div class="card-body bg-white">
            <form action="admin-manage" method="post" class="row g-3">
                <input type="hidden" name="action" value="add">
                <div class="col-md-3">
                    <label class="small fw-bold text-muted text-uppercase">Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="small fw-bold text-muted text-uppercase">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="col-md-3">
                    <label class="small fw-bold text-muted text-uppercase">Full Name</label>
                    <input type="text" name="fullname" class="form-control">
                </div>
                <div class="col-md-2">
                    <label class="small fw-bold text-muted text-uppercase">Contact</label>
                    <input type="text" name="contactNumber" class="form-control">
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-success w-100 shadow-sm">Add</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card table-card">
        <div class="list-header"><i class="bi bi-people-fill me-2"></i>Current Admin Members</div>
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle text-center">
                <thead>
                    <tr>
                        <th class="ps-3">ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Contact</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${admins}">
                        <tr>
                            <td class="ps-3 fw-bold">#${a.id}</td>
                            <td><span class="badge bg-light text-primary border px-3">${a.username}</span></td>
                            <td>${a.fullname}</td>
                            <td>${a.contactNumber}</td>
                            <td>
                                <a href="admin-manage?action=edit&id=${a.id}" class="btn btn-warning btn-sm text-white shadow-sm me-1">
                                    <i class="bi bi-pencil-square me-1"></i> Edit
                                </a>
                                <a href="admin-manage?action=delete&id=${a.id}" class="btn btn-danger btn-sm shadow-sm" onclick="return confirm('Delete this Admin?')">
                                    <i class="bi bi-trash me-1"></i> Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty admins}">
                        <tr>
                            <td colspan="5" class="py-5 text-muted">No admin members found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
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