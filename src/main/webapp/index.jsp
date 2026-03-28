<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Welcome</title>
     <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">
    <img src="${pageContext.request.contextPath}/images/logo.png" class="logo-img">
    <span>DentFisto</span>
</div>
</header>

<!-- Hero Section -->
<section class="hero">
    <h1>
        Précision clinique,<span class="highlight"> simplement</span>.
    </h1>
    <p>
        Une plateforme moderne pour votre cabinet. Choisissez votre rôle pour démarrer.
    </p>
</section>

<!-- Cards Section -->
<section class="cards">

    <!-- Admin -->
    <div class="card">
            <a href="${pageContext.request.contextPath}/login-admin.jsp">
            <div class="card-bg"></div>
            <div class="overlay"></div>
            <div class="content">
            <h2>Admin</h2>
            <p>Check newly stats, manage users and system.</p>
            </div>
            </a>
    </div>

    <!-- Assistant -->
    <div  class="card">
        <a href="${pageContext.request.contextPath}/login-assistant.jsp">
            <div class="card-bg"></div>
            <div class="overlay"></div>
            <div class="content">
            <h2>Assistant</h2>
            <p>Coordinate patient flow, chairside schedules, and clinical preparation.</p>
            </div>
        </a>
    </div>

    <!-- Dentist -->
     
    <div class="card">
        <a href="${pageContext.request.contextPath}/login-dentist.jsp" >
            <div class="card-bg"></div>
            <div class="overlay"></div>
            <div class="content">
            <h2>Dentist</h2>
            <p>Clinical management, diagnostics, and treatment planning.</p>
            </div>
        </a>
    </div>

</section>

<footer class="footer">
    <p>©2026 Clicnic technology</p>
</footer>

</body>
</html>