<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #667eea, #764ba2); height: 100vh; }
        .login-card { background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .form-control { border-radius: 10px; }
        .btn-primary { border-radius: 10px; background: #667eea; border: none; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="login-card p-5">
                    <h2 class="text-center mb-4">Ocean View Resort</h2>
                    <h4 class="text-center mb-4">Staff Login</h4>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <form action="login" method="post" id="loginForm">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Login</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>