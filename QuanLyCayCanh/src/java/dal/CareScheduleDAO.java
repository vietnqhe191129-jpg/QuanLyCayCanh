/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Models.CareSchedule;
import java.sql.*;
import java.util.*;

/**
 *
 * @author vktuy
 */
public class CareScheduleDAO extends DBContext {
    // 1. Lấy tất cả schedule của 1 plant

    public List<CareSchedule> getByPlantId(int plantId) {
        List<CareSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM CareSchedules WHERE PlantID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CareSchedule cs = new CareSchedule();
                cs.setScheduleId(rs.getInt("ScheduleID"));
                cs.setPlantId(rs.getInt("PlantID"));
                cs.setActionType(rs.getString("ActionType"));
                cs.setFrequencyDays(rs.getInt("FrequencyDays"));
                cs.setLastPerformed(rs.getTimestamp("LastPerformed"));
                cs.setNextDueDate(rs.getTimestamp("NextDueDate"));

                list.add(cs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CareSchedule> getTodayTasks(int userId) {
        List<CareSchedule> list = new ArrayList<>();

        String sql = """
        SELECT cs.*
        FROM CareSchedules cs
        JOIN UserPlants up ON cs.PlantID = up.PlantID
        WHERE up.UserID = ?
          AND CAST(cs.NextDueDate AS DATE) <= CAST(GETDATE() AS DATE)
        ORDER BY cs.NextDueDate ASC
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CareSchedule cs = new CareSchedule();

                cs.setScheduleId(rs.getInt("ScheduleID"));
                cs.setPlantId(rs.getInt("PlantID"));
                cs.setActionType(rs.getString("ActionType"));
                cs.setFrequencyDays(rs.getInt("FrequencyDays"));
                cs.setLastPerformed(rs.getTimestamp("LastPerformed"));
                cs.setNextDueDate(rs.getTimestamp("NextDueDate"));

                list.add(cs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insert(CareSchedule cs) {
        String sql = """
            INSERT INTO CareSchedules
            (PlantID, ActionType, FrequencyDays, LastPerformed, NextDueDate)
            VALUES (?, ?, ?, GETDATE(), DATEADD(day, ?, GETDATE()))
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cs.getPlantId());
            ps.setString(2, cs.getActionType());
            ps.setInt(3, cs.getFrequencyDays());
            ps.setInt(4, cs.getFrequencyDays());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(CareSchedule cs) {
        String sql = """
            UPDATE CareSchedules
            SET ActionType = ?, FrequencyDays = ?
            WHERE ScheduleID = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, cs.getActionType());
            ps.setInt(2, cs.getFrequencyDays());
            ps.setInt(3, cs.getScheduleId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int scheduleId) {
        String sql = "DELETE FROM CareSchedules WHERE ScheduleID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void markAsDone(int scheduleId) {
        String sql = """
            UPDATE CareSchedules
            SET LastPerformed = GETDATE(),
                NextDueDate = DATEADD(day, FrequencyDays, GETDATE())
            WHERE ScheduleID = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public CareSchedule getWaterScheduleByPlantId(int plantId) {
        String sql = """
        SELECT TOP 1 *
        FROM CareSchedules
        WHERE PlantID = ? AND ActionType = 'WATER'
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                CareSchedule cs = new CareSchedule();
                cs.setScheduleId(rs.getInt("ScheduleID"));
                cs.setPlantId(rs.getInt("PlantID"));
                cs.setActionType(rs.getString("ActionType"));
                cs.setFrequencyDays(rs.getInt("FrequencyDays"));
                cs.setLastPerformed(rs.getTimestamp("LastPerformed"));
                cs.setNextDueDate(rs.getTimestamp("NextDueDate"));
                return cs;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertWaterSchedule(
            int plantId,
            int frequencyDays,
            Timestamp lastPerformed,
            Timestamp nextDueDate) {

        String sql = """
        INSERT INTO CareSchedules
        (
            PlantID,
            ActionType,
            FrequencyDays,
            LastPerformed,
            NextDueDate
        )
        VALUES (?, 'WATER', ?, ?, ?)
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, plantId);
            ps.setInt(2, frequencyDays);
            ps.setTimestamp(3, lastPerformed);
            ps.setTimestamp(4, nextDueDate);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean updateWaterSchedule(
        int scheduleId,
        int frequencyDays,
        Timestamp lastPerformed,
        Timestamp nextDueDate) {

    String sql = """
        UPDATE CareSchedules

        SET FrequencyDays = ?,
            LastPerformed = ?,
            NextDueDate = ?

        WHERE ScheduleID = ?
          AND ActionType = 'WATER'
        """;

    try {
        

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setInt(1, frequencyDays);
        ps.setTimestamp(2, lastPerformed);
        ps.setTimestamp(3, nextDueDate);
        ps.setInt(4, scheduleId);

        return ps.executeUpdate() > 0;

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return false;
}
}
