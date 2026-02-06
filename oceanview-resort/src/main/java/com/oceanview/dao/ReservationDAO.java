package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.List;

public interface ReservationDAO {
    List<Reservation> getAllReservations();
    Reservation getReservationByNumber(String resNumber);
    boolean addReservation(Reservation reservation);
    boolean updateReservation(Reservation reservation);
    boolean deleteReservation(String resNumber); 
    List<Reservation> searchByNumber(String resNumber);
    List<Reservation> searchByPhone(String phone);
    String generateReservationNumber(); // Required for AddReservationServlet
}