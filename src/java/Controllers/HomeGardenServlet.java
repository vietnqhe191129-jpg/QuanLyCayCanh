package Controllers;

import Models.PlantCategory;
import Models.User;
import Models.UserPlant;
import dal.CategoryDAO;
import dal.ReportDAO;
import dal.UserPlantDAO;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet(name = "HomeGardenServlet", urlPatterns = {"/my-garden"})
public class HomeGardenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra đăng nhập (Bảo mật Route)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Hứng tham số từ form bộ lọc (nếu có)
        String search = request.getParameter("search");
        String location = request.getParameter("location");

        // 3. Gọi DAO lấy danh sách cây
        UserPlantDAO dao = new UserPlantDAO();
        ArrayList<UserPlant> list = dao.getUserPlants(user.getUserID(), search, location);

        // 4. Đóng gói dữ liệu cây gửi sang JSP
        request.setAttribute("listPlant", list);
        request.setAttribute("search", search);     // Giữ lại text tìm kiếm trên ô input
        request.setAttribute("location", location); // Giữ lại lựa chọn dropdown

        // 5. Gọi CategoryDAO để lấy danh sách PlantCategory cho form thêm mới
        CategoryDAO catDao = new CategoryDAO();
        List<PlantCategory> listCategory = catDao.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        // 6. Đếm số lượng phản hồi/báo cáo đã được Admin tư vấn để hiện huy hiệu chấm đỏ trên Navbar
        ReportDAO reportDAO = new ReportDAO();
        int unreadCount = reportDAO.countUnreadResponses(user.getUserID());
        request.setAttribute("unreadCount", unreadCount);

        // 7. Chuyển hướng sang giao diện my-garden.jsp
        request.getRequestDispatcher("my-garden.jsp").forward(request, response);
    }
    
    
}