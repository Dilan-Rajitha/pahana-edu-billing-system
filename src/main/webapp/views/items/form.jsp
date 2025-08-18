<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
  com.pahanaedu.model.Item it = (com.pahanaedu.model.Item) request.getAttribute("item");
  boolean editing = (it != null && it.getId() != null);
  String cat = (editing && it.getCategory()!=null) ? it.getCategory() : "";
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title><%= editing ? "Edit" : "Add" %> Item</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap');
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f1f5f9; --panel:#fff; --panel-2:#f8fafc;
      --text:#0f172a; --muted:#64748b; --border:#e5eaf0; --border-2:#cbd5e1;
      --shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:'Inter',system-ui,-apple-system,Segoe UI,Roboto,Arial;background:var(--bg);color:var(--text)}

    .topbar{
      background:var(--brand); color:#fff; display:flex; align-items:center; justify-content:space-between;
      padding:10px 18px; position:sticky; top:0; z-index:50; box-shadow:inset 0 -3px rgba(0,0,0,.06);
    }
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:40px}
    .brand-title{font-weight:800}
    .top-right{display:flex; align-items:center; gap:10px}
    .welcome{background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28); padding:6px 10px; border-radius:999px; font-weight:600}
    .logout{background:#ff6b6b; border:1px solid #ff9a9a; color:#fff; padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800}

    .subbar{background:#ffffffcc; backdrop-filter:saturate(1.2) blur(6px); border-bottom:1px solid var(--border);
      position:sticky; top:52px; z-index:40;}
    .subbar-inner{max-width:980px; margin:10px auto; padding:10px 18px; display:flex; gap:12px; align-items:center}
    .btn{
      padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:700; text-decoration:none; color:#0f172a; display:inline-flex; align-items:center; gap:6px; transition:.15s;
    }
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}

    .page{max-width:980px; margin:16px auto 28px; padding:0 18px}
    .card{background:var(--panel); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden}
    .card-head{padding:16px 18px; border-bottom:1px solid var(--border); background:var(--panel-2)}
    .card-body{padding:18px}
    .title{margin:0; font-weight:800}

    .grid{display:grid; grid-template-columns:1fr 1fr; gap:16px}
    @media (max-width:720px){ .grid{grid-template-columns:1fr} }

    label{font-weight:700; font-size:14px; color:#334155; display:block; margin-bottom:6px}

    /* ✅ Unified control sizing */
    input[type="text"],
    input[type="number"],
    select{
      width:100%;
      height:44px;               /* same height everywhere */
      padding:0 12px;
      border:1px solid var(--border);
      border-radius:10px;
      outline:none; background:#fff; font-size:14px;
      line-height:44px;          /* vertically centers text in some UAs */
    }
    textarea{
      width:100%;
      min-height:110px;
      padding:12px;
      border:1px solid var(--border);
      border-radius:10px;
      outline:none; background:#fff; font-size:14px;
      resize:vertical;
    }
    input:focus, select:focus, textarea:focus{box-shadow:0 0 0 3px rgba(14,180,210,.15)}
    /* Remove number spinners for consistent height */
    input[type=number]::-webkit-outer-spin-button,
    input[type=number]::-webkit-inner-spin-button{ -webkit-appearance: none; margin: 0; }
    input[type=number]{ -moz-appearance: textfield; }

    .thumb{width:100px; height:100px; object-fit:cover; border:1px solid #e5e7eb; border-radius:12px; margin-top:8px; box-shadow:var(--shadow)}
    .actions{display:flex; gap:10px; margin-top:10px; justify-content:flex-end}

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
    <a class="btn" href="${pageContext.request.contextPath}/items">⬅ Back to Items</a>
  </div>
</div>

<div class="page">
  <div class="card">
    <div class="card-head">
      <h2 class="title"><%= editing ? "Edit" : "Add" %> Item</h2>
    </div>

    <div class="card-body">
      <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
      </c:if>

      <!-- enctype for file upload -->
      <form method="post" action="${pageContext.request.contextPath}/items" enctype="multipart/form-data" novalidate>
        <% if (editing) { %>
          <input type="hidden" name="id" value="<%= it.getId() %>">
        <% } %>

        <div class="grid">
          <div>
            <label>Name</label>
            <input type="text" name="name" value="<%= editing ? it.getName() : "" %>" required>
          </div>

          <div>
            <label>Price</label>
            <input type="number" name="price" step="0.01" min="0"
                   value="<%= editing && it.getPrice()!=null ? it.getPrice() : "" %>" required>
          </div>

          <div>
            <label>Quantity</label>
            <input type="number" name="quantity" step="1" min="0"
                   value="<%= editing && it.getQuantity()!=null ? it.getQuantity() : "0" %>" required>
          </div>

          <div>
            <label>Category</label>
            <select name="category">
              <option value="">-- Select --</option>
              <option value="Textbooks"  <%= "Textbooks".equals(cat)  ? "selected" : "" %>>Textbooks</option>
              <option value="Stationery" <%= "Stationery".equals(cat) ? "selected" : "" %>>Stationery</option>
              <option value="Novels"     <%= "Novels".equals(cat)     ? "selected" : "" %>>Novels</option>
              <option value="Magazines"  <%= "Magazines".equals(cat)  ? "selected" : "" %>>Magazines</option>
              <option value="Others"     <%= "Others".equals(cat)     ? "selected" : "" %>>Others</option>
            </select>
          </div>

          <div style="grid-column:1/-1">
            <label>Description</label>
            <textarea name="description"><%= editing && it.getDescription()!=null ? it.getDescription() : "" %></textarea>
          </div>

          <div>
            <label>Image (PNG/JPG/JPEG/WEBP)</label>
            <input type="file" name="imageFile" accept=".png,.jpg,.jpeg,.webp">
          </div>

          <div>
            <c:if test="${not empty item and not empty item.image}">
              <label>Current Image</label>
              <img class="thumb"
                   src="${(fn:startsWith(item.image,'http') or fn:startsWith(item.image,'https'))
                          ? item.image
                          : pageContext.request.contextPath.concat(item.image)}"
                   alt="preview">
            </c:if>
          </div>
        </div>

        <div class="actions">
          <a class="btn" href="${pageContext.request.contextPath}/items">Cancel</a>
          <button class="btn primary" type="submit"><%= editing ? "Update" : "Create" %></button>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
