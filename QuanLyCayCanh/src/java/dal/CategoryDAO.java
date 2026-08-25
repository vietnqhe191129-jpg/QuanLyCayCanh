package dal;

import Models.PlantCategory;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    public List<PlantCategory> getAllCategories() {
        List<PlantCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM PlantCategories ORDER BY CategoryID DESC";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                list.add(new PlantCategory(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getString("ScientificName"),
                    rs.getString("Description"),
                    rs.getInt("DefaultWaterDays"),
                    rs.getString("LightRequirement"),
                    rs.getString("ImageUrl")
                ));
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO.getAllCategories: " + e.getMessage());
        }
        return list;
    }

    public PlantCategory getCategoryById(int id) {
        String sql = "SELECT * FROM PlantCategories WHERE CategoryID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new PlantCategory(
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"),
                        rs.getString("ScientificName"),
                        rs.getString("Description"),
                        rs.getInt("DefaultWaterDays"),
                        rs.getString("LightRequirement"),
                        rs.getString("ImageUrl")
                    );
                }
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO.getCategoryById: " + e.getMessage());
        }
        return null;
    }

    public boolean addCategory(PlantCategory cat) {
        String sql = "INSERT INTO PlantCategories (CategoryName, ScientificName, Description, DefaultWaterDays, LightRequirement, ImageUrl) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, cat.getCategoryName());
            stm.setString(2, cat.getScientificName());
            stm.setString(3, cat.getDescription());
            stm.setInt(4, cat.getDefaultWaterDays());
            stm.setString(5, cat.getLightRequirement());
            stm.setString(6, cat.getImageUrl());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("CategoryDAO.addCategory: " + e.getMessage());
        }
        return false;
    }

    public boolean updateCategory(PlantCategory cat) {
        String sql = "UPDATE PlantCategories SET CategoryName = ?, ScientificName = ?, Description = ?, DefaultWaterDays = ?, LightRequirement = ?, ImageUrl = ? WHERE CategoryID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, cat.getCategoryName());
            stm.setString(2, cat.getScientificName());
            stm.setString(3, cat.getDescription());
            stm.setInt(4, cat.getDefaultWaterDays());
            stm.setString(5, cat.getLightRequirement());
            stm.setString(6, cat.getImageUrl());
            stm.setInt(7, cat.getCategoryID());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("CategoryDAO.updateCategory: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM PlantCategories WHERE CategoryID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("CategoryDAO.deleteCategory: " + e.getMessage());
        }
        return false;
    }

    public List<PlantCategory> searchAndSortCategories(String search, String sort) {
        List<PlantCategory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM PlantCategories WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (CategoryName LIKE ? OR ScientificName LIKE ?) ");
        }
        if ("1".equals(sort)) {
            sql.append(" ORDER BY CategoryID ASC ");
        } else if ("0".equals(sort)) {
            sql.append(" ORDER BY CategoryID DESC ");
        } else {
            sql.append(" ORDER BY CategoryID DESC ");
        }
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                stm.setString(1, pattern);
                stm.setString(2, pattern);
            }
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    list.add(new PlantCategory(
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"),
                        rs.getString("ScientificName"),
                        rs.getString("Description"),
                        rs.getInt("DefaultWaterDays"),
                        rs.getString("LightRequirement"),
                        rs.getString("ImageUrl")
                    ));
                }
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO.searchAndSortCategories: " + e.getMessage());
        }
        return list;
    }
}
