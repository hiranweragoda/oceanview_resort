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
    <title>Admin Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .header-blue { background-color: #0d6efd; color: white; padding: 12px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .header-teal { background-color: #17a2b8; color: white; padding: 12px; border-radius: 8px 8px 0 0; font-weight: bold; }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="admin-dashboard.jsp">Ocean View Resort - Admin</a>
        <span class="navbar-text text-white fw-bold">Welcome, <%= displayName %></span>
    </div>
</nav>
<div class="container">

 <h2 class="mb-4 text-center fw-bold">Admin Management</h2>
    <div class="card mb-4 border-0 shadow-sm">
        <div class="header-blue"><i class="bi bi-person-plus-fill me-2"></i>Add New Admin Member</div>
        <div class="card-body">
            <form action="admin-manage" method="post" class="row g-3">
                <input type="hidden" name="action" value="add">
                <div class="col-md-3"><label class="small fw-bold">Username</label><input type="text" name="username" class="form-control" required></div>
                <div class="col-md-3"><label class="small fw-bold">Password</label><input type="password" name="password" class="form-control" required></div>
                <div class="col-md-3"><label class="small fw-bold">Full Name</label><input type="text" name="fullname" class="form-control"></div>
                <div class="col-md-2"><label class="small fw-bold">Contact</label><input type="text" name="contactNumber" class="form-control"></div>
                <div class="col-md-1 d-flex align-items-end"><button type="submit" class="btn btn-success w-100">Add</button></div>
            </form>
        </div>
    </div>
    <div class="card border-0 shadow-sm">
        <div class="header-teal"><i class="bi bi-people-fill me-2"></i>Current Admin Members</div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-dark"><tr><th class="ps-3">ID</th><th>Username</th><th>Full Name</th><th>Contact</th><th>Actions</th></tr></thead>
                <tbody>
                    <c:forEach var="a" items="${admins}">
                        <tr>
                            <td class="ps-3">${a.id}</td>
                            <td><span class="badge bg-light text-dark border">${a.username}</span></td>
                            <td>${a.fullname}</td>
                            <td>${a.contactNumber}</td>
                            <td>
                                <a href="admin-manage?action=edit&id=${a.id}" class="btn btn-warning btn-sm"><i class="bi bi-pencil-square"></i> Edit</a>
                                <a href="admin-manage?action=delete&id=${a.id}" class="btn btn-danger btn-sm" onclick="return confirm('Delete this Admin?')"><i class="bi bi-trash"></i> Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>