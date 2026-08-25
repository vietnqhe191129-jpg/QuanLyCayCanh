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
public class CareLog {
    private int logId;
    private int plantId;
    private String actionType;
    private java.sql.Timestamp performedAt;

    public CareLog() {
    }

    public CareLog(int logId, int plantId, String actionType, Timestamp performedAt) {
        this.logId = logId;
        this.plantId = plantId;
        this.actionType = actionType;
        this.performedAt = performedAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getPlantId() {
        return plantId;
    }

    public void setPlantId(int plantId) {
        this.plantId = plantId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public Timestamp getPerformedAt() {
        return performedAt;
    }

    public void setPerformedAt(Timestamp performedAt) {
        this.performedAt = performedAt;
    }
    
    
}
