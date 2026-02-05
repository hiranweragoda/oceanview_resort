package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.impl.GuestDAOImpl;
import com.oceanview.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/guest")
public class GuestServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"STAFF".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listGuests(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteGuest(request, response);
                break;
            default:
                listGuests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (session == null || !"STAFF".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addGuest(request, response);
        } else if ("update".equals(action)) {
            updateGuest(request, response);
        }
    }

    private void listGuests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Guest> guestList = guestDAO.getAllGuests();
        request.setAttribute("guestList", guestList);
        request.getRequestDispatcher("/guest-management.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Guest guest = guestDAO.getGuestById(id);
        request.setAttribute("guest", guest);
        request.getRequestDispatcher("/guest-form.jsp").forward(request, response);
    }

    private void addGuest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guestName = request.getParameter("guestName").trim();
        String address = request.getParameter("address");
        String phone = request.getParameter("phoneNumber");
        String nic = request.getParameter("nic").trim();

        if (guestName.isEmpty() || nic.isEmpty()) {
            request.setAttribute("error", "Guest name and NIC are required.");
            listGuests(request, response);
            return;
        }

        if (guestDAO.nicExists(nic)) {
            request.setAttribute("error", "A guest with this NIC already exists.");
            listGuests(request, response);
            return;
        }

        Guest guest = new Guest();
        guest.setGuestName(guestName);
        guest.setAddress(address);
        guest.setPhoneNumber(phone);
        guest.setNic(nic);

        boolean success = guestDAO.addGuest(guest);

        if (success) {
            request.setAttribute("success", "Guest added successfully.");
        } else {
            request.setAttribute("error", "Failed to add guest.");
        }
        listGuests(request, response);
    }

    private void updateGuest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String guestName = request.getParameter("guestName").trim();
        String address = request.getParameter("address");
        String phone = request.getParameter("phoneNumber");
        String nic = request.getParameter("nic").trim();

        if (guestName.isEmpty() || nic.isEmpty()) {
            request.setAttribute("error", "Guest name and NIC are required.");
            showEditForm(request, response);
            return;
        }

        // Check if NIC is changed and already used by another guest
        Guest existing = guestDAO.getGuestById(id);
        if (!existing.getNic().equals(nic) && guestDAO.nicExists(nic)) {
            request.setAttribute("error", "Another guest already has this NIC.");
            showEditForm(request, response);
            return;
        }

        Guest guest = new Guest();
        guest.setId(id);
        guest.setGuestName(guestName);
        guest.setAddress(address);
        guest.setPhoneNumber(phone);
        guest.setNic(nic);

        boolean success = guestDAO.updateGuest(guest);

        if (success) {
            request.setAttribute("success", "Guest updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update guest.");
        }
        listGuests(request, response);
    }

    private void deleteGuest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = guestDAO.deleteGuest(id);

        if (success) {
            request.setAttribute("success", "Guest deleted successfully.");
        } else {
            request.setAttribute("error", "Failed to delete guest (may be linked to reservations).");
        }
        listGuests(request, response);
    }
}