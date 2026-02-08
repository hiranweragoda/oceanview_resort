package com.oceanview.model;

public class Staff {
    private int id;
    private String username;
    private String password; // Add this field
    private String fullName;
    private String contactNumber;

    // ... existing getters/setters ...

    // FIX: Add this method to resolve "undefined for the type Staff" errors
    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }
    
    // Ensure these exist as well
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
}