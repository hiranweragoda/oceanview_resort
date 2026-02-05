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
        String datePart = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE); // e.g. 20250204
        String prefix = "RES-" + datePart + "-";

        String countSql = "SELECT COUNT(*) FROM reservations WHERE reservation_number LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            rs.next();
            int count = rs.getInt(1) + 1;
            return prefix + String.format("%04d", count);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to generate reservation number", e);
        }
    }

    @Override
    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO reservations " +
                     "(reservation_number, guest_id, room_type_id, check_in_date, check_out_date, phone_number) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getReservationNumber());
            ps.setInt(2, r.getGuestId());
            ps.setInt(3, r.getRoomTypeId());
            ps.setDate(4, Date.valueOf(r.getCheckInDate()));
            ps.setDate(5, Date.valueOf(r.getCheckOutDate()));
            ps.setString(6, r.getPhoneNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Reservation getReservationByNumber(String reservationNumber) {
        String sql = "SELECT * FROM reservations WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reservationNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNumber(rs.getString("reservation_number"));
                r.setGuestId(rs.getInt("guest_id"));
                r.setRoomTypeId(rs.getInt("room_type_id"));
                r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
                r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
                r.setPhoneNumber(rs.getString("phone_number"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateReservation(Reservation r) {
        String sql = "UPDATE reservations SET check_in_date = ?, check_out_date = ?, phone_number = ? " +
                     "WHERE reservation_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(r.getCheckInDate()));
            ps.setDate(2, Date.valueOf(r.getCheckOutDate()));
            ps.setString(3, r.getPhoneNumber());
            ps.setString(4, r.getReservationNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelReservation(String reservationNumber) {
        String sql = "DELETE FROM reservations WHERE reservation_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reservationNumber);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Reservation> searchByPhone(String phoneNumber) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE phone_number = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phoneNumber);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNumber(rs.getString("reservation_number"));
                r.setGuestId(rs.getInt("guest_id"));
                r.setRoomTypeId(rs.getInt("room_type_id"));
                r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
                r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
                r.setPhoneNumber(rs.getString("phone_number"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}