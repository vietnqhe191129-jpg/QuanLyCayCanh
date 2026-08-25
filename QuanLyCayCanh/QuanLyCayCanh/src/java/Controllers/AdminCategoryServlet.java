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
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.deleteCategory(id);
            } catch (NumberFormatException e) {
                System.out.println("Delete category ID format error: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        } else if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                PlantCategory categoryToEdit = categoryDAO.getCategoryById(id);
                request.setAttribute("categoryToEdit", categoryToEdit);
            } catch (NumberFormatException e) {
                System.out.println("Edit category ID format error: " + e.getMessage());
            }
        }

        List<PlantCategory> list = categoryDAO.getAllCategories();
        request.setAttribute("categoriesList", list);
        request.getRequestDispatcher("/admin-categories.jsp").forward(request, response);
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

        CategoryDAO categoryDAO = new CategoryDAO();
        String action = request.getParameter("action");

        String name = request.getParameter("categoryName");
        String scientificName = request.getParameter("scientificName");
        String description = request.getParameter("description");
        String waterDaysStr = request.getParameter("defaultWaterDays");
        String light = request.getParameter("lightRequirement");
        String imageUrl = request.getParameter("imageUrl");

        int waterDays = 2; // default fallback
        try {
            if (waterDaysStr != null && !waterDaysStr.trim().isEmpty()) {
                waterDays = Integer.parseInt(waterDaysStr);
            }
        } catch (NumberFormatException e) {
            System.out.println("waterDays format error: " + e.getMessage());
        }

        if ("add".equals(action)) {
            PlantCategory cat = new PlantCategory(0, name, scientificName, description, waterDays, light, imageUrl);
            categoryDAO.addCategory(cat);
        } else if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                PlantCategory cat = new PlantCategory(id, name, scientificName, description, waterDays, light, imageUrl);
                categoryDAO.updateCategory(cat);
            } catch (NumberFormatException e) {
                System.out.println("Update category ID format error: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
