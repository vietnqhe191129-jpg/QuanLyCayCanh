<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Ký Tài Khoản</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 400px; }
        .card-title { color: #1e6b3b; text-align: center; margin-top: 0; font-size: 24px; border-bottom: 2px solid #eee; padding-bottom: 15px;}
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; color: #555; font-size: 14px;}
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .form-control:focus { border-color: #1e6b3b; outline: none; }
        .btn-submit { background-color: #1e6b3b; color: white; border: none; padding: 12px; width: 100%; font-weight: bold; border-radius: 4px; cursor: pointer; margin-top: 10px; font-size: 16px;}
        .btn-submit:hover { background-color: #144d29; }
        .error { color: #e74c3c; font-weight: bold; text-align: center; margin-bottom: 15px; font-size: 14px;}
        .links { text-align: center; margin-top: 15px; font-size: 14px;}
        .links a { color: #1e6b3b; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h2 class="card-title">🌱 HOME GARDEN<br>Tạo Tài Khoản</h2>
        
        <div class="error">${error}</div>
        
        <form action="register" method="POST">
            <div class="form-group">
                <label>Tên đăng nhập (*):</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Họ và Tên (*):</label>
                <input type="text" name="fullname" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Email (*):</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" class="form-control">
            </div>
            <div class="form-group">
                <label>Mật khẩu (*):</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn-submit">Đăng Ký Ngay</button>
        </form>
        <div class="links">
            Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
        </div>
    </div>
</body>
</html>