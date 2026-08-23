package Models;

import java.sql.Date;

public class UserPlant {
    private int plantID;
    private int userID;
    private Integer categoryID; // can be null
    private String customName;
    private String locationInHome;
    private Date plantedDate;
    private String healthStatus;
    private String imageUrl;
    private String note;

    public UserPlant() {
    }

    public UserPlant(int plantID, int userID, Integer categoryID, String customName, String locationInHome, Date plantedDate, String healthStatus, String imageUrl, String note) {
        this.plantID = plantID;
        this.userID = userID;
        this.categoryID = categoryID;
        this.customName = customName;
        this.locationInHome = locationInHome;
        this.plantedDate = plantedDate;
        this.healthStatus = healthStatus;
        this.imageUrl = imageUrl;
        this.note = note;
    }

    public int getPlantID() {
        return plantID;
    }

    public void setPlantID(int plantID) {
        this.plantID = plantID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
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
