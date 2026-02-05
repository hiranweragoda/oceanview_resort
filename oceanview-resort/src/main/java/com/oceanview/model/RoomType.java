package com.oceanview.model;

import java.math.BigDecimal;

public class RoomType {

    private int id;
    private String typeName;
    private BigDecimal ratePerNight;

    // Constructors
    public RoomType() {}

    public RoomType(String typeName, BigDecimal ratePerNight) {
        this.typeName = typeName;
        this.ratePerNight = ratePerNight;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public BigDecimal getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }

    @Override
    public String toString() {
        return "RoomType{" +
                "id=" + id +
                ", typeName='" + typeName + '\'' +
                ", ratePerNight=" + ratePerNight +
                '}';
    }
}