package dal;

import Models.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            stm.setString(2, password);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("Phone"),
                            rs.getString("Role"),
                            rs.getBoolean("Status"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        } catch (Exception e) {
            System.out.println("UserDAO.login: " + e.getMessage());
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY CreatedAt DESC";
        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        null, // Don't expose password hash/string in listings
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("Phone"),
                        rs.getString("Role"),
                        rs.getBoolean("Status"),
                        rs.getTimestamp("CreatedAt")
                ));
            }
        } catch (Exception e) {
            System.out.println("UserDAO.getAllUsers: " + e.getMessage());
        }
        return list;
    }

    public boolean toggleUserStatus(int userID, boolean newStatus) {
        String sql = "UPDATE Users SET Status = ? WHERE UserID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setBoolean(1, newStatus);
            stm.setInt(2, userID);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("UserDAO.toggleUserStatus: " + e.getMessage());
        }
        return false;
    }

    // Hàm cập nhật hồ sơ cá nhân
    public boolean updateProfile(String username, String email, String phone, String password) {
        String sql = "UPDATE Users SET Email = ?, Phone = ?, Password = ? WHERE Username = ?";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            stm.setString(2, phone);
            stm.setString(3, password);
            stm.setString(4, username);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateProfile: " + e.getMessage());
        }
        return false;
    }
    // Kiểm tra trùng lặp Username hoặc Email

    public boolean checkDuplicate(String username, String email) {
        String sql = "SELECT * FROM Users WHERE Username = ? OR Email = ?";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, email);
            java.sql.ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return true; // Đã tồn tại
            }
        } catch (Exception e) {
            System.out.println("Lỗi checkDuplicate: " + e.getMessage());
        }
        return false;
    }

// Thêm User mới
    public boolean registerUser(String username, String password, String fullName, String email, String phone) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Phone) VALUES (?, ?, ?, ?, ?)";
        try {
            java.sql.PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            stm.setString(3, fullName);
            stm.setString(4, email);
            stm.setString(5, phone);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi registerUser: " + e.getMessage());
        }
        return false;
    }
}
