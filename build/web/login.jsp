<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống quản lý cây cảnh</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            background-color: rgba(255, 255, 255, 0.95);
            max-width: 420px;
            width: 100%;
            overflow: hidden;
        }
        .login-header {
            background-color: #2e7d32;
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        .login-header i {
            font-size: 3rem;
            margin-bottom: 10px;
        }
        .btn-green {
            background-color: #2e7d32;
            color: white;
            border: none;
            transition: all 0.3s;
        }
        .btn-green:hover {
            background-color: #1b5e20;
            color: white;
            transform: translateY(-2px);
        }
        .form-control:focus {
            border-color: #81c784;
            box-shadow: 0 0 0 0.25rem rgba(129, 199, 132, 0.25);
        }
        
        .hover-underline:hover {
            text-decoration: underline !important;
        }
    </style>
</head>
<body>

<div class="login-card p-0">
    <div class="login-header">
        <i class="fa-solid fa-leaf animate__animated animate__heartBeat animate__infinite"></i>
        <h4 class="mb-1 fw-bold">Home Garden</h4>
        <small class="text-white-50">Hệ thống quản lý cây cảnh tại nhà</small>
    </div>
    <div class="card-body p-4">
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center py-2" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                <div>
                    <%= request.getAttribute("error") %>
                </div>
            </div>
        <% } %>
        
        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label text-muted small fw-bold">Tên đăng nhập</label>
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-regular fa-user"></i></span>
                    <input type="text" class="form-control border-start-0 ps-0" id="username" name="username" placeholder="Nhập tên đăng nhập" required autocomplete="username">
                </div>
            </div>
            
            <div class="mb-2">
                <label for="password" class="form-label text-muted small fw-bold">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control border-start-0 ps-0" id="password" name="password" placeholder="Nhập mật khẩu" required autocomplete="current-password">
                </div>
            </div>

            <!-- Quên mật khẩu  -->
            <div class="text-end mb-4">
                <a href="forgot-password.jsp" class="text-success text-decoration-none small fw-bold hover-underline">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn btn-green w-100 py-2 rounded-3 fw-bold shadow-sm mb-3">ĐĂNG NHẬP</button>
            
            <!-- Tạo tài khoản mới -->
            <div class="text-center mt-2 mb-2">
                <span class="text-muted small">Chưa có tài khoản?</span>
                <a href="register.jsp" class="text-success text-decoration-none fw-bold small hover-underline ms-1">Tạo tài khoản mới</a>
            </div>
        </form>

        <hr class="text-muted opacity-25 mx-3 mt-3 mb-3">

        <div class="text-center">
            <p class="text-muted small mb-1">Tài khoản mặc định thử nghiệm:</p>
            <code class="text-success">admin / 123</code> <span class="text-muted small">hoặc</span> <code class="text-success">user1 / 123</code>
        </div>
    </div>
</div>

<!-- Bootstrap 5 Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>