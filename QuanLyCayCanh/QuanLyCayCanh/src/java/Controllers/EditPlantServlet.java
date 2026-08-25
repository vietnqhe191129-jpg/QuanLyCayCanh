/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import Models.User;
import Models.UserPlant;
import dal.CategoryDAO;
import dal.UserPlantDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
public class EditPlantServlet extends HttpServlet {
   
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
            out.println("<title>Servlet EditPlantServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditPlantServlet at " + request.getContextPath () + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        int plantId = Integer.parseInt(request.getParameter("id"));
        UserPlant plant = new UserPlantDAO().getPlantById(plantId, user.getUserID());
        
        request.setAttribute("plant", plant);
        request.setAttribute("listCategory", new CategoryDAO().getAllCategories());
        request.getRequestDispatcher("edit-plant.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        
        UserPlant p = new UserPlant();
        p.setPlantId(Integer.parseInt(request.getParameter("plantID")));
        p.setUserId(user.getUserID());
        
        String catId = request.getParameter("categoryID");
        p.setCategoryId((catId != null && !catId.isEmpty()) ? Integer.parseInt(catId) : null);
        p.setCustomName(request.getParameter("customName"));
        p.setLocationInHome(request.getParameter("location"));
        p.setHealthStatus(request.getParameter("healthStatus"));
        p.setImageUrl(request.getParameter("imageUrl"));
        p.setNote(request.getParameter("note"));

        new UserPlantDAO().updatePlant(p);
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
