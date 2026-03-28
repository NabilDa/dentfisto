<%-- sidebar.jsp  —  include this at the top of every dentist page --%>
<%-- Usage: <%@ include file="sidebar.jsp" %> --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <img src="${pageContext.request.contextPath}/images/logo.png" class="sidebar-logo" alt="logo">
        <span>DentFisto</span>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dentist/dashboard"
           class="nav-item ${activePage == 'overview' ? 'active' : ''}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <span>Tableau de bord</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/planning"
           class="nav-item ${activePage == 'planning' ? 'active' : ''}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
            <span>Planning</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/appointments"
           class="nav-item ${activePage == 'appointments' ? 'active' : ''}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg>
            <span>Rendez-vous</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/patients"
           class="nav-item ${activePage == 'patients' ? 'active' : ''}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            <span>Patients</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/dossier"
           class="nav-item ${activePage == 'dossier' ? 'active' : ''}">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            <span>Dossiers médicaux</span>
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar">Dr</div>
            <div class="user-info">
                <span class="user-name">${sessionScope.dentistName != null ? sessionScope.dentistName : 'Dr. Martin'}</span>
                <span class="user-role">Dentiste</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Déconnexion">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        </a>
    </div>
</aside>

<main class="dashboard-main" id="dashMain">
    <header class="topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle" id="sidebarToggle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <span class="breadcrumb">${pageTitle}</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-date">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="13" height="13"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                <span id="currentDate"></span>
            </div>
        </div>
    </header>
    <div class="content-area">
<%-- Each page closes </div></main> itself --%>

<script>
document.getElementById('currentDate').textContent =
    new Date().toLocaleDateString('fr-FR',{weekday:'long',day:'numeric',month:'long',year:'numeric'});
document.getElementById('sidebarToggle').addEventListener('click',()=>{
    document.getElementById('sidebar').classList.toggle('collapsed');
    document.getElementById('dashMain').classList.toggle('sidebar-collapsed');
});
// page-entrance animation
document.body.style.opacity=0;
requestAnimationFrame(()=>{
    document.body.style.transition='opacity 0.35s ease';
    document.body.style.opacity=1;
});
</script>