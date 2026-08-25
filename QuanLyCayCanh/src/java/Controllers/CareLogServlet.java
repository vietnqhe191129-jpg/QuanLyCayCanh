/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import dal.CareLogDAO;
import dal.CareScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author vktuy
 */
public class CareLogServlet extends HttpServlet {
   
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
            out.println("<title>Servlet CareLogServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CareLogServlet at " + request.getContextPath () + "</h1>");
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
         request.setCharacterEncoding("UTF-8");

        try {

            int scheduleId =
                    Integer.parseInt(
                            request.getParameter("scheduleId")
                    );

            int plantId =
                    Integer.parseInt(
                            request.getParameter("plantId")
                    );

            String actionType =
                    request.getParameter("actionType");

            if (actionType == null
                    || actionType.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/TodayTask"
                );

                return;
            }

            CareLogDAO logDAO = new CareLogDAO();
            CareScheduleDAO scheduleDAO =
                    new CareScheduleDAO();

            /*
             * 1. Lưu lịch sử chăm sóc
             */
            logDAO.insert(
                    plantId,
                    actionType
            );

            /*
             * 2. Gia hạn lịch tiếp theo
             */
            scheduleDAO.markAsDone(scheduleId);

            /*
             * 3. Quay lại checklist
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/TodayTask"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/TodayTask"
            );
        }
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
