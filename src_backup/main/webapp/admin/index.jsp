<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard role-admin">
    <nav class="navbar">
        <span class="navbar-brand">DentFisto</span>
        <div class="navbar-info">
            <span>Welcome, ${sessionScope.user.login}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm">Logout</a>
        </div>
    </nav>
    <main class="content">
        <h2>Admin Dashboard</h2>
        <p>Worker management features will go here.</p>
        <!-- The UI team will build out this page -->
    </main>
</body>
</html>
