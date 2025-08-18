<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Help & Support – Staff</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f8fafc; --panel:#ffffff; --muted:#64748b; --text:#1e293b; --border:#e2e8f0;
      --shadow:0 1px 3px rgba(0,0,0,.08);
      --shadow-lg:0 10px 25px -5px rgba(0,0,0,.1);
      --radius:12px;
      --content-width: 1200px;
      --topbar-h: 56px;
      --subbar-h: 52px;
      --total-header-h: 108px; /* topbar + subbar */
    }

    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      font-family: 'Inter', ui-sans-serif, system-ui, -apple-system, sans-serif;
      background:var(--bg); color:var(--text);
      line-height:1.6;
      padding-top:var(--total-header-h); /* Add space for fixed headers */
    }

    /* Top bar - Fixed */
    .topbar{
      background:var(--brand); color:#fff;
      display:flex; align-items:center; justify-content:space-between;
      padding:10px 18px;
      box-shadow:inset 0 -3px rgba(0,0,0,.08);
      position:fixed; top:0; left:0; right:0; z-index:100;
      height:var(--topbar-h);
    }
    .brand{display:flex; align-items:center; gap:12px; min-height:36px}
    .brand img{height:40px; width:auto; display:block}

    .top-right{display:flex; align-items:center; gap:10px}
    .welcome{
      background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28);
      padding:8px 12px; border-radius:999px; font-weight:600; white-space:nowrap
    }
    .logout{
      background:#ff6b6b; border:1px solid #ff9a9a; color:#fff;
      padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800
    }
    .logout:hover{filter:brightness(.96)}

    /* Subbar - Fixed */
    .subbar{
      position:fixed; top:var(--topbar-h); left:0; right:0; z-index:90;
      background:#ffffffcc; backdrop-filter:saturate(1.1) blur(8px);
      border-bottom:1px solid var(--border);
      box-shadow: 0 2px 4px rgba(0,0,0,.03);
      height:var(--subbar-h);
    }
    .subbar-inner{
      max-width:var(--content-width); margin:0 auto;
      padding:12px 24px; display:flex; align-items:center; justify-content:space-between;
      gap:16px; height:100%;
    }

    /* Improved Buttons */
    .btn{
      padding:10px 16px; border-radius:10px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:600; color:var(--text); text-decoration:none; display:inline-flex; align-items:center; gap:8px; transition:.15s;
      font-size:14px;
    }
    .btn:hover{box-shadow:var(--shadow); border-color:#cbd5e1; background:#f8fafc}
    .btn.primary{
      background:linear-gradient(135deg,var(--brand),var(--brand-dark)); color:#fff; border:none;
      box-shadow: 0 2px 4px rgba(14,180,210,.2);
    }
    .btn.primary:hover{box-shadow: 0 4px 6px rgba(14,180,210,.3); opacity:.95}

    /* Page container */
    .wrap{
      max-width:var(--content-width); margin:24px auto 36px; padding:0 24px;
    }

    /* Two-column layout with aligned heights */
    .grid{
      display:grid; grid-template-columns:minmax(240px, 300px) 1fr; gap:24px;
    }
    @media (max-width:900px){ .grid{grid-template-columns:1fr} }

    /* Improved Sidebar */
    .side{
      background:#fff; border:1px solid var(--border); border-radius:var(--radius);
      padding:16px; position:sticky; top:calc(var(--total-header-h) + 16px);
      height:fit-content; box-shadow:var(--shadow);
    }
    .side h4{
      margin:4px 0 12px 8px; font-size:13px; color:#0b7b90; letter-spacing:.4px;
      text-transform:uppercase; font-weight:700;
    }
    .nav{
      display:flex; flex-direction:column; gap:6px; margin-top:8px;
    }
    .nav a{
      padding:12px 14px; border-radius:8px; border:1px solid transparent;
      color:var(--text); text-decoration:none; font-weight:500; display:flex; align-items:center; gap:10px;
      transition:all .15s ease; font-size:15px;
    }
    .nav a:hover{background:#f0f9ff; border-color:#e0f2fe}
    .nav a.active{
      background:#e6f9fd; border-color:#b8ecf7; color:#06637b;
      font-weight:600;
    }
    .nav a::before{
      content:''; display:block; width:6px; height:6px; 
      background:var(--brand); border-radius:50%; opacity:0;
      transition:opacity .15s;
    }
    .nav a.active::before{opacity:1}

    /* Improved Content card */
    .card{
      background:#fff; border:1px solid var(--border); border-radius:var(--radius);
      box-shadow:var(--shadow-lg); overflow:hidden;
    }
    .sec{
      padding:24px 28px; border-bottom:1px solid var(--border);
      scroll-margin-top: calc(var(--total-header-h) + 16px);
    }
    .sec:last-child{border-bottom:none}

    /* Improved Typography */
    h2{
      margin:0 0 16px; font-size:24px; letter-spacing:-0.2px;
      color:#0f172a; font-weight:700;
    }
    h3{
      margin:0 0 14px; font-size:20px; letter-spacing:-0.1px;
      color:#0f172a; font-weight:600;
    }
    p{margin:8px 0 16px; color:var(--text); font-size:15px}
    ul,ol{margin:12px 0 0 24px; padding-left:4px}
    li{margin:8px 0; color:var(--text); font-size:15px; line-height:1.6}
    code{
      background:#f1f5f9; border:1px solid #e2e8f0; padding:2px 6px; 
      border-radius:6px; font-family:monospace; font-size:14px;
    }

    /* Improved Notes */
    .note{
      background:#f0f9ff; border-left:4px solid var(--brand); padding:14px 16px; 
      border-radius:8px; margin:16px 0; font-size:14px;
    }
    .warn{
      background:#fff7ed; border-left:4px solid #f97316; padding:14px 16px; 
      border-radius:8px; margin:16px 0; font-size:14px;
    }

    /* Tiny helpers */
    .row{display:flex; align-items:center; gap:12px; flex-wrap:wrap}

    /* Smooth scrolling */
    html {
      scroll-behavior: smooth;
    }

    /* Better focus states */
    a:focus-visible, button:focus-visible {
      outline: 2px solid var(--brand);
      outline-offset: 2px;
    }

    /* Print styles */
    @media print {
      .topbar, .subbar, .side { display: none; }
      body { background: white; padding-top: 0; }
      .card { box-shadow: none; border: none; }
      .wrap { margin: 0; padding: 0; }
      .grid { grid-template-columns: 1fr; }
    }
  </style>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

  <!-- Top bar (Now Fixed) -->
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

  <!-- Subbar (Now Fixed) -->
  <div class="subbar">
    <div class="subbar-inner">
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Dashboard</a>
      <div class="row">
        <button class="btn primary" onclick="window.print()">🖨️ Print Guide</button>
      </div>
    </div>
  </div>

  <!-- Page -->
  <div class="wrap grid">
    <!-- Improved Sidebar -->
    <aside class="side">
      <h4>Navigation</h4>
      <nav class="nav" id="toc">
        <a href="#start">Getting Started</a>
        <a href="#customers">Customers</a>
        <a href="#items">Items</a>
        <a href="#billing">Billing (POS)</a>
        <a href="#search">Search &amp; Filters</a>
        <a href="#trouble">Troubleshooting</a>
        <a href="#shortcuts">Useful Links</a>
      </nav>
    </aside>

    <!-- Improved Content -->
    <main class="card" id="content">
      <section id="start" class="sec">
        <h2>Getting Started</h2>
        <p>Welcome to the Pahana Edu Help Center. Here's how to begin:</p>
        <ul>
          <li>Log in with your <strong>Staff</strong> account credentials</li>
          <li>Use the dashboard shortcuts for quick access to key features:
            <ul>
              <li><em>Register Customer</em> - Add new customers</li>
              <li><em>View Customers</em> - Manage existing customers</li>
              <li><em>View Items</em> - Browse product inventory</li>
              <li><em>Calculate Bill</em> - Point of Sale system</li>
            </ul>
          </li>
          <li>Always use the top-right <em>Logout</em> link to securely sign out</li>
        </ul>
      </section>

      <section id="customers" class="sec">
        <h3>Customer Management</h3>
        <p>Add, view, edit, or delete customer records:</p>
        <ol>
          <li><strong>Add New Customer</strong>: 
            <ul>
              <li>Navigate to <code>/customers?action=new</code></li>
              <li>Fill in all required details</li>
              <li>Click <em>Save</em> to create the record</li>
            </ul>
            <div class="note">Account Numbers are auto-generated in the format <code>PE-ACC-10001</code></div>
          </li>
          
          <li><strong>View Customers</strong>: 
            <ul>
              <li>Open <code>/customers</code> to see the complete list</li>
              <li>Use the search function to find specific customers</li>
            </ul>
          </li>
          
          <li><strong>Edit Customer</strong>: 
            <ul>
              <li>Click <em>Edit</em> on any customer record</li>
              <li>Update the necessary fields</li>
              <li>Click <em>Save</em> to apply changes</li>
            </ul>
          </li>
          
          <li><strong>Delete Customer</strong>: 
            <ul>
              <li>Click <em>Delete</em> on the customer record</li>
              <li>Confirm the deletion in the dialog</li>
            </ul>
            <div class="warn">Customer deletion is blocked if they have associated bills to maintain data integrity</div>
          </li>
        </ol>
      </section>

      <section id="items" class="sec">
        <h3>Inventory Management</h3>
        <p>Manage your product inventory:</p>
        <ol>
          <li><strong>Add New Item</strong>:
            <ul>
              <li>Go to <code>/items?action=new</code></li>
              <li>Complete all fields: Name, Price, Quantity, Category, Description</li>
              <li>Upload an image if available</li>
              <li>Click <em>Save</em> to add to inventory</li>
            </ul>
            <div class="note">
              <strong>Image Guidelines:</strong>
              <ul>
                <li>Allowed formats: .png, .jpg, .jpeg, .webp</li>
                <li>Maximum file size: 5MB</li>
                <li>Images are stored at <code>/images/items/...</code></li>
              </ul>
            </div>
          </li>
          
          <li><strong>View/Filter Items</strong>:
            <ul>
              <li>Access <code>/items</code> for the complete inventory</li>
              <li>Use filters by ID, Name, or Category</li>
              <li>Search functionality available for quick access</li>
            </ul>
          </li>
          
          <li><strong>Edit Item</strong>:
            <ul>
              <li>Click <em>Edit</em> on any item</li>
              <li>Modify the necessary fields</li>
              <li>Upload a new image or keep the existing one</li>
              <li>Click <em>Save</em> to update</li>
            </ul>
          </li>
          
          <li><strong>Delete Item</strong>:
            <ul>
              <li>Click <em>Delete</em> on the item</li>
              <li>Confirm deletion in the dialog</li>
            </ul>
          </li>
        </ol>
      </section>

      <section id="billing" class="sec">
        <h3>Point of Sale System</h3>
        <p>Create bills and print receipts for customers:</p>
        <ol>
          <li><strong>Access POS</strong>:
            <ul>
              <li>Open <code>/billing</code> in your browser</li>
            </ul>
          </li>
          
          <li><strong>Add Items to Cart</strong>:
            <ul>
              <li>Browse the product catalog on the left</li>
              <li>Click items to add them to the cart</li>
              <li>Adjust quantities using:
                <ul>
                  <li><em>+</em>/<em>-</em> buttons</li>
                  <li>Direct numeric input</li>
                </ul>
              </li>
            </ul>
          </li>
          
          <li><strong>Apply Discounts</strong>:
            <ul>
              <li>Enter percentage value (e.g., <code>5</code>)</li>
              <li>Click <em>Apply Discount</em></li>
            </ul>
          </li>
          
          <li><strong>Attach Customer</strong>:
            <ul>
              <li>Search by Customer ID, Account No, or Phone</li>
              <li>Click <em>Apply</em> to link to the bill</li>
            </ul>
          </li>
          
          <li><strong>Complete Checkout</strong>:
            <ul>
              <li>Click <em>Save</em> to generate the bill</li>
              <li>System redirects to receipt page</li>
              <li>Use <em>Print Bill</em> for a hard copy</li>
            </ul>
          </li>
        </ol>
        <div class="note">
          <strong>Note:</strong> Checkout is disabled when the cart is empty. All item images are served from <code>/images/items/</code> directory.
        </div>
      </section>

      <section id="search" class="sec">
        <h3>Search &amp; Filter Functions</h3>
        <p>Efficiently locate records with these tools:</p>
        <ul>
          <li><strong>Customer Search</strong>:
            <ul>
              <li>Available on the Customers page</li>
              <li>Search by: ID, Name, Phone, Account Number</li>
            </ul>
          </li>
          
          <li><strong>Item Search</strong>:
            <ul>
              <li>Available on the Items page</li>
              <li>Search by: ID, Name, Category</li>
            </ul>
          </li>
          
          <li><strong>Billing Catalog</strong>:
            <ul>
              <li>Combined keyword and category filtering</li>
              <li>Real-time search results</li>
            </ul>
          </li>
        </ul>
      </section>

      <section id="trouble" class="sec">
        <h3>Troubleshooting Guide</h3>
        <p>Solutions for common issues:</p>
        <ul>
          <li><strong>Login Problems</strong>:
            <ul>
              <li>Clear browser cookies and cache</li>
              <li>Ensure correct credentials</li>
            </ul>
          </li>
          
          <li><strong>Number Formatting</strong>:
            <ul>
              <li>Use dot for decimals (e.g., <code>1200.50</code>)</li>
              <li>No commas or other separators</li>
            </ul>
          </li>
          
          <li><strong>Image Loading</strong>:
            <ul>
              <li>Verify database paths start with <code>/images/items/</code></li>
              <li>Check file permissions</li>
              <li>Confirm image files exist in the directory</li>
            </ul>
          </li>
        </ul>
      </section>

      <section id="shortcuts" class="sec">
        <h3>Quick Access Links</h3>
        <p>Direct links to key sections:</p>
        <ul>
          <li><a href="${pageContext.request.contextPath}/customers">/customers</a> - Customer management portal</li>
          <li><a href="${pageContext.request.contextPath}/items">/items</a> - Inventory control center</li>
          <li><a href="${pageContext.request.contextPath}/billing">/billing</a> - Point of Sale system</li>
          <li><a href="${pageContext.request.contextPath}/dashboard">/dashboard</a> - Main control panel</li>
        </ul>
      </section>
    </main>
  </div>

  <script>
    // Scroll to topic if provided by server
    (function(){
      var t = '<%= request.getAttribute("topic")==null? "" : request.getAttribute("topic") %>';
      if(t){ 
        var el = document.getElementById(t); 
        if(el){ 
          setTimeout(function(){
            el.scrollIntoView({behavior:'smooth'});
          }, 100);
        } 
      }
    })();

    // Enhanced scrollspy for the sidebar
    (function(){
      const sections = Array.from(document.querySelectorAll('.sec'));
      const links = Array.from(document.querySelectorAll('#toc a'));
      const byId = id => links.find(a => a.getAttribute('href') === '#' + id);

      const observer = new IntersectionObserver((entries)=>{
        entries.forEach(entry=>{
          if(entry.isIntersecting && entry.intersectionRatio > 0.2){
            links.forEach(a=>a.classList.remove('active'));
            const a = byId(entry.target.id);
            if(a) {
              a.classList.add('active');
              // Update URL without page jump
              history.replaceState(null, null, '#'+entry.target.id);
            }
          }
        });
      }, { 
        rootMargin: '-20% 0px -65% 0px', 
        threshold: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1] 
      });

      sections.forEach(s=>observer.observe(s));
      
      // Handle direct anchor links
      window.addEventListener('load', function() {
        if(window.location.hash) {
          const target = document.getElementById(window.location.hash.substring(1));
          if(target) {
            setTimeout(function(){
              target.scrollIntoView({behavior:'smooth'});
            }, 100);
          }
        }
      });
    })();
  </script>
</body>
</html>