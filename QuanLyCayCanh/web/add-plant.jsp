<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm cây mới vào vườn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin: auto;
        }
        h2 {
            color: #2c7a4b;
            text-align: center;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        input[type="text"], select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            height: 80px;
        }
        .btn-submit {
            background-color: #27ae60;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            font-weight: bold;
        }
        .btn-submit:hover {
            background-color: #219653;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #555;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>🌱 Thêm Cây Mới Vào Vườn</h2>
        
        <c:if test="${error != null}">
            <div class="error-msg">${error}</div>
        </c:if>

        <form action="add-plant" method="POST">
            
            <div class="form-group">
                <label>Chọn loại cây từ Thư viện mẫu:</label>
                <select name="categoryID">
                    <option value="">-- Tự nhập tên riêng / Không chọn mẫu --</option>
                    <!-- Duyệt danh sách các loài cây chuẩn từ Database -->
                    <c:forEach items="${listCategory}" var="cat">
                        <option value="${cat.categoryID}">${cat.categoryName} (${cat.scientificName})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Tên riêng của cây (Custom Name): <span style="color:red;">*</span></label>
                <input type="text" name="customName" required placeholder="Ví dụ: Kim tiền phòng khách số 1...">
            </div>

            <div class="form-group">
                <label>Vị trí đặt cây trong nhà:</label>
                <select name="location">
                    <option value="Phòng khách">Phòng khách</option>
                    <option value="Ban công">Ban công</option>
                    <option value="Phòng ngủ">Phòng ngủ</option>
                    <option value="Sân thượng">Sân thượng</option>
                    <option value="Bàn làm việc">Bàn làm việc</option>
                    <option value="Nhà bếp">Nhà bếp</option>
                </select>
            </div>

            <div class="form-group">
                <label>Tình trạng sức khỏe:</label>
                <select name="healthStatus">
                    <option value="Khỏe mạnh">Khỏe mạnh</option>
                    <option value="Cần chăm sóc">Cần chăm sóc</option>
                    <option value="Sâu bệnh">Sâu bệnh</option>
                    <option value="Héo">Héo</option>
                </select>
            </div>

            <div class="form-group">
                <label>Đường dẫn ảnh đại diện (ImageUrl):</label>
                <input type="text" name="imageUrl" placeholder="assets/images/kim_tien.jpg">
            </div>

            <div class="form-group">
                <label>Ghi chú:</label>
                <textarea name="note" placeholder="Nhập ghi chú chi tiết về tình trạng cây..."></textarea>
            </div>

            <button type="submit" class="btn-submit">Lưu Thông Tin Cây</button>
        </form>
        
        <a href="my-garden" class="back-link">← Quay lại danh sách vườn cây</a>
    </div>

</body>
</html>