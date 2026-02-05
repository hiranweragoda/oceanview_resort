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

@WebServlet("/guests-for-reservation")
public class GuestListForReservationServlet extends HttpServlet {

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

        List<Guest> guests = guestDAO.getAllGuests();
        request.setAttribute("guests", guests);

        request.getRequestDispatcher("/guest-list-for-reservation.jsp").forward(request, response);
    }
}