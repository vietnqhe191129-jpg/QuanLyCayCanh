<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Vườn cây của tôi</title>
        <style>
            /* --- CSS CHO MENU TÀI KHOẢN (SHOPEE STYLE) --- */
            .user-dropdown {
                position: relative;
                display: inline-block;
                cursor: pointer;
            }
            .user-dropbtn {
                color: white;
                font-weight: bold;
                padding: 8px 12px;
                border-radius: 4px;
                transition: background-color 0.3s;
            }
            .user-dropdown:hover .user-dropbtn {
                background-color: rgba(255, 255, 255, 0.2);
            }
            .user-dropdown-content {
                display: none;
                position: absolute;
                right: 0;
                background-color: #ffffff;
                min-width: 180px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                border-radius: 4px;
                z-index: 100;
                margin-top: 10px;
                overflow: hidden;
            }
            .user-dropdown-content a {
                color: #333;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
                font-size: 14px;
                border-bottom: 1px solid #f0f0f0;
            }
            .user-dropdown-content a:hover {
                background-color: #f9f9f9;
                color: #1e6b3b;
                font-weight: bold;
            }

            .btn-sm {
                padding: 5px 10px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 12px;
                font-weight: bold;
                color: white;
                display: inline-block;
                margin-top: 2px;
            }
            .btn-edit {
                background-color: #f39c12;
            }
            .btn-delete {
                background-color: #e74c3c;
                margin-left: 5px;
            }
            .btn-report {
                background-color: #3498db;
            }
            .btn-report:hover {
                background-color: #2980b9;
            }

            /* CSS Reset & Tone màu chủ đạo */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                background-color: #f4f7f6;
                color: #333;
            }

            /* Thanh Điều Hướng (Navbar) */
            .navbar {
                background-color: #1e6b3b;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .navbar .brand {
                font-size: 20px;
                font-weight: bold;
                letter-spacing: 1px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .navbar .menu {
                display: flex;
                gap: 20px;
            }
            .navbar .menu a {
                color: white;
                text-decoration: none;
                padding: 5px 10px;
                border-bottom: 2px solid transparent;
                font-size: 15px;
            }
            .navbar .menu a.active {
                border-bottom: 2px solid #f1c40f;
                color: #f1c40f;
                font-weight: bold;
            }

            /* Bố cục trang */
            .container {
                padding: 20px 30px;
                max-width: 1400px;
                margin: auto;
            }
            .row {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                align-items: flex-start;
            }
            .col-left {
                flex: 2;
            }
            .col-right {
                flex: 1;
            }

            /* Khối Card trắng */
            .card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                margin-bottom: 20px;
            }
            .card-title {
                color: #1e6b3b;
                font-size: 18px;
                font-weight: bold;
                margin-top: 0;
                margin-bottom: 15px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }

            /* Bảng dữ liệu */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th {
                background-color: #e8f5e9;
                color: #1e6b3b;
                padding: 12px;
                text-align: left;
                font-weight: bold;
                border-bottom: 2px solid #c8e6c9;
            }
            td {
                padding: 12px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }
            td img {
                border-radius: 4px;
                object-fit: cover;
                border: 1px solid #ddd;
            }

            /* Form nhập liệu */
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                font-weight: bold;
                font-size: 13px;
                margin-bottom: 5px;
                color: #555;
            }
            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-family: inherit;
            }
            .form-control:focus {
                border-color: #1e6b3b;
                outline: none;
                box-shadow: 0 0 5px rgba(30, 107, 59, 0.2);
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                font-size: 14px;
                transition: 0.3s;
            }
            .btn-primary {
                background-color: #1e6b3b;
                color: white;
                width: 100%;
                padding: 12px;
                margin-top: 10px;
            }
            .btn-primary:hover {
                background-color: #144d29;
            }
            .btn-filter {
                background-color: #f39c12;
                color: white;
                height: 39px;
            }
            .btn-filter:hover {
                background-color: #e67e22;
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: flex-end;
            }
            .filter-row .form-group {
                margin-bottom: 0;
                flex: 1;
            }
            .show {
                display: block !important;
            }
        </style>
    </head>
    <body>

        <!-- THANH NAVBAR -->
        <div class="navbar">
            <div class="brand">🌱 HOME GARDEN USER</div>
            <div class="menu">
                <a href="my-garden" class="active">🌿 Vườn của tôi</a>
                <a href="#">Thư viện mẫu</a>
                <a href="Care">Nhắc nhở tưới</a>
                <!-- BỔ SUNG: Đường dẫn đến trang Báo cáo sự cố -->
                <a href="reports" style="position: relative; display: inline-block;">
                    Báo cáo bệnh
                    <c:if test="${unreadCount > 0}">
                        <span style="
                              background-color: #e74c3c;
                              color: white;
                              border-radius: 50%;
                              padding: 1px 6px;
                              font-size: 11px;
                              font-weight: bold;
                              position: absolute;
                              top: -5px;
                              right: -10px;
                              box-shadow: 0 2px 4px rgba(0,0,0,0.2);">
                            ${unreadCount}
                        </span>
                    </c:if>
                </a> 
            </div>

            <!-- Khu vực User dạng Click Dropdown -->
            <div class="user-dropdown">
                <div class="user-dropbtn" onclick="toggleDropdown()">
                    👤 Chào, ${sessionScope.user != null ? sessionScope.user.username : 'Bạn'} ▼
                </div>

                <div class="user-dropdown-content" id="myDropdown">
                    <a href="profile">Tài Khoản Của Tôi</a>
                    <a href="logout" style="color: #e74c3c;">Đăng Xuất</a>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- KHU VỰC BỘ LỌC TÌM KIẾM -->
            <div class="card">
                <form action="my-garden" method="GET" class="filter-row">
                    <div class="form-group">
                        <label>Tìm theo tên cây:</label>
                        <input type="text" name="search" value="${search}" class="form-control" placeholder="Nhập tên cây cần tìm...">
                    </div>
                    <div class="form-group">
                        <label>Vị trí đặt cây:</label>
                        <select name="location" class="form-control">
                            <option value="All" ${location == 'All' ? 'selected' : ''}>Tất cả vị trí</option>
                            <option value="Phòng khách" ${location == 'Phòng khách' ? 'selected' : ''}>Phòng khách</option>
                            <option value="Ban công" ${location == 'Ban công' ? 'selected' : ''}>Ban công</option>
                            <option value="Phòng ngủ" ${location == 'Phòng ngủ' ? 'selected' : ''}>Phòng ngủ</option>
                            <option value="Sân thượng" ${location == 'Sân thượng' ? 'selected' : ''}>Sân thượng</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-filter">🔍 Lọc Dữ Liệu</button>
                </form>
            </div>

            <div class="row">
                <!-- NỬA TRÁI: BẢNG DANH SÁCH -->
                <div class="col-left">
                    <div class="card">
                        <h3 class="card-title">Danh sách cây đang trồng</h3>
                        <table>
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên cây</th>
                                <th>Vị trí</th>
                                <th>Tình trạng</th>
                                <th>Ngày trồng</th>
                                <th>Thao tác</th>
                            </tr>
                            <c:forEach items="${listPlant}" var="p">
                                <tr>
                                    <td><img src="${p.getImageUrl()}" width="50" height="50" alt="plant"></td>
                                    <td style="font-weight: bold; color: #1e6b3b;">${p.getCustomName()}</td>
                                    <td>${p.getLocationInHome()}</td>
                                    <td>
                                        <span style="color: ${p.getHealthStatus() == 'Khỏe mạnh' ? 'green' : (p.getHealthStatus() == 'Héo' ? 'red' : 'orange')}; font-weight: bold;">
                                            ${p.getHealthStatus()}
                                        </span>
                                    </td>
                                    <td>${p.getPlantedDate()}</td>
                                    <td>
                                        <a href="edit-plant?id=${p.getPlantId()}" class="btn-sm btn-edit">Sửa</a>
                                        <a href="delete-plant?id=${p.getPlantId()}" class="btn-sm btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa cây này khỏi vườn?');">Xóa</a>
                                        <!-- BỔ SUNG: Nút Báo bệnh nhanh cho từng cây -->
                                        <a href="reports" class="btn-sm btn-report">Báo bệnh</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </div>

                <!-- NỬA PHẢI: FORM THÊM MỚI -->
                <div class="col-right">
                    <div class="card">
                        <h3 class="card-title">+ Thêm Cây Mới</h3>
                        <form action="add-plant" method="POST">
                            <div class="form-group">
                                <label>Chọn từ Thư viện mẫu:</label>
                                <select name="categoryID" class="form-control">
                                    <option value="">-- Tự nhập tên riêng --</option>
                                    <c:forEach items="${listCategory}" var="cat">
                                        <option value="${cat.getCategoryID()}">
                                            ${cat.getCategoryName()} (${cat.getScientificName()})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Tên riêng của cây: *</label>
                                <input type="text" name="customName" required class="form-control" placeholder="Ví dụ: Kim tiền ban công...">
                            </div>

                            <div class="form-group">
                                <label>Vị trí đặt cây:</label>
                                <select name="location" class="form-control">
                                    <option value="Phòng khách">Phòng khách</option>
                                    <option value="Ban công">Ban công</option>
                                    <option value="Phòng ngủ">Phòng ngủ</option>
                                    <option value="Sân thượng">Sân thượng</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Tình trạng sức khỏe:</label>
                                <select name="healthStatus" class="form-control">
                                    <option value="Khỏe mạnh">Khỏe mạnh</option>
                                    <option value="Sâu bệnh">Sâu bệnh</option>
                                    <option value="Héo">Héo</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Link Ảnh (ImageUrl):</label>
                                <input type="text" name="imageUrl" class="form-control" placeholder="assets/images/...jpg">
                            </div>

                            <div class="form-group">
                                <label>Ghi chú:</label>
                                <textarea name="note" rows="2" class="form-control" placeholder="Tình trạng chi tiết..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">Lưu Thông Tin Cây</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleDropdown() {
                document.getElementById("myDropdown").classList.toggle("show");
            }

            window.onclick = function (event) {
                if (!event.target.matches('.user-dropbtn') && !event.target.closest('.user-dropbtn')) {
                    var dropdowns = document.getElementsByClassName("user-dropdown-content");
                    for (var i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
                    }
                }
            }
        </script>      
    </body>
</html>