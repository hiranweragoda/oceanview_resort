package com.oceanview.dao.impl;

import com.oceanview.model.Admin;
import com.oceanview.util.DBConnection;
import com.oceanview.util.PasswordUtil; // Use your existing project utility
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAOImpl {

    public Admin validateLogin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    
                    // Verify password using your project's PasswordUtil
                    if (PasswordUtil.checkPassword(password, storedHash)) {
                        Admin a = new Admin();
                        a.setId(rs.getInt("id"));
                        a.setUsername(rs.getString("username"));
                        a.setFullname(rs.getString("fullname"));
                        a.setContactNumber(rs.getString("contact_number"));
                        return a;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addAdmin(Admin a) {
        // Hash password before inserting
        String hashedPassword = PasswordUtil.hashPassword(a.getPassword());
        String sql = "INSERT INTO admins (username, password, fullname, contact_number) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getUsername());
            ps.setString(2, hashedPassword);
            ps.setString(3, a.getFullname());
            ps.setString(4, a.getContactNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Admin> getAllAdmins() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT * FROM admins";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("id"));
                a.setUsername(rs.getString("username"));
                a.setFullname(rs.getString("fullname"));
                a.setContactNumber(rs.getString("contact_number"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Admin getAdminById(int id) {
        String sql = "SELECT * FROM admins WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setId(rs.getInt("id"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                    a.setFullname(rs.getString("fullname"));
                    a.setContactNumber(rs.getString("contact_number"));
                    return a;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateAdmin(Admin a) {
        String sql = "UPDATE admins SET fullname=?, contact_number=?, password=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullname());
            ps.setString(2, a.getContactNumber());
            ps.setString(3, a.getPassword());
            ps.setInt(4, a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteAdmin(int id) {
        String sql = "DELETE FROM admins WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}