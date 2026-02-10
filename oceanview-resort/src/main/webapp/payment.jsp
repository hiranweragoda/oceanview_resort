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
<input type="text" class="form-control" name="cardNumber" id="cardNumber" placeholder="Card Number (12 digits)" pattern="\d{12}" maxlength="12" minlength="12">
<div class="row g-2">
<div class="col-6"><input type="text" class="form-control" name="expiry" placeholder="MM/YY"></div>
<div class="col-6"><input type="text" class="form-control" name="cvv" id="cvv" placeholder="CVV (3 digits)" pattern="\d{3}" maxlength="3" minlength="3"></div>
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
// UI Toggles
document.getElementById('cardBtn').classList.toggle('active', m === 'CARD');
document.getElementById('cashBtn').classList.toggle('active', m === 'CASH');
// Section Toggles
document.getElementById('cardSection').classList.toggle('d-none', m === 'CASH');
document.getElementById('cashSection').classList.toggle('d-none', m === 'CARD');

// Toggle 'required' attribute based on method
const isCard = m === 'CARD';
document.getElementsByName('cardNumber')[0].required = isCard;
document.getElementsByName('expiry')[0].required = isCard;
document.getElementsByName('cvv')[0].required = isCard;
document.getElementById('cashReceived').required = !isCard;
}

// Initial state for required fields
setMethod('CARD');

function calculateBalance() {
const totalDue = parseFloat('${totalAmount}');
const received = parseFloat(document.getElementById('cashReceived').value) || 0;
const balance = received - totalDue;
const display = document.getElementById('balanceDisplay');
if (balance >= 0) {
display.innerText = "$" + balance.toFixed(2);
display.style.color = "#157347"; // Green for valid balance
} else {
display.innerText = "$0.00";
display.style.color = "#842029"; // Red if insufficient
}
}

// Validation logic for card digits
document.getElementById('paymentForm').onsubmit = function(e) {
    const method = document.getElementById('selectedMethod').value;
    if (method === 'CARD') {
        const cardNumber = document.getElementById('cardNumber').value;
        const cvv = document.getElementById('cvv').value;
        
        if (cardNumber.length !== 12) {
            alert("Card Number must be exactly 12 digits.");
            e.preventDefault();
            return false;
        }
        if (cvv.length !== 3) {
            alert("CVV must be exactly 3 digits.");
            e.preventDefault();
            return false;
        }
    }
};
</script>
</body>
</html>