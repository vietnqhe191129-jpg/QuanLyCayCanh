```jsp
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

        .user-table-card {
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
            <h2 class="fw-bold text-success">
                <i class="fa-solid fa-users-gear me-2"></i>
                Quản lý Thành Viên
            </h2>

            <p class="text-muted">
                Danh sách tài khoản người dùng trên hệ thống và trạng thái hoạt động
            </p>
        </div>


        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>

                ${error}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>
            </div>
        </c:if>


        <!-- User table -->
        <div class="card user-table-card p-4">

            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-success table-opacity-10 text-success">
                        <tr>
                            <th scope="col" style="width: 80px;">
                                User ID
                            </th>

                            <th scope="col">
                                Tài khoản
                            </th>

                            <th scope="col">
                                Họ và tên
                            </th>

                            <th scope="col">
                                Email
                            </th>

                            <th scope="col">
                                Số điện thoại
                            </th>

                            <th scope="col">
                                Vai trò
                            </th>

                            <th scope="col">
                                Trạng thái
                            </th>

                            <th scope="col" style="width: 150px;">
                                Hành động
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Danh sách User -->
                        <c:forEach items="${usersList}" var="u">
                            <tr>
                                <td>
                                    <strong>
                                        #${u.getUserID()}
                                    </strong>
                                </td>
                                <td>
                                    <span class="fw-semibold text-dark">
                                        ${u.getUsername()}
                                    </span>
                                </td>
                                <td>
                                    ${u.getFullName()}
                                </td>
                                <td>
                                    ${u.getEmail()}
                                </td>
                                <td>

                                    <c:choose>

                                        <c:when test="${not empty u.getPhone()}">
                                            ${u.getPhone()}
                                        </c:when>

                                        <c:otherwise>
                                            <span class="text-muted small">
                                                Chưa cập nhật
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>
                                <!-- Role -->
                                <td>

                                    <c:choose>

                                        <c:when test="${u.getRole() == 'ADMIN'}">

                                            <span class="badge bg-danger text-uppercase px-2 py-1">
                                                ${u.getRole()}
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="badge bg-secondary text-uppercase px-2 py-1">
                                                ${u.getRole()}
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </td>


                                <!-- Status -->
                                <td>

                                    <c:choose>

                                        <c:when test="${u.isStatus()}">

                                            <span class="status-badge bg-success bg-opacity-10 text-success fw-semibold">
                                                <i class="fa-solid fa-circle-check me-1"></i>
                                                Hoạt động
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="status-badge bg-danger bg-opacity-10 text-danger fw-semibold">
                                                <i class="fa-solid fa-circle-minus me-1"></i>
                                                Bị khoá
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </td>


                                <!-- Action -->
                                <td>
                                    <c:choose>

                                        <c:when test="${not empty sessionScope.user 
                                                      and u.getUserID() == sessionScope.user.getUserID()}">

                                            <button class="btn btn-sm btn-outline-secondary w-100 fw-semibold"
                                                    disabled>

                                                <i class="fa-solid fa-user-lock me-1"></i>
                                                Bản thân
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${u.isStatus()}">

                                                <a href="${pageContext.request.contextPath}/admin/users?action=toggle&id=${u.getUserID()}&status=false"
                                                   class="btn btn-sm btn-outline-danger w-100 fw-semibold"
                                                   onclick="return confirm('Bạn có chắc muốn KHOÁ tài khoản của ${u.getUsername()}?')">

                                                    <i class="fa-solid fa-lock me-1"></i>
                                                    Khoá

                                                </a>

                                            </c:if>
                                            <c:if test="${not u.isStatus()}">

                                                <a href="${pageContext.request.contextPath}/admin/users?action=toggle&id=${u.getUserID()}&status=true"
                                                   class="btn btn-sm btn-outline-success w-100 fw-semibold"
                                                   onclick="return confirm('Bạn có chắc muốn MỞ KHOÁ tài khoản của ${u.getUsername()}?')">

                                                    <i class="fa-solid fa-lock-open me-1"></i>
                                                    Mở khoá

                                                </a>

                                            </c:if>

                                        </c:otherwise>

                                    </c:choose>

                                </td>

                            </tr>

                        </c:forEach>


                        <!-- Không có dữ liệu -->
                        <c:if test="${empty usersList}">

                            <tr>

                                <td colspan="8"
                                    class="text-center py-4 text-muted">

                                    Không có người dùng nào.

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
