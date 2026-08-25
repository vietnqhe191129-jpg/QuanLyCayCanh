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
                "SELECT r.*, u.FullName AS UserFullName, p.CustomName AS PlantCustomName "
                + "FROM PlantReports r "
                + "JOIN Users u ON r.UserID = u.UserID "
                + "LEFT JOIN UserPlants p ON r.PlantID = p.PlantID "
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
        String sql = "SELECT r.*, u.FullName AS UserFullName, p.CustomName AS PlantCustomName "
                + "FROM PlantReports r "
                + "JOIN Users u ON r.UserID = u.UserID "
                + "LEFT JOIN UserPlants p ON r.PlantID = p.PlantID "
                + "WHERE r.ReportID = ?";
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

    public boolean insertReport(PlantReport report) {
        String sql = "INSERT INTO PlantReports (UserID, PlantID, Title, Description, ImageUrl, Status, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, N'Chờ xử lý', GETDATE())";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, report.getUserID());

            if (report.getPlantID() != null && report.getPlantID() > 0) {
                stm.setInt(2, report.getPlantID());
            } else {
                stm.setNull(2, java.sql.Types.INTEGER);
            }

            stm.setString(3, report.getTitle());
            stm.setString(4, report.getDescription());
            stm.setString(5, report.getImageUrl());

            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("ReportDAO.insertReport: " + e.getMessage());
        }
        return false;
    }

    public List<PlantReport> getReportsByUserId(int userId) {
        List<PlantReport> list = new ArrayList<>();
        String sql = "SELECT r.*, p.CustomName AS PlantCustomName "
                + "FROM PlantReports r "
                + "LEFT JOIN UserPlants p ON r.PlantID = p.PlantID "
                + "WHERE r.UserID = ? "
                + "ORDER BY r.CreatedAt DESC";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
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
                    report.setPlantCustomName(rs.getString("PlantCustomName"));
                    list.add(report);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO.getReportsByUserId: " + e.getMessage());
        }
        return list;
    }

    public int countUnreadResponses(int userId) {
        // Chỉ đếm những báo cáo đã được Admin tư vấn nhưng User chưa bấm xác nhận kết quả
        String sql = "SELECT COUNT(*) FROM PlantReports WHERE UserID = ? AND Status = N'Đã tư vấn'";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO.countUnreadResponses: " + e.getMessage());
        }
        return 0;
    }

    // Cập nhật trạng thái báo cáo khi User xác nhận khỏi bệnh ('Đã hoàn thành') hoặc tiếp tục xử lý
    public boolean updateReportStatus(int reportId, String newStatus) {
        String sql = "UPDATE PlantReports SET Status = ? WHERE ReportID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, newStatus);
            stm.setInt(2, reportId);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("ReportDAO.updateReportStatus: " + e.getMessage());
        }
        return false;
    }
}
