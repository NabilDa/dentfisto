<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Admin Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page role-admin">
    <div class="login-container">
        <div class="login-card">
            <h1>Admin Login</h1>
            <p class="login-subtitle">System Administration</p>

            <c:if test="${param.error == 'invalid'}">
                <div class="alert alert-error">Invalid username or password.</div>
            </c:if>
            <c:if test="${param.error == 'missing'}">
                <div class="alert alert-error">Please fill in all fields.</div>
            </c:if>

            <form action="login" method="post">
                <input type="hidden" name="role" value="ADMIN">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-admin">Sign In</button>
            </form>
            <a href="index.jsp" class="back-link">&larr; Back to home</a>
        </div>
    </div>
</body>
</html>
