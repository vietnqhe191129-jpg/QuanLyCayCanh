package Models;

import java.sql.Date;

public class UserPlant {
    private int plantId;
    private int userId;
    private Integer categoryId; // can be null
    private String customName;
    private String locationInHome;
    private Date plantedDate;
    private String healthStatus;
    private String imageUrl;
    private String note;

    public UserPlant() {
    }

    public UserPlant(int plantID, int userID, Integer categoryID, String customName, String locationInHome, Date plantedDate, String healthStatus, String imageUrl, String note) {
        this.plantId = plantID;
        this.userId = userID;
        this.categoryId = categoryID;
        this.customName = customName;
        this.locationInHome = locationInHome;
        this.plantedDate = plantedDate;
        this.healthStatus = healthStatus;
        this.imageUrl = imageUrl;
        this.note = note;
    }

    public int getPlantId() {
        return plantId;
    }

    public void setPlantId(int plantId) {
        this.plantId = plantId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCustomName() {
        return customName;
    }

    public void setCustomName(String customName) {
        this.customName = customName;
    }

    public String getLocationInHome() {
        return locationInHome;
    }

    public void setLocationInHome(String locationInHome) {
        this.locationInHome = locationInHome;
    }

    public Date getPlantedDate() {
        return plantedDate;
    }

    public void setPlantedDate(Date plantedDate) {
        this.plantedDate = plantedDate;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
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
