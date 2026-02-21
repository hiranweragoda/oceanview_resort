package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.List;

public interface ReservationDAO {

    String generateReservationNumber();
    boolean addReservation(Reservation reservation);
    Reservation getReservationByNumber(String reservationNumber);
    List<Reservation> getAllReservations();
    boolean updateReservation(Reservation reservation);
    boolean cancelReservation(String reservationNumber);
    boolean deleteReservation(String reservationNumber);
    List<Reservation> searchByNumber(String reservationNumber);
    List<Reservation> searchByPhone(String phoneNumber);
    List<Reservation> getReservationsByStatus(String status);
    boolean hasActiveReservationsForRoomType(int roomTypeId);
}