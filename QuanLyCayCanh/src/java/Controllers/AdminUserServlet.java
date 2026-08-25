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

        // Xử lý Xoá mềm / Khoá / Mở khoá (mode1 = 1 hoặc action = toggle)
        String mode1 = request.getParameter("mode1");
        if ("1".equals(mode1)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id == loggedUser.getUserID()) {
                    request.setAttribute("error", "Không thể tự khoá tài khoản của chính mình!");
                } else {
                    String statusParam = request.getParameter("status");
                    boolean newStatus;
                    if (statusParam != null) {
                        newStatus = Boolean.parseBoolean(statusParam);
                    } else {
                        User u = userDAO.getUserById(id);
                        newStatus = (u != null && !u.isStatus());
                    }
                    userDAO.toggleUserStatus(id, newStatus);
                    request.setAttribute("success", newStatus ? "Mở khoá tài khoản thành công!" : "Đã khoá tài khoản!");
                }
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse id mode1: " + e.getMessage());
            }
        }

        // Xử lý Search
        String searchValue = request.getParameter("searchValue");
        List<User> data = userDAO.searchAndSortUsers(searchValue, null);

        request.setAttribute("data", data);
        request.setAttribute("usersList", data);
        request.setAttribute("searchValue", searchValue);

        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
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

        UserDAO userDAO = new UserDAO();

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String statusStr = request.getParameter("status");
        boolean status = "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr) || "on".equalsIgnoreCase(statusStr);

        // Chỉ xử lý nút ADD (Người dùng tự update thông tin trong profile cá nhân)
        if (request.getParameter("add") != null) {
            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()
                    || email == null || email.trim().isEmpty() || fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc!");
            } else if (userDAO.checkDuplicate(username.trim(), email.trim())) {
                request.setAttribute("error", "Tên đăng nhập hoặc Email đã tồn tại!");
            } else {
                if (role == null || role.trim().isEmpty()) {
                    role = "USER";
                }
                User newUser = new User(0, username.trim(), password.trim(), fullName.trim(), email.trim(),
                        phone != null ? phone.trim() : "", role, status, null);
                boolean ok = userDAO.addUser(newUser);
                if (ok) {
                    request.setAttribute("success", "Thêm người dùng mới thành công!");
                } else {
                    request.setAttribute("error", "Đã có lỗi xảy ra khi thêm người dùng!");
                }
            }
        }

        // Load lại danh sách sau khi thêm
        String searchValue = request.getParameter("searchValue");
        List<User> data = userDAO.searchAndSortUsers(searchValue, null);

        request.setAttribute("data", data);
        request.setAttribute("usersList", data);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }
}
