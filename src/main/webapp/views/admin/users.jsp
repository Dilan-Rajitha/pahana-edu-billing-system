<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Manage Users</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    *{box-sizing:border-box}
    body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Arial;background:#f3f6f9;color:#0f172a}

    /* Top bar */
    .topbar{background:#0EB4D2;color:#fff;display:flex;align-items:center;justify-content:space-between;padding:10px 18px;box-shadow:inset 0 -3px rgba(0,0,0,.08);position:sticky;top:0;z-index:50;}
    .brand{display:flex;align-items:center;gap:10px}
    .brand img{height:40px;width:auto;display:block}
    .right{display:flex;align-items:center;gap:10px}
    .welcome{background:rgba(255,255,255,.18);border:1px solid rgba(255,255,255,.28);padding:8px 12px;border-radius:999px;font-weight:600}
    .logout{background:#ff6b6b;border:1px solid #ff9a9a;color:#fff;padding:8px 12px;border-radius:10px;text-decoration:none;font-weight:800}
    .logout:hover{filter:brightness(.96)}

    /* Sub bar */
    .subbar{background:#ffffffcc;backdrop-filter:saturate(1.2) blur(6px);border-bottom:1px solid #e5eaf0;position:sticky;top:56px;z-index:40;}
    .subbar-inner{max-width:1200px;margin:0 auto;padding:10px 18px;display:flex;gap:12px;align-items:center}
    .btn{padding:10px 14px;border-radius:10px;border:1px solid #e5eaf0;background:#fff;cursor:pointer;font-weight:700;text-decoration:none;color:#0f172a;display:inline-flex;align-items:center;gap:6px;transition:.18s;}
    .btn:hover{box-shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04)}
    .btn.primary{background:#0EB4D2;color:#fff;border:none}
    .btn.primary:hover{background:#0aa1bb}
    .btn.danger{background:linear-gradient(135deg,#ef4444,#dc2626);color:#fff;border:none}

    .wrap{max-width:1200px;margin:18px auto;padding:0 18px}

    /* Card */
    .card{background:#ffffff;border:1px solid #e5eaf0;border-radius:16px;box-shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);overflow:hidden}
    .card-header{display:flex;align-items:center;justify-content:space-between;padding:16px 18px;border-bottom:1px solid #e5eaf0;background:#f8fafc}
    h2{margin:0;font-size:20px}

    /* Form row */
    .form-row{display:flex;gap:10px;align-items:center;flex-wrap:wrap;padding:16px 18px;border-bottom:1px solid #e5eaf0;background:#fff}
    input[type="text"],input[type="password"],select{padding:10px 12px;border:1px solid #e5eaf0;border-radius:10px;background:#fff;min-width:200px;outline:none;}
    input:focus,select:focus{box-shadow:0 0 0 3px rgba(14,180,210,.15);border-color:#cbd5e1}

    /* Table */
    .table-wrap{overflow:auto}
    table{border-collapse:separate;border-spacing:0;width:100%}
    thead th{position:sticky;top:0;background:#f8fafc;border-bottom:1px solid #e5eaf0;text-align:left;padding:12px 14px;z-index:1}
    th, td{padding:12px 14px;border-bottom:1px solid #e5eaf0;text-align:left}
    tbody tr:hover{background:#fafcff}
    .actions a{margin-right:6px}

    .alert{margin:12px 0;padding:12px 14px;border-radius:10px;font-weight:700}
    .alert.error{background:#fee2e2;border:1px solid #fecaca;color:#991b1b}
    .alert.success{background:#dcfce7;border:1px solid #bbf7d0;color:#166534}

    @media (max-width:720px){
      .subbar{top:54px}
      thead{display:none}
      table,tbody,tr,td{display:block;width:100%}
      tbody tr{background:#fff;border:1px solid #e5eaf0;margin:10px 0;border-radius:12px}
      tbody td{border:none;padding:10px 14px}
      tbody td::before{content:attr(data-label);font-weight:700;color:#334155;display:block;margin-bottom:4px}
    }
  </style>
</head>
<body>

  <!-- TOP BAR -->
  <div class="topbar">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/images/Logo01.png" alt="Logo">
    </div>
    <div class="right">
      <div class="welcome">
        Welcome, <c:out value="${empty sessionScope.userName ? (empty sessionScope.user ? 'User' : sessionScope.user) : sessionScope.userName}"/>
      </div>
      <a class="logout" href="${pageContext.request.contextPath}/logout">LogOut</a>
    </div>
  </div>

  <!-- SUB BAR -->
  <div class="subbar">
    <div class="subbar-inner">
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
    </div>
  </div>

  <div class="wrap">

    <!-- Messages -->
    <c:if test="${not empty error}">
      <div class="alert error"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert success"><c:out value="${success}"/></div>
    </c:if>

    <!-- Card -->
    <div class="card">
      <div class="card-header">
        <h2>Manage Users</h2>
      </div>

      <!-- Add user form -->
      <form method="post" action="${pageContext.request.contextPath}/admin/users">
        <div class="form-row">
          <input type="text" name="username" placeholder="Username" required>
          <input type="password" name="password" placeholder="Password" required>
          <select name="role" required>
            <option value="STAFF">STAFF</option>
            <option value="ADMIN">ADMIN</option>
          </select>
          <button class="btn primary" type="submit">+ Add</button>
        </div>
      </form>

      <!-- Users table -->
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th style="width:90px">ID</th>
              <th>Username</th>
              <th style="width:140px">Role</th>
              <th style="width:140px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="u" items="${users}">
              <tr>
                <td data-label="ID"><c:out value="${u.id}"/></td>
                <td data-label="Username" style="font-weight:700"><c:out value="${u.username}"/></td>
                <td data-label="Role"><span style="background:#e3f2fd;padding:4px 10px;border-radius:999px;font-weight:700"><c:out value="${u.role}"/></span></td>
                <td data-label="Actions" class="actions">
                  <a class="btn danger"
                     href="${pageContext.request.contextPath}/admin/users?action=delete&id=${u.id}"
                     onclick="return confirm('Delete this user?')">Delete</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty users}">
              <tr>
                <td colspan="4" style="text-align:center; color:#6b7280; padding:16px">No users found</td>
              </tr>
            </c:if>
            
          </tbody>
        </table>
      </div>
    </div>
  </div>

</body>
</html>
