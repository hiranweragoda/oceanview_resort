package com.oceanview.controller;

import com.oceanview.dao.impl.AdminDAOImpl;
import com.oceanview.model.Admin;
import com.oceanview.util.PasswordUtil; // Corrected import
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin-manage")
public class AdminServlet extends HttpServlet {
    private final AdminDAOImpl adminDAO = new AdminDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Admin admin = adminDAO.getAdminById(id);
            request.setAttribute("admin", admin);
            request.getRequestDispatcher("/admin-update.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            adminDAO.deleteAdmin(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect("admin-manage?action=list");
        } else {
            request.setAttribute("admins", adminDAO.getAllAdmins());
            request.getRequestDispatcher("/admin-list.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Admin a = new Admin();
            a.setUsername(request.getParameter("username"));
            a.setPassword(request.getParameter("password")); // DAO will hash it
            a.setFullname(request.getParameter("fullname"));
            a.setContactNumber(request.getParameter("contactNumber"));
            adminDAO.addAdmin(a);
        } else if ("saveUpdate".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Admin a = adminDAO.getAdminById(id); 
            a.setFullname(request.getParameter("fullname"));
            a.setContactNumber(request.getParameter("contactNumber"));
            
            String newPass = request.getParameter("password");
            if (newPass != null && !newPass.trim().isEmpty()) {
                // Use existing utility to hash the new password
                a.setPassword(PasswordUtil.hashPassword(newPass));
            }
            adminDAO.updateAdmin(a);
        }
        response.sendRedirect("admin-manage?action=list");
    }
}