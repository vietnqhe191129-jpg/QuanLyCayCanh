package Models;

public class PlantCategory {
    private int categoryID;
    private String categoryName;
    private String scientificName;
    private String description;
    private int defaultWaterDays;
    private String lightRequirement;
    private String imageUrl;

    public PlantCategory() {
    }

    public PlantCategory(int categoryID, String categoryName, String scientificName, String description, int defaultWaterDays, String lightRequirement, String imageUrl) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.scientificName = scientificName;
        this.description = description;
        this.defaultWaterDays = defaultWaterDays;
        this.lightRequirement = lightRequirement;
        this.imageUrl = imageUrl;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getScientificName() {
        return scientificName;
    }

    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDefaultWaterDays() {
        return defaultWaterDays;
    }

    public void setDefaultWaterDays(int defaultWaterDays) {
        this.defaultWaterDays = defaultWaterDays;
    }

    public String getLightRequirement() {
        return lightRequirement;
    }

    public void setLightRequirement(String lightRequirement) {
        this.lightRequirement = lightRequirement;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
