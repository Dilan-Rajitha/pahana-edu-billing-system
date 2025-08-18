<%@ page contentType="text/html; charset=UTF-8" %>
<%
  com.pahanaedu.model.Customer c =
    (com.pahanaedu.model.Customer) request.getAttribute("customer");
  boolean editing = (c != null && c.getId() != null);

  String nextAcc = (String) request.getAttribute("nextAcc");
  String accVal  = editing ? c.getAccountNumber() : (nextAcc != null ? nextAcc : "");
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title><%= editing ? "Edit" : "Register" %> Customer</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap');
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f1f5f9; --panel:#fff; --panel-2:#f8fafc;
      --text:#0f172a; --muted:#64748b; --border:#e5eaf0; --border-2:#cbd5e1;
      --shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);
      --shadow-lg:0 16px 32px rgba(2,6,23,.10);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:'Inter',system-ui,-apple-system,Segoe UI,Roboto,Arial;background:var(--bg);color:var(--text)}

    /* TOP BAR */
    .topbar{
      background:var(--brand); color:#fff; display:flex; align-items:center; justify-content:space-between;
      padding:10px 18px; box-shadow:inset 0 -3px rgba(0,0,0,.06);
      position:sticky; top:0; z-index:50;
    }
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:40px}

    .top-right{display:flex; align-items:center; gap:10px}
    .welcome{background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28); padding:6px 10px; border-radius:999px; font-weight:600}
    .logout{background:#ff6b6b; border:1px solid #ff9a9a; color:#fff; padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800}

    /* SUB BAR */
    .subbar{background:#ffffffcc; backdrop-filter:saturate(1.2) blur(6px); border-bottom:1px solid var(--border);
      position:sticky; top:52px; z-index:40;}
    .subbar-inner{max-width:980px; margin:10px auto; padding:10px 18px; display:flex; gap:12px; align-items:center}
    .btn{
      padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:700; text-decoration:none; color:var(--text); display:inline-flex; align-items:center; gap:6px;
    }
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}
    .btn.muted{background:#fff}

    /* PAGE */
    .page{max-width:980px; margin:16px auto 28px; padding:0 18px}
    .card{background:var(--panel); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow)}
    .card-head{padding:16px 18px; border-bottom:1px solid var(--border); background:var(--panel-2)}
    .card-body{padding:18px}

    .title{margin:0; font-weight:800}
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:16px}
    @media (max-width:720px){ .grid{grid-template-columns:1fr} }

    label{font-weight:700; font-size:14px; color:#334155; display:block; margin-bottom:6px}
    input[type="text"], input[type="email"]{
      width:100%; padding:12px; border:1px solid var(--border); border-radius:10px; outline:none; background:#fff;
    }
    input[readonly]{background:#f5faff}
    input:focus{box-shadow:0 0 0 3px rgba(14,180,210,.15)}

    .actions{display:flex; gap:10px; margin-top:8px; justify-content:flex-end}
    .alert{margin:12px 0; padding:12px 14px; border-radius:10px; font-weight:700}
    .alert.error{background:#fee2e2; border:1px solid #fecaca; color:#991b1b}
  </style>
</head>
<body>

<!-- TOP BAR -->
<div class="topbar">
  <div class="brand">
    <img src="${pageContext.request.contextPath}/images/Logo01.png" alt="Logo">

  </div>
  <div class="top-right">
    <div class="welcome">
      Welcome, <c:out value="${empty sessionScope.userName ? (empty sessionScope.user ? 'User' : sessionScope.user) : sessionScope.userName}"/>
    </div>
    <a class="logout" href="${pageContext.request.contextPath}/logout">LogOut</a>
  </div>
</div>

<!-- SUB BAR -->
<div class="subbar">
  <div class="subbar-inner">
    <a class="btn muted" href="${pageContext.request.contextPath}/customers">⬅ Back to List</a>
  </div>
</div>

<div class="page">
  <div class="card">
    <div class="card-head">
      <h2 class="title"><%= editing ? "Edit" : "Register" %> Customer</h2>
    </div>
    <div class="card-body">

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert error"><%= request.getAttribute("error") %></div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/customers" novalidate>
        <% if (editing) { %>
          <input type="hidden" name="id" value="<%= c.getId() %>">
        <% } %>

        <div class="grid">
          <div>
            <label>Account Number</label>
            <input type="text" name="accountNumber" value="<%= accVal %>" readonly>
          </div>

          <div>
            <label>Name</label>
            <input type="text" name="name" value="<%= editing && c.getName()!=null ? c.getName() : "" %>" required>
          </div>

          <div>
            <label>Address</label>
            <input type="text" name="address" value="<%= editing && c.getAddress()!=null ? c.getAddress() : "" %>">
          </div>

          <div>
            <label>Phone</label>
            <input type="text" name="phone" value="<%= editing && c.getPhone()!=null ? c.getPhone() : "" %>">
          </div>

          <div>
            <label>Email</label>
            <input type="email" name="email" value="<%= editing && c.getEmail()!=null ? c.getEmail() : "" %>">
          </div>
        </div>

        <div class="actions">
          <a class="btn" href="${pageContext.request.contextPath}/customers">Cancel</a>
          <button class="btn primary" type="submit"><%= editing ? "Update" : "Create" %></button>
        </div>
      </form>

    </div>
  </div>
</div>
</body>
</html>
