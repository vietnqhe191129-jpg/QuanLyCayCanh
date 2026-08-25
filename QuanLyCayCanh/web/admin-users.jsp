<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý User - Home Garden</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .user-table-card, .form-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            background-color: white;
        }

        .status-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
    </style>
</head>

<body>

    <!-- Trang hiện tại -->
    <c:set var="activePage" value="users" scope="request"/>

    <!-- Navbar -->
    <jsp:include page="/admin-navbar.jsp" />

    <div class="container my-5">

        <!-- Header -->
        <div class="mb-4">
            <h2 class="fw-bold text-success m-0">
                <i class="fa-solid fa-users-gear me-2"></i>
                Quản lý Thành Viên
            </h2>
            <p class="text-muted mb-0">
                Thêm mới người dùng, tra cứu và quản lý trạng thái tài khoản (Khoá / Mở khoá)
            </p>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Form Thêm Mới Người Dùng (ADD) -->
        <div class="card form-card p-4 mb-4">
            <h5 class="fw-bold text-success mb-3 border-bottom pb-2">
                <i class="fa-solid fa-user-plus me-2"></i>Thêm Người Dùng Mới
            </h5>
            <form action="users" method="post">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="txtUsername" class="form-label small fw-bold text-muted">Tài khoản (Username): <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="txtUsername" name="username" placeholder="Nhập username" required>
                    </div>
                    <div class="col-md-3">
                        <label for="txtPassword" class="form-label small fw-bold text-muted">Mật khẩu: <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="txtPassword" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                    <div class="col-md-3">
                        <label for="txtName" class="form-label small fw-bold text-muted">Họ và tên: <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="txtName" name="fullName" placeholder="Nhập họ và tên" required>
                    </div>
                    <div class="col-md-3">
                        <label for="txtEmail" class="form-label small fw-bold text-muted">Email: <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="txtEmail" name="email" placeholder="example@gmail.com" required>
                    </div>
                    <div class="col-md-4">
                        <label for="txtPhone" class="form-label small fw-bold text-muted">Số điện thoại:</label>
                        <input type="text" class="form-control" id="txtPhone" name="phone" placeholder="VD: 0901234567">
                    </div>
                    <div class="col-md-4">
                        <label for="cboRole" class="form-label small fw-bold text-muted">Vai trò:</label>
                        <select class="form-select" id="cboRole" name="role">
                            <option value="USER" selected>USER</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-muted d-block">Trạng thái ban đầu:</label>
                        <div class="form-check form-switch mt-2">
                            <input class="form-check-input" type="checkbox" id="chkStatus" name="status" value="1" checked>
                            <label class="form-check-label fw-semibold" for="chkStatus">Hoạt động</label>
                        </div>
                    </div>
                    <div class="col-12 text-center mt-3">
                        <input type="submit" name="add" id="btnAdd" value="ADD" class="btn btn-success px-4 py-2 fw-bold">
                    </div>
                </div>
            </form>
        </div>

        <!-- Form Tìm Kiếm (SEARCH) -->
        <div class="card form-card p-3 mb-4">
            <form action="users" method="get" class="row g-3 align-items-center">
                <div class="col-md-8 col-lg-6">
                    <div class="input-group">
                        <input type="text" class="form-control" name="searchValue" id="txtSearch" value="${searchValue}" placeholder="Tìm theo tên đăng nhập, họ tên hoặc email...">
                        <input type="submit" name="search" id="btnSearch" value="SEARCH" class="btn btn-success fw-bold px-3">
                        <c:if test="${not empty searchValue}">
                            <a href="users" class="btn btn-outline-secondary">Xoá lọc</a>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>

        <!-- Bảng Danh Sách Người Dùng (List of Users) -->
        <div class="card user-table-card p-4">
            <h5 class="fw-bold text-success mb-3">
                <i class="fa-solid fa-list me-2"></i>Danh Sách Thành Viên (List of Users)
            </h5>
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-success table-opacity-10 text-success text-center">
                        <tr>
                            <th scope="col" style="width: 80px;">UserID</th>
                            <th scope="col">Username</th>
                            <th scope="col">FullName</th>
                            <th scope="col">Email</th>
                            <th scope="col">Phone</th>
                            <th scope="col">Role</th>
                            <th scope="col">Status</th>
                            <th scope="col" style="width: 140px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${data}" var="item">
                            <tr class="text-center">
                                <td id="td_id_${item.getUserID()}"><strong>#${item.getUserID()}</strong></td>
                                <td id="td_username_${item.getUserID()}" class="fw-semibold text-start">${item.getUsername()}</td>
                                <td id="td_name_${item.getUserID()}" class="text-start">${item.getFullName()}</td>
                                <td id="td_email_${item.getUserID()}" class="text-start">${item.getEmail()}</td>
                                <td id="td_phone_${item.getUserID()}">
                                    <c:choose>
                                        <c:when test="${not empty item.getPhone()}">${item.getPhone()}</c:when>
                                        <c:otherwise><span class="text-muted small">Chưa có</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td id="td_role_${item.getUserID()}">
                                    <c:choose>
                                        <c:when test="${item.getRole() == 'ADMIN'}">
                                            <span class="badge bg-danger text-uppercase px-2 py-1">${item.getRole()}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary text-uppercase px-2 py-1">${item.getRole()}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td id="td_status_${item.getUserID()}">
                                    <c:choose>
                                        <c:when test="${item.isStatus()}">
                                            <span class="status-badge bg-success bg-opacity-10 text-success fw-semibold">
                                                <i class="fa-solid fa-circle-check me-1"></i> Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-danger bg-opacity-10 text-danger fw-semibold">
                                                <i class="fa-solid fa-circle-minus me-1"></i> Bị khoá
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user and item.getUserID() == sessionScope.user.getUserID()}">
                                            <button class="btn btn-sm btn-outline-secondary w-100 fw-semibold" disabled>
                                                <i class="fa-solid fa-user-lock me-1"></i> Bản thân
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${item.isStatus()}">
                                                <a id="te_lock_${item.getUserID()}" href="users?id=${item.getUserID()}&mode1=1&status=false" 
                                                   class="btn btn-sm btn-outline-danger w-100 fw-semibold"
                                                   onclick="return confirm('Bạn có chắc muốn KHOÁ tài khoản ${item.getUsername()}?')">
                                                    <i class="fa-solid fa-lock me-1"></i>Khoá
                                                </a>
                                            </c:if>
                                            <c:if test="${not item.isStatus()}">
                                                <a id="te_unlock_${item.getUserID()}" href="users?id=${item.getUserID()}&mode1=1&status=true" 
                                                   class="btn btn-sm btn-outline-success w-100 fw-semibold"
                                                   onclick="return confirm('Bạn có chắc muốn MỞ KHOÁ tài khoản ${item.getUsername()}?')">
                                                    <i class="fa-solid fa-lock-open me-1"></i>Mở khoá
                                                </a>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty data}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    Không tìm thấy người dùng nào phù hợp.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
