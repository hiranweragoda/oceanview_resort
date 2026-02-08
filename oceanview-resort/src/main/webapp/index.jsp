<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { 
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), 
                        url('1770487770.png'); 
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            height: 100vh; 
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-card { 
            background: rgba(255, 255, 255, 0.95); 
            border-radius: 20px; 
            box-shadow: 0 20px 40px rgba(0,0,0,0.4); 
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .login-icon {
            font-size: 3rem;
            color: #0d6efd; /* Matching your Admin Blue */
            margin-bottom: 1rem;
        }
        .form-label { color: #495057; letter-spacing: 0.5px; }
        .form-control { 
            border-radius: 8px; 
            padding: 12px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
            border-color: #0d6efd;
        }
        .btn-login { 
            border-radius: 8px; 
            background: #0d6efd; 
            border: none; 
            padding: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            transition: transform 0.2s, background 0.3s;
        }
        .btn-login:hover { 
            background: #0b5ed7; 
            transform: translateY(-3px); 
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.4);
        }
        .resort-title {
            color: #212529;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="login-card p-5 text-center">
                    <div class="login-icon">
                        <i class="bi bi-tsunami"></i>
                    </div>
                    
                    <h2 class="resort-title mb-1">Ocean View</h2>
                    <p class="text-muted mb-4 fw-semibold">MANAGEMENT PORTAL</p>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger d-flex align-items-center py-2 small shadow-sm mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <div><%= request.getAttribute("error") %></div>
                        </div>
                    <% } %>

                    <form action="login" method="post" class="text-start">
                        <div class="mb-3">
                            <label for="username" class="form-label small fw-bold">USERNAME</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="bi bi-person text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" id="username" name="username" placeholder="Enter username" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label small fw-bold">PASSWORD</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="bi bi-shield-lock text-muted"></i></span>
                                <input type="password" class="form-control border-start-0" id="password" name="password" placeholder="Enter password" required>
                            </div>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-login shadow">SIGN IN</button>
                        </div>
                    </form>
                    
                    <div class="mt-4 pt-3 border-top text-muted small">
                        &copy; 2026 Ocean View Resort System
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>