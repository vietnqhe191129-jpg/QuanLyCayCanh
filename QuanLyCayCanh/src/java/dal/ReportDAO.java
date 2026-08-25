package dal;

import Models.PlantReport;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO extends DBContext {

    public List<PlantReport> getAllReports(String statusFilter) {
        List<PlantReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, u.FullName AS UserFullName, p.CustomName AS PlantCustomName " +
            "FROM PlantReports r " +
            "JOIN Users u ON r.UserID = u.UserID " +
            "LEFT JOIN UserPlants p ON r.PlantID = p.PlantID "
        );
        
        boolean hasFilter = statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all");
        if (hasFilter) {
            sql.append("WHERE r.Status = ? ");
        }
        sql.append("ORDER BY r.CreatedAt DESC");

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            if (hasFilter) {
                stm.setString(1, statusFilter);
            }
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    PlantReport report = new PlantReport(
                        rs.getInt("ReportID"),
                        rs.getInt("UserID"),
                        rs.getObject("PlantID") != null ? rs.getInt("PlantID") : null,
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getString("ImageUrl"),
                        rs.getString("Status"),
                        rs.getString("AdminResponse"),
                        rs.getTimestamp("CreatedAt")
                    );
                    report.setUserFullName(rs.getString("UserFullName"));
                    report.setPlantCustomName(rs.getString("PlantCustomName"));
                    list.add(report);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO.getAllReports: " + e.getMessage());
        }
        return list;
    }

    public PlantReport getReportById(int reportId) {
        String sql = "SELECT r.*, u.FullName AS UserFullName, p.CustomName AS PlantCustomName " +
                     "FROM PlantReports r " +
                     "JOIN Users u ON r.UserID = u.UserID " +
                     "LEFT JOIN UserPlants p ON r.PlantID = p.PlantID " +
                     "WHERE r.ReportID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, reportId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    PlantReport report = new PlantReport(
                        rs.getInt("ReportID"),
                        rs.getInt("UserID"),
                        rs.getObject("PlantID") != null ? rs.getInt("PlantID") : null,
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getString("ImageUrl"),
                        rs.getString("Status"),
                        rs.getString("AdminResponse"),
                        rs.getTimestamp("CreatedAt")
                    );
                    report.setUserFullName(rs.getString("UserFullName"));
                    report.setPlantCustomName(rs.getString("PlantCustomName"));
                    return report;
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO.getReportById: " + e.getMessage());
        }
        return null;
    }

    public boolean updateReportResponse(int reportId, String response) {
        String sql = "UPDATE PlantReports SET AdminResponse = ?, Status = N'Đã tư vấn' WHERE ReportID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, response);
            stm.setInt(2, reportId);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("ReportDAO.updateReportResponse: " + e.getMessage());
        }
        return false;
    }
}
