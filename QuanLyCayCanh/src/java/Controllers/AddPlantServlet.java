/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import Models.User;
import Models.UserPlant;
import dal.UserPlantDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
public class AddPlantServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddPlantServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddPlantServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Hỗ trợ nhận diện tiếng Việt có dấu
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra xem User đã đăng nhập chưa
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy ID danh mục (nếu người dùng không chọn mẫu, giá trị sẽ là null)
        String categoryIDStr = request.getParameter("categoryID");
        Integer categoryID = (categoryIDStr != null && !categoryIDStr.trim().isEmpty()) 
                             ? Integer.parseInt(categoryIDStr) : null;

        // Đóng gói thông tin cây từ Form vào Object
        UserPlant p = new UserPlant();
        p.setUserId(user.getUserID());
        p.setCategoryId(categoryID);
        p.setCustomName(request.getParameter("customName"));
        p.setLocationInHome(request.getParameter("location"));
        p.setHealthStatus(request.getParameter("healthStatus"));
        p.setImageUrl(request.getParameter("imageUrl"));
        p.setNote(request.getParameter("note"));

        // Gọi DAO để lưu xuống CSDL
        UserPlantDAO dao = new UserPlantDAO();
        dao.insertPlant(p);
        
        // Lưu xong, đẩy người dùng về lại trang danh sách vườn cây
        response.sendRedirect("my-garden");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
