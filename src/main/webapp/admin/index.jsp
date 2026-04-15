<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Espace Administrateur</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-admin">

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand"><img src="${pageContext.request.contextPath}/images/logo.png" class="sidebar-logo" alt="logo"><span>DentFisto</span></div>
    <nav class="sidebar-nav">
        <a href="#overview" class="nav-item active" data-section="overview">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <p class="nav-item-name">Tableau de bord</p>
        </a>
        <a href="#dentists" class="nav-item" data-section="dentists">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <p class="nav-item-name">Dentistes</p>
        </a>
        <a href="#assistants" class="nav-item" data-section="assistants">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            <p class="nav-item-name">Assistantes</p>
        </a>
        <a href="#statistics" class="nav-item" data-section="statistics">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>
            <p class="nav-item-name">Statistiques</p>
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user"><div class="user-avatar">Ad</div><div class="user-info"><span class="user-name">${not empty sessionScope.user.login ? sessionScope.user.login : 'Admin'}</span><span class="user-role">Administrateur</span></div></div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Déconnexion"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></a>
    </div>
</aside>

<main class="dashboard-main">
    <header class="topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle" id="sidebarToggle"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg></button>
            <div class="breadcrumb"><span id="breadcrumbText">Tableau de bord</span></div>
        </div>
        <div class="topbar-right">
            <div class="topbar-date"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="14" height="14"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg><span id="currentDate"></span></div>
        </div>
    </header>

    <div class="content-area">

        <!-- ══════ OVERVIEW ══════ -->
        <section class="dash-section active" id="section-overview">
            <div class="section-hero"><div><h1 class="section-title">Administration<span class="wave">⚙️</span></h1><p class="section-sub">Gestion du cabinet dentaire.</p></div></div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <div class="kpi-card kpi-blue">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${totalPatients}</span><span class="kpi-label">Patients</span></div>
                </div>
                <div class="kpi-card kpi-green">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${totalRdv}</span><span class="kpi-label">Rendez-vous</span></div>
                </div>
                <div class="kpi-card kpi-amber">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/> MAD</span><span class="kpi-label">Chiffre d'affaires</span></div>
                </div>
                <div class="kpi-card kpi-red">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${totalConsultations}</span><span class="kpi-label">Consultations</span></div>
                </div>
            </div>

            <div class="overview-grid">
                <div class="dash-card">
                    <div class="card-header"><h3>Équipe médicale</h3><button class="btn-text" onclick="showSection('dentists')">Gérer →</button></div>
                    <div class="rv-list">
                        <c:forEach var="d" items="${dentistes}">
                            <div class="rv-item"><div class="rv-time" style="min-width:auto;">🦷</div><div class="rv-info"><span class="rv-patient">${d.login}</span><span class="rv-type">Dentiste</span></div><span class="rv-status status-confirmed">Actif</span></div>
                        </c:forEach>
                        <c:forEach var="a" items="${assistantes}">
                            <div class="rv-item"><div class="rv-time" style="min-width:auto;">👩‍⚕️</div><div class="rv-info"><span class="rv-patient">${a.login}</span><span class="rv-type">Assistante</span></div><span class="rv-status status-confirmed">Actif</span></div>
                        </c:forEach>
                    </div>
                </div>
                <div class="dash-card">
                    <div class="card-header"><h3>Accès rapide</h3></div>
                    <div class="quick-actions">
                        <button class="qa-btn" onclick="showSection('dentists')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>Gérer dentistes</button>
                        <button class="qa-btn" onclick="showSection('assistants')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>Gérer assistantes</button>
                        <button class="qa-btn" onclick="showSection('statistics')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>Statistiques</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══════ DENTISTS ══════ -->
        <section class="dash-section" id="section-dentists">
            <div class="section-hero"><div><h1 class="section-title">Dentistes</h1><p class="section-sub">Gérez les comptes des dentistes.</p></div>
                <button class="btn-primary" onclick="document.getElementById('addDentistModal').classList.add('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Ajouter</button>
            </div>
            <div class="dash-card">
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Login</th><th>Actions</th></tr></thead><tbody>
                    <c:forEach var="d" items="${dentistes}">
                        <tr><td>${d.id}</td><td class="td-bold">${d.login}</td><td class="td-actions">
                            <button class="btn-table btn-edit" onclick="openEditModal(${d.id}, '${d.login}', 'DENTISTE')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</button>
                            <a href="${pageContext.request.contextPath}/admin/users/delete?id=${d.id}" class="btn-table btn-cancel" onclick="return confirm('Supprimer ce dentiste ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Supprimer</a>
                        </td></tr>
                    </c:forEach>
                </tbody></table></div>
            </div>
        </section>

        <!-- ══════ ASSISTANTS ══════ -->
        <section class="dash-section" id="section-assistants">
            <div class="section-hero"><div><h1 class="section-title">Assistantes</h1><p class="section-sub">Gérez les comptes des assistantes.</p></div>
                <button class="btn-primary" onclick="document.getElementById('addAssistantModal').classList.add('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Ajouter</button>
            </div>
            <div class="dash-card">
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>ID</th><th>Login</th><th>Actions</th></tr></thead><tbody>
                    <c:forEach var="a" items="${assistantes}">
                        <tr><td>${a.id}</td><td class="td-bold">${a.login}</td><td class="td-actions">
                            <button class="btn-table btn-edit" onclick="openEditModal(${a.id}, '${a.login}', 'ASSISTANTE')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</button>
                            <a href="${pageContext.request.contextPath}/admin/users/delete?id=${a.id}" class="btn-table btn-cancel" onclick="return confirm('Supprimer cette assistante ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Supprimer</a>
                        </td></tr>
                    </c:forEach>
                </tbody></table></div>
            </div>
        </section>

        <!-- ══════ STATISTICS ══════ -->
        <section class="dash-section" id="section-statistics">
            <div class="section-hero"><div><h1 class="section-title">Statistiques<span class="wave">📊</span></h1><p class="section-sub">Performance du cabinet et indicateurs clés.</p></div></div>

            <!-- Appointment Metrics KPIs -->
            <div class="kpi-grid" style="margin-bottom:24px;">
                <div class="kpi-card kpi-green">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${rdvTermine}</span><span class="kpi-label">RDV terminés</span></div>
                </div>
                <div class="kpi-card kpi-red">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${rdvAnnule} <small style="font-size:14px;color:#94a3b8;">(${tauxAnnulation}%)</small></span><span class="kpi-label">Annulés</span></div>
                </div>
                <div class="kpi-card kpi-amber">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${rdvNonHonore} <small style="font-size:14px;color:#94a3b8;">(${tauxNonHonore}%)</small></span><span class="kpi-label">Non honorés</span></div>
                </div>
                <div class="kpi-card kpi-blue">
                    <div class="kpi-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M18 20V10M12 20V4M6 20v-6"/></svg></div>
                    <div class="kpi-body"><span class="kpi-value">${totalRdv}</span><span class="kpi-label">Total RDV</span></div>
                </div>
            </div>

            <!-- Revenue by Dentist -->
            <div class="dash-card">
                <div class="card-header"><h3>Chiffre d'affaires par dentiste</h3></div>
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>Dentiste</th><th>Total RDV</th><th>Terminés</th><th>Annulés</th><th>Non honorés</th><th>Chiffre d'affaires (MAD)</th></tr></thead><tbody>
                    <c:forEach var="rev" items="${revenueByDentist}">
                        <tr>
                            <td class="td-bold">${rev.dentisteLogin}</td>
                            <td>${rev.totalRdv}</td>
                            <td><span style="color:#16a34a;font-weight:600;">${rev.rdvTermine}</span></td>
                            <td><span style="color:#dc2626;font-weight:600;">${rev.rdvAnnule}</span></td>
                            <td><span style="color:#d97706;font-weight:600;">${rev.rdvNonHonore}</span></td>
                            <td class="td-bold" style="color:#1a6fa8;"><fmt:formatNumber value="${rev.chiffreAffaires}" pattern="#,##0.00"/> MAD</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty revenueByDentist}">
                        <tr><td colspan="6" style="text-align:center;color:#94a3b8;padding:30px;">Aucune donnée disponible.</td></tr>
                    </c:if>
                </tbody></table></div>
            </div>

            <!-- Appointment Status Breakdown chart (visual bars) -->
            <div class="dash-card" style="margin-top:20px;">
                <div class="card-header"><h3>Répartition des rendez-vous</h3></div>
                <div id="appointmentChart" style="display:flex;flex-direction:column;gap:14px;">
                    <!-- Built by JS -->
                </div>
            </div>
        </section>

    </div>
</main>

<!-- ══════ MODALS ══════ -->

<!-- Add Dentist Modal -->
<div class="modal-backdrop" id="addDentistModal">
    <div class="modal"><div class="modal-header"><h3>Ajouter un dentiste</h3><button class="modal-close" onclick="document.getElementById('addDentistModal').classList.remove('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>
        <form action="${pageContext.request.contextPath}/admin/users/add" method="post" class="modal-form" onsubmit="return validateModal('addDentist')">
            <input type="hidden" name="role" value="DENTISTE">
            <div class="form-group"><label>Login *</label><input type="text" name="login" class="form-select" placeholder="Login" required id="addDentistLogin"><span class="field-error" id="addDentistLoginError"></span></div>
            <div class="form-group"><label>Mot de passe *</label><input type="password" name="password" class="form-select" placeholder="••••••" required id="addDentistPassword"><span class="field-error" id="addDentistPasswordError"></span></div>
            <div class="modal-actions"><button type="button" class="btn-secondary" onclick="document.getElementById('addDentistModal').classList.remove('open')">Annuler</button><button type="submit" class="btn-primary">Enregistrer</button></div>
        </form>
    </div>
</div>

<!-- Add Assistant Modal -->
<div class="modal-backdrop" id="addAssistantModal">
    <div class="modal"><div class="modal-header"><h3>Ajouter une assistante</h3><button class="modal-close" onclick="document.getElementById('addAssistantModal').classList.remove('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>
        <form action="${pageContext.request.contextPath}/admin/users/add" method="post" class="modal-form" onsubmit="return validateModal('addAssistant')">
            <input type="hidden" name="role" value="ASSISTANTE">
            <div class="form-group"><label>Login *</label><input type="text" name="login" class="form-select" placeholder="Login" required id="addAssistantLogin"><span class="field-error" id="addAssistantLoginError"></span></div>
            <div class="form-group"><label>Mot de passe *</label><input type="password" name="password" class="form-select" placeholder="••••••" required id="addAssistantPassword"><span class="field-error" id="addAssistantPasswordError"></span></div>
            <div class="modal-actions"><button type="button" class="btn-secondary" onclick="document.getElementById('addAssistantModal').classList.remove('open')">Annuler</button><button type="submit" class="btn-primary">Enregistrer</button></div>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal-backdrop" id="editUserModal">
    <div class="modal"><div class="modal-header"><h3 id="editUserTitle">Modifier le personnel</h3><button class="modal-close" onclick="document.getElementById('editUserModal').classList.remove('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>
        <form action="${pageContext.request.contextPath}/admin/users/update" method="post" class="modal-form" onsubmit="return validateEditModal()">
            <input type="hidden" name="id" id="editUserId">
            <div class="form-group"><label>Login *</label><input type="text" name="login" class="form-select" placeholder="Login" required id="editUserLogin"><span class="field-error" id="editUserLoginError"></span></div>
            <div class="form-group"><label>Nouveau mot de passe <small style="color:#94a3b8;">(laisser vide pour ne pas changer)</small></label><input type="password" name="password" class="form-select" placeholder="••••••" id="editUserPassword"></div>
            <div class="modal-actions"><button type="button" class="btn-secondary" onclick="document.getElementById('editUserModal').classList.remove('open')">Annuler</button><button type="submit" class="btn-primary">Enregistrer</button></div>
        </form>
    </div>
</div>

<script>
    /* EL data for chart — passed to external JS via data attributes */
    document.body.setAttribute('data-total-rdv', '${totalRdv}');
    document.body.setAttribute('data-rdv-termine', '${rdvTermine}');
    document.body.setAttribute('data-rdv-annule', '${rdvAnnule}');
    document.body.setAttribute('data-rdv-non-honore', '${rdvNonHonore}');
</script>
<script src="../js/dashboard-admin.js"></script>
</body>
</html>
