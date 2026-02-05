package com.oceanview.controller;

import com.oceanview.dao.StaffDAO;
import com.oceanview.dao.impl.StaffDAOImpl;
import com.oceanview.model.Staff;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff")
public class StaffServlet extends HttpServlet {

    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                listStaff(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStaff(request, response);
                break;
            default:
                listStaff(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addStaff(request, response);
        } else if ("update".equals(action)) {
            updateStaff(request, response);
        }
    }

    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Staff> staffList = staffDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/staff-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Staff ID is required.");
            listStaff(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid staff ID format.");
            listStaff(request, response);
            return;
        }

        Staff staff = staffDAO.getStaffById(id);
        if (staff == null) {
            request.setAttribute("error", "Staff member not found.");
            listStaff(request, response);
            return;
        }

        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/staff-form.jsp").forward(request, response);
    }

    private void addStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String contact = request.getParameter("contactNumber");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Username, password, and full name are required.");
            listStaff(request, response);
            return;
        }

        username = username.trim();
        password = password.trim();
        fullName = fullName.trim();
        contact = (contact != null) ? contact.trim() : null;

        if (staffDAO.usernameExists(username)) {
            request.setAttribute("error", "Username already exists.");
            listStaff(request, response);
            return;
        }

        Staff staff = new Staff();
        staff.setUsername(username);
        staff.setFullName(fullName);
        staff.setContactNumber(contact);

        boolean success = staffDAO.addStaff(staff, password);

        if (success) {
            request.setAttribute("success", "Staff member added successfully.");
        } else {
            request.setAttribute("error", "Failed to add staff member.");
        }

        listStaff(request, response);
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String fullName = request.getParameter("fullName");
        String contact = request.getParameter("contactNumber");
        String newPassword = request.getParameter("newPassword");

        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Staff ID is required.");
            listStaff(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid staff ID.");
            listStaff(request, response);
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required.");
            showEditForm(request, response);
            return;
        }

        fullName = fullName.trim();
        contact = (contact != null) ? contact.trim() : null;

        Staff staff = new Staff();
        staff.setId(id);
        staff.setFullName(fullName);
        staff.setContactNumber(contact);

        boolean success = staffDAO.updateStaff(staff, newPassword);

        if (success) {
            request.setAttribute("success", "Staff member updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update staff member.");
        }

        listStaff(request, response);
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Staff ID is required.");
            listStaff(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid staff ID.");
            listStaff(request, response);
            return;
        }

        boolean success = staffDAO.deleteStaff(id);

        if (success) {
            request.setAttribute("success", "Staff member deleted successfully.");
        } else {
            request.setAttribute("error", "Failed to delete staff member.");
        }

        listStaff(request, response);
    }
}