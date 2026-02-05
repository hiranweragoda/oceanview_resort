package com.oceanview.dao.impl;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAOImpl implements RoomTypeDAO {

    @Override
    public void addRoomType(RoomType roomType) {
        String sql = "INSERT INTO room_types (type_name, rate_per_night) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomType.getTypeName().trim());
            ps.setBigDecimal(2, roomType.getRatePerNight());
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error adding room type: " + e.getMessage(), e);
        }
    }

    @Override
    public RoomType getRoomTypeById(int id) {
        String sql = "SELECT * FROM room_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getBigDecimal("rate_per_night"));
                return rt;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching room type by ID", e);
        }
        return null;
    }

    @Override
    public RoomType getRoomTypeByName(String typeName) {
        String sql = "SELECT * FROM room_types WHERE type_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, typeName.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getBigDecimal("rate_per_night"));
                return rt;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching room type by name", e);
        }
        return null;
    }

    @Override
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY type_name ASC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getBigDecimal("rate_per_night"));
                list.add(rt);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all room types", e);
        }
        return list;
    }

    @Override
    public boolean updateRoomType(RoomType roomType) {
        String sql = "UPDATE room_types SET type_name = ?, rate_per_night = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomType.getTypeName().trim());
            ps.setBigDecimal(2, roomType.getRatePerNight());
            ps.setInt(3, roomType.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error updating room type", e);
        }
    }

    @Override
    public boolean deleteRoomType(int id) {
        String sql = "DELETE FROM room_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // You may want to handle foreign key constraint exception here
            throw new RuntimeException("Error deleting room type: " + e.getMessage(), e);
        }
    }
}