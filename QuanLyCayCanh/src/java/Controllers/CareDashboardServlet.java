/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.CareSchedule;
import Models.User;
import Models.UserPlant;
import dal.CareScheduleDAO;
import dal.UserPlantDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author vktuy
 */
public class CareDashboardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet CareDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CareDashboardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        int userId = user.getUserID();

        UserPlantDAO plantDAO = new UserPlantDAO();
        CareScheduleDAO scheduleDAO = new CareScheduleDAO();

        List<UserPlant> plants
                = plantDAO.getByUserId(userId);

        Map<Integer, CareSchedule> scheduleMap
                = new HashMap<>();

        Map<Integer, String> waterStatusMap
                = new HashMap<>();

        Map<Integer, Long> daysUntilWaterMap
                = new HashMap<>();

        LocalDate today = LocalDate.now();

        for (UserPlant plant : plants) {

            CareSchedule schedule
                    = scheduleDAO.getWaterScheduleByPlantId(
                            plant.getPlantId()
                    );

            if (schedule != null) {

                scheduleMap.put(
                        plant.getPlantId(),
                        schedule
                );

                if (schedule.getNextDueDate() != null) {

                    LocalDate dueDate
                            = schedule
                                    .getNextDueDate()
                                    .toLocalDateTime()
                                    .toLocalDate();

                    if (dueDate.isBefore(today)) {

                        waterStatusMap.put(
                                plant.getPlantId(),
                                "OVERDUE"
                        );

                    } else if (dueDate.isEqual(today)) {

                        waterStatusMap.put(
                                plant.getPlantId(),
                                "TODAY"
                        );

                    } else {

                        waterStatusMap.put(
                                plant.getPlantId(),
                                "UPCOMING"
                        );

                        long days
                                = ChronoUnit.DAYS.between(
                                        today,
                                        dueDate
                                );

                        daysUntilWaterMap.put(
                                plant.getPlantId(),
                                days
                        );
                    }

                } else {

                    // Có schedule nhưng chưa có ngày tiếp theo
                    waterStatusMap.put(
                            plant.getPlantId(),
                            "NO_SCHEDULE"
                    );
                }

            } else {

                waterStatusMap.put(
                        plant.getPlantId(),
                        "NO_SCHEDULE"
                );
            }
        }

        // ==============================
        // QUAN TRỌNG: GỬI DATA SANG JSP
        // ==============================
        request.setAttribute(
                "plants",
                plants
        );

        request.setAttribute(
                "scheduleMap",
                scheduleMap
        );

        request.setAttribute(
                "waterStatusMap",
                waterStatusMap
        );

        request.setAttribute(
                "daysUntilWaterMap",
                daysUntilWaterMap
        );

        // ==============================
        // FORWARD SANG JSP
        // ==============================
        request.getRequestDispatcher(
                "/Care-dashboard.jsp"
        ).forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
