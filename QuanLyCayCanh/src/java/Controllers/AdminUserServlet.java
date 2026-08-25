package Controllers;

import Models.User;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

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

        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");
        if ("toggle".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                
                // admin không khóa đưoc chính mình
                if (id == loggedUser.getUserID()) {
                    request.setAttribute("error", "Bạn không thể tự khoá tài khoản của chính mình!");
                } else {
                    userDAO.toggleUserStatus(id, status);
                }
            } catch (NumberFormatException e) {
                System.out.println("AdminUserServlet action error: " + e.getMessage());
            }
        }

        List<User> list = userDAO.getAllUsers();
        request.setAttribute("usersList", list);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
