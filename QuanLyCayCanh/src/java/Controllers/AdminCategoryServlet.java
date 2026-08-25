package Controllers;

import Models.PlantCategory;
import Models.User;
import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoryServlet extends HttpServlet {

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

        CategoryDAO categoryDAO = new CategoryDAO();

        // Xử lý Delete (mode1 = 1)
        String mode1 = request.getParameter("mode1");
        if ("1".equals(mode1)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.deleteCategory(id);
                request.setAttribute("success", "Xoá loài cây thành công!");
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse id mode1: " + e.getMessage());
            }
        }

        // Xử lý Select (mode2 = 1) để load dữ liệu lên form
        String mode2 = request.getParameter("mode2");
        if ("1".equals(mode2)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                PlantCategory p = categoryDAO.getCategoryById(id);
                request.setAttribute("p", p);
                request.setAttribute("categoryToEdit", p);
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse id mode2: " + e.getMessage());
            }
        }

        // Xử lý Search & Sort
        String searchValue = request.getParameter("searchValue");
        String sort = request.getParameter("sort");
        List<PlantCategory> data = categoryDAO.searchAndSortCategories(searchValue, sort);

        request.setAttribute("data", data);
        request.setAttribute("categoriesList", data);
        request.setAttribute("searchValue", searchValue);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/admin-categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
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

        CategoryDAO categoryDAO = new CategoryDAO();

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String scientificName = request.getParameter("scientificName");
        String description = request.getParameter("description");
        String waterDaysStr = request.getParameter("defaultWaterDays");
        String light = request.getParameter("lightRequirement");

        int waterDays = 2;
        try {
            if (waterDaysStr != null && !waterDaysStr.trim().isEmpty()) {
                waterDays = Integer.parseInt(waterDaysStr.trim());
            }
        } catch (NumberFormatException e) {
            System.out.println("waterDays format error: " + e.getMessage());
        }

        // Nút ADD
        if (request.getParameter("add") != null) {
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên loài cây không được để trống!");
            } else {
                PlantCategory cat = new PlantCategory(0, name.trim(),
                        scientificName != null ? scientificName.trim() : "",
                        description != null ? description.trim() : "",
                        waterDays, light, "");
                boolean ok = categoryDAO.addCategory(cat);
                if (ok) {
                    request.setAttribute("success", "Thêm loài cây mới thành công!");
                } else {
                    request.setAttribute("error", "Đã có lỗi khi thêm loài cây!");
                }
            }
        }

        // Nút UPDATE
        if (request.getParameter("update") != null) {
            try {
                int id = Integer.parseInt(idStr);
                PlantCategory existing = categoryDAO.getCategoryById(id);
                String image = existing != null && existing.getImageUrl() != null ? existing.getImageUrl() : "";
                
                PlantCategory cat = new PlantCategory(id, name != null ? name.trim() : "",
                        scientificName != null ? scientificName.trim() : "",
                        description != null ? description.trim() : "",
                        waterDays, light, image);
                boolean ok = categoryDAO.updateCategory(cat);
                if (ok) {
                    request.setAttribute("success", "Cập nhật loài cây thành công!");
                } else {
                    request.setAttribute("error", "Cập nhật thất bại!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Vui lòng chọn loài cây hợp lệ để cập nhật!");
            }
        }

        // Load lại danh sách
        String searchValue = request.getParameter("searchValue");
        String sort = request.getParameter("sort");
        List<PlantCategory> data = categoryDAO.searchAndSortCategories(searchValue, sort);

        request.setAttribute("data", data);
        request.setAttribute("categoriesList", data);
        request.getRequestDispatcher("/admin-categories.jsp").forward(request, response);
    }
}
