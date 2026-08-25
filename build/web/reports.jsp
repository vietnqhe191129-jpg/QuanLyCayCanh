<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo Cáo Sự Cố & Hỗ Trợ - Home Garden</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f4f7f6;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
            }
            .disease-img-sm {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 4px;
            }
            .navbar-custom {
                background-color: #1e6b3b;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .navbar-custom .brand {
                font-size: 20px;
                font-weight: bold;
                letter-spacing: 1px;
                color: white;
                text-decoration: none;
            }
            .navbar-custom .menu {
                display: flex;
                gap: 20px;
            }
            .navbar-custom .menu a {
                color: white;
                text-decoration: none;
                padding: 5px 10px;
                font-size: 15px;
                position: relative;
            }
            .navbar-custom .menu a.active {
                border-bottom: 2px solid #f1c40f;
                color: #f1c40f;
                font-weight: bold;
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
        <div class="navbar-custom">
            <a href="my-garden" class="brand">🌱 HOME GARDEN USER</a>
            <div class="menu">
                <a href="my-garden">🌿 Vườn của tôi</a>
                <a href="#">Thư viện mẫu</a>
                <a href="Care">Nhắc nhở tưới</a>
                <a href="reports" class="active">
                    🩺 Báo cáo bệnh
                    <c:if test="${unreadCount > 0}">
                        <span style="background-color: #e74c3c; color: white; border-radius: 50%; padding: 1px 6px; font-size: 11px; font-weight: bold; position: absolute; top: -5px; right: -5px;">
                            ${unreadCount}
                        </span>
                    </c:if>
                </a>
            </div>
            <div>
                <span class="fw-bold text-white">👤 Chào, ${sessionScope.user != null ? sessionScope.user.username : 'Bạn'}</span>
                <a href="logout" class="btn btn-sm btn-danger ms-3">Đăng Xuất</a>
            </div>
        </div>

        <div class="container my-5" style="max-width: 1400px;">

            <!-- Thông báo -->
            <c:if test="${not empty sessionScope.msgSuccess}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.msgSuccess}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("msgSuccess"); %>
            </c:if>
            <c:if test="${not empty sessionScope.msgError}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.msgError}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("msgError"); %>
            </c:if>

            <div class="mb-4">
                <h2 class="text-success fw-bold"><i class="fa-solid fa-briefcase-medical me-2"></i>Trung Tâm Hỗ Trợ Sâu Bệnh</h2>
                <p class="text-muted">Gửi thông tin và mô tả tình trạng cây trồng để được Admin tư vấn cách chữa trị kịp thời.</p>
            </div>

            <div class="row">
                <!-- Cột Trái: Form Gửi Báo Cáo (Tự động điền dữ liệu cũ khi bấm Chưa khỏi bệnh) -->
                <div class="col-lg-4 mb-4">
                    <div class="card shadow-sm border-0 rounded-3 p-3">
                        <h5 class="text-success fw-bold border-bottom pb-2 mb-3"><i class="fa-solid fa-paper-plane me-2"></i>Gửi Yêu Cầu Tư Vấn</h5>
                        <form action="${pageContext.request.contextPath}/reports" method="post" enctype="multipart/form-data">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Chọn cây trong vườn</label>
                                <select class="form-select" name="plantId">
                                    <option value="">-- Cây tự do / Ngoài vườn --</option>
                                    <c:forEach items="${userPlants}" var="plant">
                                        <option value="${plant.plantId}" ${plant.plantId == sessionScope.fillPlantID ? 'selected' : ''}>${plant.customName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tiêu đề sự cố <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="title" value="${sessionScope.fillTitle != null ? sessionScope.fillTitle : ''}" required placeholder="VD: Trầu bà bị vàng lá">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tải lên hình ảnh lá/vết bệnh</label>
                                <input class="form-control" type="file" name="reportImage" accept="image/*">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mô tả chi tiết <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" rows="5" required placeholder="Mô tả triệu chứng, vị trí đặt, lượng nước tưới...">${sessionScope.fillDescription != null ? sessionScope.fillDescription : ''}</textarea>
                            </div>

                            <button type="submit" class="btn btn-success w-100 fw-bold py-2 shadow-sm">
                                Gửi Báo Cáo
                            </button>
                        </form>
                    </div>

                    <!-- Hiển thị Popup / Khung xem chi tiết báo cáo nếu user bấm vào nút Xem -->
                    <c:if test="${not empty detailReport}">
                        <div class="card shadow-sm border-success mt-4 p-3 bg-white">
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-2">
                                <h6 class="text-success fw-bold m-0"><i class="fa-solid fa-circle-info me-1"></i>Chi Tiết Báo Cáo #${detailReport.reportID}</h6>
                                <a href="reports" class="btn-close" aria-label="Close"></a>
                            </div>
                            <p class="mb-1"><strong>Tiêu đề:</strong> ${detailReport.title}</p>
                            <p class="mb-1"><strong>Mô tả:</strong> ${detailReport.description}</p>
                            <p class="mb-1"><strong>Trạng thái:</strong> <span class="badge bg-info text-dark">${detailReport.status}</span></p>
                            <c:if test="${not empty detailReport.imageUrl}">
                                <div class="mb-2 text-center">
                                    <img src="${pageContext.request.contextPath}/${detailReport.imageUrl}" class="img-fluid rounded border" style="max-height: 150px;" alt="Ảnh báo cáo">
                                </div>
                            </c:if>
                            <c:if test="${not empty detailReport.adminResponse}">
                                <div class="p-2 bg-light border-start border-success border-3 rounded small">
                                    <strong>Admin tư vấn:</strong> ${detailReport.adminResponse}
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>

                <!-- Cột Phải: Danh sách lịch sử & Nút thao tác -->
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0 rounded-3 p-3">
                        <h5 class="text-success fw-bold border-bottom pb-2 mb-3"><i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch Sử Tư Vấn Của Bạn</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tiêu đề sự cố</th>
                                        <th>Cây</th>
                                        <th>Trạng thái</th>
                                        <th>Phản hồi & Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${userReports}" var="r">
                                        <tr class="${r.status == 'Đã tư vấn' ? 'fw-bold border-start border-success border-4 bg-light' : ''}">
                                            <td>
                                                <strong>${r.title}</strong><br>
                                                <small class="text-muted fw-normal">${r.createdAt}</small>
                                            </td>
                                            <td><span class="text-success">${r.plantCustomName != null ? r.plantCustomName : 'Cây tự do'}</span></td>
                                            <td>
                                                <span class="badge ${r.status == 'Chờ xử lý' ? 'bg-warning text-dark' : (r.status == 'Đã hoàn thành' ? 'bg-secondary' : 'bg-success')}">
                                                    ${r.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="mb-2">
                                                    <!-- Nút xem chi tiết báo cáo -->
                                                    <a href="reports?action=view&id=${r.reportID}" class="btn btn-sm btn-outline-primary mb-1">
                                                        <i class="fa-solid fa-eye me-1"></i> Xem chi tiết
                                                    </a>
                                                </div>

                                                <c:if test="${not empty r.adminResponse}">
                                                    <div class="p-2 text-dark small mb-2 bg-white rounded border">
                                                        ${r.adminResponse}
                                                    </div>
                                                    
                                                    <!-- 2 Nút xác nhận Khỏi bệnh / Chưa khỏi bệnh -->
                                                    <c:if test="${r.status == 'Đã tư vấn'}">
                                                        <div class="d-flex gap-2">
                                                            <a href="reports?action=resolved&id=${r.reportID}" class="btn btn-sm btn-success fw-bold" onclick="return confirm('Xác nhận cây đã khỏi bệnh?');">
                                                                <i class="fa-solid fa-check me-1"></i> Khỏi bệnh
                                                            </a>
                                                            <a href="reports?action=unresolved&id=${r.reportID}" class="btn btn-sm btn-warning fw-bold text-dark" onclick="alert('Hãy mô tả lại tình trạng mới sau khi thực hiện hướng dẫn nhé!');">
                                                                <i class="fa-solid fa-rotate-right me-1"></i> Chưa khỏi bệnh
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                </c:if>
                                                <c:if test="${empty r.adminResponse}">
                                                    <small class="text-muted fst-italic fw-normal">Đang chờ chuyên gia phản hồi...</small>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty userReports}">
                                        <tr>
                                            <td colspan="4" class="text-center py-4 text-muted">Bạn chưa gửi yêu cầu hỗ trợ nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<%
    // Dọn dẹp session tạm sau khi đã fill dữ liệu vào form để tránh bị lưu dính mãi
    session.removeAttribute("fillPlantID");
    session.removeAttribute("fillTitle");
    session.removeAttribute("fillDescription");
%>