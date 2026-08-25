package Controllers;

import Models.User;
import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
            return;
        }

        DashboardDAO dashboardDAO = new DashboardDAO();
        int totalUsers = dashboardDAO.getTotalUsers();
        int totalPlants = dashboardDAO.getTotalPlants();
        int pendingReports = dashboardDAO.getPendingReportsCount();
        int totalCategories = dashboardDAO.getTotalCategoriesCount();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPlants", totalPlants);
        request.setAttribute("pendingReports", pendingReports);
        request.setAttribute("totalCategories", totalCategories);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
