package com.oceanview.dao;

import com.oceanview.model.Guest;
import java.util.List;

public interface GuestDAO {
    boolean addGuest(Guest guest);
    Guest getGuestById(int id);
    Guest getGuestByNic(String nic);
    List<Guest> getAllGuests();
    boolean updateGuest(Guest guest);
    boolean deleteGuest(int id);
    boolean nicExists(String nic);
}