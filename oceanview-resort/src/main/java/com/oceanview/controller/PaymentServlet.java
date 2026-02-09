package com.oceanview.controller;

import com.oceanview.dao.PaymentDAO;
import com.oceanview.dao.impl.PaymentDAOImpl;
import com.oceanview.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Security: Ensure only Admin can manage payments
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (paymentDAO.deletePayment(id)) {
                    request.getSession().setAttribute("success", "Payment record deleted successfully.");
                } else {
                    request.getSession().setAttribute("error", "Failed to delete payment record.");
                }
                response.sendRedirect("payment?action=list");
            } else {
                // Default: List all payments
                List<Payment> payments = paymentDAO.getAllPayments();
                request.setAttribute("paymentList", payments);
                request.getRequestDispatcher("/payment_view.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment?action=list");
        }
    }
}