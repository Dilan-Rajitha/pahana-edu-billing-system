<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Staff Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f3f6f9; --panel:#ffffff; --muted:#5b6b7a; --text:#0f172a; --border:#e5eaf0;
      --shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);
      --shadow-lg:0 16px 32px rgba(2,6,23,.08);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Arial;background:var(--bg);color:var(--text)}

    .topbar{background:var(--brand); color:#fff; display:flex; align-items:center; justify-content:space-between; padding:10px 18px; box-shadow:inset 0 -3px rgba(0,0,0,.08)}
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:40px;width:auto;display:block}

    .right{display:flex; align-items:center; gap:10px}
    .welcome{background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28); padding:8px 12px; border-radius:999px; font-weight:600}
    .logout{background:#ff6b6b; border:1px solid #ff9a9a; color:#fff; padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800}
    .logout:hover{filter:brightness(.96)}

    .wrap{max-width:1280px; margin:18px auto; padding:0 18px}

    .stats{display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:22px}
    .stat{background:var(--brand); color:#fff; border-radius:14px; padding:16px 18px; box-shadow:var(--shadow); display:flex; flex-direction:column; gap:10px; min-height:100px}
    .stat h4{margin:0; font-size:15px; font-weight:800; opacity:.95}
    .stat .value{font-size:36px; font-weight:900; line-height:1}

    .tiles{display:grid; grid-template-columns:repeat(2,1fr); gap:22px}
    .tile{background:var(--panel); border:1px solid var(--border); border-radius:20px; box-shadow:var(--shadow); min-height:160px; padding:18px; display:flex; align-items:flex-end; justify-content:flex-start; position:relative; overflow:hidden; transition:.2s}
    .tile:hover{transform:translateY(-2px); box-shadow:var(--shadow-lg)}
    .tile .label{color:#0b7b90; font-weight:800}
    .tile::before{content:""; position:absolute; inset:auto -20% 40% auto; width:140px; height:140px; background:rgba(14,180,210,.15); border-radius:50%; filter:blur(2px)}
    .tile .btn{margin-top:10px; display:inline-block; background:var(--brand); color:#fff; border:none; padding:10px 14px; border-radius:10px; text-decoration:none; font-weight:800}
    .tile .btn:hover{background:var(--brand-dark)}

    @media (max-width:1100px){ .tiles{grid-template-columns:1fr} }
    @media (max-width:720px){ .stats{grid-template-columns:1fr} }
  </style>
</head>
<body>

  <div class="topbar">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/images/Logo01.png" alt="Logo">
 
    </div>
    <div class="right">
      <div class="welcome">
        Welcome, Staff (
        <c:out value="${empty sessionScope.userName ? (empty sessionScope.user ? 'User' : sessionScope.user) : sessionScope.userName}"/>
        )
      </div>
      <a class="logout" href="${pageContext.request.contextPath}/logout">LogOut</a>
    </div>
  </div>

  <div class="wrap">
    <!-- Stats row -->
    <div class="stats">
      <!-- 👇 NEW: This staff user's today's sales -->
      <div class="stat">
        <h4>Your Sales Today (Rs.)</h4>
        <div class="value">
          <fmt:formatNumber value="${staffTodaySales != null ? staffTodaySales : 0}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
        </div>
      </div>

      <div class="stat">
        <h4>Items Total :</h4>
        <div class="value"><c:out value="${itemCount != null ? itemCount : 0}"/></div>
      </div>

      <div class="stat">
        <h4>Registered Customers:</h4>
        <div class="value"><c:out value="${customerCount != null ? customerCount : 0}"/></div>
      </div>
    </div>

    <!-- Tiles -->
    <div class="tiles">
      <div class="tile">
        <div>
          <div class="label">Register / Manage Customers</div>
          <a class="btn" href="${pageContext.request.contextPath}/customers">Open</a>
        </div>
      </div>

      <div class="tile">
        <div>
          <div class="label">View / Manage Items</div>
          <a class="btn" href="${pageContext.request.contextPath}/items">Open</a>
        </div>
      </div>

      <div class="tile">
        <div>
          <div class="label">Calculate Bill</div>
          <a class="btn" href="${pageContext.request.contextPath}/billing">Open</a>
        </div>
      </div>

      <div class="tile">
        <div>
          <div class="label">Help & Support</div>
          <a class="btn" href="${pageContext.request.contextPath}/help">Open</a>

          

        </div>
      </div>
    </div>
  </div>

</body>
</html>
