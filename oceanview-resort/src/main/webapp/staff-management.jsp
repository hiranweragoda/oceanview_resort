<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Import both models to avoid casting errors --%>
<%@ page import="com.oceanview.model.User, com.oceanview.model.Admin" %>
<%
    // Get the generic object from session
    HttpSession sess = request.getSession(false);
    Object sessionUser = (sess != null) ? sess.getAttribute("user") : null;
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;
    String displayName = "";

    // Verify if the user is logged in and has the ADMIN role
    if (sess == null || !"ADMIN".equals(role)) {
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
    <h2 class="mb-4 text-center fw-bold">Staff Management</h2>

    <%-- Success/Error Alerts with Automatic Cleanup --%>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>

    <div class="card mb-4 table-card shadow-sm">
        <div class="header-blue">
            <i class="bi bi-person-plus-fill me-2"></i>Add New Staff Member
        </div>
        <div class="card-body bg-white">
            <form action="staff" method="post">
                <input type="hidden" name="action" value="add">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="username" class="form-label small fw-bold text-muted">USERNAME</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="col-md-3">
                        <label for="password" class="form-label small fw-bold text-muted">PASSWORD</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="col-md-3">
                        <label for="fullName" class="form-label small fw-bold text-muted">FULL NAME</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>
                    <div class="col-md-2">
                        <label for="contactNumber" class="form-label small fw-bold text-muted">CONTACT</label>
                        <input type="text" class="form-control" id="contactNumber" name="contactNumber">
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100 shadow-sm">
                          <i class="bi bi-plus-circle"></i> Add
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card table-card shadow-sm border-0">
        <div class="list-header">
            <i class="bi bi-people-fill me-2"></i>Current Staff Members
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
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
                                <td class="fw-bold">${s.id}</td>
                                <td><span class="">${s.username}</span></td>
                                <td>${s.fullName}</td>
                                <td>${s.contactNumber}</td>
                                <td class="text-center">
                                    <a href="staff?action=edit&id=${s.id}" class="btn btn-sm btn-warning text-white shadow-sm me-1">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                    <a href="staff?action=delete&id=${s.id}" class="btn btn-sm btn-danger shadow-sm"
                                       onclick="return confirm('Delete ${s.username}?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty staffList}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                    No staff members found.
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