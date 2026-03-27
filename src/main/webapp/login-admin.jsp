<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page role">

    <!-- Navbar -->
<header class="navbar">
    <div class="logo">
    <img src="${pageContext.request.contextPath}/images/logo.png" class="logo-img">
    <span>DentFisto</span>
</div>
</header>

    <div class="login-container">

        <!-- LEFT: Hero panel -->
        <div class="login-hero">
            <img src="${pageContext.request.contextPath}/images/admin_link_img.png" alt="Clinic reception" class="hero-img">
            <div class="hero-overlay"></div>
            <div class="hero-tagline">
                <h2>Bonjour, Admin</h2>
                <p>Connectez-vous pour lancer votre gestion administrative.</p>
            </div>
        </div>

        <!-- RIGHT: Form panel -->
        <div class="login-form-panel">
            <div class="login-card">

                <div class="login-card-header">
                    <h1>Admin Sign In</h1>
                    <p class="login-subtitle">Please enter your credentials to access your dashboard.</p>
                </div>

                <c:if test="${param.error == 'invalid'}">
                    <div class="alert alert-error">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        Invalid username or password.
                    </div>
                </c:if>
                <c:if test="${param.error == 'missing'}">
                    <div class="alert alert-error">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        Please fill in all fields.
                    </div>
                </c:if>

                <form action="login" method="post" class="login-form">
                    <input type="hidden" name="role" value="ASSISTANTE">

                    <div class="form-group">
                        <label for="username">Email or Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                            </span>
                            <input type="text" id="username" name="username"
                                   placeholder="admin name"
                                   required autofocus>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input type="password" id="password" name="password"
                                   placeholder="••••••••••••"
                                   required>
                        </div>
                    </div>

                    <button type="submit" class="btn-login">
                        Login
                        <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/>
                        </svg>
                    </button>
                </form>

                <a href="index.jsp" class="back-link">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round">
                        <path d="M19 12H5M12 5l-7 7 7 7"/>
                    </svg>
                    Back to home
                </a>

            </div>
        </div>
    </div>

    <footer class="login-footer">
        <span>© 2026 <a href="#">DentFisto Systems</a>. All rights reserved.</span>
    </footer>

</body>
</html>