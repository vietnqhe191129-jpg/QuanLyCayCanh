<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Hồ Sơ Của Tôi - Home Garden</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .navbar { background-color: #1e6b3b; color: white; padding: 15px 30px; font-weight: bold; font-size: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar a { color: white; text-decoration: none; }
        .container { max-width: 500px; margin-top: 50px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .card-header { background-color: white; border-bottom: 2px solid #e8f5e9; text-align: center; padding: 20px; border-radius: 10px 10px 0 0 !important; }
        .card-header h4 { color: #1e6b3b; font-weight: bold; margin: 0; }
        .btn-green { background-color: #1e6b3b; color: white; font-weight: bold; transition: 0.3s; }
        .btn-green:hover { background-color: #144d29; color: white; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="my-garden">🌱 HOME GARDEN</a>
    </div>

    <div class="container">
        <div class="card">
            <div class="card-header">
                <h4><i class="fa-solid fa-user-pen me-2"></i>Thông Tin Tài Khoản</h4>
            </div>
            <div class="card-body p-4">
                
                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success py-2 text-center fw-bold"><i class="fa-solid fa-check me-2"></i><%= request.getAttribute("message") %></div>
                <% } %>
                
                <form action="profile" method="POST">
                    <!-- KHÓA TÊN ĐĂNG NHẬP -->
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">Tên đăng nhập (Không thể đổi)</label>
                        <input type="text" name="username" class="form-control bg-light" value="${sessionScope.user.username}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">Email</label>
                        <input type="email" name="email" class="form-control" value="${sessionScope.user.email}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" value="${sessionScope.user.phone}">
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-muted small fw-bold">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" value="${sessionScope.user.password}" required>
                    </div>

                    <button type="submit" class="btn btn-green w-100 py-2 rounded-3 mb-3">LƯU THAY ĐỔI</button>
                    
                    <div class="text-center">
                        <a href="my-garden" class="text-success text-decoration-none small fw-bold">← Quay lại Vườn cây</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>