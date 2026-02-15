package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.dao.impl.UserDAOImpl;
import com.oceanview.dao.StaffDAO;
import com.oceanview.dao.impl.StaffDAOImpl;
import com.oceanview.dao.impl.AdminDAOImpl;
import com.oceanview.model.User;
import com.oceanview.model.Admin;
import com.oceanview.model.StaffAuthDTO;
import com.oceanview.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();
    private final AdminDAOImpl adminDAO = new AdminDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        password = password.trim();

        // 1. Check Primary System User
        User masterUser = userDAO.authenticate(username, password);
        if (masterUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", masterUser);
            session.setAttribute("username", masterUser.getUsername()); // Fixes "null" name problem
            session.setAttribute("role", "ADMIN");
            response.sendRedirect("admin-dashboard.jsp");
            return;
        }

        // 2. Check Managed Admins table (Uses BCrypt in validateLogin)
        Admin secondaryAdmin = adminDAO.validateLogin(username, password);
        if (secondaryAdmin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", secondaryAdmin);
            session.setAttribute("username", secondaryAdmin.getFullname()); // Fixes "null" name problem
            session.setAttribute("role", "ADMIN");
            response.sendRedirect("admin-dashboard.jsp");
            return;
        }

        // 3. Check Staff table
        StaffAuthDTO staff = staffDAO.getStaffByUsername(username);
        if (staff != null && PasswordUtil.checkPassword(password, staff.getHashedPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("staffId", staff.getId());
            session.setAttribute("username", staff.getUsername()); // Fixes "null" name problem
            session.setAttribute("role", "STAFF");
            response.sendRedirect("staff-dashboard.jsp");
            return;
        }

        request.setAttribute("error", "Invalid username or password");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}