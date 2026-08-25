<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật thông tin cây</title>
    <style>
        /* Đồng bộ CSS với giao diện Admin/User */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background-color: #f4f7f6; color: #333; }
        .navbar { background-color: #1e6b3b; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .navbar .brand { font-size: 20px; font-weight: bold; letter-spacing: 1px; }
        .container { padding: 40px 30px; max-width: 650px; margin: auto; }
        .card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .card-title { color: #1e6b3b; font-size: 22px; font-weight: bold; margin-top: 0; margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px; text-align: center; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; font-size: 14px; margin-bottom: 5px; color: #555; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-family: inherit; }
        .form-control:focus { border-color: #1e6b3b; outline: none; box-shadow: 0 0 5px rgba(30, 107, 59, 0.2); }
        .btn-primary { background-color: #f39c12; color: white; width: 100%; padding: 12px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 16px; margin-top: 10px; transition: 0.3s;}
        .btn-primary:hover { background-color: #e67e22; }
        .btn-back { display: block; text-align: center; margin-top: 15px; color: #777; text-decoration: none; font-size: 14px; }
        .btn-back:hover { text-decoration: underline; color: #1e6b3b; }
    </style>
</head>
<body>

    <!-- THANH NAVBAR -->
    <div class="navbar">
        <div class="brand">🌱 HOME GARDEN USER</div>
        <div class="user-info">👤 Chào, ${sessionScope.user != null ? sessionScope.user.username : 'Bạn'}</div>
    </div>

    <div class="container">
        <div class="card">
            <h3 class="card-title">✏️ Cập Nhật Thông Tin Cây</h3>
            
            <form action="edit-plant" method="POST">
                <!-- ĐIỂM QUAN TRỌNG: Thẻ ẩn truyền ID cây về Servlet -->
                <input type="hidden" name="plantID" value="${plant.getPlantId()}">

                <div class="form-group">
    <label>Loại cây:</label>
    <select name="categoryId" class="form-control">
        <option value="">Không chọn loại cây</option>

        <c:forEach var="category" items="${listCategory}">
            <option value="${category.categoryID}"
                    ${plant.categoryId eq category.categoryID ? 'selected' : ''}>
                ${category.categoryName} - ${category.scientificName}
            </option>
        </c:forEach>
    </select>
</div>

                <div class="form-group">
                    <label>Tên riêng của cây: *</label>
                    <!-- Tự động điền tên cũ -->
                    <input type="text" name="customName" value="${plant.getCustomName()}" required class="form-control">
                </div>

                <div class="form-group">
                    <label>Vị trí đặt cây:</label>
                    <select name="location" class="form-control">
                        <option value="Phòng khách" ${plant.getLocationInHome() == 'Phòng khách' ? 'selected' : ''}>Phòng khách</option>
                        <option value="Ban công" ${plant.getLocationInHome() == 'Ban công' ? 'selected' : ''}>Ban công</option>
                        <option value="Phòng ngủ" ${plant.getLocationInHome() == 'Phòng ngủ' ? 'selected' : ''}>Phòng ngủ</option>
                        <option value="Sân thượng" ${plant.getLocationInHome() == 'Sân thượng' ? 'selected' : ''}>Sân thượng</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Tình trạng sức khỏe:</label>
                    <select name="healthStatus" class="form-control">
                        <option value="Khỏe mạnh" ${plant.getHealthStatus() == 'Khỏe mạnh' ? 'selected' : ''}>Khỏe mạnh</option>
                        <option value="Sâu bệnh" ${plant.getHealthStatus() == 'Sâu bệnh' ? 'selected' : ''}>Sâu bệnh</option>
                        <option value="Héo" ${plant.getHealthStatus() == 'Héo' ? 'selected' : ''}>Héo</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Link Ảnh (ImageUrl):</label>
                    <input type="text" name="imageUrl" value="${plant.getImageUrl()}" class="form-control">
                </div>

                <div class="form-group">
                    <label>Ghi chú:</label>
                    <textarea name="note" rows="3" class="form-control">${plant.getNote()}</textarea>
                </div>

                <button type="submit" class="btn-primary">💾 Lưu Thay Đổi</button>
                <a href="my-garden" class="btn-back">← Hủy và quay lại vườn cây</a>
            </form>
        </div>
    </div>
</body>
</html>