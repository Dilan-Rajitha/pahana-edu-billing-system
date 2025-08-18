<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login - PahanaEdu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    :root {
      --brand: #0097b2;
      --brand-dark: #007a91;
      --brand-light: #e6f7fb;
      --ink: #0f172a;
      --muted: #64748b;
      --ring: #bff0f8;
      --bg: #f6fbfd;
      --success: #10b981;
      --error: #ef4444;
    }
    
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    
    body {
      min-height: 100vh;
      font-family: 'Segoe UI', 'Roboto', -apple-system, BlinkMacSystemFont, sans-serif;
      color: var(--ink);
      background: linear-gradient(135deg, #f8fafc 0%, var(--bg) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      line-height: 1.5;
      position: relative;
      overflow: hidden;
    }

    /* Animated background elements */
    body::before,
    body::after {
      content: '';
      position: absolute;
      border-radius: 50%;
      background: rgba(0, 151, 178, 0.05);
      z-index: -1;
      animation: float 15s infinite linear;
    }
    
    body::before {
      width: 300px;
      height: 300px;
      top: -50px;
      left: -50px;
      animation-delay: 0s;
    }
    
    body::after {
      width: 200px;
      height: 200px;
      bottom: -30px;
      right: -30px;
      animation-delay: 5s;
    }
    
    @keyframes float {
      0% { transform: translate(0, 0) rotate(0deg); }
      25% { transform: translate(50px, 50px) rotate(90deg); }
      50% { transform: translate(0, 100px) rotate(180deg); }
      75% { transform: translate(-50px, 50px) rotate(270deg); }
      100% { transform: translate(0, 0) rotate(360deg); }
    }

    /* Shell container */
    .shell {
      width: min(1000px, 96vw);
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 24px;
      box-shadow: 0 20px 50px rgba(2, 132, 199, .08);
      overflow: hidden;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: 600px;
    }

    /* Left: Brand panel */
    .brand-pane {
      background: linear-gradient(135deg, var(--brand), var(--brand-dark));
      padding: 40px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      position: relative;
      overflow: hidden;
    }
    
    .brand-pane::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 100%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      transform: rotate(30deg);
      animation: shine 8s infinite;
    }
    
    @keyframes shine {
      0% { opacity: 0.3; }
      50% { opacity: 0.1; }
      100% { opacity: 0.3; }
    }
    
    .logo-wrap {
      position: relative;
      z-index: 2;
      padding: 20px;
      backdrop-filter: blur(5px);
      margin-bottom: 30px;
    }
    
    .logo-wrap img {
      width: 350px;
      height: auto;
      display: block;
    }
    
    

    /* Right: Form panel */
    .form-pane {
      padding: 60px 50px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .card {
      width: 100%;
      max-width: 400px;
    }
    
    .card-header {
      margin-bottom: 30px;
      text-align: center;
    }
    
    .card h1 {
      font-size: 28px;
      margin-bottom: 8px;
      font-weight: 800;
      color: var(--ink);
    }
    
    .card p {
      color: var(--muted);
      font-weight: 500;
    }
    
    /* Messages */
    .msg {
      margin: 16px 0;
      padding: 14px 16px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    
    .msg i {
      font-size: 18px;
    }
    
    .msg.error {
      background: #fef2f2;
      color: var(--error);
      border-left: 4px solid var(--error);
    }
    
    .msg.info {
      background: #eff6ff;
      color: #1e40af;
      border-left: 4px solid #1e40af;
    }

    /* Form elements */
    .field {
      margin: 20px 0;
      position: relative;
    }
    
    .label {
      display: block;
      font-weight: 600;
      margin-bottom: 8px;
      color: var(--ink);
    }
    
    .input {
      width: 100%;
      padding: 16px 18px;
      border-radius: 12px;
      font-size: 15px;
      border: 2px solid #e5e7eb;
      background: #fafafa;
      outline: none;
      transition: all 0.2s;
      font-family: inherit;
    }
    
    .input:focus {
      background: #fff;
      border-color: var(--brand);
      box-shadow: 0 0 0 4px rgba(0, 151, 178, 0.15);
    }
    
    .input-icon {
      position: absolute;
      right: 16px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      cursor: pointer;
      pointer-events: auto; /* Add this to ensure click events work */
    }
    
    /* Add this new class for input container */
    .input-container {
      position: relative;
    }
    
    /* Adjust padding for inputs with icons */
    .input-with-icon {
      padding-right: 45px !important; /* Make space for the icon */
    }
    
    .actions {
      margin-top: 28px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
    }
    
    .btn {
      padding: 16px 24px;
      border-radius: 12px;
      border: none;
      cursor: pointer;
      color: #fff;
      font-weight: 700;
      font-size: 15px;
      background: linear-gradient(135deg, var(--brand) 0%, var(--brand-dark) 100%);
      box-shadow: 0 4px 12px rgba(0, 151, 178, 0.25);
      transition: all 0.2s;
      font-family: inherit;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      width: 100%;
    }
    
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(0, 151, 178, 0.3);
    }
    
    .btn:active {
      transform: translateY(0);
    }
    
    .link {
      color: var(--brand-dark);
      font-weight: 600;
      text-decoration: none;
      font-size: 14px;
      transition: color 0.2s;
    }
    
    .link:hover {
      color: var(--brand);
      text-decoration: underline;
    }
    
    .foot {
      margin-top: 32px;
      color: #94a3b8;
      text-align: center;
      font-size: 13px;
      padding-top: 16px;
      border-top: 1px solid #e5e7eb;
    }

    /* Responsive */
    @media (max-width: 900px) {
      .shell {
        grid-template-columns: 1fr;
      }
      
      .brand-pane {
        display: none;
      }
      
      .form-pane {
        padding: 40px 30px;
      }
    }
    
    @media (max-width: 480px) {
      .form-pane {
        padding: 30px 20px;
      }
      
      .actions {
        flex-direction: column;
        gap: 15px;
      }
      
      .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>

  <div class="shell">
    <!-- LEFT: Brand panel -->
    <aside class="brand-pane">
      <div class="logo-wrap">
        <img src="${pageContext.request.contextPath}/images/Logo01.png" alt="PahanaEdu Logo">
      </div>
      
      
    </aside>

    <!-- RIGHT: Login form -->
    <section class="form-pane">
      <div class="card">
        <div class="card-header">
          <h1>Welcome back</h1>
          <p>Please login to your account</p>
        </div>

        <c:if test="${not empty error}">
          <div class="msg error">
            <i class="fas fa-exclamation-circle"></i>
            ${error}
          </div>
        </c:if>
        
        <c:if test="${not empty info}">
          <div class="msg info">
            <i class="fas fa-info-circle"></i>
            ${info}
          </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="on">
          <div class="field">
            <label class="label" for="username">Username</label>
            <div class="input-container">
              <input id="username" class="input input-with-icon" name="username" placeholder="Enter your username"
                     value="${username}" required autocomplete="username">
              <i class="fas fa-user input-icon" style="pointer-events: none;"></i>
            </div>
          </div>

          <div class="field">
            <label class="label" for="password">Password</label>
            <div class="input-container">
              <input id="password" class="input input-with-icon" type="password" name="password"
                     placeholder="Enter your password" required autocomplete="current-password">
              <i class="fas fa-eye input-icon" id="togglePassword" onclick="togglePasswordVisibility()"></i>
            </div>
          </div>

          <div class="actions">
            <div class="remember-me">
              <input type="checkbox" id="remember" name="remember">
              <label for="remember" style="font-size: 14px; color: var(--muted);">Remember me</label>
            </div>
            <a class="link" href="#" onclick="alert('Password reset functionality coming soon');return false;">
              Forgot password?
            </a>
          </div>

          <div class="field">
            <button class="btn" type="submit">
              <i class="fas fa-sign-in-alt"></i>
              Sign In
            </button>
          </div>
        </form>

        <div class="foot">
          © 2025 PahanaEdu. All rights reserved.
        </div>
      </div>
    </section>
  </div>

  <script>
    function togglePasswordVisibility() {
      const passwordInput = document.getElementById('password');
      const toggleIcon = document.getElementById('togglePassword');
      
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash');
      } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye');
      }
    }
  </script>
</body>
</html>