package Models;

import java.sql.Timestamp;

public class PlantReport {
    private int reportID;
    private int userID;
    private Integer plantID;
    private String title;
    private String description;
    private String imageUrl;
    private String status;
    private String adminResponse;
    private Timestamp createdAt;

    // Join fields for user-facing UI
    private String userFullName;
    private String plantCustomName;

    public PlantReport() {
    }

    public PlantReport(int reportID, int userID, Integer plantID, String title, String description, String imageUrl, String status, String adminResponse, Timestamp createdAt) {
        this.reportID = reportID;
        this.userID = userID;
        this.plantID = plantID;
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
        this.adminResponse = adminResponse;
        this.createdAt = createdAt;
    }

    public int getReportID() {
        return reportID;
    }

    public void setReportID(int reportID) {
        this.reportID = reportID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Integer getPlantID() {
        return plantID;
    }

    public void setPlantID(Integer plantID) {
        this.plantID = plantID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public String getPlantCustomName() {
        return plantCustomName;
    }

    public void setPlantCustomName(String plantCustomName) {
        this.plantCustomName = plantCustomName;
    }
}
