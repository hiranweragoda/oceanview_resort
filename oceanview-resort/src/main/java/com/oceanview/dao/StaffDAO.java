package com.oceanview.dao;

import com.oceanview.model.Staff;
import com.oceanview.model.StaffAuthDTO;
import java.util.List;

public interface StaffDAO {
    boolean addStaff(Staff staff, String plainPassword);
    Staff getStaffById(int id);
    StaffAuthDTO getStaffByUsername(String username);   // changed to return DTO
    List<Staff> getAllStaff();
    boolean updateStaff(Staff staff, String newPlainPassword);
    boolean deleteStaff(int id);
    boolean usernameExists(String username);
}