<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Processing - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .payment-card { max-width: 550px; margin: 40px auto; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .header-green { background-color: #157347; color: white; padding: 25px; text-align: center; }
        .header-green h3 { font-weight: 700; letter-spacing: 1px; margin-bottom: 5px; }

        .method-btn {
            border: 2px solid #dee2e6;
            background: white;
            padding: 12px;
            border-radius: 8px;
            width: 100%;
            font-weight: 500;
            transition: 0.2s;
        }
        .method-btn.active { border-color: #157347; color: #157347; background-color: #f1f8f5; }

        .form-control { padding: 12px; border-radius: 6px; border: 1px solid #ced4da; margin-bottom: 12px; }
        .btn-confirm { background-color: #157347; color: white; font-weight: 700; border: none; padding: 15px; border-radius: 8px; text-transform: uppercase; }
        .btn-confirm:hover { background-color: #115c39; color: white; }

        .balance-box { background-color: #fff3f3; border: 1px solid #f5c2c7; color: #842029; padding: 10px; border-radius: 6px; font-weight: bold; }
        .invalid-feedback { display: none; font-size: 0.875rem; }
        .is-invalid ~ .invalid-feedback { display: block; }
    </style>
</head>
<body>
<div class="container">
    <div class="card payment-card border-0">
        <div class="header-green">
            <h3 class="text-uppercase">Payment Processing</h3>
            <small>Reservation: <strong>${resNum}</strong></small>
        </div>

        <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
                <span class="text-muted text-uppercase small fw-bold">Amount Due</span>
                <h1 class="fw-bold text-dark" style="font-size: 3rem;">$${totalAmount}</h1>
            </div>

            <form action="generate-bill" method="POST" id="paymentForm">
                <input type="hidden" name="action" value="processPayment">
                <input type="hidden" name="resNum" value="${resNum}">
                <input type="hidden" name="total" value="${totalAmount}" id="totalDue">
                <input type="hidden" name="method" id="selectedMethod" value="CARD">

                <div class="row g-2 mb-4">
                    <div class="col-6">
                        <button type="button" class="method-btn active" id="cardBtn" onclick="setMethod('CARD')">Card Payment</button>
                    </div>
                    <div class="col-6">
                        <button type="button" class="method-btn" id="cashBtn" onclick="setMethod('CASH')">Cash Payment</button>
                    </div>
                </div>

                <div id="cardSection">
                    <div class="mb-3">
                        <label class="small fw-bold text-muted text-uppercase">Card Number (12 digits)</label>
                        <input type="text" class="form-control" name="cardNumber" id="cardNumber" 
                               placeholder="Enter 12-digit card number" maxlength="12" pattern="[0-9]{12}" required>
                        <div class="invalid-feedback">
                            Please enter exactly 12 digits.
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="small fw-bold text-muted text-uppercase">Expiry</label>
                            <input type="text" class="form-control" name="expiry" placeholder="MM/YY" required>
                        </div>
                        <div class="col-6">
                            <label class="small fw-bold text-muted text-uppercase">CVV</label>
                            <input type="text" class="form-control" name="cvv" placeholder="CVV" maxlength="4" pattern="[0-9]{3,4}" required>
                            <div class="invalid-feedback">
                                Please enter 3 or 4 digits.
                            </div>
                        </div>
                    </div>
                </div>

                <div id="cashSection" class="d-none">
                    <div class="mb-3">
                        <label class="small fw-bold text-muted text-uppercase">Cash Received from Guest</label>
                        <input type="number" step="0.01" class="form-control form-control-lg" id="cashReceived" placeholder="0.00" oninput="calculateBalance()">
                    </div>
                    <div class="balance-box d-flex justify-content-between align-items-center mb-3">
                        <span>Balance to Return:</span>
                        <span id="balanceDisplay">$0.00</span>
                    </div>
                    <div class="alert alert-light border text-center py-2 mb-0">
                        <small>Total to collect: <strong>$${totalAmount}</strong></small>
                    </div>
                </div>

                <button type="submit" class="btn btn-confirm w-100 mt-4">Confirm & Save</button>
            </form>
        </div>
    </div>
</div>

<script>
    function setMethod(m) {
        document.getElementById('selectedMethod').value = m;

        document.getElementById('cardBtn').classList.toggle('active', m === 'CARD');
        document.getElementById('cashBtn').classList.toggle('active', m === 'CASH');

        document.getElementById('cardSection').classList.toggle('d-none', m === 'CASH');
        document.getElementById('cashSection').classList.toggle('d-none', m === 'CARD');
    }

    function calculateBalance() {
        const totalDue = parseFloat('${totalAmount}');
        const received = parseFloat(document.getElementById('cashReceived').value) || 0;
        const balance = received - totalDue;

        const display = document.getElementById('balanceDisplay');
        if (balance >= 0) {
            display.innerText = "$" + balance.toFixed(2);
            display.style.color = "#157347";
        } else {
            display.innerText = "$0.00";
            display.style.color = "#842029";
        }
    }

    // Form validation before submit
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        const method = document.getElementById('selectedMethod').value;

        if (method === 'CARD') {
            const cardInput = document.getElementById('cardNumber');
            const cvvInput = document.getElementById('cvv');

            // Card number: exactly 12 digits
            if (!/^\d{12}$/.test(cardInput.value)) {
                cardInput.classList.add('is-invalid');
                e.preventDefault();
                return;
            } else {
                cardInput.classList.remove('is-invalid');
            }

            // CVV: 3 or 4 digits
            if (!/^\d{3,4}$/.test(cvvInput.value)) {
                cvvInput.classList.add('is-invalid');
                e.preventDefault();
                return;
            } else {
                cvvInput.classList.remove('is-invalid');
            }
        }
    });
</script>
</body>
</html>