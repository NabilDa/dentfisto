package com.dentfisto.model;

import java.time.LocalDateTime;

/**
 * Represents a dental appointment.
 */
public class Appointment {

    private int id;
    private String patientName;
    private int dentistId;
    private LocalDateTime dateTime;
    private String status;
    private String notes;

    public Appointment() {}

    public Appointment(int id, String patientName, int dentistId,
                       LocalDateTime dateTime, String status, String notes) {
        this.id = id;
        this.patientName = patientName;
        this.dentistId = dentistId;
        this.dateTime = dateTime;
        this.status = status;
        this.notes = notes;
    }

    // --- Getters & Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public int getDentistId() { return dentistId; }
    public void setDentistId(int dentistId) { this.dentistId = dentistId; }

    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
