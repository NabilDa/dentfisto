<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        <a href="#actes" class="nav-item" data-section="actes">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            <p class="nav-item-name">Actes & Tarifs</p>
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

        <!-- OVERVIEW -->
        <section class="dash-section active" id="section-overview">
            <div class="section-hero"><div><h1 class="section-title">Administration<span class="wave">⚙️</span></h1><p class="section-sub">Gestion du cabinet dentaire.</p></div></div>
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
                        <button class="qa-btn" onclick="showSection('actes')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>Actes & Tarifs</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- DENTISTS -->
        <section class="dash-section" id="section-dentists">
            <div class="section-hero"><div><h1 class="section-title">Dentistes</h1><p class="section-sub">Gérez les comptes des dentistes.</p></div>
                <button class="btn-primary" onclick="document.getElementById('addDentistModal').classList.add('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Ajouter</button>
            </div>
            <div class="dash-card">
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>Login</th><th>Actions</th></tr></thead><tbody>
                    <c:forEach var="d" items="${dentistes}">
                        <tr><td class="td-bold">${d.login}</td><td class="td-actions">
                            <a href="${pageContext.request.contextPath}/admin/users/delete?id=${d.id}" class="btn-table btn-cancel" onclick="return confirm('Supprimer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Supprimer</a>
                        </td></tr>
                    </c:forEach>
                </tbody></table></div>
            </div>
        </section>

        <!-- ASSISTANTS -->
        <section class="dash-section" id="section-assistants">
            <div class="section-hero"><div><h1 class="section-title">Assistantes</h1><p class="section-sub">Gérez les comptes des assistantes.</p></div>
                <button class="btn-primary" onclick="document.getElementById('addAssistantModal').classList.add('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Ajouter</button>
            </div>
            <div class="dash-card">
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>Login</th><th>Actions</th></tr></thead><tbody>
                    <c:forEach var="a" items="${assistantes}">
                        <tr><td class="td-bold">${a.login}</td><td class="td-actions">
                            <a href="${pageContext.request.contextPath}/admin/users/delete?id=${a.id}" class="btn-table btn-cancel" onclick="return confirm('Supprimer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Supprimer</a>
                        </td></tr>
                    </c:forEach>
                </tbody></table></div>
            </div>
        </section>

        <!-- ACTES -->
        <section class="dash-section" id="section-actes">
            <div class="section-hero"><div><h1 class="section-title">Actes & Tarifs</h1><p class="section-sub">Catalogue des actes dentaires.</p></div>
                <button class="btn-primary" onclick="document.getElementById('addActeModal').classList.add('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Ajouter acte</button>
            </div>
            <div class="dash-card">
                <div class="table-wrapper"><table class="data-table"><thead><tr><th>Code</th><th>Désignation</th><th>Tarif (MAD)</th><th>Actions</th></tr></thead><tbody>
                    <c:forEach var="acte" items="${actes}">
                        <tr><td class="td-bold">${acte.code}</td><td>${acte.nom}</td><td>${acte.tarifBase}</td><td class="td-actions">
                            <a href="${pageContext.request.contextPath}/admin/actes/delete?id=${acte.id}" class="btn-table btn-cancel" onclick="return confirm('Supprimer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Supprimer</a>
                        </td></tr>
                    </c:forEach>
                </tbody></table></div>
            </div>
        </section>

    </div>
</main>

<!-- Modals -->
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
<div class="modal-backdrop" id="addActeModal">
    <div class="modal"><div class="modal-header"><h3>Ajouter un acte</h3><button class="modal-close" onclick="document.getElementById('addActeModal').classList.remove('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>
        <form action="${pageContext.request.contextPath}/admin/actes/add" method="post" class="modal-form" onsubmit="return validateModal('addActe')">
            <div class="form-group"><label>Code *</label><input type="text" name="code" class="form-select" placeholder="DET01" required id="addActeCode"><span class="field-error" id="addActeCodeError"></span></div>
            <div class="form-group"><label>Désignation *</label><input type="text" name="designation" class="form-select" placeholder="Détartrage" required id="addActeDesignation"><span class="field-error" id="addActeDesignationError"></span></div>
            <div class="form-group"><label>Tarif (MAD) *</label><input type="number" name="tarif" class="form-select" placeholder="300" required id="addActeTarif"><span class="field-error" id="addActeTarifError"></span></div>
            <div class="modal-actions"><button type="button" class="btn-secondary" onclick="document.getElementById('addActeModal').classList.remove('open')">Annuler</button><button type="submit" class="btn-primary">Enregistrer</button></div>
        </form>
    </div>
</div>

<script>
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });
    var sectionLabels = { overview:'Tableau de bord', dentists:'Dentistes', assistants:'Assistantes', actes:'Actes & Tarifs' };

    function showSection(name) {
        document.querySelectorAll('.dash-section').forEach(function(s) { s.classList.remove('active'); });
        document.querySelectorAll('.nav-item').forEach(function(n) { n.classList.remove('active'); });
        var sec = document.getElementById('section-' + name); if (sec) sec.classList.add('active');
        var nav = document.querySelector('[data-section="' + name + '"]'); if (nav) nav.classList.add('active');
        document.getElementById('breadcrumbText').textContent = sectionLabels[name] || name;
    }

    document.querySelectorAll('.nav-item').forEach(function(item) { item.addEventListener('click', function(e) { e.preventDefault(); if (this.dataset.section) showSection(this.dataset.section); }); });
    document.getElementById('sidebarToggle').addEventListener('click', function() { document.getElementById('sidebar').classList.toggle('collapsed'); document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed'); });
    document.querySelectorAll('.modal-backdrop').forEach(function(m) { m.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('open'); }); });

    function showError(id, msg) { var el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = 'block'; } }
    function clearError(id) { var el = document.getElementById(id); if (el) { el.textContent = ''; el.style.display = 'none'; } }

    function validateModal(prefix) {
        var fields = document.querySelectorAll('#' + prefix + 'Modal input[required]');
        var ok = true;
        fields.forEach(function(f) {
            clearError(f.id + 'Error');
            if (!f.value.trim()) { showError(f.id + 'Error', 'Ce champ est obligatoire.'); ok = false; }
        });
        return ok;
    }

    document.body.style.opacity = 0; document.body.style.transform = 'translateY(12px)';
    requestAnimationFrame(function() { document.body.style.transition = 'opacity 0.4s ease, transform 0.4s ease'; document.body.style.opacity = 1; document.body.style.transform = 'translateY(0)'; });
</script>
</body>
</html>
