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

    private Reservation mapResultSet(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setPhoneNumber(rs.getString("phone_number"));
        r.setStatus(rs.getString("status"));
        return r;
    }

    @Override
    public String generateReservationNumber() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String prefix = "RES-" + datePart + "-";

        String sql = "SELECT COUNT(*) FROM reservations WHERE reservation_number LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            rs.next();
            int nextSequence = rs.getInt(1) + 1;
            return String.format("%s%04d", prefix, nextSequence);
        } catch (SQLException e) {
            e.printStackTrace();
            return prefix + "0001";
        }
    }

    @Override
    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO reservations " +
                     "(reservation_number, guest_id, room_type_id, check_in_date, check_out_date, phone_number, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getReservationNumber());
            ps.setInt(2, r.getGuestId());
            ps.setInt(3, r.getRoomTypeId());
            ps.setDate(4, Date.valueOf(r.getCheckInDate()));
            ps.setDate(5, Date.valueOf(r.getCheckOutDate()));
            ps.setString(6, r.getPhoneNumber());
            ps.setString(7, r.getStatus() != null ? r.getStatus() : "CONFIRMED");

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateReservation(Reservation r) {
        String sql = "UPDATE reservations SET guest_id=?, room_type_id=?, check_in_date=?, check_out_date=?, phone_number=?, status=? " +
                     "WHERE reservation_number=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, r.getGuestId());
            ps.setInt(2, r.getRoomTypeId());
            ps.setDate(3, Date.valueOf(r.getCheckInDate()));
            ps.setDate(4, Date.valueOf(r.getCheckOutDate()));
            ps.setString(5, r.getPhoneNumber());
            ps.setString(6, r.getStatus());
            ps.setString(7, r.getReservationNumber());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelReservation(String reservationNumber) {
        String sql = "UPDATE reservations SET status = 'CANCELLED' WHERE reservation_number = ?";

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
    public boolean deleteReservation(String reservationNumber) {
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
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Reservation getReservationByNumber(String reservationNumber) {
        String sql = "SELECT * FROM reservations WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reservationNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Reservation> searchByNumber(String reservationNumber) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE reservation_number LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + reservationNumber + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Reservation> searchByPhone(String phoneNumber) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE phone_number LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + phoneNumber + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Reservation> getReservationsByStatus(String status) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean hasActiveReservationsForRoomType(int roomTypeId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE room_type_id = ? AND status = 'CHECKED_IN'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }
}