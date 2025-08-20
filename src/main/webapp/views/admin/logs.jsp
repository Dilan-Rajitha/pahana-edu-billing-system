<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>System Activity Logs</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial; background: #f3f6f9; color: #0f172a; }

    /* Top bar */
    .topbar { background: #0EB4D2; color: #fff; display: flex; align-items: center; justify-content: space-between; padding: 10px 18px; box-shadow: inset 0 -3px rgba(0, 0, 0, .08); position: sticky; top: 0; z-index: 50; }
    .brand { display: flex; align-items: center; gap: 10px; }
    .brand img { height: 40px; width: auto; display: block; }

    .right { display: flex; align-items: center; gap: 10px; }
    .welcome { background: rgba(255, 255, 255, .18); border: 1px solid rgba(255, 255, 255, .28); padding: 8px 12px; border-radius: 999px; font-weight: 600; }
    .logout { background: #ff6b6b; border: 1px solid #ff9a9a; color: #fff; padding: 8px 12px; border-radius: 10px; text-decoration: none; font-weight: 800; }
    .logout:hover { filter: brightness(.96); }

    .wrap { max-width: 1280px; margin: 18px auto; padding: 0 18px; }

    /* Sub bar with back button */
    .subbar { display: flex; align-items: center; gap: 10px; margin: 12px 0 16px; }
    .btn { padding: 10px 14px; border-radius: 12px; border: 1px solid #e5eaf0; background: #fff; text-decoration: none; color: #0f172a; font-weight: 800; display: inline-flex; align-items: center; gap: 6px; transition: .15s; }
    .btn:hover { box-shadow: 0 1px 2px rgba(0, 0, 0, .06), 0 1px 1px rgba(0, 0, 0, .04); }
    .btn.primary { background: linear-gradient(135deg, #0EB4D2, #0aa1bb); color: #fff; border: none; }

    /* Filter card */
    .card { background: #ffffff; border: 1px solid #e5eaf0; border-radius: 16px; box-shadow: 0 1px 2px rgba(0, 0, 0, .06), 0 1px 1px rgba(0, 0, 0, .04); }
    .filters { display: flex; flex-wrap: wrap; gap: 10px; padding: 14px; }
    .filters input, .filters select { padding: 10px 12px; border: 1px solid #e5eaf0; border-radius: 10px; background: #fff; min-width: 180px; }
    .filters .muted { color: #6b7280; text-decoration: none; font-weight: 700; align-self: center; }

    /* Table card with sticky header */
    .table-card { margin-top: 14px; overflow: hidden; }
    .table-wrap { max-height: calc(85vh - 220px); overflow: auto; }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    thead th {
      position: sticky;
      top: 0;
      background: #f8fafc;
      border-bottom: 1px solid #e5eaf0;
      z-index: 1;
      text-align: center;
      padding: 12px;
      font-weight: 800;
    }
    tbody td { padding: 12px; border-bottom: 1px solid #e5eaf0; text-align: center; }
    tbody tr:hover { background: #fafcff; }
    .chip { background: #e0f2fe; color: #075985; border: 1px solid #bae6fd; padding: 4px 10px; border-radius: 999px; font-weight: 800; display: inline-block; }

    /* Page title */
    .title { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
    .title h2 { margin: 0; font-size: 22px; font-weight: 900; }
  </style>
</head>
<body>

  <!-- Top bar -->
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

  <div class="wrap">
    <div class="title">
      <h2>System Activity Logs</h2>
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
    </div>

    <!-- Filters -->
    <div class="card">
      <form method="get" action="${pageContext.request.contextPath}/logs" class="filters">
        <input type="text" name="user" placeholder="Filter by user" value="${userQ}">
        <select name="action">
          <option value="">All actions</option>
          <c:set var="aQ" value="${actionQ}"/>
          <option value="LOGIN" ${aQ=='LOGIN'?'selected':''}>LOGIN</option>
          <option value="LOGOUT" ${aQ=='LOGOUT'?'selected':''}>LOGOUT</option>
          <option value="BILL_CREATE" ${aQ=='BILL_CREATE'?'selected':''}>BILL_CREATE</option>
          <option value="ITEM_CREATE" ${aQ=='ITEM_CREATE'?'selected':''}>ITEM_CREATE</option>
          <option value="ITEM_UPDATE" ${aQ=='ITEM_UPDATE'?'selected':''}>ITEM_UPDATE</option>
          <option value="ITEM_DELETE" ${aQ=='ITEM_DELETE'?'selected':''}>ITEM_DELETE</option>
        </select>
        <select name="period">
          <c:set var="p" value="${period}" />
          <option value="today"  ${p=='today'?'selected':''}>Today</option>
          <option value="last7"  ${p=='last7'?'selected':''}>Last 7 days</option>
          <option value="last30" ${p=='last30'?'selected':''}>Last 30 days</option>
          <option value="all"    ${p=='all'?'selected':''}>All time</option>
        </select>
        <button class="btn primary" type="submit">Filter</button>
        <a href="${pageContext.request.contextPath}/logs" class="muted">Reset</a>
      </form>
    </div>

    <!-- Table -->
    <div class="card table-card">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th style="width:70px">#</th>
              <th>User</th>
              <th>Role</th>
              <th>Action</th>
              <th>Reference</th>
              <th>IP</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="e" items="${logs}" varStatus="s">
              <tr>
                <td>${s.count}</td>
                <td>${e.username}</td>
                <td><span class="chip">${e.role}</span></td>
                <td>${e.action}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty e.referenceType}">
                      ${e.referenceType}<c:if test="${not empty e.referenceId}"> #${e.referenceId}</c:if>
                    </c:when>
                    <c:otherwise><span style="color:#6b7280">-</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${empty e.ipAddress ? '-' : e.ipAddress}</td>
                <td>${e.createdAt}</td>
              </tr>
            </c:forEach>
            <c:if test="${empty logs}">
              <tr><td colspan="7" style="color:#6b7280; padding:14px; text-align:center;">No activity found</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</body>
</html>
