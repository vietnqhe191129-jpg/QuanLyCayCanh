package dal;

import Models.UserPlant;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserPlantDAO extends DBContext {

    public ArrayList<UserPlant> getUserPlants(int userId, String searchName, String location) {
        ArrayList<UserPlant> list = new ArrayList<>();
        // Câu lệnh gốc lấy cây của user đang đăng nhập
        String sql = "SELECT * FROM UserPlants WHERE UserID = ?";

        // Nối thêm điều kiện tìm kiếm nếu có
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND CustomName LIKE ?";
        }
        // Nối thêm điều kiện lọc vị trí nếu khác "All"
        if (location != null && !location.trim().isEmpty() && !location.equals("All")) {
            sql += " AND LocationInHome = ?";
        }

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            int paramIndex = 2; // Biến đếm vị trí của dấu ? tiếp theo

            // Đổ dữ liệu vào các dấu ? vừa được nối thêm
            if (searchName != null && !searchName.trim().isEmpty()) {
                stm.setString(paramIndex++, "%" + searchName + "%"); // Dùng % để tìm gần đúng
            }
            if (location != null && !location.trim().isEmpty() && !location.equals("All")) {
                stm.setString(paramIndex++, location);
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                UserPlant p = new UserPlant();
                p.setPlantId(rs.getInt("PlantID"));
                p.setUserId(rs.getInt("UserID"));
                // categoryID có thể bị null trong DB nên cần lấy qua Object
                p.setCategoryId(rs.getObject("CategoryID") != null ? rs.getInt("CategoryID") : null);
                p.setCustomName(rs.getString("CustomName"));
                p.setLocationInHome(rs.getString("LocationInHome"));
                p.setPlantedDate(rs.getDate("PlantedDate"));
                p.setHealthStatus(rs.getString("HealthStatus"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setNote(rs.getString("Note"));

                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getUserPlants: " + e.getMessage());
        }
        return list;
    }

    public boolean deletePlant(int plantId, int userId) {
        // Kèm thêm điều kiện UserID để bảo mật, đảm bảo người này không xóa trộm cây của người khác
        String sql = "DELETE FROM UserPlants WHERE PlantID = ? AND UserID = ?";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, plantId);
            stm.setInt(2, userId);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deletePlant: " + e.getMessage());
        }
        return false;
    }
    // Lấy thông tin cây theo ID (Kèm UserID để bảo mật)

    public UserPlant getPlantById(int plantId, int userId) {
        String sql = "SELECT * FROM UserPlants WHERE PlantID = ? AND UserID = ?";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, plantId);
            stm.setInt(2, userId);
            java.sql.ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                UserPlant p = new UserPlant();
                p.setPlantId(rs.getInt("PlantID"));
                p.setCategoryId(rs.getObject("CategoryID") != null ? rs.getInt("CategoryID") : null);
                p.setCustomName(rs.getString("CustomName"));
                p.setLocationInHome(rs.getString("LocationInHome"));
                p.setHealthStatus(rs.getString("HealthStatus"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setNote(rs.getString("Note"));
                return p;
            }
        } catch (Exception e) {
            System.out.println("Lỗi getPlantById: " + e.getMessage());
        }
        return null;
    }

// Cập nhật thông tin cây
    public boolean updatePlant(UserPlant p) {
        String sql = "UPDATE UserPlants SET CategoryID=?, CustomName=?, LocationInHome=?, HealthStatus=?, ImageUrl=?, Note=? WHERE PlantID=? AND UserID=?";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            if (p.getCategoryId() != null) {
                stm.setInt(1, p.getCategoryId());
            } else {
                stm.setNull(1, java.sql.Types.INTEGER);
            }

            stm.setString(2, p.getCustomName());
            stm.setString(3, p.getLocationInHome());
            stm.setString(4, p.getHealthStatus());
            stm.setString(5, p.getImageUrl());
            stm.setString(6, p.getNote());
            stm.setInt(7, p.getPlantId());
            stm.setInt(8, p.getUserId());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updatePlant: " + e.getMessage());
        }
        return false;
    }

    // Hàm thêm một cây mới vào cơ sở dữ liệu
    public boolean insertPlant(UserPlant p) {
        // Cột PlantedDate sử dụng hàm GETDATE() của SQL Server để tự động lấy ngày hiện tại
        String sql = "INSERT INTO UserPlants (UserID, CategoryID, CustomName, LocationInHome, HealthStatus, ImageUrl, Note, PlantedDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);

            // Điền dữ liệu vào các dấu ?
            stm.setInt(1, p.getUserId());

            // Xử lý CategoryID (Vì có thể người dùng chọn "Tự nhập tên riêng" -> Null)
            if (p.getCategoryId() != null) {
                stm.setInt(2, p.getCategoryId());
            } else {
                stm.setNull(2, java.sql.Types.INTEGER);
            }

            stm.setString(3, p.getCustomName());
            stm.setString(4, p.getLocationInHome());
            stm.setString(5, p.getHealthStatus());
            stm.setString(6, p.getImageUrl());
            stm.setString(7, p.getNote());

            // Thực thi lệnh INSERT
            return stm.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi insertPlant: " + e.getMessage());
        }
        return false;
    }

    public List<UserPlant> getByUserId(int userId) {
        List<UserPlant> list = new ArrayList<>();

        String sql = "SELECT * FROM UserPlants WHERE UserID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserPlant p = new UserPlant();
                p.setPlantId(rs.getInt("PlantID"));
                p.setCustomName(rs.getString("CustomName"));
                p.setLocationInHome(rs.getString("LocationInHome"));
                p.setHealthStatus(rs.getString("HealthStatus"));
                p.setImageUrl(rs.getString("ImageUrl"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    public UserPlant getById(int plantId) {

    String sql = """
        SELECT *
        FROM UserPlants
        WHERE PlantID = ?
    """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, plantId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            UserPlant plant = new UserPlant();

            plant.setPlantId(rs.getInt("PlantID"));
            plant.setUserId(rs.getInt("UserID"));

            int categoryId = rs.getInt("CategoryID");

            if (rs.wasNull()) {
                plant.setCategoryId(null);
            } else {
                plant.setCategoryId(categoryId);
            }

            plant.setCustomName(rs.getString("CustomName"));
            plant.setLocationInHome(rs.getString("LocationInHome"));
            plant.setPlantedDate(rs.getDate("PlantedDate"));
            plant.setHealthStatus(rs.getString("HealthStatus"));
            plant.setImageUrl(rs.getString("ImageUrl"));
            plant.setNote(rs.getString("Note"));

            return plant;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}
}
