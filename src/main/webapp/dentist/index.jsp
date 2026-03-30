<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Espace Dentiste</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-dentist">

<!-- SIDEBAR -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <img src="${pageContext.request.contextPath}/images/logo.png" class="sidebar-logo" alt="logo">
        <span>DentFisto</span>
    </div>
    <nav class="sidebar-nav">
        <a href="#overview" class="nav-item active" data-section="overview">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <p class="nav-item-name">Tableau de bord</p>
        </a>
        <a href="#planning" class="nav-item" data-section="planning">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
             <p class="nav-item-name">Planning</p>
        </a>
        <a href="#search-rdv" class="nav-item" data-section="search-rdv">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
             <p class="nav-item-name">Chercher RV</p>
        </a>
        <a href="#search-patient" class="nav-item" data-section="search-patient">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
             <p class="nav-item-name">Chercher Patient</p>
        </a>
        <a href="#dossier" class="nav-item" data-section="dossier">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
             <p class="nav-item-name">Dossier médical</p>
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar">Dr</div>
            <div class="user-info">
                <span class="user-name">${not empty sessionScope.user.login ? sessionScope.user.login : 'Dr.'}</span>
                <span class="user-role">Dentiste</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Déconnexion">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        </a>
    </div>
</aside>

<!-- MAIN CONTENT -->
<main class="dashboard-main">
    <header class="topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle" id="sidebarToggle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <div class="breadcrumb"><span id="breadcrumbText">Tableau de bord</span></div>
        </div>
        <div class="topbar-right">
            <div class="topbar-date">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="14" height="14"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                <span id="currentDate"></span>
            </div>
        </div>
    </header>

    <div class="content-area">

        <!-- ══════ SECTION: OVERVIEW ══════ -->
        <section class="dash-section active" id="section-overview">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Bonjour, ${not empty sessionScope.user.login ? sessionScope.user.login : 'Docteur'}<span class="wave">👋</span></h1>
                    <p class="section-sub">Vos rendez-vous du jour, classés par priorité.</p>
                </div>
            </div>

            <div class="dash-card">
                <div class="card-header">
                    <h3>Rendez-vous du jour</h3>
                </div>
                <div class="rv-list">
                    <c:choose>
                        <c:when test="${not empty rdvList}">
                            <c:forEach var="rdv" items="${rdvList}">
                                <div class="rv-item ${rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'rv-item-waiting' : ''} ${rdv.statut == 'EN_COURS' ? 'rv-item-inprogress' : ''}"
                                     data-rdv-id="${rdv.id}" data-statut="${rdv.statut}" data-patient-id="${rdv.patientId}"
                                     <c:if test="${rdv.statut == 'EN_SALLE_D_ATTENTE' or rdv.statut == 'EN_COURS' or rdv.statut == 'PLANIFIE'}">style="cursor:pointer;"</c:if>>
                                    <div class="rv-time">${rdv.heureDebut}</div>
                                    <div class="rv-info">
                                        <span class="rv-patient">${rdv.patientFullName}</span>
                                        <span class="rv-type">${rdv.motif}</span>
                                    </div>
                                    <span class="rv-status status-${rdv.statut == 'EN_COURS' ? 'in_progress' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : rdv.statut == 'TERMINE' ? 'done' : rdv.statut == 'PLANIFIE' ? 'confirmed' : 'cancelled'}">${rdv.statut}</span>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun rendez-vous prioritaire aujourd'hui.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- ══════ SECTION: PLANNING ══════ -->
        <section class="dash-section" id="section-planning">
            <div class="section-hero">
                <div><h1 class="section-title">Planning</h1><p class="section-sub">Consultez votre emploi du temps.</p></div>
                <div class="planning-toggle">
                    <button class="toggle-btn active" id="btnDay" onclick="switchPlanning('day')">Jour</button>
                    <button class="toggle-btn" id="btnWeek" onclick="switchPlanning('week')">Semaine</button>
                </div>
            </div>
            <div id="planningDay" class="planning-view">
                <div class="dash-card">
                    <div class="card-header"><h3 id="dayLabel"></h3></div>
                    <div class="day-timeline">
                        <c:choose>
                            <c:when test="${not empty rdvList}">
                                <c:forEach var="rdv" items="${rdvList}">
                                    <div class="time-slot slot-${rdv.statut == 'PLANIFIE' ? 'confirmed' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : rdv.statut == 'TERMINE' ? 'confirmed' : 'cancelled'}"
                                         data-rdv-id="${rdv.id}" data-statut="${rdv.statut}"
                                         <c:if test="${rdv.statut == 'EN_SALLE_D_ATTENTE' or rdv.statut == 'PLANIFIE' or rdv.statut == 'EN_COURS'}">style="cursor:pointer;"</c:if>>
                                        <div class="slot-time">${rdv.heureDebut}</div>
                                        <div class="slot-body"><span class="slot-patient">${rdv.patientFullName}</span><span class="slot-type">${rdv.motif}</span></div>
                                        <div class="slot-actions"><span class="slot-badge badge-${rdv.statut == 'PLANIFIE' ? 'confirmed' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : 'confirmed'}">${rdv.statut}</span></div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align:center;padding:20px;color:#94a3b8;">Aucun rendez-vous aujourd'hui.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- WEEKLY CALENDAR GRID -->
            <div id="planningWeek" class="planning-view" style="display:none;">
                <div class="dash-card" style="padding:0;overflow:hidden;">
                    <div class="card-header" style="padding:20px 24px 16px;"><h3>Planning de la semaine</h3></div>
                    <div class="weekly-calendar" id="weeklyCalendar">
                        <!-- Built dynamically via JS -->
                    </div>
                </div>
            </div>
        </section>

        <!-- ══════ SECTION: SEARCH RDV ══════ -->
        <section class="dash-section" id="section-search-rdv">
            <div class="section-hero"><div><h1 class="section-title">Chercher un RV</h1><p class="section-sub">Recherchez par nom ou téléphone.</p></div></div>
            <div class="search-bar-form">
                <div class="search-bar" style="gap:10px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" id="searchRdvNom" placeholder="Nom du patient…" required style="flex:1;">
                    <input type="tel" id="searchRdvTel" placeholder="N° Téléphone…" required style="flex:1; border-left: 1px solid #e2e8f0; padding-left: 10px;">
                    <button type="button" class="btn-primary" onclick="searchRdv()">Rechercher</button>
                </div>
                <span class="field-error" id="searchRdvError"></span>
            </div>
            <div id="searchRdvResults"></div>
        </section>

        <!-- ══════ SECTION: SEARCH PATIENT ══════ -->
        <section class="dash-section" id="section-search-patient">
            <div class="section-hero"><div><h1 class="section-title">Chercher un patient</h1><p class="section-sub">Recherchez par nom ou téléphone.</p></div></div>
            <div class="search-bar-form">
                <div class="search-bar" style="gap:10px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" id="searchPatientNom" placeholder="Nom ou prénom…" required style="flex:1;">
                    <input type="tel" id="searchPatientTel" placeholder="N° Téléphone…" required style="flex:1; border-left: 1px solid #e2e8f0; padding-left: 10px;">
                    <button type="button" class="btn-primary" onclick="searchPatient()">Rechercher</button>
                </div>
                <span class="field-error" id="searchPatientError"></span>
            </div>
            <div id="searchPatientResults"></div>
            <div id="patientDetailView" style="display:none;"></div>
        </section>

        <!-- ══════ SECTION: DOSSIER MEDICAL ══════ -->
        <section class="dash-section" id="section-dossier">
            <div class="section-hero"><div><h1 class="section-title">Dossier médical</h1><p class="section-sub">Consultez le dossier complet d'un patient.</p></div></div>
            <div class="search-bar-form">
                <div class="search-bar" style="gap:10px;">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" id="searchDossierNom" placeholder="Nom du patient…" required style="flex:1;">
                    <input type="tel" id="searchDossierTel" placeholder="N° Téléphone…" required style="flex:1; border-left: 1px solid #e2e8f0; padding-left: 10px;">
                    <button type="button" class="btn-primary" onclick="searchForDossier()">Ouvrir</button>
                </div>
                <span class="field-error" id="searchDossierError"></span>
            </div>
            <div id="dossierPatientCards"></div>
            <div id="dossierFullView" style="display:none;"></div>
        </section>

        <!-- ══════ SECTION: CONSULTATION (loaded dynamically) ══════ -->
        <section class="dash-section" id="section-consultation" style="display:none;">
            <div class="section-hero"><div><h1 class="section-title">Consultation en cours</h1><p class="section-sub">Remplissez le dossier médical.</p></div></div>

            <c:if test="${consultation != null}">
            <form action="${pageContext.request.contextPath}/dentist/consultation" method="post" id="consultationForm" class="dash-card" onsubmit="return validateConsultation()">
                <input type="hidden" name="consultationId" value="${consultation.id}">
                <input type="hidden" name="rdvId" value="${rdv.id}">

                <!-- Patient info banner -->
                <div class="consultation-patient-banner">
                    <div class="patient-avatar">${patient.nom.substring(0,1)}${patient.prenom.substring(0,1)}</div>
                    <div>
                        <h3>${patient.nom} ${patient.prenom}</h3>
                        <span class="section-sub">${patient.telephone} · ${rdv.motif}</span>
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-top:20px;">
                    <div class="form-group">
                        <label for="diagnostic">Diagnostic *</label>
                        <textarea id="diagnostic" name="diagnostic" class="form-select" rows="4" placeholder="Diagnostic du patient…" required>${consultation.diagnostic}</textarea>
                        <span class="field-error" id="diagnosticError"></span>
                    </div>
                    <div class="form-group">
                        <label for="observations">Observations</label>
                        <textarea id="observations" name="observations" class="form-select" rows="4" placeholder="Observations et notes…">${consultation.observations}</textarea>
                    </div>
                </div>

                <!-- Actes médicaux -->
                <div class="form-group" style="margin-top:16px;">
                    <label>Actes réalisés</label>
                    <div class="actes-grid">
                        <c:forEach var="acte" items="${catalogueActes}">
                            <label class="acte-checkbox">
                                <input type="checkbox" name="acteIds" value="${acte.id}"
                                    <c:forEach var="done" items="${consultation.actesRealises}">
                                        <c:if test="${done.id == acte.id}">checked</c:if>
                                    </c:forEach>
                                >
                                <span class="acte-label">${acte.nom}</span>
                                <span class="acte-price">${acte.tarifBase} MAD</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <!-- Documents -->
                <div class="form-group" style="margin-top:16px;">
                    <label>Ajouter un document</label>
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;">
                        <input type="text" id="docType" name="docType" class="form-select" placeholder="Type (Radio, Analyse…)">
                        <input type="date" id="docDate" name="docDate" class="form-select">
                        <input type="text" id="docPath" name="docPath" class="form-select" placeholder="Chemin du fichier">
                    </div>
                </div>

                <div class="modal-actions" style="margin-top:24px;">
                    <button type="submit" name="generateOrdonnance" value="false" class="btn-secondary">Terminer sans ordonnance</button>
                    <button type="submit" name="generateOrdonnance" value="true" class="btn-primary">Terminer + Générer ordonnance</button>
                </div>
            </form>
            </c:if>
        </section>

        <!-- ══════ SECTION: ORDONNANCE ══════ -->
        <c:if test="${showOrdonnance}">
        <section class="dash-section active" id="section-ordonnance-gen">
            <div class="section-hero"><div><h1 class="section-title">Générer une ordonnance</h1><p class="section-sub">Ajoutez les médicaments prescrits.</p></div></div>
            <div class="dash-card">
                <div class="consultation-patient-banner" style="margin-bottom:20px;">
                    <div class="patient-avatar">${patient.nom.substring(0,1)}${patient.prenom.substring(0,1)}</div>
                    <div><h3>${patient.nom} ${patient.prenom}</h3><span class="section-sub">${patient.telephone}</span></div>
                </div>

                <div class="form-group">
                    <label>Médicaments</label>
                    <div style="display:flex;gap:10px;margin-bottom:12px;">
                        <input type="text" id="medInput" class="form-select" style="flex:1" placeholder="Nom du médicament, posologie…">
                        <button type="button" class="btn-primary" onclick="addMedication()">+</button>
                    </div>
                    <span class="field-error" id="medError"></span>
                    <table class="data-table" id="medTable">
                        <thead><tr><th>#</th><th>Médicament</th><th>Action</th></tr></thead>
                        <tbody id="medTableBody"></tbody>
                    </table>
                </div>

                <form action="${pageContext.request.contextPath}/dentist/ordonnance" method="post" id="ordonnanceForm" style="margin-top:20px;">
                    <input type="hidden" name="consultationId" value="${consultation.id}">
                    <input type="hidden" name="medications" id="medicationsHidden">
                    <div class="modal-actions">
                        <a href="${pageContext.request.contextPath}/dentist/" class="btn-secondary">Passer</a>
                        <button type="button" class="btn-secondary" onclick="printOrdonnance()">Imprimer PDF</button>
                        <button type="submit" class="btn-primary" onclick="return submitOrdonnance()">Enregistrer ordonnance</button>
                    </div>
                </form>
            </div>
        </section>
        </c:if>

    </div>
</main>

<!-- MODAL: Status change -->
<div class="modal-backdrop" id="statusModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Modifier le statut</h3>
            <button class="modal-close" onclick="closeStatusModal()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>
        </div>
        <form action="${pageContext.request.contextPath}/dentist/rdv/status" method="post" class="modal-form">
            <input type="hidden" name="rdvId" id="statusRvId">
            <div class="form-group">
                <label for="newStatus">Nouveau statut</label>
                <select name="status" id="newStatus" class="form-select">
                    <option value="PLANIFIE">Planifié</option>
                    <option value="EN_SALLE_D_ATTENTE">En salle d'attente</option>
                    <option value="EN_COURS">En cours (démarrer consultation)</option>
                    <option value="TERMINE">Terminé</option>
                    <option value="ANNULE">Annulé</option>
                    <option value="NON_HONORE">Non honoré</option>
                </select>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeStatusModal()">Annuler</button>
                <button type="submit" class="btn-primary">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<script>
    /* ── Date ── */
    document.getElementById('currentDate').textContent =
        new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });
    const dayLabel = document.getElementById('dayLabel');
    if (dayLabel) dayLabel.textContent = new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });

    /* ── Section navigation ── */
    const sectionLabels = { overview:'Tableau de bord', planning:'Planning', 'search-rdv':'Chercher RV', 'search-patient':'Chercher Patient', dossier:'Dossier médical' };

    function showSection(name) {
        document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        const sec = document.getElementById('section-' + name);
        if (sec) { sec.style.display = ''; sec.classList.add('active'); }
        const nav = document.querySelector('[data-section="' + name + '"]');
        if (nav) nav.classList.add('active');
        document.getElementById('breadcrumbText').textContent = sectionLabels[name] || name;
        window.scrollTo(0,0);
    }

    // If consultation data was loaded by servlet, show consultation section
    <c:if test="${consultation != null && empty showOrdonnance}">
        showSection('consultation');
        document.getElementById('section-consultation').style.display = 'block';
    </c:if>

    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) { e.preventDefault(); if (this.dataset.section) showSection(this.dataset.section); });
    });

    /* ── Sidebar toggle ── */
    document.getElementById('sidebarToggle').addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('collapsed');
        document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed');
    });

    /* ── Planning switch ── */
    function switchPlanning(mode) {
        document.getElementById('planningDay').style.display = mode === 'day' ? '' : 'none';
        document.getElementById('planningWeek').style.display = mode === 'week' ? '' : 'none';
        document.getElementById('btnDay').classList.toggle('active', mode === 'day');
        document.getElementById('btnWeek').classList.toggle('active', mode === 'week');
        if (mode === 'week') buildWeeklyCalendar();
    }

    /* ── Status modal ── */
    function openStatusModal(id, currentStatus) {
        document.getElementById('statusRvId').value = id;
        document.getElementById('newStatus').value = currentStatus;
        document.getElementById('statusModal').classList.add('open');
    }
    function closeStatusModal() { document.getElementById('statusModal').classList.remove('open'); }
    document.getElementById('statusModal').addEventListener('click', function(e) { if (e.target === this) closeStatusModal(); });

    /* ── RV item click delegation ── */
    document.querySelectorAll('.rv-item[data-rdv-id], .time-slot[data-rdv-id]').forEach(function(item) {
        item.addEventListener('click', function() {
            var id = this.getAttribute('data-rdv-id');
            var statut = this.getAttribute('data-statut');
            if (statut === 'EN_SALLE_D_ATTENTE' || statut === 'PLANIFIE') {
                openStatusModal(id, statut);
            } else if (statut === 'EN_COURS') {
                window.location.href = '${pageContext.request.contextPath}/dentist/consultation?rdvId=' + id;
            }
        });
    });

    /* ── Inline validation ── */
    function showError(id, msg) { const el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = 'block'; } }
    function clearError(id) { const el = document.getElementById(id); if (el) { el.textContent = ''; el.style.display = 'none'; } }

    function validateConsultation() {
        let ok = true;
        clearError('diagnosticError');
        if (!document.getElementById('diagnostic').value.trim()) { showError('diagnosticError', 'Le diagnostic est obligatoire.'); ok = false; }
        return ok;
    }

    /* ── Search RDV ── */
    function searchRdv() {
        const nom = document.getElementById('searchRdvNom').value.trim();
        const tel = document.getElementById('searchRdvTel').value.trim();
        clearError('searchRdvError');
        if (!nom || !tel) { showError('searchRdvError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        fetch('${pageContext.request.contextPath}/api/search?type=rdv&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('searchRdvResults');
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun résultat trouvé.</div>'; return; }
                let html = '<div class="dash-card"><div class="table-wrapper"><table class="data-table"><thead><tr><th>Patient</th><th>Date</th><th>Heure</th><th>Motif</th><th>Statut</th><th>Actions</th></tr></thead><tbody>';
                data.results.forEach(r => {
                    const sc = r.statut === 'EN_COURS' ? 'in_progress' : r.statut === 'PLANIFIE' ? 'confirmed' : r.statut === 'TERMINE' ? 'done' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'pending' : 'cancelled';
                    html += '<tr><td class="td-bold">' + r.patient + '</td><td>' + r.date + '</td><td>' + r.heure + '</td><td>' + r.motif + '</td><td><span class="rv-status status-' + sc + '">' + r.statut + '</span></td>';
                    html += '<td class="td-actions"><button class="btn-table btn-edit" onclick="openStatusModal(' + r.id + ',\'' + r.statut + '\')">Modifier statut</button></td></tr>';
                });
                html += '</tbody></table></div></div>';
                div.innerHTML = html;
            });
    }

    /* ── Search Patient ── */
    function searchPatient() {
        const nom = document.getElementById('searchPatientNom').value.trim();
        const tel = document.getElementById('searchPatientTel').value.trim();
        clearError('searchPatientError');
        if (!nom || !tel) { showError('searchPatientError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        fetch('${pageContext.request.contextPath}/api/search?type=patient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('searchPatientResults');
                document.getElementById('patientDetailView').style.display = 'none';
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun patient trouvé.</div>'; return; }
                let html = '<div class="patient-grid">';
                data.results.forEach(p => {
                    html += '<div class="patient-card" style="cursor:pointer" onclick="showPatientOnly(' + p.id + ')">';
                    html += '<div class="patient-avatar">' + p.nom.charAt(0) + p.prenom.charAt(0) + '</div>';
                    html += '<div class="patient-info"><span class="patient-name">' + p.nom + ' ' + p.prenom + '</span><span class="patient-meta">' + p.tel + '</span></div>';
                    html += '</div>';
                });
                html += '</div>';
                div.innerHTML = html;
            });
    }

    /* ── Show Patient Only (info + modify, no consultations) ── */
    function showPatientOnly(patientId) {
        // Hide search bar and results
        var section = document.getElementById('section-search-patient');
        section.querySelector('.search-bar-form').style.display = 'none';
        document.getElementById('searchPatientResults').style.display = 'none';
        var div = document.getElementById('patientDetailView');
        div.style.display = 'block';
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement…</div>';

        fetch('${pageContext.request.contextPath}/api/search?type=patientDetail&id=' + patientId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                div.innerHTML = buildPatientOnlyHTML(data);
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    function backToPatientSearch() {
        var section = document.getElementById('section-search-patient');
        section.querySelector('.search-bar-form').style.display = '';
        document.getElementById('searchPatientResults').style.display = '';
        document.getElementById('patientDetailView').style.display = 'none';
    }

    /* ── Build Patient-Only HTML (info + modify, NO consultations) ── */
    function buildPatientOnlyHTML(p) {
        var html = '<div class="dossier-detail-view">';
        html += '<button class="btn-secondary" onclick="backToPatientSearch()" style="margin-bottom:16px;">← Retour aux résultats</button>';
        html += '<div class="dash-card">';
        html += '<div class="dossier-patient-header" style="margin-bottom:20px;">';
        html += '<div class="dossier-avatar">' + (p.nom ? p.nom.charAt(0) : '') + (p.prenom ? p.prenom.charAt(0) : '') + '</div>';
        html += '<div><h3>' + esc(p.nom) + ' ' + esc(p.prenom) + '</h3><span class="dossier-meta">' + esc(p.tel) + '</span></div>';
        html += '</div>';
        html += '<div class="dossier-info-list">';
        html += infoRow('Sexe', p.sexe === 'H' ? 'Homme' : p.sexe === 'F' ? 'Femme' : (p.sexe || '—'));
        html += infoRow('Date de naissance', p.dateNaissance || '—');
        html += infoRow('Adresse', p.adresse || '—');
        html += infoRow('Téléphone', p.tel || '—');
        html += infoRow('CNSS/Mutuelle', p.cnssMutuelle || '—');
        if (p.allergie) html += '<div class="dossier-info-row"><span class="di-label">Allergie</span><span class="di-val allergy">⚠ ' + esc(p.allergie) + '</span></div>';
        if (p.antecedents) html += infoRow('Antécédents', p.antecedents);
        if (p.responsableNom) html += infoRow('Responsable légal', p.responsableNom + (p.responsableTel ? ' (' + p.responsableTel + ')' : ''));
        html += '</div>';
        html += '</div>';
        html += '</div>';
        return html;
    }

    /* ── Load Patient Detail Inline for Dossier section (AJAX) ── */
    function loadDossierDetailInline(patientId) {
        // Hide search bar and patient cards
        var section = document.getElementById('section-dossier');
        section.querySelector('.search-bar-form').style.display = 'none';
        document.getElementById('dossierPatientCards').style.display = 'none';
        var div = document.getElementById('dossierFullView');
        div.style.display = 'block';
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement du dossier…</div>';

        fetch('${pageContext.request.contextPath}/api/search?type=patientDetail&id=' + patientId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                div.innerHTML = buildPatientDetailHTML(data);
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    function backToDossierSearch() {
        var section = document.getElementById('section-dossier');
        section.querySelector('.search-bar-form').style.display = '';
        document.getElementById('dossierPatientCards').style.display = '';
        document.getElementById('dossierFullView').style.display = 'none';
    }

    /* ── Build Patient Detail HTML ── */
    function buildPatientDetailHTML(p) {
        let html = '<div class="dossier-detail-view">';

        // Back button
        html += '<button class="btn-secondary" onclick="backToDossierSearch()" style="margin-bottom:16px;">← Retour aux résultats</button>';

        // Patient banner
        html += '<div class="dash-card"><div class="dossier-layout">';

        // Left: patient info sidebar
        html += '<div class="dash-card dossier-sidebar-card" style="margin-bottom:0;border:1px solid #e8edf3;">';
        html += '<div class="dossier-patient-header">';
        html += '<div class="dossier-avatar">' + (p.nom ? p.nom.charAt(0) : '') + (p.prenom ? p.prenom.charAt(0) : '') + '</div>';
        html += '<div><h3>' + esc(p.nom) + ' ' + esc(p.prenom) + '</h3><span class="dossier-meta">' + esc(p.tel) + '</span></div>';
        html += '</div>';
        html += '<div class="dossier-info-list">';
        html += infoRow('Sexe', p.sexe === 'H' ? 'Homme' : p.sexe === 'F' ? 'Femme' : (p.sexe || '—'));
        html += infoRow('Date de naissance', p.dateNaissance || '—');
        html += infoRow('Adresse', p.adresse || '—');
        html += infoRow('Téléphone', p.tel || '—');
        html += infoRow('CNSS/Mutuelle', p.cnssMutuelle || '—');
        if (p.allergie) html += '<div class="dossier-info-row"><span class="di-label">Allergie</span><span class="di-val allergy">⚠ ' + esc(p.allergie) + '</span></div>';
        if (p.antecedents) html += infoRow('Antécédents', p.antecedents);
        if (p.responsableNom) html += infoRow('Responsable légal', p.responsableNom + (p.responsableTel ? ' (' + p.responsableTel + ')' : ''));
        html += '</div>';

        // Dossier reference
        if (p.dossier) {
            html += '<div style="margin-top:16px;padding-top:14px;border-top:1px solid #f1f5f9;">';
            html += '<div class="dossier-info-row"><span class="di-label">N° Dossier</span><span class="di-val">' + esc(p.dossier.ref) + '</span></div>';
            html += '<div class="dossier-info-row" style="margin-top:6px;"><span class="di-label">Créé le</span><span class="di-val">' + p.dossier.dateCreation + '</span></div>';
            html += '</div>';
        }
        html += '</div>';

        // Right: consultation history
        html += '<div>';
        html += '<h3 style="font-size:16px;font-weight:700;color:#1e293b;margin-bottom:16px;">Historique des consultations</h3>';

        if (p.consultations && p.consultations.length > 0) {
            p.consultations.forEach(function(c, idx) {
                html += '<div class="dash-card consultation-history-card" style="margin-bottom:12px;border:1px solid #e8edf3;">';
                html += '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">';
                html += '<div style="display:flex;align-items:center;gap:10px;">';
                html += '<div style="width:36px;height:36px;border-radius:10px;background:#eff6ff;display:flex;align-items:center;justify-content:center;">';
                html += '<svg viewBox="0 0 24 24" fill="none" stroke="#1a6fa8" stroke-width="1.75" width="16" height="16"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>';
                html += '</div>';
                html += '<div><span style="font-size:14px;font-weight:600;color:#1e293b;">' + (c.date || '—') + '</span>';
                if (c.heure) html += '<span style="font-size:12px;color:#94a3b8;margin-left:8px;">' + c.heure + '</span>';
                html += '</div></div>';
                if (c.motif) html += '<span class="rv-status status-confirmed" style="font-size:11px;">' + esc(c.motif) + '</span>';
                html += '</div>';

                if (c.diagnostic) {
                    html += '<div style="margin-bottom:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Diagnostic</span>';
                    html += '<p style="font-size:13.5px;color:#1e293b;margin-top:4px;font-family:Inter,sans-serif;line-height:1.6;">' + esc(c.diagnostic) + '</p></div>';
                }
                if (c.observations) {
                    html += '<div style="margin-bottom:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Observations</span>';
                    html += '<p style="font-size:13.5px;color:#475569;margin-top:4px;font-family:Inter,sans-serif;line-height:1.6;">' + esc(c.observations) + '</p></div>';
                }
                if (c.actes && c.actes.length > 0) {
                    html += '<div><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Actes réalisés</span>';
                    html += '<div style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;">';
                    c.actes.forEach(function(a) {
                        html += '<span style="font-size:12px;padding:4px 10px;background:#f0fdf4;color:#15803d;border-radius:6px;font-weight:500;">' + esc(a.nom) + ' <span style="color:#94a3b8;">(' + a.tarif + ' MAD)</span></span>';
                    });
                    html += '</div></div>';
                }
                html += '</div>';
            });
        } else {
            html += '<div class="dash-card" style="text-align:center;padding:30px;color:#94a3b8;border:1px dashed #e2e8f0;">Aucune consultation pour ce patient.</div>';
        }

        // Documents
        html += '<h3 style="font-size:16px;font-weight:700;color:#1e293b;margin:20px 0 12px;">Documents annexes</h3>';
        if (p.dossier && p.dossier.documents && p.dossier.documents.length > 0) {
            p.dossier.documents.forEach(function(d) {
                html += '<div class="dash-card" style="margin-bottom:10px;border:1px solid #e8edf3;padding:14px 18px;">';
                html += '<div style="display:flex;align-items:center;gap:12px;">';
                html += '<div style="width:38px;height:38px;border-radius:10px;background:#fef3c7;display:flex;align-items:center;justify-content:center;flex-shrink:0;">';
                html += '<svg viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="1.75" width="18" height="18"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>';
                html += '</div>';
                html += '<div style="flex:1;min-width:0;">';
                html += '<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">';
                html += '<span style="font-size:13.5px;font-weight:600;color:#1e293b;">' + esc(d.type) + '</span>';
                html += '<span style="font-size:11px;padding:2px 8px;background:#f1f5f9;color:#64748b;border-radius:4px;">' + d.date + '</span>';
                html += '</div>';
                html += '<div style="font-size:12px;color:#64748b;margin-top:4px;font-family:Inter,sans-serif;word-break:break-all;">' + esc(d.chemin) + '</div>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
            });
        } else {
            html += '<div class="dash-card" style="text-align:center;padding:24px;color:#94a3b8;border:1px dashed #e2e8f0;">Aucun document dans ce dossier.</div>';
        }

        html += '</div>'; // end right
        html += '</div></div>'; // end layout, end card
        html += '</div>'; // end dossier-detail-view
        return html;
    }

    function infoRow(label, val) {
        return '<div class="dossier-info-row"><span class="di-label">' + label + '</span><span class="di-val">' + esc(val || '') + '</span></div>';
    }

    function esc(s) { if (!s) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

    /* ── Search for Dossier ── */
    function searchForDossier() {
        const nom = document.getElementById('searchDossierNom').value.trim();
        const tel = document.getElementById('searchDossierTel').value.trim();
        clearError('searchDossierError');
        if (!nom || !tel) { showError('searchDossierError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        document.getElementById('dossierFullView').style.display = 'none';
        fetch('${pageContext.request.contextPath}/api/search?type=patient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('dossierPatientCards');
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun patient trouvé.</div>'; return; }
                let html = '<div class="patient-grid">';
                data.results.forEach(p => {
                    html += '<div class="patient-card" style="cursor:pointer" onclick="loadDossierDetailInline(' + p.id + ')">';
                    html += '<div class="patient-avatar">' + p.nom.charAt(0) + p.prenom.charAt(0) + '</div>';
                    html += '<div class="patient-info"><span class="patient-name">' + p.nom + ' ' + p.prenom + '</span><span class="patient-meta">' + p.tel + '</span></div>';
                    html += '</div>';
                });
                html += '</div>';
                div.innerHTML = html;
            });
    }

    /* ══════════════════════════════════════
       WEEKLY CALENDAR
    ══════════════════════════════════════ */
    var weekRdvData = [];
    <c:if test="${not empty rdvWeekList}">
        <c:forEach var="rdv" items="${rdvWeekList}">
            weekRdvData.push({
                id: ${rdv.id},
                date: '${rdv.dateRdv}',
                heure: '${rdv.heureDebut}',
                patient: '${rdv.patientFullName}',
                motif: '${rdv.motif}',
                statut: '${rdv.statut}'
            });
        </c:forEach>
    </c:if>

    function buildWeeklyCalendar() {
        var cal = document.getElementById('weeklyCalendar');
        if (!cal) return;

        var today = new Date();
        var dayOfWeek = today.getDay(); // 0=Sun
        var mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
        var monday = new Date(today);
        monday.setDate(today.getDate() + mondayOffset);

        var days = [];
        var dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
        for (var i = 0; i < 6; i++) {
            var d = new Date(monday);
            d.setDate(monday.getDate() + i);
            days.push(d);
        }

        var hours = [];
        for (var h = 8; h <= 18; h++) {
            hours.push(h);
        }

        // Build header
        var html = '<div class="wcal-grid" style="grid-template-columns: 60px repeat(6, 1fr);">';
        html += '<div class="wcal-corner"></div>';
        days.forEach(function(d, idx) {
            var isToday = d.toDateString() === today.toDateString();
            var dayNum = d.getDate();
            var monthShort = d.toLocaleDateString('fr-FR', {month:'short'});
            html += '<div class="wcal-day-header' + (isToday ? ' wcal-today' : '') + '">';
            html += '<span class="wcal-day-name">' + dayNames[idx] + '</span>';
            html += '<span class="wcal-day-num' + (isToday ? ' wcal-today-num' : '') + '">' + dayNum + '</span>';
            html += '<span class="wcal-day-month">' + monthShort + '</span>';
            html += '</div>';
        });

        // Build time rows
        hours.forEach(function(h) {
            var timeStr = (h < 10 ? '0' : '') + h + ':00';
            html += '<div class="wcal-time-label">' + timeStr + '</div>';

            days.forEach(function(d, colIdx) {
                var dateStr = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
                var isToday = d.toDateString() === today.toDateString();
                var cellRdvs = weekRdvData.filter(function(r) {
                    var rHour = parseInt(r.heure.split(':')[0], 10);
                    return r.date === dateStr && rHour === h;
                });

                html += '<div class="wcal-cell' + (isToday ? ' wcal-cell-today' : '') + '">';
                cellRdvs.forEach(function(r) {
                    var cls = r.statut === 'PLANIFIE' ? 'ev-blue' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'ev-amber' : r.statut === 'EN_COURS' ? 'ev-blue' : r.statut === 'TERMINE' ? 'ev-green' : 'ev-grey';
                    html += '<div class="wcal-event ' + cls + '" title="' + esc(r.patient) + ' – ' + esc(r.motif) + '">';
                    html += '<span class="wcal-event-time">' + r.heure.substring(0,5) + '</span>';
                    html += '<span class="wcal-event-name">' + esc(r.patient) + '</span>';
                    html += '</div>';
                });
                html += '</div>';
            });
        });

        html += '</div>';
        cal.innerHTML = html;
    }

    /* ── Ordonnance: medication table ── */
    let medications = [];
    function addMedication() {
        const input = document.getElementById('medInput');
        const val = input.value.trim();
        clearError('medError');
        if (!val) { showError('medError', 'Veuillez saisir un médicament.'); return; }
        medications.push(val);
        input.value = '';
        renderMedTable();
    }
    function removeMed(i) { medications.splice(i, 1); renderMedTable(); }
    function renderMedTable() {
        const tbody = document.getElementById('medTableBody');
        if (!tbody) return;
        tbody.innerHTML = medications.map((m, i) =>
            '<tr><td>' + (i+1) + '</td><td>' + m + '</td><td><button type="button" class="btn-table btn-cancel" onclick="removeMed(' + i + ')">✕</button></td></tr>'
        ).join('');
    }
    function submitOrdonnance() {
        if (!medications.length) { showError('medError', 'Ajoutez au moins un médicament.'); return false; }
        document.getElementById('medicationsHidden').value = medications.join('|||');
        return true;
    }
    function printOrdonnance() {
        if (!medications.length) { showError('medError', 'Ajoutez au moins un médicament pour imprimer.'); return; }
        const w = window.open('', '_blank');
        let html = '<html><head><title>Ordonnance</title><style>body{font-family:serif;padding:40px;} h1{font-size:20px;} .med{margin:8px 0;padding:8px;border-bottom:1px solid #eee;} .header{border-bottom:2px solid #333;padding-bottom:10px;margin-bottom:20px;} .footer{margin-top:40px;border-top:1px solid #ccc;padding-top:10px;font-size:12px;color:#888;}</style></head><body>';
        html += '<div class="header"><h1>DentFisto – Ordonnance Médicale</h1>';
        html += '<p>Patient: <b>${patient.nom} ${patient.prenom}</b></p>';
        html += '<p>Date: ' + new Date().toLocaleDateString('fr-FR') + '</p></div>';
        html += '<h2>Prescription</h2>';
        medications.forEach((m, i) => { html += '<div class="med">' + (i+1) + '. ' + m + '</div>'; });
        html += '<div class="footer"><p>Signature du médecin: _____________________</p></div>';
        html += '</body></html>';
        w.document.write(html);
        w.document.close();
        w.print();
    }

    /* ── Initial Section Loader ── */
    <c:if test="${showDossier}">showSection('dossier');</c:if>
    <c:if test="${showConsultation}">showSection('consultation');</c:if>
    <c:if test="${showOrdonnance}">
        // Ordonnance section has ID 'section-ordonnance-gen', handle it specially
        document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
        var ordSec = document.getElementById('section-ordonnance-gen');
        if (ordSec) { ordSec.style.display = 'block'; ordSec.classList.add('active'); }
        document.getElementById('breadcrumbText').textContent = 'Ordonnance';
    </c:if>

    /* ── Auto-load dossier if showDossier + patient data ── */
    <c:if test="${showDossier && patient != null}">
        (function() {
            loadDossierDetailInline(${patient.id});
        })();
    </c:if>

    /* ── Page entrance ── */
    document.body.style.opacity = 0;
    document.body.style.transform = 'translateY(12px)';
    requestAnimationFrame(() => {
        document.body.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        document.body.style.opacity = 1;
        document.body.style.transform = 'translateY(0)';
    });
</script>
</body>
</html>
