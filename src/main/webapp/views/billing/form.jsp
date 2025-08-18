<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Billing Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap');
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f1f5f9; --panel:#fff; --panel-2:#f8fafc;
      --text:#0f172a; --muted:#64748b; --border:#e5eaf0; --border-2:#cbd5e1;
      --success:#0fa968; --danger:#ef4444;
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
    .subbar-inner{max-width:1200px; margin:10px; padding:10px 18px; display:flex; gap:12px; align-items:center}
    .btn{
      padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:700; text-decoration:none; color:var(--text); display:inline-flex; align-items:center; gap:6px;
    }
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}
    .btn.small{padding:6px 10px; font-weight:700}
    .btn.danger{background:linear-gradient(135deg,#ef4444,#dc2626); color:#fff; border:none}
    .search-form{display:flex; gap:10px; align-items:center; background:#fff; border:1px solid var(--border); border-radius:12px; padding:6px 8px}
    .search-form input[type="text"]{padding:10px 12px; border:1px solid var(--border); border-radius:10px; min-width:260px}

    /* PAGE GRID */
    .wrap{
      display:grid; grid-template-columns:200px 1fr 490px; gap:5px;
      max-width:100%; margin:10px auto; padding:0 18px;
    }
    .card{background:var(--panel); border:1px solid var(--border); border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden}

    /* SIDEBAR */
    .side{position:sticky; top:112px; height:fit-content}
    .side ul{list-style:none; padding:12px}
    .side a{display:flex; align-items:center; gap:10px; padding:12px 14px; border-radius:12px; text-decoration:none; color:var(--text); font-weight:600}
    .side a.active{background:#e6f9fd; border:1px solid #b8ecf7; color:#06637b}

    /* PRODUCTS */
    .product-panel{max-height:calc(88vh - 120px); overflow:auto}
    .grid{display:grid; grid-template-columns:repeat(4, minmax(0,1fr)); gap:10px; padding:10px}
    @media (max-width:1280px){ .grid{grid-template-columns:repeat(3,minmax(0,1fr))} }
    @media (max-width:960px){  .grid{grid-template-columns:repeat(2,minmax(0,1fr))} }
    @media (max-width:640px){  .grid{grid-template-columns:1fr} }
    .item{border:1px solid var(--border); border-radius:16px; padding:10px; background:#fff; transition:.2s}
    .item img{width:100%; height:140px; object-fit:cover; border-radius:12px; border:1px solid var(--border); background:#f6f7fb}
    .name{font-weight:800; margin:10px 0 2px}
    .muted{color:var(--muted); font-size:12px; text-transform:uppercase; letter-spacing:.4px}
    .price{color:#0a7a60; font-weight:900; margin:8px 0}
    .row{display:flex; gap:10px; align-items:center; margin-top:6px}
    .row input[type="number"]{width:72px; padding:8px; border:1px solid var(--border); border-radius:10px}

    /* CART */
    .cart{position:sticky; top:112px; max-height:calc(90vh - 130px); display:flex; flex-direction:column}
    .cart-header{display:flex; justify-content:space-between; align-items:center; padding:14px 16px; border-bottom:1px solid var(--border); background:var(--panel-2)}
    .customer-form{padding:12px 16px; border-bottom:1px solid var(--border); background:#fff}
    .customer-form input{width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:10px; margin-bottom:10px}
    .customer-info{padding:10px 16px; background:#eaffe9; border-bottom:1px solid var(--border)}

    /* Only the items table area scrolls */
    .cart-scroll{flex:1 1 auto; min-height:0; overflow:auto}
    table{width:100%; border-collapse:collapse}
    th,td{padding:10px 12px; border-bottom:1px solid var(--border)}
    th{background:#f8fafc; font-size:12px; text-transform:uppercase; color:#475569}
    .right{text-align:right}
    .qty-controls{display:flex; align-items:center; gap:4px}

    /* Summary box: Subtotal + Discount + Total + Checkout (fixed at bottom) */
    .summary-box{
      flex:0 0 auto;
      border-top:1px solid var(--border);
      background:#fff;
      padding:12px 12px 16px;
    }
    .summary-card{
      border:1px solid var(--border);
      border-radius:12px;
      background:var(--panel-2);
      padding:12px;
    }
    .summary-row{
      display:flex; justify-content:space-between; align-items:center; padding:8px 4px;
      border-bottom:1px dashed var(--border-2);
    }
    .summary-row:last-child{border-bottom:none}
    .total{
      color:#0a7a60; font-weight:900; font-size:20px;
    }
  </style>

  <script>
    function validateCheckout(form){
      const itemCount = ${fn:length(billDraft.items)};
      if(itemCount===0){toast("Your cart is empty. Please add some items.","error");return false;}
      const btn=form.querySelector('button[type="submit"]');const t=btn.textContent;btn.textContent='Processing...';btn.disabled=true;
      const w=window.open('','receiptWin','width=900,height=1000,scrollbars=yes,resizable=yes');if(w){form.target='receiptWin'}
      setTimeout(()=>{btn.textContent=t;btn.disabled=false;},1600);return true;
    }
    function toast(msg,type){
      const el=document.createElement('div');
      el.className='alert '+(type==='error'?'error':'success'); el.textContent=msg;
      el.style.position='fixed'; el.style.top='18px'; el.style.right='18px'; el.style.zIndex='9999';
      document.body.appendChild(el); setTimeout(()=>el.remove(),2600);
    }
  </script>
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
    <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
    <form method="get" action="${pageContext.request.contextPath}/billing" class="search-form">
      <input type="text" name="q" value="${q}" placeholder="Enter product ID or name">
      <input type="hidden" name="cat" value="${cat}">
      <button class="btn primary" type="submit">🔍 Search</button>
      <a class="btn" href="${pageContext.request.contextPath}/billing">Reset</a>
    </form>
  </div>
</div>

<!-- FLASH -->
<c:if test="${not empty error}"><div class="alert error" style="margin:10px 18px">${error}</div></c:if>
<c:if test="${not empty success}"><div class="alert success" style="margin:10px 18px">${success}</div></c:if>

<!-- LAYOUT -->
<div class="wrap">

  <!-- LEFT: Categories -->
  <aside class="card side">
    <ul>
      <li>
        <a href="${pageContext.request.contextPath}/billing?cat=ALL&q=${fn:escapeXml(q)}"
           class="${cat=='ALL' ? 'active' : ''}">All Categories</a>
      </li>
      <c:forEach var="cname" items="${categories}">
        <li>
          <a class="${cname==cat ? 'active' : ''}"
             href="${pageContext.request.contextPath}/billing?cat=${cname}&q=${fn:escapeXml(q)}">${cname}</a>
        </li>
      </c:forEach>
    </ul>
  </aside>

  <!-- MIDDLE: Product grid -->
  <section class="card product-panel">
    <div class="grid">
      <c:forEach var="it" items="${allItems}">
        <c:set var="nameOk" value="${empty q or fn:contains(fn:toLowerCase(it.name), fn:toLowerCase(q))}"/>
        <c:set var="idOk"   value="${empty q or fn:contains(fn:toLowerCase(it.id),   fn:toLowerCase(q))}"/>
        <c:set var="catOk"  value="${cat=='ALL' or it.category==cat}"/>
        <c:if test="${(nameOk or idOk) and catOk}">
          <div class="item">
            <c:choose>
              <c:when test="${not empty it.image && (fn:startsWith(it.image,'http') or fn:startsWith(it.image,'https'))}">
                <img src="${it.image}" alt="${it.name}">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}${it.image}" alt="${it.name}">
              </c:otherwise>
            </c:choose>
            <div class="name">${it.name}</div>
            <div class="muted">${it.category}</div>
            <div class="price">Rs. ${it.price}</div>

            <form method="post" action="${pageContext.request.contextPath}/billing" class="row">
              <input type="hidden" name="action" value="add">
              <input type="hidden" name="itemId" value="${it.id}">
              <input type="number" name="qty" min="1" max="999" value="1">
              <button class="btn primary" type="submit">🛒 Add to Cart</button>
            </form>
          </div>
        </c:if>
      </c:forEach>
    </div>
  </section>

  <!-- RIGHT: Cart -->
  <aside class="card cart">
    <div class="cart-header">
      <h3 style="margin:0">🛒 Shopping Cart</h3>
      <a class="btn small danger" href="${pageContext.request.contextPath}/billing?action=clear"
         onclick="return confirm('Are you sure you want to clear the cart?')">Clear All</a>
    </div>

    <div class="customer-form">
      <form method="post" action="${pageContext.request.contextPath}/billing">
        <input type="hidden" name="action" value="setCustomer">
        <input type="text" name="customerKey" placeholder="Enter Customer ID, Account #, or Phone">
        <div style="display:flex; gap:8px; flex-wrap:wrap">
          <button class="btn small primary" type="submit">👤 Identify Customer</button>
          <button class="btn small" type="submit"
                  formaction="${pageContext.request.contextPath}/billing" name="action" value="clearCustomer">Remove</button>
        </div>
      </form>
    </div>

    <c:if test="${not empty sessionScope.billCustomerName}">
      <div class="customer-info"><strong>Customer:</strong> ${sessionScope.billCustomerName}</div>
    </c:if>

    <!-- Items table (this part scrolls) -->
    <div class="cart-scroll">
      <div style="overflow-x:auto;">
        <table>
          <thead>
            <tr>
              <th>#</th><th>Item</th>
              <th class="right">Price</th>
              <th class="right">Qty</th>
              <th class="right">Total</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="bi" items="${billDraft.items}" varStatus="s">
              <tr>
                <td>${s.count}</td>
                <td>${bi.itemName}</td>
                <td class="right">Rs. ${bi.unitPrice}</td>
                <td class="right">
                  <div class="qty-controls">
                    <form method="post" action="${pageContext.request.contextPath}/billing" style="display:inline">
                      <input type="hidden" name="action" value="dec">
                      <input type="hidden" name="itemId" value="${bi.itemId}">
                      <button class="btn small">−</button>
                    </form>
                    <span style="margin:0 8px; font-weight:700">${bi.quantity}</span>
                    <form method="post" action="${pageContext.request.contextPath}/billing" style="display:inline">
                      <input type="hidden" name="action" value="inc">
                      <input type="hidden" name="itemId" value="${bi.itemId}">
                      <button class="btn small">+</button>
                    </form>
                  </div>
                </td>
                <td class="right">Rs. ${bi.subtotal}</td>
                <td>
                  <a class="btn small danger"
                     href="${pageContext.request.contextPath}/billing?action=remove&itemId=${bi.itemId}"
                     onclick="return confirm('Remove this item?')">🗑️</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty billDraft.items}">
              <tr><td colspan="6" style="text-align:center; color:#6b7280; padding:16px">Your cart is empty</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <!-- FIXED SUMMARY BOX -->
    <div class="summary-box">
      <div class="summary-card">
        <!-- Subtotal -->
        <div class="summary-row">
          <div style="font-weight:800; color:#475569; letter-spacing:.5px">SUBTOTAL:</div>
          <div style="font-weight:800;">Rs. ${billDraft.subtotal}</div>
        </div>

        <!-- Discount line -->
        <div class="summary-row">
          <div style="display:flex; align-items:center; gap:8px; color:#475569">
            Discount:
            <form method="post" action="${pageContext.request.contextPath}/billing" style="display:flex; align-items:center; gap:8px; margin:0">
              <input type="hidden" name="action" value="discount">
              <input type="number" name="discountPercent" step="0.01" min="0" max="100"
                     value="${billDraft.discountPercent}"
                     style="width:80px; padding:6px 8px; border:1px solid var(--border); border-radius:8px;">
              <span>%</span>
              <button class="btn small" type="submit">Apply</button>
              <button class="btn small danger" type="submit"
                      formaction="${pageContext.request.contextPath}/billing" name="action" value="discountClear">Clear</button>
            </form>
          </div>
          <div style="font-weight:700">${billDraft.discountPercent}%</div>
        </div>

        <!-- Total -->
        <div class="summary-row">
          <div style="font-size:18px; font-weight:900; letter-spacing:.6px">TOTAL:</div>
          <div class="total">Rs. ${billDraft.total}</div>
        </div>

        <!-- Checkout button -->
        <form method="post" action="${pageContext.request.contextPath}/billing" onsubmit="return validateCheckout(this);" style="margin-top:12px">
          <input type="hidden" name="action" value="save">
          <button class="btn primary" type="submit"
                  style="width:100%; justify-content:center; padding:14px; font-size:16px">
            💳 Proceed to Checkout
          </button>
        </form>
      </div>
    </div>

  </aside>
</div>
</body>
</html>
