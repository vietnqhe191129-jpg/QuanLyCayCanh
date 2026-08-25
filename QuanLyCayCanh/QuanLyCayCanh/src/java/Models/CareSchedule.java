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
public class CareSchedule {
    private int scheduleId;
    private int plantId;
    private String actionType;
    private int frequencyDays;
    private java.sql.Timestamp lastPerformed;
    private java.sql.Timestamp nextDueDate;

    public CareSchedule() {
    }

    public CareSchedule(int scheduleId, int plantId, String actionType, int frequencyDays, Timestamp lastPerformed, Timestamp nextDueDate) {
        this.scheduleId = scheduleId;
        this.plantId = plantId;
        this.actionType = actionType;
        this.frequencyDays = frequencyDays;
        this.lastPerformed = lastPerformed;
        this.nextDueDate = nextDueDate;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
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

    public int getFrequencyDays() {
        return frequencyDays;
    }

    public void setFrequencyDays(int frequencyDays) {
        this.frequencyDays = frequencyDays;
    }

    public Timestamp getLastPerformed() {
        return lastPerformed;
    }

    public void setLastPerformed(Timestamp lastPerformed) {
        this.lastPerformed = lastPerformed;
    }

    public Timestamp getNextDueDate() {
        return nextDueDate;
    }

    public void setNextDueDate(Timestamp nextDueDate) {
        this.nextDueDate = nextDueDate;
    }
    
    
}
