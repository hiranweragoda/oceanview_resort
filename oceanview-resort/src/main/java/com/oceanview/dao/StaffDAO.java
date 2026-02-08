package com.oceanview.dao;

import com.oceanview.model.Staff;
import com.oceanview.model.StaffAuthDTO;
import java.util.List;

public interface StaffDAO {
    
    // Core CRUD operations
    boolean addStaff(Staff staff); 
    boolean updateStaff(Staff staff);
    Staff getStaffById(int id);
    List<Staff> getAllStaff();
    boolean deleteStaff(int id);

    // FIX for LoginServlet error (Line 68)
    StaffAuthDTO getStaffByUsername(String username);

    // FIX for StaffDAOImpl override errors (Line 142)
    boolean usernameExists(String username);
}