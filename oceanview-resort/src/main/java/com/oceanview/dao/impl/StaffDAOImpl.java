package com.oceanview.dao.impl;

import com.oceanview.dao.StaffDAO;
import com.oceanview.model.Staff;
import com.oceanview.model.StaffAuthDTO;
import com.oceanview.util.DBConnection;
import com.oceanview.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public boolean addStaff(Staff staff, String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            return false;
        }

        String hashed = PasswordUtil.hashPassword(plainPassword);

        String sql = "INSERT INTO staff (username, password, full_name, contact_number) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, staff.getUsername());
            ps.setString(2, hashed);
            ps.setString(3, staff.getFullName());
            ps.setString(4, staff.getContactNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Staff getStaffById(int id) {
        String sql = "SELECT id, username, full_name, contact_number FROM staff WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Staff s = new Staff();
                s.setId(rs.getInt("id"));
                s.setUsername(rs.getString("username"));
                s.setFullName(rs.getString("full_name"));
                s.setContactNumber(rs.getString("contact_number"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public StaffAuthDTO getStaffByUsername(String username) {
        String sql = "SELECT id, username, password, full_name, contact_number FROM staff WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                StaffAuthDTO dto = new StaffAuthDTO();
                dto.setId(rs.getInt("id"));
                dto.setUsername(rs.getString("username"));
                dto.setHashedPassword(rs.getString("password"));
                return dto;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT id, username, full_name, contact_number FROM staff ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Staff s = new Staff();
                s.setId(rs.getInt("id"));
                s.setUsername(rs.getString("username"));
                s.setFullName(rs.getString("full_name"));
                s.setContactNumber(rs.getString("contact_number"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateStaff(Staff staff, String newPlainPassword) {
        String sql;
        boolean hasNewPassword = newPlainPassword != null && !newPlainPassword.trim().isEmpty();

        if (hasNewPassword) {
            sql = "UPDATE staff SET full_name = ?, contact_number = ?, password = ? WHERE id = ?";
        } else {
            sql = "UPDATE staff SET full_name = ?, contact_number = ? WHERE id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, staff.getFullName());
            ps.setString(2, staff.getContactNumber());

            if (hasNewPassword) {
                String hashed = PasswordUtil.hashPassword(newPlainPassword);
                ps.setString(3, hashed);
                ps.setInt(4, staff.getId());
            } else {
                ps.setInt(3, staff.getId());
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM staff WHERE id = ?";
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
    public boolean usernameExists(String username) {
        String sql = "SELECT 1 FROM staff WHERE username = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            return ps.executeQuery().next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}