package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO extends DBContext {

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE Role = 'USER'";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO.getTotalUsers: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalPlants() {
        String sql = "SELECT COUNT(*) FROM UserPlants";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO.getTotalPlants: " + e.getMessage());
        }
        return 0;
    }

    public int getPendingReportsCount() {
        String sql = "SELECT COUNT(*) FROM PlantReports WHERE Status = N'Chờ xử lý'";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO.getPendingReportsCount: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalCategoriesCount() {
        String sql = "SELECT COUNT(*) FROM PlantCategories";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO.getTotalCategoriesCount: " + e.getMessage());
        }
        return 0;
    }
}
