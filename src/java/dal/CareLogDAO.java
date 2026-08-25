/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import Models.CareLog;
import java.sql.*;
import java.util.*;
/**
 *
 * @author vktuy
 */
public class CareLogDAO extends DBContext{
     // 1. Insert log (khi bấm Done)
    public void insert(int plantId, String actionType) {
        String sql = """
            INSERT INTO CareLogs (PlantID, ActionType)
            VALUES (?, ?)
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);
            ps.setString(2, actionType);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
        public List<CareLog> getByPlantId(int plantId) {
        List<CareLog> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM CareLogs
            WHERE PlantID = ?
            ORDER BY PerformedAt DESC
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CareLog log = new CareLog();
                log.setLogId(rs.getInt("LogID"));
                log.setPlantId(rs.getInt("PlantID"));
                log.setActionType(rs.getString("ActionType"));
                log.setPerformedAt(rs.getTimestamp("PerformedAt"));

                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
            public CareLog getLatestLog(int plantId, String actionType) {
        String sql = """
            SELECT TOP 1 *
            FROM CareLogs
            WHERE PlantID = ? AND ActionType = ?
            ORDER BY PerformedAt DESC
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);
            ps.setString(2, actionType);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                CareLog log = new CareLog();
                log.setLogId(rs.getInt("LogID"));
                log.setPlantId(rs.getInt("PlantID"));
                log.setActionType(rs.getString("ActionType"));
                log.setPerformedAt(rs.getTimestamp("PerformedAt"));
                return log;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
                public void delete(int logId) {
        String sql = "DELETE FROM CareLogs WHERE LogID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, logId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

