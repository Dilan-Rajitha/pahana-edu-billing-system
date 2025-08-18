<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Customers</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
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

    /* Top bar (same style as dashboard) */
    .topbar{
      background:var(--brand); color:#fff; display:flex; align-items:center; justify-content:space-between;
      padding:10px 18px; box-shadow:inset 0 -3px rgba(0,0,0,.08);
    }
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:40px;width:auto;display:block}

    .right{display:flex; align-items:center; gap:10px}
    .welcome{background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28); padding:8px 12px; border-radius:999px; font-weight:600}
    .logout{background:#ff6b6b; border:1px solid #ff9a9a; color:#fff; padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800}
    .logout:hover{filter:brightness(.96)}

    .wrap{max-width:1200px; margin:18px auto; padding:0 18px}

    /* Actions row */
    .actions{display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin:6px 0 16px}
    .btn{padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; font-weight:800; text-decoration:none; color:var(--text)}
    .btn:hover{box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}
    .spacer{flex:1}

    /* Search box */
    .search{display:flex; gap:8px; align-items:center; flex-wrap:wrap}
    .search input[type="text"]{
      padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#fff; min-width:280px; outline:none
    }
    .search input[type="text"]:focus{box-shadow:0 0 0 3px rgba(14,180,210,.15)}
    .search .btn{font-weight:800}

    /* Card + table */
    .card{background:var(--panel); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden}
    .head{padding:16px 18px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center}
    .title{margin:0; font-size:20px; font-weight:900}
    .table-wrap{max-height:calc(85vh - 200px); overflow:auto}
    table{border-collapse:separate; border-spacing:0; width:100%}
    thead th{position:sticky; top:0; z-index:1; background:#f8fafc; border-bottom:1px solid var(--border)}
    th,td{padding:12px 14px; border-bottom:1px solid var(--border); vertical-align:middle}
    tbody tr:hover{background:#fafcff}
    .muted{color:var(--muted)}
    .acts a{display:inline-block; text-decoration:none; font-weight:700; padding:8px 10px; border-radius:8px; margin-right:6px; border:1px solid var(--border); background:#fff}
    .acts a:hover{box-shadow:var(--shadow)}
    .acts a.edit{color:#0b63c7; border-color:#c7d2fe; background:#eef2ff}
    .acts a.del{color:#991b1b; border-color:#fecaca; background:#fee2e2}

    /* Responsive (cards on mobile) */
    @media (max-width:760px){
      .table-wrap{max-height:none}
      thead{display:none}
      table,tbody,tr,td{display:block; width:100%}
      tbody tr{background:#fff; border:1px solid var(--border); margin:10px 0; border-radius:12px; box-shadow:var(--shadow)}
      tbody td{border:none; padding:10px 14px}
      tbody td::before{content:attr(data-label); font-weight:800; color:#334155; display:block; margin-bottom:4px}
      .acts{display:flex; gap:8px; flex-wrap:wrap}
    }
  </style>
</head>
<body>

  <!-- Top bar -->
  <div class="topbar">
    <div class="brand">
      <!-- replace with your logo path -->
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
    <!-- Actions & Search -->
    <div class="actions">
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
      <a class="btn primary" href="${pageContext.request.contextPath}/customers?action=new">+ Register Customer</a>
      <span class="spacer"></span>
      <form method="get" action="${pageContext.request.contextPath}/customers" class="search">
        <input type="text" name="q" value="${q}" placeholder="Search by ID / Phone / Account / Name">
        <button class="btn primary" type="submit">🔍 Search</button>
        <a class="btn" href="${pageContext.request.contextPath}/customers">Reset</a>
      </form>
    </div>

    <div class="card">
      <div class="head">
        <h3 class="title">Customers</h3>
      </div>

      <c:if test="${not empty error}">
        <div style="padding:12px 18px; color:#991b1b; background:#fef2f2; border-bottom:1px solid #fecaca;">
          ${error}
        </div>
      </c:if>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th style="width:160px">Account #</th>
              <th>Name</th>
              <th style="width:140px">Phone</th>
              <th style="width:220px">Email</th>
              <th>Address</th>
              <th style="width:170px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="c" items="${customers}">
              <tr>
                <td data-label="Account #">${c.accountNumber}</td>
                <td data-label="Name">
                  <div style="font-weight:800">${c.name}</div>
                  <div class="muted" style="font-size:12px">ID: ${c.id}</div>
                </td>
                <td data-label="Phone">${c.phone}</td>
                <td data-label="Email">${c.email}</td>
                <td data-label="Address" class="muted">${c.address}</td>
                <td data-label="Actions" class="acts">
                  <a class="edit" href="${pageContext.request.contextPath}/customers?action=edit&id=${c.id}">Edit</a>
                  <a class="del" href="${pageContext.request.contextPath}/customers?action=delete&id=${c.id}"
                     onclick="return confirm('Delete this customer?')">Delete</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty customers}">
              <tr>
                <td colspan="6" style="text-align:center; color:#6b7280; padding:24px">No customers found</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</body>
</html>
