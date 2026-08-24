/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Models.UserPlant;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 *
 * @author vktuy
 */
public class UserPlantDAO extends DBContext{
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
}
