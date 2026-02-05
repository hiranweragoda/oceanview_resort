package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.List;

public interface ReservationDAO {
    String generateReservationNumber();
    boolean addReservation(Reservation reservation);
    List<Reservation> getAllReservations();
    Reservation getReservationByNumber(String reservationNumber);
    boolean updateReservation(Reservation reservation);
    boolean cancelReservation(String reservationNumber);
    List<Reservation> searchByPhone(String phoneNumber);
}