<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String username = (sess != null) ? (String) sess.getAttribute("username") : null;

    if (sess == null || !"STAFF".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Management - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="staff-dashboard.jsp">Ocean View Resort - Staff</a>
        <div class="navbar-nav ms-auto">
            <span class="nav-link">Welcome, <%= username %></span>
            <a class="nav-link" href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2 class="mb-4">Guest Management</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Add New Guest Form -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0">Register New Guest</h5>
        </div>
        <div class="card-body">
            <form action="guest" method="post">
                <input type="hidden" name="action" value="add">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="guestName" class="form-label">Guest Name</label>
                        <input type="text" class="form-control" id="guestName" name="guestName" required>
                    </div>
                    <div class="col-md-3">
                        <label for="nic" class="form-label">NIC / Passport No</label>
                        <input type="text" class="form-control" id="nic" name="nic" required>
                    </div>
                    <div class="col-md-3">
                        <label for="phoneNumber" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-person-plus"></i> Register
                        </button>
                    </div>
                </div>
                <div class="mt-3">
                    <label for="address" class="form-label">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                </div>
            </form>
        </div>
    </div>

    <!-- Guest List Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Registered Guests</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-bordered mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Guest Name</th>
                            <th>NIC</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="g" items="${guestList}">
                            <tr>
                                <td>${g.id}</td>
                                <td>${g.guestName}</td>
                                <td>${g.nic}</td>
                                <td>${g.phoneNumber}</td>
                                <td>${g.address}</td>
                                <td>
                                    <a href="guest?action=edit&id=${g.id}" class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                    <a href="guest?action=delete&id=${g.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Delete guest ${g.guestName}?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty guestList}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    No guests registered yet.
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