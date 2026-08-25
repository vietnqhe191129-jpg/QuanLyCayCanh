<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Từ điển loài cây - Home Garden</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .category-table-card, .form-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            background-color: white;
        }
    </style>
</head>

<body>

    <!-- Trang hiện tại -->
    <c:set var="activePage" value="categories" scope="request"/>

    <!-- Navbar -->
    <jsp:include page="/admin-navbar.jsp" />

    <div class="container my-5">

        <!-- Header -->
        <div class="mb-4">
            <h2 class="fw-bold text-success m-0">
                <i class="fa-solid fa-book-open me-2"></i>
                Từ điển Loại Cây Mẫu
            </h2>
            <p class="text-muted mb-0">
                Quản lý danh mục cây mẫu gợi ý (Thêm, Sửa, Xoá và Tìm kiếm cây mẫu chuẩn)
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

        <!-- Form Nhập Liệu & Cập Nhật Cây (ADD / UPDATE) -->
        <div class="card form-card p-4 mb-4">
            <h5 class="fw-bold text-success mb-3 border-bottom pb-2">
                <i class="fa-solid fa-pen-to-square me-2"></i>Thông Tin Loài Cây
            </h5>
            <form action="categories" method="post">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="txtId" class="form-label small fw-bold text-muted">CategoryID:</label>
                        <input type="text" class="form-control" id="txtId" name="id" value="${p.getCategoryID()}" readonly placeholder="(Tự động)">
                    </div>
                    <div class="col-md-5">
                        <label for="txtName" class="form-label small fw-bold text-muted">CategoryName (Tên cây): <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="txtName" name="name" value="${p.getCategoryName()}" placeholder="VD: Cây Kim Tiền" required>
                    </div>
                    <div class="col-md-4">
                        <label for="txtScientificName" class="form-label small fw-bold text-muted">ScientificName (Tên khoa học):</label>
                        <input type="text" class="form-control" id="txtScientificName" name="scientificName" value="${p.getScientificName()}" placeholder="VD: Zamioculcas zamiifolia">
                    </div>
                    <div class="col-md-4">
                        <label for="txtWaterDays" class="form-label small fw-bold text-muted">Tưới nước (Số ngày/lần): <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="txtWaterDays" name="defaultWaterDays" min="1" max="60" value="${empty p ? '2' : p.getDefaultWaterDays()}" required>
                    </div>
                    <div class="col-md-8">
                        <label for="cboLight" class="form-label small fw-bold text-muted">Nhu cầu ánh sáng:</label>
                        <select class="form-select" id="cboLight" name="lightRequirement">
                            <option value="Nắng trực tiếp" <c:if test="${p.getLightRequirement() == 'Nắng trực tiếp'}">selected</c:if>>Nắng trực tiếp</option>
                            <option value="Ánh sáng gián tiếp" <c:if test="${empty p or p.getLightRequirement() == 'Ánh sáng gián tiếp'}">selected</c:if>>Ánh sáng gián tiếp</option>
                            <option value="Bán râm" <c:if test="${p.getLightRequirement() == 'Bán râm'}">selected</c:if>>Bán râm, chịu bóng</option>
                            <option value="Râm mát hoàn toàn" <c:if test="${p.getLightRequirement() == 'Râm mát hoàn toàn'}">selected</c:if>>Râm mát hoàn toàn</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label for="txtDescription" class="form-label small fw-bold text-muted">Mô tả đặc điểm & cách chăm sóc:</label>
                        <textarea class="form-control" id="txtDescription" name="description" rows="3" placeholder="Mô tả công dụng, cách chăm sóc...">${p.getDescription()}</textarea>
                    </div>
                    <div class="col-12 text-center mt-4">
                        <input type="submit" name="add" id="btnAdd" value="ADD" class="btn btn-success px-4 py-2 fw-bold me-2">
                        <input type="submit" name="update" id="btnUpdate" value="UPDATE" class="btn btn-primary px-4 py-2 fw-bold me-2">
                        <a href="categories" class="btn btn-outline-secondary px-3 py-2 fw-semibold">RESET FORM</a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Form Tìm Kiếm & Sắp Xếp (SEARCH & SORT) -->
        <div class="card form-card p-3 mb-4">
            <form action="categories" method="get" class="row g-3 align-items-center">
                <div class="col-md-5">
                    <div class="input-group">
                        <input type="text" class="form-control" name="searchValue" id="txtSearch" value="${searchValue}" placeholder="Tìm theo tên cây hoặc tên khoa học...">
                        <input type="submit" name="search" id="btnSearch" value="SEARCH" class="btn btn-success fw-bold px-3">
                    </div>
                </div>
                <div class="col-md-7 d-flex align-items-center justify-content-md-end gap-3">
                    <span class="fw-bold small text-muted">Sắp xếp CategoryID:</span>
                    <div class="form-check form-check-inline m-0">
                        <input class="form-check-input" type="radio" id="rdTang" name="sort" value="1" <c:if test="${sort == '1'}">checked</c:if>>
                        <label class="form-check-label small" for="rdTang">Tăng dần</label>
                    </div>
                    <div class="form-check form-check-inline m-0">
                        <input class="form-check-input" type="radio" id="rdGiam" name="sort" value="0" <c:if test="${sort == '0'}">checked</c:if>>
                        <label class="form-check-label small" for="rdGiam">Giảm dần</label>
                    </div>
                    <input type="submit" id="btnSort" name="btnSort" value="SORT" class="btn btn-outline-secondary btn-sm fw-bold px-3">
                </div>
            </form>
        </div>

        <!-- Bảng Danh Sách Loại Cây (List of Categories) -->
        <div class="card category-table-card p-4">
            <h5 class="fw-bold text-success mb-3">
                <i class="fa-solid fa-list me-2"></i>Danh Sách Loài Cây (List of Categories)
            </h5>
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-success table-opacity-10 text-success text-center">
                        <tr>
                            <th scope="col" style="width: 80px;">CategoryID</th>
                            <th scope="col">CategoryName</th>
                            <th scope="col">ScientificName</th>
                            <th scope="col" style="width: 120px;">Tưới nước</th>
                            <th scope="col" style="width: 150px;">Ánh sáng</th>
                            <th scope="col">Mô tả đặc điểm</th>
                            <th scope="col" colspan="2" style="width: 160px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${data}" var="item">
                            <tr class="text-center">
                                <td id="td_id_${item.getCategoryID()}"><strong>#${item.getCategoryID()}</strong></td>
                                <td id="td_name_${item.getCategoryID()}" class="fw-semibold text-start">${item.getCategoryName()}</td>
                                <td id="td_scientific_${item.getCategoryID()}" class="text-start fst-italic text-muted">${item.getScientificName()}</td>
                                <td id="td_water_${item.getCategoryID()}">
                                    <span class="badge bg-info text-dark">${item.getDefaultWaterDays()} ngày/lần</span>
                                </td>
                                <td id="td_light_${item.getCategoryID()}">${item.getLightRequirement()}</td>
                                <td id="td_description_${item.getCategoryID()}" class="text-start small text-muted text-truncate" style="max-width: 250px;">
                                    ${item.getDescription()}
                                </td>
                                <td>
                                    <a id="te_delete_${item.getCategoryID()}" href="categories?id=${item.getCategoryID()}&mode1=1" 
                                       class="btn btn-sm btn-outline-danger fw-semibold"
                                       onclick="return confirm('Bạn có chắc muốn XOÁ loài cây này?')">
                                        <i class="fa-solid fa-trash me-1"></i>Delete
                                    </a>
                                </td>
                                <td>
                                    <a id="te_select_${item.getCategoryID()}" href="categories?id=${item.getCategoryID()}&mode2=1" 
                                       class="btn btn-sm btn-outline-primary fw-semibold">
                                        <i class="fa-solid fa-pen-to-square me-1"></i>Select
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty data}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    Không tìm thấy loài cây nào phù hợp.
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
