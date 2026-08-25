/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;
import java.sql.Timestamp;
/**
 *
 * @author vktuy
 */
public class GrowthDiary {
    private int diaryId;
    private int plantId;
    private Timestamp logDate;
    private Double heightCm;
    private String imageUrl;
    private String note;

    public GrowthDiary() {
    }

    public GrowthDiary(int diaryId, int plantId, Timestamp logDate, double heightCm, String imageUrl, String note) {
        this.diaryId = diaryId;
        this.plantId = plantId;
        this.logDate = logDate;
        this.heightCm = heightCm;
        this.imageUrl = imageUrl;
        this.note = note;
    }

    public int getDiaryId() {
        return diaryId;
    }

    public void setDiaryId(int diaryId) {
        this.diaryId = diaryId;
    }

    public int getPlantId() {
        return plantId;
    }

    public void setPlantId(int plantId) {
        this.plantId = plantId;
    }

    public Timestamp getLogDate() {
        return logDate;
    }

    public void setLogDate(Timestamp logDate) {
        this.logDate = logDate;
    }

    public Double getHeightCm() {
        return heightCm;
    }

    public void setHeightCm(Double heightCm) {
        this.heightCm = heightCm;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    
}
