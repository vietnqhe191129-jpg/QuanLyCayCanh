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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userParam = request.getParameter("username");
        String passParam = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(userParam, passParam);

        if (user != null) {
            if (!user.isStatus()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khoá!");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // If it's a regular user, redirect to index
                response.sendRedirect(request.getContextPath() + "/index.html");
            }
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
