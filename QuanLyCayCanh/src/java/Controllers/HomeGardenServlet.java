package Controllers;

import Models.PlantCategory;
import Models.User;
import Models.UserPlant;
import dal.CategoryDAO;
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
        User user = (User) session.getAttribute("user"); // Đảm bảo lúc Login em đã setAttribute là "user"
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Hứng tham số từ form bộ lọc (nếu có)
        String search = request.getParameter("search");
        String location = request.getParameter("location");

        // 3. Gọi DAO lấy danh sách
        UserPlantDAO dao = new UserPlantDAO();
        ArrayList<UserPlant> list = dao.getUserPlants(user.getUserID(), search, location);

        // 4. Đóng gói dữ liệu gửi sang JSP
        request.setAttribute("listPlant", list);
        request.setAttribute("search", search);     // Giữ lại text tìm kiếm trên ô input
        request.setAttribute("location", location); // Giữ lại lựa chọn dropdown

        // Gọi CategoryDAO của em để lấy danh sách PlantCategory
        CategoryDAO catDao = new CategoryDAO();
        List<PlantCategory> listCategory = catDao.getAllCategories();

        // Đóng gói gửi sang giao diện my-garden.jsp
        request.setAttribute("listCategory", listCategory);
        request.getRequestDispatcher("my-garden.jsp").forward(request, response);
    }
}
