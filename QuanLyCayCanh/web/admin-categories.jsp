<%@ page import="Models.PlantCategory" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Từ điển loài cây - Home Garden</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .garden-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            background-color: white;
        }
        .form-control:focus, .form-select:focus {
            border-color: #81c784;
            box-shadow: 0 0 0 0.25rem rgba(129, 199, 132, 0.25);
        }
        .plant-thumbnail {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
    </style>
</head>
<body>

<% request.setAttribute("activePage", "categories"); %>
<jsp:include page="/admin-navbar.jsp" />

<div class="container-fluid px-5 my-5">
    <div class="mb-4">
        <h2 class="fw-bold text-success"><i class="fa-solid fa-book-open me-2"></i>Từ điển Loại Cây Mẫu</h2>
        <p class="text-muted">Quản lý cơ sở dữ liệu cây mẫu gợi ý (Admin thêm/sửa/xóa)</p>
    </div>

    <div class="row g-4">
        <!-- FORM COLUMN -->
        <div class="col-lg-4">
            <%
                PlantCategory editCat = (PlantCategory) request.getAttribute("categoryToEdit");
                boolean isEditMode = (editCat != null);
            %>
            <div class="card garden-card p-4">
                <h5 class="fw-bold text-success border-bottom pb-2 mb-3">
                    <i class="fa-solid <%= isEditMode ? "fa-pen-to-square" : "fa-circle-plus" %> me-2"></i>
                    <%= isEditMode ? "Cập Nhật Loài Cây" : "Thêm Loài Cây Mới" %>
                </h5>
                
                <form action="<%= request.getContextPath() %>/admin/categories?action=<%= isEditMode ? "edit&id=" + editCat.getCategoryID() : "add" %>" method="post">
                    
                    <div class="mb-3">
                        <label for="categoryName" class="form-label text-muted small fw-bold">Tên loài cây <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="categoryName" name="categoryName" 
                               value="<%= isEditMode ? editCat.getCategoryName() : "" %>" 
                               placeholder="VD: Cây Kim Tiền" required>
                    </div>

                    <div class="mb-3">
                        <label for="scientificName" class="form-label text-muted small fw-bold">Tên khoa học</label>
                        <input type="text" class="form-control" id="scientificName" name="scientificName" 
                               value="<%= isEditMode && editCat.getScientificName() != null ? editCat.getScientificName() : "" %>" 
                               placeholder="VD: Zamioculcas zamiifolia">
                    </div>

                    <div class="mb-3">
                        <label for="defaultWaterDays" class="form-label text-muted small fw-bold">Tần suất tưới mặc định (Ngày/lần) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="defaultWaterDays" name="defaultWaterDays" min="1" max="60" 
                               value="<%= isEditMode ? editCat.getDefaultWaterDays() : "2" %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="lightRequirement" class="form-label text-muted small fw-bold">Nhu cầu ánh sáng</label>
                        <select class="form-select" id="lightRequirement" name="lightRequirement">
                            <option value="Nắng trực tiếp" <%= isEditMode && "Nắng trực tiếp".equals(editCat.getLightRequirement()) ? "selected" : "" %>>Nắng trực tiếp</option>
                            <option value="Ánh sáng gián tiếp" <%= isEditMode && "Ánh sáng gián tiếp".equals(editCat.getLightRequirement()) ? "selected" : "" %>>Ánh sáng gián tiếp</option>
                            <option value="Bán râm" <%= isEditMode && "Bán râm".equals(editCat.getLightRequirement()) ? "selected" : "" %>>Bán râm, chịu bóng</option>
                            <option value="Râm mát hoàn toàn" <%= isEditMode && "Râm mát hoàn toàn".equals(editCat.getLightRequirement()) ? "selected" : "" %>>Râm mát hoàn toàn</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="imageUrl" class="form-label text-muted small fw-bold">Đường dẫn ảnh đại diện (URL)</label>
                        <input type="text" class="form-control" id="imageUrl" name="imageUrl" 
                               value="<%= isEditMode && editCat.getImageUrl() != null ? editCat.getImageUrl() : "" %>" 
                               placeholder="VD: assets/images/kim_tien.jpg">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label text-muted small fw-bold">Mô tả đặc điểm</label>
                        <textarea class="form-control" id="description" name="description" rows="4" 
                                  placeholder="Mô tả công dụng, cách chăm sóc cơ bản..."><%= isEditMode && editCat.getDescription() != null ? editCat.getDescription() : "" %></textarea>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success fw-bold flex-grow-1">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Lưu lại
                        </button>
                        <% if (isEditMode) { %>
                            <a href="<%= request.getContextPath() %>/admin/categories" class="btn btn-outline-secondary fw-semibold">
                                Huỷ
                            </a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>

        <!-- TABLE COLUMN -->
        <div class="col-lg-8">
            <div class="card garden-card p-4">
                <h5 class="fw-bold text-success border-bottom pb-2 mb-3"><i class="fa-solid fa-list me-2"></i>Danh Sách Loài Cây Mẫu</h5>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-success table-opacity-10 text-success">
                            <tr>
                                <th scope="col" style="width: 60px;">ID</th>
                                <th scope="col" style="width: 80px;">Hình ảnh</th>
                                <th scope="col">Tên loài cây</th>
                                <th scope="col">Tên khoa học</th>
                                <th scope="col">Tần suất tưới</th>
                                <th scope="col">Ánh sáng</th>
                                <th scope="col" style="width: 150px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<PlantCategory> list = (List<PlantCategory>) request.getAttribute("categoriesList");
                                if (list != null && !list.isEmpty()) {
                                    for (PlantCategory cat : list) {
                            %>
                            <tr>
                                <td><strong>#<%= cat.getCategoryID() %></strong></td>
                                <td>
                                    <% if (cat.getImageUrl() != null && !cat.getImageUrl().trim().isEmpty()) { %>
                                        <img src="<%= request.getContextPath() %>/<%= cat.getImageUrl() %>" 
                                             onerror="this.src='https://placehold.co/100x100?text=Plant'"
                                             alt="<%= cat.getCategoryName() %>" class="plant-thumbnail">
                                    <% } else { %>
                                        <img src="https://placehold.co/100x100?text=No+Image" alt="No image" class="plant-thumbnail">
                                    <% } %>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark"><%= cat.getCategoryName() %></div>
                                    <div class="text-muted small text-truncate" style="max-width: 250px;"><%= cat.getDescription() != null ? cat.getDescription() : "" %></div>
                                </td>
                                <td><em class="text-secondary"><%= cat.getScientificName() != null ? cat.getScientificName() : "" %></em></td>
                                <td><span class="badge bg-info text-dark"><%= cat.getDefaultWaterDays() %> ngày/lần</span></td>
                                <td><%= cat.getLightRequirement() != null ? cat.getLightRequirement() : "" %></td>
                                <td>
                                    <div class="btn-group w-100">
                                        <a href="<%= request.getContextPath() %>/admin/categories?action=edit&id=<%= cat.getCategoryID() %>" 
                                           class="btn btn-sm btn-outline-primary fw-semibold">
                                            <i class="fa-solid fa-edit"></i> Sửa
                                        </a>
                                        <a href="<%= request.getContextPath() %>/admin/categories?action=delete&id=<%= cat.getCategoryID() %>" 
                                           class="btn btn-sm btn-outline-danger fw-semibold"
                                           onclick="return confirm('Bạn có chắc muốn XOÁ loài cây này? Việc xoá có thể ảnh hưởng đến cây trồng của người dùng!')">
                                            <i class="fa-solid fa-trash"></i> Xoá
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Không có loài cây nào trong từ điển.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
