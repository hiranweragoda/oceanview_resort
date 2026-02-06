package com.oceanview.dao.impl;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    @Override
    public String generateReservationNumber() {
        // Formats the date as 20260205
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String sql = "SELECT COUNT(*) FROM reservations WHERE reservation_number LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "RES-" + datePart + "-%");
            ResultSet rs = ps.executeQuery();
            
            int nextSequence = 1;
            if (rs.next()) {
                nextSequence = rs.getInt(1) + 1;
            }
            // Pads with zeros to create RES-20260205-0001
            return String.format("RES-%s-%04d", datePart, nextSequence);
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "RES-" + datePart + "-0001";
        }
    }

    @Override
    public boolean deleteReservation(String resNumber) {
        String sql = "DELETE FROM reservations WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Reservation> searchByNumber(String resNumber) {
        return getFilteredReservations("SELECT * FROM reservations WHERE reservation_number LIKE ?", "%" + resNumber + "%");
    }

    @Override
    public List<Reservation> searchByPhone(String phone) {
        return getFilteredReservations("SELECT * FROM reservations WHERE phone_number LIKE ?", "%" + phone + "%");
    }

    // Helper to map DB results to Java Objects
    private Reservation mapResultSet(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setPhoneNumber(rs.getString("phone_number"));
        return r;
    }

    private List<Reservation> getFilteredReservations(String sql, String param) {
        List<Reservation> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (param != null) ps.setString(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override public List<Reservation> getAllReservations() { return getFilteredReservations("SELECT * FROM reservations", null); }

    @Override
    public Reservation getReservationByNumber(String resNumber) {
        String sql = "SELECT * FROM reservations WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSet(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO reservations (reservation_number, guest_id, room_type_id, check_in_date, check_out_date, phone_number) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getReservationNumber());
            ps.setInt(2, r.getGuestId());
            ps.setInt(3, r.getRoomTypeId());
            ps.setDate(4, Date.valueOf(r.getCheckInDate()));
            ps.setDate(5, Date.valueOf(r.getCheckOutDate()));
            ps.setString(6, r.getPhoneNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean updateReservation(Reservation r) {
        String sql = "UPDATE reservations SET room_type_id=?, check_in_date=?, check_out_date=?, phone_number=? WHERE reservation_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getRoomTypeId());
            ps.setDate(2, Date.valueOf(r.getCheckInDate()));
            ps.setDate(3, Date.valueOf(r.getCheckOutDate()));
            ps.setString(4, r.getPhoneNumber());
            ps.setString(5, r.getReservationNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}