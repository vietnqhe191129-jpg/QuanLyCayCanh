/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import Models.GrowthDiary;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author vktuy
 */
public class GrowthDiaryDAO extends DBContext {
    public List<GrowthDiary> getByPlantId(int plantId) {

        List<GrowthDiary> list = new ArrayList<>();

        String sql = """
                     SELECT *
                     FROM GrowthDiaries
                     WHERE PlantID = ?
                     ORDER BY LogDate DESC
                     """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, plantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                GrowthDiary diary = new GrowthDiary();

                diary.setDiaryId(rs.getInt("DiaryID"));
                diary.setPlantId(rs.getInt("PlantID"));
                diary.setLogDate(rs.getTimestamp("LogDate"));

                double height = rs.getDouble("HeightCm");

                if (rs.wasNull()) {
                    diary.setHeightCm(null);
                } else {
                    diary.setHeightCm(height);
                }

                diary.setImageUrl(rs.getString("ImageUrl"));
                diary.setNote(rs.getString("Note"));

                list.add(diary);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public boolean insert(GrowthDiary diary) {

    String sql = """
                 INSERT INTO GrowthDiaries
                 (PlantID, HeightCm, ImageUrl, Note)
                 VALUES (?, ?, ?, ?)
                 """;

    try {

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setInt(1, diary.getPlantId());

        if (diary.getHeightCm() != null) {
            ps.setDouble(2, diary.getHeightCm());
        } else {
            ps.setNull(2, java.sql.Types.FLOAT);
        }

        ps.setString(3, diary.getImageUrl());
        ps.setString(4, diary.getNote());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}
    
    public boolean update(GrowthDiary diary) {

    String sql = """
                 UPDATE GrowthDiaries
                 SET HeightCm = ?,
                     ImageUrl = ?,
                     Note = ?
                 WHERE DiaryID = ?
                 """;

    try {

        PreparedStatement ps = connection.prepareStatement(sql);

        if (diary.getHeightCm() != null) {
            ps.setDouble(1, diary.getHeightCm());
        } else {
            ps.setNull(1, java.sql.Types.FLOAT);
        }

        ps.setString(2, diary.getImageUrl());
        ps.setString(3, diary.getNote());
        ps.setInt(4, diary.getDiaryId());

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}
    
    public boolean delete(int diaryId) {

    String sql = """
                 DELETE FROM GrowthDiaries
                 WHERE DiaryID = ?
                 """;

    try {

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setInt(1, diaryId);

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}
    
    public GrowthDiary getById(int diaryId) {

    String sql = """
                 SELECT *
                 FROM GrowthDiaries
                 WHERE DiaryID = ?
                 """;

    try {

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setInt(1, diaryId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            GrowthDiary diary = new GrowthDiary();

            diary.setDiaryId(rs.getInt("DiaryID"));
            diary.setPlantId(rs.getInt("PlantID"));
            diary.setLogDate(rs.getTimestamp("LogDate"));

            double height = rs.getDouble("HeightCm");

            if (!rs.wasNull()) {
                diary.setHeightCm(height);
            }

            diary.setImageUrl(rs.getString("ImageUrl"));
            diary.setNote(rs.getString("Note"));

            return diary;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return null;
}
}
