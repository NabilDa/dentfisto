<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Espace Dentiste</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-dentist.css">
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
                                    <c:if test="${rdv.statut == 'TERMINE'}">
                                        <a href="${pageContext.request.contextPath}/dentist/ordonnance?rdvId=${rdv.id}" class="btn-table btn-dossier" style="margin-left:8px;font-size:11px;" onclick="event.stopPropagation();">📋 Ordonnance</a>
                                    </c:if>
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
                                        <div class="slot-actions"><span class="slot-badge badge-${rdv.statut == 'PLANIFIE' ? 'confirmed' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : 'confirmed'}">${rdv.statut}</span>
                                        <c:if test="${rdv.statut == 'TERMINE'}">
                                            <a href="${pageContext.request.contextPath}/dentist/ordonnance?rdvId=${rdv.id}" class="btn-table btn-dossier" style="margin-left:6px;font-size:10px;" onclick="event.stopPropagation();">📋 Ordonnance</a>
                                        </c:if>
                                        </div>
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

<!-- MODAL: RDV full edit -->
<div class="modal-backdrop" id="rdvEditModal">
    <div class="modal" style="max-width:560px;">
        <div class="modal-header">
            <h3>Modifier le rendez-vous</h3>
            <button class="modal-close" onclick="closeRdvEditModal()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>
        </div>
        <div class="modal-form">
            <input type="hidden" id="editRdvId">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
                <div class="form-group">
                    <label for="editRdvDate">Date</label>
                    <input type="date" id="editRdvDate" class="form-select">
                </div>
                <div class="form-group">
                    <label for="editRdvStatut">Statut</label>
                    <select id="editRdvStatut" class="form-select">
                        <option value="PLANIFIE">Planifié</option>
                        <option value="EN_SALLE_D_ATTENTE">En salle d'attente</option>
                        <option value="EN_COURS">En cours</option>
                        <option value="TERMINE">Terminé</option>
                        <option value="ANNULE">Annulé</option>
                        <option value="NON_HONORE">Non honoré</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="editRdvHeureDebut">Heure début</label>
                    <input type="time" id="editRdvHeureDebut" class="form-select">
                </div>
                <div class="form-group">
                    <label for="editRdvHeureFin">Heure fin</label>
                    <input type="time" id="editRdvHeureFin" class="form-select">
                </div>
            </div>
            <div class="form-group" style="margin-top:10px;">
                <label for="editRdvMotif">Motif</label>
                <input type="text" id="editRdvMotif" class="form-select" placeholder="Motif du rendez-vous">
            </div>
            <div class="form-group" style="margin-top:10px;">
                <label for="editRdvNotes">Notes internes</label>
                <textarea id="editRdvNotes" class="form-select" rows="3" placeholder="Notes internes…"></textarea>
            </div>
            <span class="field-error" id="rdvEditError"></span>
            <div class="modal-actions" style="margin-top:18px;">
                <button type="button" class="btn-secondary" onclick="closeRdvEditModal()">Annuler</button>
                <button type="button" class="btn-primary" onclick="saveRdvEdit()">Enregistrer</button>
            </div>
        </div>
    </div>
</div>

<script>
    /* EL data — must remain inline for JSP processing */
    var CTX = '${pageContext.request.contextPath}';
    var patientName = '${patient != null ? patient.nom : ""}' + ' ' + '${patient != null ? patient.prenom : ""}';
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
</script>
<script src="${pageContext.request.contextPath}/js/dashboard-dentist.js"></script>
<script>
    /* Section switching directives — depend on EL */
    <c:if test="${consultation != null && empty showOrdonnance}">
        showSection('consultation');
        document.getElementById('section-consultation').style.display = 'block';
    </c:if>
    <c:if test="${showDossier}">showSection('dossier');</c:if>
    <c:if test="${showConsultation}">showSection('consultation');</c:if>
    <c:if test="${showOrdonnance}">
        document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
        var ordSec = document.getElementById('section-ordonnance-gen');
        if (ordSec) { ordSec.style.display = 'block'; ordSec.classList.add('active'); }
        document.getElementById('breadcrumbText').textContent = 'Ordonnance';
    </c:if>
    <c:if test="${showDossier && patient != null}">
        (function() { loadDossierDetailInline(${patient.id}); })();
    </c:if>
</script>
</body>
</html>

