<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Home Garden</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .stat-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .bg-gradient-green {
            background: linear-gradient(135deg, #2e7d32, #4caf50);
            color: white;
        }
        .bg-gradient-blue {
            background: linear-gradient(135deg, #1565c0, #1e88e5);
            color: white;
        }
        .bg-gradient-warning {
            background: linear-gradient(135deg, #e65100, #ff8f00);
            color: white;
        }
        .bg-gradient-purple {
            background: linear-gradient(135deg, #4a148c, #8e24aa);
            color: white;
        }
    </style>
</head>
<body>

<% request.setAttribute("activePage", "dashboard"); %>
<jsp:include page="/admin-navbar.jsp" />

<div class="container my-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold text-success m-0"><i class="fa-solid fa-gauge-high me-2"></i>Dashboard Thống Kê</h2>
            <p class="text-muted mb-0">Hệ thống giám sát và quản lý cây trồng</p>
        </div>
        <div class="text-end">
            <span class="badge bg-success py-2 px-3 rounded-pill text-uppercase shadow-sm fw-semibold">
                <i class="fa-regular fa-calendar me-1"></i>
                Hôm nay: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
            </span>
        </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card stat-card bg-gradient-green p-3 h-100">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-white-50 text-uppercase fw-bold small m-0">Tổng số cây trồng</h6>
                        <h2 class="fw-bold mt-2 mb-0"><%= request.getAttribute("totalPlants") %></h2>
                    </div>
                    <div class="fs-1 text-white-50"><i class="fa-solid fa-leaf"></i></div>
                </div>
                <hr class="my-2 border-white-50">
                <a href="<%= request.getContextPath() %>/admin/categories" class="text-white text-decoration-none small d-flex align-items-center justify-content-between">
                    <span>Xem từ điển cây mẫu</span>
                    <i class="fa-solid fa-circle-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="card stat-card bg-gradient-blue p-3 h-100">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-white-50 text-uppercase fw-bold small m-0">Người dùng</h6>
                        <h2 class="fw-bold mt-2 mb-0"><%= request.getAttribute("totalUsers") %></h2>
                    </div>
                    <div class="fs-1 text-white-50"><i class="fa-solid fa-users"></i></div>
                </div>
                <hr class="my-2 border-white-50">
                <a href="<%= request.getContextPath() %>/admin/users" class="text-white text-decoration-none small d-flex align-items-center justify-content-between">
                    <span>Quản lý thành viên</span>
                    <i class="fa-solid fa-circle-arrow-right"></i>
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stat-card bg-gradient-warning p-3 h-100">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-white-50 text-uppercase fw-bold small m-0">Sự cố chờ xử lý</h6>
                        <h2 class="fw-bold mt-2 mb-0"><%= request.getAttribute("pendingReports") %></h2>
                    </div>
                    <div class="fs-1 text-white-50"><i class="fa-solid fa-circle-exclamation animate__animated animate__pulse animate__infinite"></i></div>
                </div>
                <hr class="my-2 border-white-50">
                <a href="<%= request.getContextPath() %>/admin/reports?status=Chờ xử lý" class="text-white text-decoration-none small d-flex align-items-center justify-content-between">
                    <span>Hỗ trợ điều trị ngay</span>
                    <i class="fa-solid fa-circle-arrow-right"></i>
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stat-card bg-gradient-purple p-3 h-100">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-white-50 text-uppercase fw-bold small m-0">Danh mục loài cây</h6>
                        <h2 class="fw-bold mt-2 mb-0"><%= request.getAttribute("totalCategories") %></h2>
                    </div>
                    <div class="fs-1 text-white-50"><i class="fa-solid fa-tags"></i></div>
                </div>
                <hr class="my-2 border-white-50">
                <a href="<%= request.getContextPath() %>/admin/categories" class="text-white text-decoration-none small d-flex align-items-center justify-content-between">
                    <span>Quản lý danh mục</span>
                    <i class="fa-solid fa-circle-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3">
                <h5 class="fw-bold text-success border-bottom pb-2 mb-3"><i class="fa-solid fa-bolt me-2"></i>Thao Tác Nhanh</h5>
                <div class="d-grid gap-2">
                    <a href="<%= request.getContextPath() %>/admin/categories?action=addForm" class="btn btn-outline-success text-start py-3 px-4 rounded-3 d-flex align-items-center justify-content-between">
                        <div>
                            <strong class="d-block"><i class="fa-solid fa-circle-plus me-2"></i>Thêm loài cây mẫu mới</strong>
                            <small class="text-muted">Bổ sung vào từ điển tra cứu cây mẫu</small>
                        </div>
                        <i class="fa-solid fa-chevron-right text-success"></i>
                    </a>
                    
                    <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-outline-primary text-start py-3 px-4 rounded-3 d-flex align-items-center justify-content-between">
                        <div>
                            <strong class="d-block"><i class="fa-solid fa-user-lock me-2"></i>Khoá / mở tài khoản User</strong>
                            <small class="text-muted">Kiểm soát hoạt động người dùng hệ thống</small>
                        </div>
                        <i class="fa-solid fa-chevron-right text-primary"></i>
                    </a>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3">
                <h5 class="fw-bold text-success border-bottom pb-2 mb-3"><i class="fa-solid fa-envelope-open-text me-2"></i>Tình Trạng Hỗ Trợ</h5>
                <div class="p-3 bg-light rounded-3 d-flex align-items-center justify-content-between mb-3">
                    <div class="d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-circle me-3">
                            <i class="fa-solid fa-hourglass-half fs-4"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-0">Chờ xử lý báo cáo sâu bệnh</h6>
                            <small class="text-muted">Yêu cầu trợ giúp từ người dùng</small>
                        </div>
                    </div>
                    <span class="badge bg-warning text-dark fs-5 fw-bold px-3 py-1.5"><%= request.getAttribute("pendingReports") %></span>
                </div>
                
                <a href="<%= request.getContextPath() %>/admin/reports" class="btn btn-success w-100 py-2.5 rounded-3 fw-bold shadow-sm">
                    <i class="fa-solid fa-comments me-2"></i>Đi tới trang xử lý báo cáo
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
