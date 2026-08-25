<%@ page import="Models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    String activePage = (String) request.getAttribute("activePage");
%>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm" style="background-color: #2e7d32;">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center fw-bold text-uppercase" href="<%= request.getContextPath() %>/admin/dashboard">
            <i class="fa-solid fa-leaf me-2 text-warning fs-4"></i>
            Home Garden Admin
        </a>
        <button class="navbar-dark navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="navbar-collapse collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 fw-semibold">
                <li class="nav-item">
                    <a class="nav-link <%= "dashboard".equals(activePage) ? "active fw-bold text-white border-bottom border-2 border-warning" : "text-white-50" %>" href="<%= request.getContextPath() %>/admin/dashboard">
                        <i class="fa-solid fa-chart-line me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "users".equals(activePage) ? "active fw-bold text-white border-bottom border-2 border-warning" : "text-white-50" %>" href="<%= request.getContextPath() %>/admin/users">
                        <i class="fa-solid fa-users-gear me-1"></i> Quản lý User
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "categories".equals(activePage) ? "active fw-bold text-white border-bottom border-2 border-warning" : "text-white-50" %>" href="<%= request.getContextPath() %>/admin/categories">
                        <i class="fa-solid fa-book-open me-1"></i> Từ điển cây
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "reports".equals(activePage) ? "active fw-bold text-white border-bottom border-2 border-warning" : "text-white-50" %>" href="<%= request.getContextPath() %>/admin/reports">
                        <i class="fa-solid fa-triangle-exclamation me-1"></i> Hỗ trợ sự cố
                        <%
                            // For showing dynamic badge in navigation
                            int pendingBadgeCount = 0;
                            try {
                                dal.DashboardDAO badgeDAO = new dal.DashboardDAO();
                                pendingBadgeCount = badgeDAO.getPendingReportsCount();
                            } catch(Exception e){}
                            if (pendingBadgeCount > 0) {
                        %>
                            <span class="badge rounded-pill bg-danger animate__animated animate__pulse animate__infinite"><%= pendingBadgeCount %></span>
                        <% } %>
                    </a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center">
                <% if (loggedUser != null) { %>
                    <span class="text-white me-3 bg-success bg-opacity-25 px-3 py-1.5 rounded-pill border border-success border-opacity-50">
                        <i class="fa-regular fa-circle-user me-1 text-warning"></i>
                        Chào, <strong><%= loggedUser.getFullName() %></strong>
                    </span>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm rounded-pill px-3 fw-bold" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')">
                        <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</nav>
