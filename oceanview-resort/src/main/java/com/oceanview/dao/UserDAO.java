package com.oceanview.dao;

import com.oceanview.model.User;

public interface UserDAO {

    User authenticate(String username, String password);

    // add more methods if needed: register, update, etc.
}