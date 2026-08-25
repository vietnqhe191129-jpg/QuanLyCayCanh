/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import Models.GrowthDiary;
import dal.GrowthDiaryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
/**
 *
 * @author vktuy
 */
public class DiaryServlet extends HttpServlet {
   
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
            out.println("<title>Servlet DiaryServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DiaryServlet at " + request.getContextPath () + "</h1>");
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
         String action = request.getParameter("action");

        try {

            if ("edit".equals(action)) {

                int diaryId =
                        Integer.parseInt(
                                request.getParameter("diaryId")
                        );

                GrowthDiaryDAO dao = new GrowthDiaryDAO();

                GrowthDiary diary =
                        dao.getById(diaryId);

                if (diary == null) {
                    response.sendRedirect(
                            request.getContextPath() + "/Care"
                    );
                    return;
                }

                request.setAttribute(
                        "editDiary",
                        diary
                );

                request.getRequestDispatcher(
                        "/edit-diary.jsp"
                ).forward(request, response);

                return;
            }

            int plantId =
                    Integer.parseInt(
                            request.getParameter("plantId")
                    );

            GrowthDiaryDAO dao =
                    new GrowthDiaryDAO();

            List<GrowthDiary> diaries =
                    dao.getByPlantId(plantId);

            request.setAttribute(
                    "plantId",
                    plantId
            );

            request.setAttribute(
                    "diaries",
                    diaries
            );

            request.getRequestDispatcher(
                    "/growth-diary.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/Care"
            );
        }
    
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

         request.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");

        try {

            if ("update".equals(action)) {

                updateDiary(
                        request,
                        response
                );

            } else if ("delete".equals(action)) {

                deleteDiary(
                        request,
                        response
                );

            } else {

                insertDiary(
                        request,
                        response
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/Care"
            );
        }
    }
    private void insertDiary(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int plantId =
                Integer.parseInt(
                        request.getParameter("plantId")
                );

        String heightStr =
                request.getParameter("heightCm");

        String imageUrl =
                request.getParameter("imageUrl");

        String note =
                request.getParameter("note");

        Double heightCm = null;

        if (heightStr != null
                && !heightStr.trim().isEmpty()) {

            heightCm =
                    Double.parseDouble(heightStr);
        }

        GrowthDiary diary =
                new GrowthDiary();

        diary.setPlantId(plantId);
        diary.setHeightCm(heightCm);
        diary.setImageUrl(imageUrl);
        diary.setNote(note);

        GrowthDiaryDAO dao =
                new GrowthDiaryDAO();

        dao.insert(diary);

        response.sendRedirect(
                request.getContextPath()
                + "/Diary?plantId="
                + plantId
        );
    }


    private void updateDiary(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int diaryId =
                Integer.parseInt(
                        request.getParameter("diaryId")
                );

        int plantId =
                Integer.parseInt(
                        request.getParameter("plantId")
                );

        String heightStr =
                request.getParameter("heightCm");

        String imageUrl =
                request.getParameter("imageUrl");

        String note =
                request.getParameter("note");

        Double heightCm = null;

        if (heightStr != null
                && !heightStr.trim().isEmpty()) {

            heightCm =
                    Double.parseDouble(heightStr);
        }

        GrowthDiary diary =
                new GrowthDiary();

        diary.setDiaryId(diaryId);
        diary.setPlantId(plantId);
        diary.setHeightCm(heightCm);
        diary.setImageUrl(imageUrl);
        diary.setNote(note);

        GrowthDiaryDAO dao =
                new GrowthDiaryDAO();

        dao.update(diary);

        response.sendRedirect(
                request.getContextPath()
                + "/Diary?plantId="
                + plantId
        );
    }


    private void deleteDiary(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int diaryId =
                Integer.parseInt(
                        request.getParameter("diaryId")
                );

        int plantId =
                Integer.parseInt(
                        request.getParameter("plantId")
                );

        GrowthDiaryDAO dao =
                new GrowthDiaryDAO();

        dao.delete(diaryId);

        response.sendRedirect(
                request.getContextPath()
                + "/Diary?plantId="
                + plantId
        );
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
