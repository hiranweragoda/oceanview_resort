package com.oceanview.model;

public class Guest {
    private int id;
    private String guestName;
    private String address;
    private String phoneNumber;
    private String nic;

    // Constructors
    public Guest() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }
}