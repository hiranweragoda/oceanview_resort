package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.dao.impl.UserDAOImpl;
import com.oceanview.dao.StaffDAO;
import com.oceanview.dao.impl.StaffDAOImpl;
import com.oceanview.model.User;
import com.oceanview.model.StaffAuthDTO;
import com.oceanview.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();

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

        // 1. Check admin / users table
        User adminUser = userDAO.authenticate(username, password);
        if (adminUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", adminUser);
            session.setAttribute("role", "ADMIN");
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect("admin-dashboard.jsp");
            return;
        }

        // 2. Check staff table using DTO
        StaffAuthDTO staff = staffDAO.getStaffByUsername(username);
        if (staff != null && PasswordUtil.checkPassword(password, staff.getHashedPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("staffId", staff.getId());
            session.setAttribute("username", staff.getUsername());
            session.setAttribute("role", "STAFF");
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect("staff-dashboard.jsp");
            return;
        }

        // Both failed
        request.setAttribute("error", "Invalid username or password");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}