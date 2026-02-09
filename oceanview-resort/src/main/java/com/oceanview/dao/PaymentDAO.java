package com.oceanview.dao;

import com.oceanview.model.Payment;
import java.util.List;

public interface PaymentDAO {
    boolean addPayment(Payment payment);
    List<Payment> getAllPayments();
    boolean deletePayment(int id);
}