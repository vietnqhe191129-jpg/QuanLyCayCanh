<%@ page import="Models.PlantReport" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hỗ trợ sự cố sâu bệnh - Home Garden</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- FontAwesome for icons -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f4f7f6;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .report-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                background-color: white;
            }
            .disease-img {
                max-width: 100%;
                border-radius: 8px;
                max-height: 250px;
                object-fit: cover;
                border: 1px solid #dee2e6;
            }
            .form-control:focus {
                border-color: #81c784;
                box-shadow: 0 0 0 0.25rem rgba(129, 199, 132, 0.25);
            }
        </style>
    </head>
    <body>

        <% request.setAttribute("activePage", "reports"); %>
        <jsp:include page="/admin-navbar.jsp" />

        <div class="container-fluid px-5 my-5">
            <div class="mb-4">
                <h2 class="fw-bold text-success"><i class="fa-solid fa-triangle-exclamation me-2"></i>Tư vấn Báo cáo Sự cố Sâu bệnh</h2>
                <p class="text-muted">Xem hình ảnh sự cố người dùng gửi về và đưa ra phương án điều trị thích hợp</p>
            </div>

            <!-- Filter Buttons -->
            <div class="mb-4 d-flex justify-content-between align-items-center bg-white p-3 rounded-3 shadow-sm">
                <div class="btn-group">
                    <%
                        String currentFilter = (String) request.getAttribute("currentStatusFilter");
                        if (currentFilter == null)
                            currentFilter = "all";
                    %>
                    <a href="<%= request.getContextPath()%>/admin/reports?status=all" 
                       class="btn fw-semibold <%= "all".equals(currentFilter) ? "btn-success text-white" : "btn-outline-success"%>">
                        Tất cả báo cáo
                    </a>
                    <a href="<%= request.getContextPath()%>/admin/reports?status=Chờ xử lý" 
                       class="btn fw-semibold <%= "Chờ xử lý".equals(currentFilter) ? "btn-success text-white" : "btn-outline-success"%>">
                        Chờ xử lý
                    </a>
                    <a href="<%= request.getContextPath()%>/admin/reports?status=Đã tư vấn" 
                       class="btn fw-semibold <%= "Đã tư vấn".equals(currentFilter) ? "btn-success text-white" : "btn-outline-success"%>">
                        Đã tư vấn
                    </a>
                </div>
                <div>
                    <span class="text-muted small">Lọc theo trạng thái báo cáo sự cố</span>
                </div>
            </div>

            <div class="row g-4">
                <%
                    PlantReport selectedReport = (PlantReport) request.getAttribute("selectedReport");
                    boolean isReportSelected = (selectedReport != null);
                %>

                <!-- DETAIL/RESPONSE PANEL (Shown if a report is selected) -->
                <% if (isReportSelected) {%>
                <div class="col-lg-5">
                    <div class="card report-card p-4">
                        <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                            <h5 class="fw-bold text-success m-0"><i class="fa-solid fa-clipboard-question me-2"></i>Chi Tiết Sự Cố #<%= selectedReport.getReportID()%></h5>
                            <a href="<%= request.getContextPath()%>/admin/reports?status=<%= currentFilter%>" class="btn-close" aria-label="Close"></a>
                        </div>

                        <div class="mb-3">
                            <h6 class="fw-bold text-dark mb-1"><%= selectedReport.getTitle()%></h6>
                            <span class="badge <%= "Chờ xử lý".equals(selectedReport.getStatus()) ? "bg-warning text-dark" : "bg-success text-white"%> mb-2">
                                <%= selectedReport.getStatus()%>
                            </span>
                            <p class="text-secondary small mb-0">
                                <i class="fa-regular fa-clock me-1"></i> Ngày gửi: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(selectedReport.getCreatedAt())%>
                            </p>
                        </div>

                        <div class="p-3 bg-light rounded-3 mb-3 small">
                            <div class="row mb-1">
                                <div class="col-4 text-muted font-monospace">Người gửi:</div>
                                <div class="col-8 fw-semibold"><%= selectedReport.getUserFullName()%></div>
                            </div>
                            <div class="row mb-1">
                                <div class="col-4 text-muted font-monospace">Cây gặp bệnh:</div>
                                <div class="col-8 fw-semibold text-success"><%= selectedReport.getPlantCustomName() != null ? selectedReport.getPlantCustomName() : "Cây tự do/Không xác định"%></div>
                            </div>
                            <div class="row">
                                <div class="col-4 text-muted font-monospace">Mô tả triệu chứng:</div>
                                <div class="col-8 text-dark mt-1"><%= selectedReport.getDescription()%></div>
                            </div>
                        </div>

                        <% if (selectedReport.getImageUrl() != null && !selectedReport.getImageUrl().trim().isEmpty()) {%>
                        <div class="text-center mb-4">
                            <img src="<%= request.getContextPath()%>/<%= selectedReport.getImageUrl()%>" 
                                 onerror="this.src='https://placehold.co/400x250?text=Image+Not+Found'"
                                 alt="Ảnh bệnh cây" class="disease-img">
                        </div>
                        <% }%>

                        <form action="<%= request.getContextPath()%>/admin/reports?status=<%= currentFilter%>" method="post">
                            <input type="hidden" name="reportId" value="<%= selectedReport.getReportID()%>">
                            <div class="mb-3">
                                <label for="adminResponse" class="form-label text-success fw-bold"><i class="fa-solid fa-user-md me-1"></i>Chẩn đoán & Lời khuyên tư vấn</label>
                                <textarea class="form-control" id="adminResponse" name="adminResponse" rows="5" 
                                          placeholder="Nhập chẩn đoán bệnh cây và các biện pháp điều trị, tưới tiêu, bón phân phù hợp..." required><%= selectedReport.getAdminResponse() != null ? selectedReport.getAdminResponse() : ""%></textarea>
                            </div>

                            <button type="submit" class="btn btn-success w-100 fw-bold py-2 shadow-sm">
                                <i class="fa-solid fa-paper-plane me-2"></i> Gửi tư vấn điều trị
                            </button>
                        </form>
                    </div>
                </div>
                <% }%>

                <!-- LIST PANEL -->
                <div class="<%= isReportSelected ? "col-lg-7" : "col-12"%>">
                    <div class="card report-card p-4">
                        <h5 class="fw-bold text-success border-bottom pb-2 mb-3"><i class="fa-solid fa-list-check me-2"></i>Danh Sách Yêu Cầu Tư Vấn</h5>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-success table-opacity-10 text-success">
                                    <tr>
                                        <th scope="col" style="width: 60px;">ID</th>
                                        <th scope="col">Người gửi</th>
                                        <th scope="col">Cây trồng</th>
                                        <th scope="col">Tiêu đề sự cố</th>
                                        <th scope="col">Trạng thái</th>
                                        <th scope="col">Ngày gửi</th>
                                        <th scope="col" style="width: 130px;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<PlantReport> list = (List<PlantReport>) request.getAttribute("reportsList");
                                        if (list != null && !list.isEmpty()) {
                                            for (PlantReport r : list) {
                                    %>
                                    <tr class="<%= isReportSelected && selectedReport.getReportID() == r.getReportID() ? "table-active border-start border-success border-3" : ""%>">
                                        <td><strong>#<%= r.getReportID()%></strong></td>
                                        <td><%= r.getUserFullName()%></td>
                                        <td>
                                            <span class="text-success"><%= r.getPlantCustomName() != null ? r.getPlantCustomName() : "Chưa đặt tên/Tự do"%></span>
                                        </td>
                                        <td class="text-truncate" style="max-width: 200px;"><%= r.getTitle()%></td>
                                        <td>
                                            <% if ("Chờ xử lý".equals(r.getStatus())) {%>
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-hourglass-half me-1"></i><%= r.getStatus()%></span>
                                                <% } else {%>
                                            <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i><%= r.getStatus()%></span>
                                                <% }%>
                                        </td>
                                        <td class="small text-secondary"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(r.getCreatedAt())%></td>
                                        <td>
                                            <a href="<%= request.getContextPath()%>/admin/reports?status=<%= currentFilter%>&detailId=<%= r.getReportID()%>" 
                                               class="btn btn-sm btn-outline-success w-100 fw-semibold">
                                                <i class="fa-solid fa-eye me-1"></i> Xem & Tư vấn
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">Không có yêu cầu hỗ trợ nào trong danh mục này.</td>
                                    </tr>
                                    <% }%>
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
