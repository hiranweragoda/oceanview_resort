package com.oceanview.model;

public class StaffAuthDTO {
    private int id;
    private String username;
    private String hashedPassword;  // only this class holds the hash

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getHashedPassword() { return hashedPassword; }
    public void setHashedPassword(String hashedPassword) { this.hashedPassword = hashedPassword; }
}