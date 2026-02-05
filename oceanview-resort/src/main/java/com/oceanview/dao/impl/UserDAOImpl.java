package com.oceanview.dao.impl;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAOImpl implements UserDAO {

    @Override
    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);   // plain text – only for learning!

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                // password not stored in object for security
                return user;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Authentication failed", e);
        }
        return null;
    }
}