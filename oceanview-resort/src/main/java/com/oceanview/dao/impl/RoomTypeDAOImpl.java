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
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY id";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getBigDecimal("rate_per_night"));
                roomTypes.add(rt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypes;
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
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addRoomType(RoomType roomType) {
        String sql = "INSERT INTO room_types (type_name, rate_per_night) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, roomType.getTypeName());
            ps.setBigDecimal(2, roomType.getRatePerNight());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    roomType.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateRoomType(RoomType roomType) {
        String sql = "UPDATE room_types SET type_name = ?, rate_per_night = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomType.getTypeName());
            ps.setBigDecimal(2, roomType.getRatePerNight());
            ps.setInt(3, roomType.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
            e.printStackTrace();
            return false;
        }
    }
}