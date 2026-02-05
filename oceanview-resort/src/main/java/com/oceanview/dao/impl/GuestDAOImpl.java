package com.oceanview.dao.impl;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAOImpl implements GuestDAO {

    @Override
    public boolean addGuest(Guest guest) {
        String sql = "INSERT INTO guests (guest_name, address, phone_number, nic) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, guest.getGuestName());
            ps.setString(2, guest.getAddress());
            ps.setString(3, guest.getPhoneNumber());
            ps.setString(4, guest.getNic());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Guest getGuestById(int id) {
        String sql = "SELECT * FROM guests WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("id"));
                g.setGuestName(rs.getString("guest_name"));
                g.setAddress(rs.getString("address"));
                g.setPhoneNumber(rs.getString("phone_number"));
                g.setNic(rs.getString("nic"));
                return g;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Guest getGuestByNic(String nic) {
        String sql = "SELECT * FROM guests WHERE nic = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nic);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("id"));
                g.setGuestName(rs.getString("guest_name"));
                g.setAddress(rs.getString("address"));
                g.setPhoneNumber(rs.getString("phone_number"));
                g.setNic(rs.getString("nic"));
                return g;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Guest> getAllGuests() {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("id"));
                g.setGuestName(rs.getString("guest_name"));
                g.setAddress(rs.getString("address"));
                g.setPhoneNumber(rs.getString("phone_number"));
                g.setNic(rs.getString("nic"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE guests SET guest_name = ?, address = ?, phone_number = ?, nic = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, guest.getGuestName());
            ps.setString(2, guest.getAddress());
            ps.setString(3, guest.getPhoneNumber());
            ps.setString(4, guest.getNic());
            ps.setInt(5, guest.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteGuest(int id) {
        String sql = "DELETE FROM guests WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean nicExists(String nic) {
        String sql = "SELECT 1 FROM guests WHERE nic = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nic);
            return ps.executeQuery().next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}