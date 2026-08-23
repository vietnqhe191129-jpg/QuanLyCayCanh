package Controllers;

import Models.PlantReport;
import Models.User;
import dal.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports"})
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User loggedUser = (User) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
            return;
        }

        ReportDAO reportDAO = new ReportDAO();
        
        // Handle filter
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "all";
        }
        
        // Handle loading single report details
        String detailIdStr = request.getParameter("detailId");
        if (detailIdStr != null) {
            try {
                int detailId = Integer.parseInt(detailIdStr);
                PlantReport selectedReport = reportDAO.getReportById(detailId);
                request.setAttribute("selectedReport", selectedReport);
            } catch (NumberFormatException e) {
                System.out.println("Detail report ID format error: " + e.getMessage());
            }
        }

        List<PlantReport> list = reportDAO.getAllReports(statusFilter);
        request.setAttribute("reportsList", list);
        request.setAttribute("currentStatusFilter", statusFilter);
        request.getRequestDispatcher("/admin-reports.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User loggedUser = (User) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
            return;
        }

        ReportDAO reportDAO = new ReportDAO();
        try {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            String adminResponse = request.getParameter("adminResponse");
            
            if (adminResponse != null && !adminResponse.trim().isEmpty()) {
                reportDAO.updateReportResponse(reportId, adminResponse);
            }
        } catch (NumberFormatException e) {
            System.out.println("Post report ID format error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/reports");
    }
}
