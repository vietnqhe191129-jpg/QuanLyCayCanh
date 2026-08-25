/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import dal.CareScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.sql.Timestamp;
/**
 *
 * @author vktuy
 */
public class WaterScheduleServlet extends HttpServlet {
   
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
            out.println("<title>Servlet WaterScheduleServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WaterScheduleServlet at " + request.getContextPath () + "</h1>");
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

            int plantId =
                    Integer.parseInt(
                            request.getParameter("plantId")
                    );

            int frequencyDays =
                    Integer.parseInt(
                            request.getParameter("frequencyDays")
                    );


            String lastPerformedStr =
                    request.getParameter("lastPerformed");


            // ==========================
            // VALIDATION
            // ==========================

            if (frequencyDays <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Care"
                );

                return;
            }


            LocalDate lastPerformedDate =
                    LocalDate.parse(lastPerformedStr);


            LocalDate nextDueDate =
                    lastPerformedDate.plusDays(
                            frequencyDays
                    );


            Timestamp lastPerformed =
                    Timestamp.valueOf(
                            lastPerformedDate.atStartOfDay()
                    );


            Timestamp nextDue =
                    Timestamp.valueOf(
                            nextDueDate.atStartOfDay()
                    );


            CareScheduleDAO dao =
                    new CareScheduleDAO();


            String scheduleIdStr =
                    request.getParameter("scheduleId");


            // ==========================
            // INSERT
            // ==========================

            if (scheduleIdStr == null
                    || scheduleIdStr.isBlank()) {

                dao.insertWaterSchedule(
                        plantId,
                        frequencyDays,
                        lastPerformed,
                        nextDue
                );

            }

            // ==========================
            // UPDATE
            // ==========================

            else {

                int scheduleId =
                        Integer.parseInt(scheduleIdStr);


                dao.updateWaterSchedule(
                        scheduleId,
                        frequencyDays,
                        lastPerformed,
                        nextDue
                );
            }


            response.sendRedirect(
                    request.getContextPath()
                    + "/Care"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/Care"
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
