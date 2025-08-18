<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Items</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f3f6f9; --panel:#ffffff; --panel-alt:#f1f5f9;
      --text:#0f172a; --muted:#64748b; --border:#e2eaf0;
      --shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);
      --shadow-lg:0 16px 32px rgba(2,6,23,.08);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Arial;background:var(--bg);color:var(--text)}

    /* Top bar (same as dashboard) */
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

    .page{max-width:1200px; margin:18px auto; padding:0 18px}

    h2{margin:0 0 14px; font-size:22px; letter-spacing:.2px; font-weight:900; color:#111827}

    /* Buttons + search row */
    .actions{display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin:6px 0 16px}
    .btn{
      padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:800; transition:.2s; text-decoration:none; display:inline-flex; align-items:center; gap:6px; color:var(--text)
    }
    .btn:hover{box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}
    .spacer{flex:1}

    /* Card */
    .card{background:var(--panel); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden}
    .head{padding:16px 18px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center}
    .title{margin:0; font-size:20px; font-weight:900}

    /* Search / Filter */
    .search{
      display:flex; gap:10px; align-items:center; flex-wrap:wrap;
      padding:14px; background:var(--panel-alt); border-bottom:1px solid var(--border);
    }
    .search input[type="text"], .search input[type="number"], .search select{
      padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#fff;
      transition:.2s; outline:none; min-width:180px;
    }
    .search input:focus, .search select:focus{ border-color:#cbd5e1; box-shadow:0 0 0 3px rgba(14,180,210,.15) }

    /* Table wrapper with own scroll, sticky header */
    .table-wrap{ max-height: calc(85vh - 220px); overflow:auto }
    table{ border-collapse:separate; border-spacing:0; width:100% }
    thead th{ position:sticky; top:0; z-index:2; background:#f8fafc; border-bottom:1px solid var(--border) }
    th, td{ padding:12px 14px; border-bottom:1px solid var(--border); vertical-align:middle; }
    tbody tr:hover{ background:#fafcff }
    tbody tr:last-child td{ border-bottom:none }
    .num{text-align:right}
    .muted{color:var(--muted)}
    .price{font-weight:800; color:#065f46}
    .qty{font-weight:700}
    .thumb{width:56px; height:56px; object-fit:cover; border:1px solid #e5e7eb; border-radius:10px; box-shadow:var(--shadow)}

    /* Category chip */
    .chip{
      display:inline-block; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:800;
      background:#eef2ff; color:#4338ca; border:1px solid #e0e7ff;
    }
    .chip.novels{ background:#ecfeff; color:#155e75; border-color:#cffafe }
    .chip.stationery{ background:#fef9c3; color:#a16207; border-color:#fde68a }
    .chip.magazines{ background:#fce7f3; color:#9d174d; border-color:#fbcfe8 }
    .chip.others{ background:#dcfce7; color:#065f46; border-color:#bbf7d0 }

    /* Row actions */
    .actions-row a{
      text-decoration:none; font-weight:700; padding:8px 10px; border-radius:8px; margin-right:6px;
      border:1px solid var(--border); color:#0f172a; background:#fff; transition:.2s;
    }
    .actions-row a:hover{ box-shadow:var(--shadow) }
    .actions-row a.edit{ color:#1d4ed8; border-color:#c7d2fe; background:#eef2ff }
    .actions-row a.del{ color:#991b1b; border-color:#fecaca; background:#fee2e2 }

    /* Empty state */
    .empty{ padding:30px; text-align:center; color:#6b7280 }

    /* Responsive: card rows */
    @media (max-width: 768px){
      .table-wrap{ max-height:none }
      thead{ display:none }
      table,tbody,tr,td{ display:block; width:100% }
      tbody tr{ background:#fff; border:1px solid var(--border); margin:10px 0; border-radius:12px; box-shadow:var(--shadow) }
      tbody td{ border:none; padding:10px 14px }
      tbody td::before{ content:attr(data-label); font-weight:800; color:#334155; display:block; margin-bottom:4px }
      .num{ text-align:left }
      .actions-row{ display:flex; gap:8px; flex-wrap:wrap }
    }
  </style>
</head>
<body>

  <!-- Top bar -->
  <div class="topbar">
    <div class="brand">
      <!-- replace with your actual logo -->
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

  <div class="page">
    <!-- Page header + quick buttons + search -->
    <div class="actions">
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
      <a class="btn primary" href="${pageContext.request.contextPath}/items?action=new">+ Add Item</a>
      <span class="spacer"></span>
      <form class="search" method="get" action="${pageContext.request.contextPath}/items">
        <input type="text"   name="qName"     placeholder="Search by name" value="${qName}">
        <input type="number" name="qId"       placeholder="Search by ID"   value="${qId}">
        <select name="qCategory">
          <c:set var="catSel" value="${qCategory}" />
          <option value="ALL"        ${catSel=='ALL' ? 'selected' : ''}>All categories</option>
          <option value="Textbooks"  ${catSel=='Textbooks' ? 'selected' : ''}>Textbooks</option>
          <option value="Stationery" ${catSel=='Stationery' ? 'selected' : ''}>Stationery</option>
          <option value="Novels"     ${catSel=='Novels' ? 'selected' : ''}>Novels</option>
          <option value="Magazines"  ${catSel=='Magazines' ? 'selected' : ''}>Magazines</option>
          <option value="Others"     ${catSel=='Others' ? 'selected' : ''}>Others</option>
        </select>
        <button class="btn primary" type="submit">🔍 Search</button>
        <a class="btn" href="${pageContext.request.contextPath}/items">Reset</a>
      </form>
    </div>

    <c:if test="${not empty error}">
      <div class="card" style="margin-bottom:12px;">
        <div style="padding:12px 14px; color:#991b1b; background:#fef2f2; border-bottom:1px solid #fecaca;">
          ${error}
        </div>
      </div>
    </c:if>

    <!-- Items table -->
    <div class="card">
      <div class="head">
        <h3 class="title">Items</h3>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th style="width:60px">#</th>
              <th style="width:84px">Image</th>
              <th>Name</th>
              <th style="width:160px">Category</th>
              <th class="num" style="width:120px">Price</th>
              <th class="num" style="width:90px">Qty</th>
              <th>Description</th>
              <th style="width:170px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="i" items="${items}" varStatus="s">
              <tr>
                <td data-label="#">${s.count}</td>
                <td data-label="Image">
                  <c:if test="${not empty i.image}">
                    <img class="thumb"
                         src="${(fn:startsWith(i.image,'http') or fn:startsWith(i.image,'https')) ? i.image : pageContext.request.contextPath.concat(i.image)}?v=${i.id}"
                         alt="${i.name}">
                  </c:if>
                </td>
                <td data-label="Name">
                  <div style="font-weight:900">${i.name}</div>
                  <div class="muted" style="font-size:12px">ID: ${i.id}</div>
                </td>
                <td data-label="Category">
                  <span class="chip
                    ${i.category=='Novels'?'novels':''}
                    ${i.category=='Stationery'?'stationery':''}
                    ${i.category=='Magazines'?'magazines':''}
                    ${i.category=='Others'?'others':''}">
                    ${i.category}
                  </span>
                </td>
                <td data-label="Price" class="num price">Rs. ${i.price}</td>
                <td data-label="Qty" class="num qty">${i.quantity}</td>
                <td data-label="Description" class="muted">${i.description}</td>
                <td data-label="Actions" class="actions-row">
                  <a class="edit" href="${pageContext.request.contextPath}/items?action=edit&id=${i.id}">Edit</a>
                  <a class="del" href="${pageContext.request.contextPath}/items?action=delete&id=${i.id}"
                     onclick="return confirm('Delete this item?')">Delete</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty items}">
              <tr>
                <td colspan="8" class="empty">No items found</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</body>
</html>
