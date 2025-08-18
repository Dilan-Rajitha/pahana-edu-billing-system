<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sales Reports</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    :root{
      --brand:#0EB4D2; --brand-dark:#0aa1bb;
      --bg:#f3f6f9; --panel:#ffffff; --panel-2:#f8fafc;
      --text:#0f172a; --muted:#5b6b7a; --border:#e5eaf0;
      --shadow:0 1px 2px rgba(0,0,0,.06), 0 1px 1px rgba(0,0,0,.04);
      --shadow-lg:0 16px 32px rgba(2,6,23,.10);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,Arial;background:var(--bg);color:var(--text)}

    /* Top bar */
    .topbar{
      background:var(--brand); color:#fff; display:flex; align-items:center; justify-content:space-between;
      padding:10px 18px; box-shadow:inset 0 -3px rgba(0,0,0,.08); position:sticky; top:0; z-index:50;
    }
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:40px; width:auto; display:block}

    .right{display:flex; align-items:center; gap:10px}
    .welcome{background:rgba(255,255,255,.18); border:1px solid rgba(255,255,255,.28); padding:8px 12px; border-radius:999px; font-weight:600}
    .logout{background:#ff6b6b; border:1px solid #ff9a9a; color:#fff; padding:8px 12px; border-radius:10px; text-decoration:none; font-weight:800}
    .logout:hover{filter:brightness(.96)}

    /* Sub bar (Back + Filters) */
    .subbar{
      background:#ffffffcc; backdrop-filter:saturate(1.1) blur(6px);
      border-bottom:1px solid var(--border); position:sticky; top:58px; z-index:40;
    }
    .subbar-inner{
      max-width:1280px; margin:0 auto; padding:10px 18px;
      display:flex; gap:12px; align-items:center; flex-wrap:wrap;
    }
    .btn{
      padding:10px 14px; border-radius:12px; border:1px solid var(--border); background:#fff; cursor:pointer;
      font-weight:700; text-decoration:none; color:var(--text); display:inline-flex; align-items:center; gap:6px; transition:.18s;
    }
    .btn:hover{box-shadow:var(--shadow)}
    .btn.primary{background:var(--brand); color:#fff; border:none}
    .btn.primary:hover{background:var(--brand-dark)}
    select,input[type="text"],input[type="date"]{
      padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#fff; outline:none;
    }
    select:focus,input:focus{box-shadow:0 0 0 3px rgba(14,180,210,.15)}

    /* Page wrap */
    .wrap{max-width:1280px; margin:18px auto; padding:0 18px}

    /* Summary cards */
    .cards{display:grid; grid-template-columns:repeat(4, minmax(0,1fr)); gap:16px; margin:18px 0}
    @media (max-width:1100px){ .cards{grid-template-columns:repeat(2,1fr)} }
    @media (max-width:640px){ .cards{grid-template-columns:1fr} }
    .card{
      background:var(--panel);
      border:1px solid var(--border);
      border-radius:16px;
      box-shadow:var(--shadow);
      padding:16px 18px;
    }
    .summary{
      background:linear-gradient(135deg, rgba(14,180,210,.12), rgba(14,180,210,.05));
      border:1px solid #cdeef5;
    }
    .summary h4{margin:0 0 8px; font-size:14px; color:#0b7b90; font-weight:800}
    .summary .val{font-size:26px; font-weight:900}

    /* Table */
    .table-card{padding:0}
    .table-head{padding:14px 18px; border-bottom:1px solid var(--border); background:var(--panel-2); font-weight:900}
    .table-wrap{overflow:auto; max-height: calc(70vh - 160px)}
    table{width:100%; border-collapse:collapse}
    th,td{padding:12px 14px; border-bottom:1px solid var(--border); text-align:center}
    thead th{background:#f8fafc; font-weight:800; color:#475569}
    tbody tr:nth-child(even){background:#fbfdff}
    tbody tr:hover{background:#f3fbfe}
    .chip{background:#e3f2fd; padding:3px 8px; border-radius:8px; display:inline-block; font-weight:700}
    .no-data{padding:30px; text-align:center; color:#6b7280}

    /* Charts ROW (2 columns) */
    .charts{
      display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-top:16px;
    }
    @media (max-width: 980px){
      .charts{ grid-template-columns:1fr; }
    }
    .chart-card{padding:0}
    .chart-card .title{padding:14px 18px; font-weight:900; border-bottom:1px solid var(--border); background:var(--panel-2)}
    .chart-wrap{position:relative; height:380px; padding:12px 16px}
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

  <!-- Sub bar (Back + Filters) -->
  <div class="subbar">
    <div class="subbar-inner">
      <a class="btn" href="${pageContext.request.contextPath}/dashboard">⬅ Back to Admin Dashboard</a>

      <form method="get" action="${pageContext.request.contextPath}/reports" id="filterForm" style="display:flex; gap:10px; align-items:center; flex-wrap:wrap">
        <label for="dateRange" style="font-weight:800">📅 Date Range:</label>
        <select name="dateRange" id="dateRange">
          <option value="today"  <c:if test="${param.dateRange == 'today'}">selected</c:if>>Today</option>
          <option value="last7"  <c:if test="${param.dateRange == 'last7'}">selected</c:if>>Last 7 Days</option>
          <option value="last30" <c:if test="${param.dateRange == 'last30'}">selected</c:if>>Last 30 Days</option>
          <option value="allTime" <c:if test="${param.dateRange == 'allTime'}">selected</c:if>>All Time</option>
        </select>
        <button type="submit" class="btn primary">🔍 Generate Report</button>
        <a class="btn" href="${pageContext.request.contextPath}/reports?dateRange=today">Reset</a>
      </form>
    </div>
  </div>

  <div class="wrap">

    <!-- Summary cards -->
    <div class="cards">
      <div class="card summary">
        <h4>Total Sales</h4>
        <div class="val" id="totalSales">Rs. 0.00</div>
      </div>
      <div class="card summary">
        <h4>Number of Bills</h4>
        <div class="val" id="totalBills">0</div>
      </div>
      <div class="card summary">
        <h4>Average Sale</h4>
        <div class="val" id="averageSale">Rs. 0.00</div>
      </div>
      <div class="card summary">
        <h4>Total Discount</h4>
        <div class="val" id="totalDiscount">Rs. 0.00</div>
      </div>
    </div>

    <!-- Table -->
    <div class="card table-card">
      <div class="table-head">📋 Detailed Sales Report</div>
      <div class="table-wrap">
        <table id="reportTable">
          <thead>
            <tr>
              <th>Bill ID</th>
              <th>Customer ID</th>
              <th>Staff User</th>
              <th>Subtotal</th>
              <th>Discount (%)</th>
              <th>Discount Amount</th>
              <th>Total</th>
              <th>Created At</th>
            </tr>
          </thead>
          <tbody id="reportTableBody"></tbody>
        </table>
      </div>
    </div>

    <!-- CHARTS: side-by-side -->
    <div class="charts">
      <div class="card chart-card">
        <div class="title">📈 Daily Sales Trends</div>
        <div class="chart-wrap"><canvas id="lineChart"></canvas></div>
      </div>
      <div class="card chart-card">
        <div class="title">👥 Sales by Staff Member</div>
        <div class="chart-wrap"><canvas id="barChart"></canvas></div>
      </div>
    </div>

    <!-- Export -->
    <div style="margin-top:16px; display:flex; gap:10px">
      <form method="post" action="${pageContext.request.contextPath}/reports/export" style="margin-top:16px;">
  <input type="hidden" name="dateRange" value="<c:out value='${param.dateRange}'/>">
  <button type="submit" class="btn primary">📄 Export as PDF</button>
</form>

    </div>

  </div>

  <script>
    // JSON from backend
    var jsonDataFromJSP = '<c:out value="${jsonReportData}" escapeXml="false" />';
    var reportData = [];
    try{
      if(jsonDataFromJSP && jsonDataFromJSP.trim() !== '' && jsonDataFromJSP !== 'null'){
        reportData = JSON.parse(jsonDataFromJSP);
      }
    }catch(e){
      console.error('JSON parse error:', e, jsonDataFromJSP);
      reportData = [];
    }

    function formatCurrency(amount){
      var num = parseFloat(amount || 0);
      return 'Rs. ' + num.toLocaleString('en-US',{minimumFractionDigits:2, maximumFractionDigits:2});
    }
    function calcDiscount(subtotal, percent){
      return (parseFloat(subtotal||0) * parseFloat(percent||0))/100;
    }
    function formatDate(d){ return d || 'N/A'; }

    function updateSummaryCards(data){
      if(!data || data.length===0){
        document.getElementById('totalSales').textContent = 'Rs. 0.00';
        document.getElementById('totalBills').textContent = '0';
        document.getElementById('averageSale').textContent = 'Rs. 0.00';
        document.getElementById('totalDiscount').textContent = 'Rs. 0.00';
        return;
      }
      var total=0, disc=0;
      data.forEach(function(b){
        total += parseFloat(b.total||0);
        disc  += calcDiscount(b.subtotal||0, b.discountPercent||0);
      });
      var avg = total/data.length;
      document.getElementById('totalSales').textContent   = formatCurrency(total);
      document.getElementById('totalBills').textContent   = String(data.length);
      document.getElementById('averageSale').textContent  = formatCurrency(avg);
      document.getElementById('totalDiscount').textContent= formatCurrency(disc);
    }

    function populateTable(data){
      var tb = document.getElementById('reportTableBody');
      tb.innerHTML = '';
      if(!data || data.length===0){
        var tr=document.createElement('tr');
        tr.innerHTML='<td colspan="8" class="no-data">No sales data found for the selected date range</td>';
        tb.appendChild(tr);
        return;
      }
      data.forEach(function(b){
        var dAmt = calcDiscount(b.subtotal, b.discountPercent);
        var tr=document.createElement('tr');
        tr.innerHTML =
          '<td><strong>#'+(b.id||'N/A')+'</strong></td>'+
          '<td>'+(b.customerId||'Walk-in')+'</td>'+
          '<td><span class="chip">'+(b.staffUser||'N/A')+'</span></td>'+
          '<td>'+formatCurrency(b.subtotal)+'</td>'+
          '<td>'+parseFloat(b.discountPercent||0).toFixed(1)+'%</td>'+
          '<td>'+formatCurrency(dAmt)+'</td>'+
          '<td><strong style="color:#0a7a60">'+formatCurrency(b.total)+'</strong></td>'+
          '<td>'+formatDate(b.createdAt)+'</td>';
        tb.appendChild(tr);
      });
    }

    function createCharts(data){
      var lineEl = document.getElementById('lineChart');
      var barEl  = document.getElementById('barChart');

      if(!data || data.length===0){
        lineEl.parentElement.innerHTML = '<div class="no-data">No data available for charts</div>';
        barEl.parentElement.innerHTML  = '<div class="no-data">No data available for charts</div>';
        return;
      }
      var daily={}, staff={};
      data.forEach(function(b){
        var dateStr = (b.createdAt||'').split(',')[0] || 'Unknown';
        daily[dateStr] = (daily[dateStr]||0) + parseFloat(b.total||0);
        var s = b.staffUser || 'Unknown';
        staff[s] = (staff[s]||0) + parseFloat(b.total||0);
      });

      // Daily line
      var dates = Object.keys(daily).sort();
      var sales = dates.map(d=>daily[d]);

      new Chart(lineEl, {
        type:'line',
        data:{ labels:dates,
          datasets:[{
            label:'Daily Sales (Rs.)',
            data:sales,
            borderColor:'#0EB4D2',
            backgroundColor:'rgba(14,180,210,.12)',
            pointBackgroundColor:'#0EB4D2',
            tension:.35, pointRadius:5
          }]
        },
        options:{
          responsive:true, maintainAspectRatio:false,
          plugins:{ legend:{ position:'top' } },
          scales:{ y:{ beginAtZero:true, ticks:{ callback:(v)=>'Rs. '+v.toLocaleString() } } }
        }
      });

      // Staff bar
      var staffNames = Object.keys(staff);
      var staffVals  = staffNames.map(n=>staff[n]);

      new Chart(barEl, {
        type:'bar',
        data:{ labels:staffNames,
          datasets:[{
            label:'Sales Amount (Rs.)',
            data:staffVals,
            backgroundColor: staffNames.map(()=> 'rgba(14,180,210,.6)'),
            borderColor: staffNames.map(()=> '#0EB4D2'),
            borderWidth:1
          }]
        },
        options:{
          responsive:true, maintainAspectRatio:false,
          plugins:{ legend:{ display:false } },
          scales:{ y:{ beginAtZero:true, ticks:{ callback:(v)=>'Rs. '+v.toLocaleString() } } }
        }
      });
    }

    window.addEventListener('load', function(){
      updateSummaryCards(reportData);
      populateTable(reportData);
      createCharts(reportData);
    });
  </script>
</body>
</html>
