<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Help & Support – Admin</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
      font-family: 'Inter', ui-sans-serif, system-ui, sans-serif;
      background:var(--bg); color:var(--text);
      line-height:1.6;
      padding-top:var(--total-header-h); /* Add space for fixed headers */
    }

    /* Top bar - Fixed */
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

    /* Buttons */
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

    /* Two-column layout */
    .grid{
      display:grid; grid-template-columns:minmax(240px, 300px) 1fr; gap:24px;
    }
    @media (max-width:900px){ .grid{grid-template-columns:1fr} }

    /* Sidebar - admin version */
    .side{
      background:#fff; border:1px solid var(--border); border-radius:var(--radius);
      padding:16px; position:sticky; top:calc(var(--total-header-h) + 16px);
      height:fit-content; box-shadow:var(--shadow);
    }
    .side-title{
      margin:4px 0 16px; font-size:15px; color:#0b7b90; 
      letter-spacing:.4px; font-weight:700; padding-left:6px;
    }
    .nav{
      display:flex; flex-direction:column; gap:6px;
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

    /* Content card - admin version */
    .card{
      background:#fff; border:1px solid var(--border); border-radius:var(--radius);
      box-shadow:var(--shadow-lg); overflow:hidden;
    }
    .sec{
      padding:24px 28px; border-bottom:1px solid var(--border);
      scroll-margin-top: calc(var(--total-header-h) + 16px);
    }
    .sec:last-child{border-bottom:none}

    /* Typography */
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

    /* Notes & Warnings */
    .note{
      background:#f0f9ff; border-left:4px solid var(--brand); padding:14px 16px; 
      border-radius:8px; margin:16px 0; font-size:14px;
    }
    .warn{
      background:#fff7ed; border-left:4px solid #f97316; padding:14px 16px; 
      border-radius:8px; margin:16px 0; font-size:14px;
    }
    .alert{
      background:#fef2f2; border-left:4px solid #ef4444; padding:14px 16px; 
      border-radius:8px; margin:16px 0; font-size:14px;
    }

    /* Admin-specific elements */
    .admin-badge{
      background:#4f46e5; color:white; padding:2px 8px; border-radius:4px;
      font-size:12px; font-weight:600; margin-left:6px;
    }
    .privilege-table{
      width:100%; border-collapse:collapse; margin:16px 0;
      font-size:14px;
    }
    .privilege-table th, .privilege-table td{
      padding:10px 12px; text-align:left; border:1px solid #e2e8f0;
    }
    .privilege-table th{background:#f1f5f9; font-weight:600}
    .privilege-table tr:nth-child(even){background:#f8fafc}

    /* Tiny helpers */
    .row{display:flex; align-items:center; gap:12px; flex-wrap:wrap}

    /* Smooth scrolling */
    html { scroll-behavior: smooth; }

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
</head>
<body>
 
  
  
  <div class="topbar">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/images/Logo01.png" alt="Logo">

    </div>
    <div class="top-right">
     <div class="welcome">
  Welcome, ${empty sessionScope.userName ? (empty sessionScope.user ? 'User' : sessionScope.user) : sessionScope.userName}
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
  

  <!-- Page Content -->
  <div class="wrap grid">
    <!-- Admin Sidebar -->
    <aside class="side">
      <div class="side-title">Admin Navigation</div>
      <nav class="nav" id="toc">
        <a href="#users">Manage Users <span class="admin-badge">ADMIN</span></a>
        <a href="#customers">Customers</a>
        <a href="#items">Items</a>
        <a href="#reports">Reports & Analytics</a>
        <a href="#logs">System Logs <span class="admin-badge">ADMIN</span></a>
        <a href="#security">Security Policies <span class="admin-badge">ADMIN</span></a>
        <a href="#links">Quick Links</a>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="card" id="content">
      <section id="users" class="sec">
        <h2>User Management <span class="admin-badge">ADMIN ONLY</span></h2>
        <p>Administrator functions for managing system users:</p>
        <ol>
          <li><strong>Add New User</strong>:
            <ul>
              <li>Navigate to <code>/admin/users?action=new</code></li>
              <li>Complete all fields: Username, Password, Role (ADMIN or STAFF)</li>
              <li>Click <em>Save</em> to create the account</li>
            </ul>
          </li>
          
          <li><strong>Edit User</strong>:
            <ul>
              <li>Access <code>/admin/users</code> for the user list</li>
              <li>Click <em>Edit</em> on any user record</li>
              <li>Update details as needed (including password reset)</li>
              <li>Click <em>Save</em> to apply changes</li>
            </ul>
          </li>
          
          <li><strong>Deactivate/Delete User</strong>:
            <ul>
              <li>Click <em>Delete</em> on the user record</li>
              <li>Confirm the action in the dialog</li>
            </ul>
          </li>
        </ol>
        
        <div class="alert">
          <strong>Security Alert:</strong> Always change default credentials after initial setup. 
          Admin accounts should have complex passwords changed regularly.
        </div>
        
        <h3>Role Privileges</h3>
        <table class="privilege-table">
          <thead>
            <tr>
              <th>Feature</th>
              <th>ADMIN</th>
              <th>STAFF</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>User Management</td>
              <td>✓ Full access</td>
              <td>✗ No access</td>
            </tr>
            <tr>
              <td>System Logs</td>
              <td>✓ Full access</td>
              <td>✗ No access</td>
            </tr>
            <tr>
              <td>Reports</td>
              <td>✓ Full access</td>
              <td>✓ View only</td>
            </tr>
            <tr>
              <td>Customer Management</td>
              <td>✓ Full access</td>
              <td>✓ Full access</td>
            </tr>
            <tr>
              <td>Item Management</td>
              <td>✓ Full access</td>
              <td>✓ Full access</td>
            </tr>
            <tr>
              <td>Billing</td>
              <td>✓ Full access</td>
              <td>✓ Full access</td>
            </tr>
          </tbody>
        </table>
      </section>

      <section id="customers" class="sec">
        <h3>Customer Management</h3>
        <p>Admin functions for customer records:</p>
        <ol>
          <li><strong>Add Customer</strong>:
            <ul>
              <li>Go to <code>/customers?action=new</code></li>
              <li>Complete all customer details</li>
              <li>Click <em>Save</em> (account number auto-generated as <code>PE-ACC-10001</code>)</li>
            </ul>
          </li>
          
          <li><strong>Edit Customer</strong>:
            <ul>
              <li>Access <code>/customers</code> for the customer list</li>
              <li>Click <em>Edit</em> on any record</li>
              <li>Update information as needed</li>
              <li>Click <em>Save</em> to update</li>
            </ul>
          </li>
          
          <li><strong>Delete Customer</strong>:
            <ul>
              <li>Click <em>Delete</em> on the customer record</li>
              <li>Confirm deletion in the dialog</li>
            </ul>
            <div class="note">
              <strong>Note:</strong> Customer deletion is blocked if they have associated bills 
              to maintain data integrity.
            </div>
          </li>
        </ol>
      </section>

      <section id="items" class="sec">
        <h3>Inventory Management</h3>
        <p>Admin functions for product inventory:</p>
        <ol>
          <li><strong>Add New Item</strong>:
            <ul>
              <li>Navigate to <code>/items?action=new</code></li>
              <li>Complete all fields: Name, Price, Quantity, Category, Description</li>
              <li>Upload an image if available</li>
              <li>Click <em>Save</em> to add to inventory</li>
            </ul>
          </li>
          
          <li><strong>Edit Existing Item</strong>:
            <ul>
              <li>Access <code>/items</code> for the inventory list</li>
              <li>Click <em>Edit</em> on any item</li>
              <li>Modify details as needed</li>
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
          
          <li><strong>Categories</strong>:
            <ul>
              <li>Fixed list: Textbooks, Stationery, Novels, Magazines, Others</li>
              <li>Category can be selected when adding/editing items</li>
            </ul>
          </li>
        </ol>
      </section>

      <section id="reports" class="sec">
        <h3>Reports & Analytics</h3>
        <p>Comprehensive reporting tools for business analysis:</p>
        <ol>
          <li><strong>Access Reports</strong>:
            <ul>
              <li>Navigate to <code>/reports</code></li>
              <li>Select a date range: Today, Last 7 Days, Last 30 Days, or All Time</li>
            </ul>
          </li>
          
          <li><strong>Report Components</strong>:
            <ul>
              <li><strong>Summary Cards</strong>: Key metrics at a glance</li>
              <li><strong>Detailed Table</strong>: Breakdown by subtotal, discount, and total</li>
              <li><strong>Line Chart</strong>: Daily sales trends</li>
              <li><strong>Bar Chart</strong>: Sales performance by staff member</li>
            </ul>
          </li>
          
          <li><strong>Export Options</strong>:
            <ul>
              <li>Click <em>Export as PDF</em> to download a printable report</li>
              <li>Use browser print function for additional formatting options</li>
            </ul>
          </li>
        </ol>
      </section>

      <section id="logs" class="sec">
        <h3>System Logs <span class="admin-badge">ADMIN ONLY</span></h3>
        <p>Audit trail of all system activities:</p>
        <ol>
          <li><strong>Access Logs</strong>:
            <ul>
              <li>Navigate to <code>/logs</code></li>
              <li>Use filters to narrow by User, Action Type, or Date Range</li>
            </ul>
          </li>
          
          <li><strong>Log Contents</strong>:
            <ul>
              <li>User login/logout events</li>
              <li>Customer record changes (create, update, delete)</li>
              <li>Inventory modifications</li>
              <li>Bill creation and updates</li>
              <li>System administrative actions</li>
            </ul>
          </li>
          
          <li><strong>Technical Notes</strong>:
            <ul>
              <li>Loopback IP normalization: <code>::1</code> converts to <code>127.0.0.1</code></li>
              <li>Timestamps in system timezone</li>
              <li>Logs are retained for 90 days</li>
            </ul>
          </li>
        </ol>
      </section>

      <section id="security" class="sec">
        <h3>Security Policies <span class="admin-badge">ADMIN ONLY</span></h3>
        <p>Critical security practices for system administrators:</p>
        <ul>
          <li><strong>Role-Based Access</strong>:
            <ul>
              <li>Enforce least-privilege principle</li>
              <li>STAFF accounts should never have ADMIN rights</li>
              <li>Regularly review user permissions</li>
            </ul>
          </li>
          
          <li><strong>Password Policies</strong>:
            <ul>
              <li>Require strong passwords (min 12 chars, mixed case, numbers, symbols)</li>
              <li>Implement regular password rotation (every 90 days)</li>
              <li>Never share admin credentials</li>
            </ul>
          </li>
          
          <li><strong>Data Protection</strong>:
            <ul>
              <li>Regular database backups (daily recommended)</li>
              <li>Backup <code>/images/items/</code> directory with database</li>
              <li>Store backups securely (encrypted, off-site)</li>
            </ul>
          </li>
          
          <li><strong>Monitoring</strong>:
            <ul>
              <li>Review system logs weekly</li>
              <li>Investigate unusual activity immediately</li>
              <li>Monitor for failed login attempts</li>
            </ul>
          </li>
        </ul>
        
        <div class="alert">
          <strong>Critical:</strong> Immediately revoke access for terminated employees 
          and change all shared credentials when staff changes occur.
        </div>
      </section>

      <section id="links" class="sec" style="border-bottom:none">
        <h3>Quick Links</h3>
        <p>Direct access to key administrative functions:</p>
        <ul>
          <li><a href="${pageContext.request.contextPath}/admin/users">/admin/users</a> – User management portal</li>
          <li><a href="${pageContext.request.contextPath}/customers">/customers</a> – Customer management</li>
          <li><a href="${pageContext.request.contextPath}/items">/items</a> – Inventory control</li>
          <li><a href="${pageContext.request.contextPath}/reports">/reports</a> – Business analytics</li>
          <li><a href="${pageContext.request.contextPath}/logs">/logs</a> – System audit trail</li>
          <li><a href="${pageContext.request.contextPath}/dashboard">/dashboard</a> – Admin control panel</li>
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
              target.scrollIntoView({behavior:'smart'});
            }, 100);
          }
        }
      });
    })();
  </script>
</body>
</html>