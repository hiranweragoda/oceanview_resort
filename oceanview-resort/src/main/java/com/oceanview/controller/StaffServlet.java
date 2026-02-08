package com.oceanview.controller;

import com.oceanview.dao.StaffDAO;
import com.oceanview.dao.impl.StaffDAOImpl;
import com.oceanview.model.Staff;
import com.oceanview.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff")
public class StaffServlet extends HttpServlet {
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // FIX: Verify login and role using session attributes rather than a specific Class cast 
        // to avoid the ClassCastException error
        if (session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteStaff(request, response);
                    break;
                default:
                    listStaff(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            listStaff(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                addStaff(request, response);
            } else if ("update".equals(action)) {
                updateStaff(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect("staff");
        }
    }

    private void listStaff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Staff> staffList = staffDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/staff-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Staff staff = staffDAO.getStaffById(id);
        
        if (staff != null) {
            request.setAttribute("staff", staff);
            // UPDATED: Points to staff-form.jsp instead of staff-update.jsp
            request.getRequestDispatcher("/staff-form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Staff member not found.");
            response.sendRedirect("staff");
        }
    }

    private void addStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Staff s = new Staff();
        s.setUsername(request.getParameter("username"));
        s.setPassword(PasswordUtil.hashPassword(request.getParameter("password")));
        s.setFullName(request.getParameter("fullName"));
        s.setContactNumber(request.getParameter("contactNumber"));

        if (staffDAO.addStaff(s)) {
            request.getSession().setAttribute("success", "Staff member added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add staff member.");
        }
        response.sendRedirect("staff");
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Staff s = staffDAO.getStaffById(id);
        
        if (s != null) {
            s.setFullName(request.getParameter("fullName"));
            s.setContactNumber(request.getParameter("contactNumber"));
            
            String newPass = request.getParameter("password");
            if (newPass != null && !newPass.trim().isEmpty()) {
                s.setPassword(PasswordUtil.hashPassword(newPass));
            }

            if (staffDAO.updateStaff(s)) {
                request.getSession().setAttribute("success", "Staff information updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update staff information.");
            }
        }
        response.sendRedirect("staff");
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (staffDAO.deleteStaff(id)) {
            request.getSession().setAttribute("success", "Staff member deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete staff member.");
        }
        response.sendRedirect("staff");
    }
}