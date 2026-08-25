package Controllers;

import Models.PlantReport;
import Models.User;
import Models.UserPlant;
import dal.ReportDAO;
import dal.UserPlantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 10,       
    maxRequestSize = 1024 * 1024 * 50     
)
@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedUser = (User) session.getAttribute("user");
        ReportDAO reportDAO = new ReportDAO();

        // 1. XỬ LÝ NÚT BẤM (Khỏi bệnh / Chưa khỏi bệnh / Xem chi tiết báo cáo)
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        if (action != null && idStr != null) {
            try {
                int reportId = Integer.parseInt(idStr);
                if ("resolved".equals(action)) {
                    reportDAO.updateReportStatus(reportId, "Đã hoàn thành");
                    session.setAttribute("msgSuccess", "Tuyệt vời! Cây đã hồi phục thành công.");
                    response.sendRedirect(request.getContextPath() + "/reports");
                    return;
                } else if ("unresolved".equals(action)) {
                    // Lưu dữ liệu cũ vào Session để form bên trái tự động điền
                    PlantReport oldReport = reportDAO.getReportById(reportId);
                    if (oldReport != null) {
                        session.setAttribute("fillPlantID", oldReport.getPlantID());
                        session.setAttribute("fillTitle", "Follow-up: " + oldReport.getTitle());
                        session.setAttribute("fillDescription", "Tình trạng sau khi áp dụng hướng dẫn: ");
                    }
                    response.sendRedirect(request.getContextPath() + "/reports");
                    return;
                } else if ("view".equals(action)) {
                    // Xem chi tiết một báo cáo đã gửi
                    PlantReport detailReport = reportDAO.getReportById(reportId);
                    request.setAttribute("detailReport", detailReport);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Load danh sách cây của user cho Dropdown chọn cây
        UserPlantDAO plantDAO = new UserPlantDAO();
        List<UserPlant> userPlants = plantDAO.getByUserId(loggedUser.getUserID());
        request.setAttribute("userPlants", userPlants);

        // 3. Load lịch sử báo cáo của user
        List<PlantReport> userReports = reportDAO.getReportsByUserId(loggedUser.getUserID());
        request.setAttribute("userReports", userReports);

        // 4. Đếm số lượng thông báo chưa đọc
        int unreadCount = reportDAO.countUnreadResponses(loggedUser.getUserID());
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/reports.jsp").forward(request, response);
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

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String plantIdStr = request.getParameter("plantId");
            
            // Xử lý upload ảnh an toàn (không bắt buộc chọn file)
            String imageUrl = "";
            try {
                Part filePart = request.getPart("reportImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = getServletContext().getRealPath("/") + "assets" + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    imageUrl = "assets/images/" + fileName;
                }
            } catch (Exception ex) {
                // Bỏ qua nếu không upload ảnh
            }

            PlantReport report = new PlantReport();
            report.setUserID(loggedUser.getUserID());
            report.setTitle(title);
            report.setDescription(description);
            report.setImageUrl(imageUrl);

            if (plantIdStr != null && !plantIdStr.trim().isEmpty()) {
                report.setPlantID(Integer.parseInt(plantIdStr));
            }

            ReportDAO reportDAO = new ReportDAO();
            boolean success = reportDAO.insertReport(report);

            if (success) {
                // Xóa sạch dữ liệu tạm sau khi gửi thành công
                session.removeAttribute("fillPlantID");
                session.removeAttribute("fillTitle");
                session.removeAttribute("fillDescription");
                
                session.setAttribute("msgSuccess", "Gửi báo cáo thành công! Vui lòng chờ Admin phản hồi.");
            } else {
                session.setAttribute("msgError", "Có lỗi xảy ra, không thể gửi báo cáo.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msgError", "Lỗi hệ thống khi gửi báo cáo.");
        }

        response.sendRedirect(request.getContextPath() + "/reports");
    }
}