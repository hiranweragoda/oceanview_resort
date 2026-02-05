<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sess = request.getSession(false);
    String role = (sess != null) ? (String) sess.getAttribute("role") : null;

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
    <title>Edit Guest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card mx-auto" style="max-width: 700px;">
        <div class="card-header bg-warning text-dark text-center">
            <h4>Edit Guest Information</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="guest" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${guest.id}">

                <div class="mb-3">
                    <label class="form-label">Guest Name</label>
                    <input type="text" class="form-control" name="guestName" value="${guest.guestName}" required>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">NIC / Passport</label>
                        <input type="text" class="form-control" name="nic" value="${guest.nic}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone Number</label>
                        <input type="text" class="form-control" name="phoneNumber" value="${guest.phoneNumber}">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <textarea class="form-control" name="address" rows="3">${guest.address}</textarea>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="guest" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>