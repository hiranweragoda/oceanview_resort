<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Admin Member</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .edit-card { max-width: 550px; margin: 60px auto; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border: none; }
        .edit-header { background-color: #ffc107; color: #212529; padding: 20px; text-align: center; font-weight: bold; font-size: 1.3rem; }
    </style>
</head>
<body class="bg-light">
<div class="card edit-card">
    <div class="edit-header">Edit Admin Member Details</div>
    <div class="card-body p-4">
        <form action="admin-manage" method="post">
            <input type="hidden" name="action" value="saveUpdate">
            <input type="hidden" name="id" value="${admin.id}">
            
            <div class="mb-3">
                <label class="fw-bold">Username</label>
                <input type="text" class="form-control bg-light" value="${admin.username}" readonly>
                <small class="text-muted">Username is fixed for security</small>
            </div>
            <div class="mb-3">
                <label class="fw-bold">Full Name</label>
                <input type="text" name="fullname" class="form-control" value="${admin.fullname}" required>
            </div>
            <div class="mb-3">
                <label class="fw-bold">Contact Number</label>
                <input type="text" name="contactNumber" class="form-control" value="${admin.contactNumber}">
            </div>
            <div class="mb-4">
                <label class="fw-bold">New Password</label>
                <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current">
            </div>
            <div class="d-flex justify-content-end gap-2">
                <a href="admin-manage?action=list" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary px-4">Save Changes</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>