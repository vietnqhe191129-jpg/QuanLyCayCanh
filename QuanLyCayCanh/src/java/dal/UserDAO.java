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
        String sql = "SELECT UserID FROM Users WHERE Username = ? OR Email = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            stm.setString(2, email);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return true; // Đã tồn tại
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi checkDuplicate: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, user.getUsername());
            stm.setString(2, user.getPassword());
            stm.setString(3, user.getFullName());
            stm.setString(4, user.getEmail());
            stm.setString(5, user.getPhone());
            stm.setString(6, user.getRole());
            stm.setBoolean(7, user.isStatus());
            int rows = stm.executeUpdate();
            System.out.println("UserDAO.addUser rows affected: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.out.println("UserDAO.addUser ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
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
            System.out.println("UserDAO.getUserById: " + e.getMessage());
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql;
        boolean hasPass = user.getPassword() != null && !user.getPassword().trim().isEmpty();
        if (hasPass) {
            sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Role = ?, Status = ?, Password = ? WHERE UserID = ?";
        } else {
            sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Role = ?, Status = ? WHERE UserID = ?";
        }
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getEmail());
            stm.setString(3, user.getPhone());
            stm.setString(4, user.getRole());
            stm.setBoolean(5, user.isStatus());
            if (hasPass) {
                stm.setString(6, user.getPassword());
                stm.setInt(7, user.getUserID());
            } else {
                stm.setInt(6, user.getUserID());
            }
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("UserDAO.updateUser: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("UserDAO.deleteUser: " + e.getMessage());
        }
        return false;
    }

    public List<User> searchAndSortUsers(String search, String sort) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (Username LIKE ? OR FullName LIKE ? OR Email LIKE ?) ");
        }
        if ("1".equals(sort)) {
            sql.append(" ORDER BY UserID ASC ");
        } else if ("0".equals(sort)) {
            sql.append(" ORDER BY UserID DESC ");
        } else {
            sql.append(" ORDER BY CreatedAt DESC ");
        }
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                stm.setString(1, pattern);
                stm.setString(2, pattern);
                stm.setString(3, pattern);
            }
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    list.add(new User(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("Phone"),
                            rs.getString("Role"),
                            rs.getBoolean("Status"),
                            rs.getTimestamp("CreatedAt")
                    ));
                }
            }
        } catch (Exception e) {
            System.out.println("UserDAO.searchAndSortUsers: " + e.getMessage());
        }
        return list;
    }
}
