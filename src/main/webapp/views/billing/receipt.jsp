<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <title>Receipt</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;margin:20px;color:#0f172a}
    h1{margin:0 0 6px 0}
    .muted{color:#6b7280;font-size:12px}
    table{border-collapse:collapse;width:100%;margin-top:12px}
    th,td{border:1px solid #e5e7eb;padding:8px}
    th{background:#f8fafc;text-align:left}
    td.right,th.right{text-align:right}
    .totals{margin-top:10px;width:280px;margin-left:auto}
    .actions{position:sticky;top:0;background:#fff;padding-bottom:10px;margin-bottom:10px}
    .btn{padding:8px 12px;border:1px solid #d1d5db;border-radius:8px;background:#f3f4f6;cursor:pointer}
    .btn.primary{background:#0ea5e9;border-color:#0284c7;color:#fff}
    .btn.danger{background:#fee2e2;border-color:#fecaca;color:#991b1b}
    @media print{
      .actions{display:none}
      body{margin:0}
    }
  </style>
</head>
<body>

<div class="actions" style="display:flex;gap:8px;justify-content:flex-end">
  <button class="btn primary" onclick="window.print()">Print Bill</button>
  <button class="btn danger" onclick="window.close()">Clear</button>
</div>

<%
  // defensive defaults
  com.pahanaedu.model.Bill bill = (com.pahanaedu.model.Bill) request.getAttribute("savedBill");
  java.util.List<com.pahanaedu.model.BillItem> items =
      (java.util.List<com.pahanaedu.model.BillItem>) request.getAttribute("savedItems");
  Long billId = (Long) request.getAttribute("billId");
  com.pahanaedu.model.Customer savedCustomer =
      (com.pahanaedu.model.Customer) request.getAttribute("savedCustomer");
  if (items == null) items = java.util.Collections.emptyList();
%>

<h1>Pahana Edu — Receipt</h1>
<div class="muted">
  Bill ID: <b><%= billId != null ? billId : 0 %></b> |
  Date: <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %> |
  Staff: <%= bill != null ? bill.getStaffUser() : "" %>
</div>

<c:if test="${not empty savedCustomer}">
  <div style="margin-top:6px">
    <b>Customer:</b> ${savedCustomer.name}
    <span class="muted">
      &nbsp;| Acc: ${savedCustomer.accountNumber}
      &nbsp;| Phone: ${savedCustomer.phone}
    </span>
  </div>
</c:if>

<table>
  <tr>
    <th>#</th>
    <th>Item</th>
    <th class="right">Unit</th>
    <th class="right">Qty</th>
    <th class="right">Subtotal</th>
  </tr>

  <c:forEach var="bi" items="${savedItems}" varStatus="s">
    <tr>
      <td>${s.count}</td>
      <td>${bi.itemName}</td>
      <td class="right">${bi.unitPrice}</td>
      <td class="right">${bi.quantity}</td>
      <td class="right">${bi.subtotal}</td>
    </tr>
  </c:forEach>
</table>

<table class="totals">
  <tr>
    <th>Sub Total</th>
    <td class="right">${savedBill.subtotal}</td>
  </tr>
  <tr>
    <th>Discount %</th>
    <td class="right">${savedBill.discountPercent}</td>
  </tr>
  <tr>
    <th>Final Total</th>
    <td class="right"><b>${savedBill.total}</b></td>
  </tr>
</table>

<p class="muted" style="margin-top:12px">Thank you for shopping with Pahana Edu!</p>

</body>
</html>
