<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>DentFisto – Espace Assistante</title>
            <link
                href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="../css/style.css">
            <link rel="stylesheet" href="../css/dashboard-dentist.css">
            <link rel="stylesheet" href="../css/assistant-rdv.css">
        </head>

        <body class="dashboard-page role-assistant">

            <!-- SIDEBAR -->
            <aside class="sidebar" id="sidebar">
                <div class="sidebar-brand">
                    <img src="${pageContext.request.contextPath}/images/logo.png" class="sidebar-logo" alt="logo">
                    <span>DentFisto</span>
                </div>
                <nav class="sidebar-nav">
                    <a href="#overview" class="nav-item active" data-section="overview">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <rect x="3" y="3" width="7" height="7" rx="1" />
                            <rect x="14" y="3" width="7" height="7" rx="1" />
                            <rect x="3" y="14" width="7" height="7" rx="1" />
                            <rect x="14" y="14" width="7" height="7" rx="1" />
                        </svg>
                        <p class="nav-item-name">Tableau de bord</p>
                    </a>
                    <a href="#planning" class="nav-item" data-section="planning">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <rect x="3" y="4" width="18" height="18" rx="2" />
                            <path d="M16 2v4M8 2v4M3 10h18" />
                        </svg>
                        <p class="nav-item-name">Planning</p>
                    </a>
                    <a href="#programmer-rdv" class="nav-item" data-section="programmer-rdv">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <rect x="3" y="4" width="18" height="18" rx="2" />
                            <path d="M16 2v4M8 2v4M3 10h18" />
                            <line x1="12" y1="14" x2="12" y2="18" />
                            <line x1="10" y1="16" x2="14" y2="16" />
                        </svg>
                        <p class="nav-item-name">Programmer RDV</p>
                    </a>
                    <a href="#search-rdv" class="nav-item" data-section="search-rdv">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <circle cx="11" cy="11" r="8" />
                            <path d="m21 21-4.35-4.35" />
                        </svg>
                        <p class="nav-item-name">Chercher RV</p>
                    </a>
                    <a href="#search-patient" class="nav-item" data-section="search-patient">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                            <circle cx="9" cy="7" r="4" />
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
                        </svg>
                        <p class="nav-item-name">Chercher Patient</p>
                    </a>
                    <a href="#add-patient" class="nav-item" data-section="add-patient">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                            <circle cx="8.5" cy="7" r="4" />
                            <line x1="20" y1="8" x2="20" y2="14" />
                            <line x1="23" y1="11" x2="17" y2="11" />
                        </svg>
                        <p class="nav-item-name">Ajouter patient</p>
                    </a>
                    <a href="#importer" class="nav-item" data-section="importer">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                            <polyline points="17 8 12 3 7 8" />
                            <line x1="12" y1="3" x2="12" y2="15" />
                        </svg>
                        <p class="nav-item-name">Importer données</p>
                    </a>
                    <a href="#disponibilite" class="nav-item" data-section="disponibilite">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                            <circle cx="9" cy="7" r="4" />
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                            <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                            <polyline points="18 8 20 10 24 6" transform="translate(-2,0)" />
                        </svg>
                        <p class="nav-item-name">Disponibilité dentistes</p>
                    </a>
                </nav>
                <div class="sidebar-footer">
                    <div class="sidebar-user">
                        <div class="user-avatar">As</div>
                        <div class="user-info">
                            <span class="user-name">${not empty sessionScope.user.login ? sessionScope.user.login :
                                'Assistante'}</span>
                            <span class="user-role">Assistante</span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Déconnexion">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16 17 21 12 16 7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                    </a>
                </div>
            </aside>

            <!-- MAIN -->
            <main class="dashboard-main">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="sidebar-toggle" id="sidebarToggle">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <line x1="3" y1="12" x2="21" y2="12" />
                                <line x1="3" y1="18" x2="21" y2="18" />
                            </svg>
                        </button>
                        <div class="breadcrumb"><span id="breadcrumbText">Tableau de bord</span></div>
                    </div>
                    <div class="topbar-right">
                        <div class="topbar-date">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="14"
                                height="14">
                                <rect x="3" y="4" width="18" height="18" rx="2" />
                                <path d="M16 2v4M8 2v4M3 10h18" />
                            </svg>
                            <span id="currentDate"></span>
                        </div>
                    </div>
                </header>

                <div class="content-area">

                    <!-- OVERVIEW -->
                    <section class="dash-section active" id="section-overview">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Bonjour, ${not empty sessionScope.user.login ?
                                    sessionScope.user.login : 'Assistante'}<span class="wave">👋</span></h1>
                                <p class="section-sub">Rendez-vous du jour, classés par priorité.</p>
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
                                                data-rdv-id="${rdv.id}" data-statut="${rdv.statut}" <c:if
                                                test="${rdv.statut == 'EN_SALLE_D_ATTENTE' or rdv.statut == 'PLANIFIE'}">
                                                style="cursor:pointer;"</c:if>>
                                                <div class="rv-time">${rdv.heureDebut}</div>
                                                <div class="rv-info">
                                                    <span class="rv-patient">${rdv.patientFullName}</span>
                                                    <span class="rv-type">${rdv.motif}</span>
                                                </div>
                                                <span
                                                    class="rv-status status-${rdv.statut == 'EN_COURS' ? 'in_progress' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : rdv.statut == 'TERMINE' ? 'done' : rdv.statut == 'PLANIFIE' ? 'confirmed' : 'cancelled'}">${rdv.statut}</span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">
                                            Aucun rendez-vous prioritaire aujourd'hui.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>

                    <!-- PLANNING -->
                    <section class="dash-section" id="section-planning">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Planning</h1>
                                <p class="section-sub">Consultez l'emploi du temps.</p>
                            </div>
                            <div class="planning-toggle">
                                <button class="toggle-btn active" id="btnDay"
                                    onclick="switchPlanning('day')">Jour</button>
                                <button class="toggle-btn" id="btnWeek"
                                    onclick="switchPlanning('week')">Semaine</button>
                            </div>
                        </div>
                        <div id="planningDay" class="planning-view">
                            <div class="dash-card">
                                <div class="card-header">
                                    <h3 id="dayLabel"></h3>
                                </div>
                                <div class="day-timeline">
                                    <c:choose>
                                        <c:when test="${not empty rdvList}">
                                            <c:forEach var="rdv" items="${rdvList}">
                                                <div class="time-slot slot-${rdv.statut == 'PLANIFIE' ? 'confirmed' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : rdv.statut == 'TERMINE' ? 'confirmed' : 'cancelled'}"
                                                    data-rdv-id="${rdv.id}" data-statut="${rdv.statut}" <c:if
                                                    test="${rdv.statut == 'EN_SALLE_D_ATTENTE' or rdv.statut == 'PLANIFIE'}">
                                                    style="cursor:pointer;"</c:if>>
                                                    <div class="slot-time">${rdv.heureDebut}</div>
                                                    <div class="slot-body"><span
                                                            class="slot-patient">${rdv.patientFullName}</span><span
                                                            class="slot-type">${rdv.motif}</span></div>
                                                    <div class="slot-actions"><span
                                                            class="slot-badge badge-${rdv.statut == 'PLANIFIE' ? 'confirmed' : rdv.statut == 'EN_SALLE_D_ATTENTE' ? 'pending' : 'confirmed'}">${rdv.statut}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="text-align:center;padding:20px;color:#94a3b8;">Aucun rendez-vous
                                                aujourd'hui.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div id="planningWeek" class="planning-view" style="display:none;">
                            <div class="dash-card" style="padding:0;overflow:hidden;">
                                <div class="card-header" style="padding:20px 24px 16px;">
                                    <h3>Planning de la semaine</h3>
                                </div>
                                <div class="weekly-calendar" id="weeklyCalendar"></div>
                            </div>
                        </div>
                    </section>

                    <!-- ═══════════════════════════════════════════════════════════════
             PROGRAMMER RDV
        ════════════════════════════════════════════════════════════════ -->
                    <section class="dash-section" id="section-programmer-rdv">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Programmer un RDV</h1>
                                <p class="section-sub">Recherchez le patient, choisissez le dentiste et le créneau.</p>
                            </div>
                        </div>

                        <!-- STEP 1 : Patient -->
                        <div class="dash-card" id="prdv-step1">
                            <div class="card-header" style="margin-bottom:18px;">
                                <h3><span class="prdv-step-badge">1</span>Rechercher le patient</h3>
                            </div>
                            <div class="search-bar-form">
                                <div class="search-bar" style="gap:10px;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                        <circle cx="11" cy="11" r="8" />
                                        <path d="m21 21-4.35-4.35" />
                                    </svg>
                                    <input type="text" id="prdvSearchNom" placeholder="Nom ou prénom…" style="flex:1;">
                                    <input type="tel" id="prdvSearchTel" placeholder="Téléphone…"
                                        style="flex:1;border-left:1px solid #e2e8f0;padding-left:10px;">
                                    <button type="button" class="btn-primary"
                                        onclick="prdvSearchPatient()">Rechercher</button>
                                </div>
                                <span class="field-error" id="prdvSearchError"></span>
                            </div>
                            <div id="prdvSearchResults"></div>

                            <!-- Fiche minimale -->
                            <div id="prdvFicheMinimale"
                                style="display:none;margin-top:20px;padding-top:20px;border-top:1px solid #e8edf3;">
                                <p style="font-size:13px;color:#64748b;margin-bottom:16px;">Patient introuvable —
                                    remplissez la <strong>fiche minimale</strong> pour l'ajouter :</p>
                                <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;">
                                    <div class="form-group">
                                        <label for="prdvNouveauNom">Nom *</label>
                                        <input type="text" id="prdvNouveauNom" class="form-select" placeholder="Nom">
                                        <span class="field-error" id="prdvNouveauNomError"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="prdvNouveauPrenom">Prénom *</label>
                                        <input type="text" id="prdvNouveauPrenom" class="form-select"
                                            placeholder="Prénom">
                                        <span class="field-error" id="prdvNouveauPrenomError"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="prdvNouveauTel">Téléphone *</label>
                                        <input type="tel" id="prdvNouveauTel" class="form-select"
                                            placeholder="06 XX XX XX XX">
                                        <span class="field-error" id="prdvNouveauTelError"></span>
                                    </div>
                                </div>
                                <button type="button" class="btn-primary" style="margin-top:12px;"
                                    onclick="prdvConfirmNewPatient()">
                                    Créer ce patient et continuer →
                                </button>
                            </div>

                            <!-- Patient sélectionné badge -->
                            <div id="prdvPatientBadge" style="display:none;margin-top:16px;">
                                <div class="prdv-patient-selected">
                                    <div class="prdv-avatar" id="prdvAvatarText">??</div>
                                    <div>
                                        <strong id="prdvPatientName">—</strong>
                                        <span id="prdvPatientTel"
                                            style="font-size:12px;color:#64748b;display:block;"></span>
                                    </div>
                                    <button type="button" class="btn-secondary"
                                        style="margin-left:auto;font-size:12px;padding:5px 12px;"
                                        onclick="prdvResetPatient()">Changer</button>
                                </div>
                            </div>
                        </div>

                        <!-- STEP 2 : Détails RDV (hidden until patient selected) -->
                        <div id="prdvFormCard" style="display:none;">

                            <!-- Dentiste + Motif -->
                            <div class="dash-card" style="margin-top:16px;">
                                <div class="card-header" style="margin-bottom:22px;">
                                    <h3><span class="prdv-step-badge">2</span>Détails du rendez-vous</h3>
                                </div>
                                <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
                                    <div class="form-group">
                                        <label for="prdvDentiste">Dentiste *</label>
                                        <select id="prdvDentiste" class="form-select" onchange="prdvDentisteChanged()">
                                            <option value="">Chargement…</option>
                                        </select>
                                        <span class="field-error" id="prdvDentisteError"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="prdvMotif">Motif de la visite *</label>
                                        <input type="text" id="prdvMotif" class="form-select"
                                            placeholder="Ex: Détartrage, Urgence…">
                                        <span class="field-error" id="prdvMotifError"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Calendrier créneau -->
                            <div class="dash-card" style="margin-top:16px;">
                                <div class="card-header" style="margin-bottom:16px;flex-wrap:wrap;gap:10px;">
                                    <h3><span class="prdv-step-badge">3</span>Choisir un créneau</h3>
                                    <div class="prdv-cal-nav" style="margin-left:auto;">
                                        <button type="button" class="btn-secondary"
                                            style="padding:6px 12px;font-size:12px;" onclick="prdvChangeWeek(-1)">←
                                            Préc.</button>
                                        <span id="prdvWeekLabel"
                                            style="font-size:13px;font-weight:600;color:#1e293b;white-space:nowrap;"></span>
                                        <button type="button" class="btn-secondary"
                                            style="padding:6px 12px;font-size:12px;" onclick="prdvChangeWeek(1)">Suiv.
                                            →</button>
                                    </div>
                                </div>
                                <div
                                    style="display:flex;gap:14px;flex-wrap:wrap;margin-bottom:14px;font-size:12px;color:#64748b;">
                                    <span style="display:inline-flex;align-items:center;gap:5px;"><span
                                            style="width:12px;height:12px;background:#fca5a5;border-radius:3px;display:inline-block;"></span>Occupé</span>
                                    <span style="display:inline-flex;align-items:center;gap:5px;"><span
                                            style="width:12px;height:12px;background:#86efac;border-radius:3px;display:inline-block;"></span>Disponible</span>
                                    <span style="display:inline-flex;align-items:center;gap:5px;"><span
                                            style="width:12px;height:12px;background:#1a6fa8;border-radius:3px;display:inline-block;"></span>Sélectionné</span>
                                    <span style="display:inline-flex;align-items:center;gap:5px;"><span
                                            style="width:12px;height:12px;background:#fef3c7;border:1px solid #fcd34d;border-radius:3px;display:inline-block;"></span>Pause
                                        déjeuner</span>
                                </div>
                                <span class="field-error" id="prdvCreneauError"></span>
                                <div id="prdvCalendar" class="prdv-calendar">
                                    <p style="color:#94a3b8;padding:20px;text-align:center;">Sélectionnez d'abord un
                                        dentiste.</p>
                                </div>
                                <div id="prdvSelectedSlot" style="display:none;margin-top:14px;"
                                    class="prdv-slot-selected-info">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        width="16" height="16">
                                        <circle cx="12" cy="12" r="10" />
                                        <path d="M12 6v6l4 2" />
                                    </svg>
                                    <span id="prdvSlotText"></span>
                                </div>
                            </div>

                            <!-- Notes -->
                            <div class="dash-card" style="margin-top:16px;">
                                <div class="card-header" style="margin-bottom:16px;">
                                    <h3><span class="prdv-step-badge">4</span>Notes internes <span
                                            style="font-weight:400;font-size:13px;color:#94a3b8;">(optionnel)</span>
                                    </h3>
                                </div>
                                <div class="form-group">
                                    <textarea id="prdvNotes" class="form-select" rows="3"
                                        placeholder="Observations, rappels, informations particulières…"
                                        style="resize:vertical;min-height:80px;width:100%;box-sizing:border-box;"></textarea>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="modal-actions" style="margin-top:8px;padding-bottom:40px;">
                                <button type="button" class="btn-secondary" onclick="prdvReset()">Annuler</button>
                                <button type="button" class="btn-primary" onclick="prdvSaveRdv()">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        width="15" height="15">
                                        <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z" />
                                        <polyline points="17 21 17 13 7 13 7 21" />
                                        <polyline points="7 3 7 8 15 8" />
                                    </svg>
                                    Enregistrer le RDV
                                </button>
                            </div>
                        </div>
                    </section>
                    <!-- ═══════════════════════════════════════════════════════════════ -->

                    <!-- SEARCH RDV -->
                    <section class="dash-section" id="section-search-rdv">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Chercher un RV</h1>
                                <p class="section-sub">Par nom ou téléphone du patient.</p>
                            </div>
                        </div>
                        <div class="search-bar-form">
                            <div class="search-bar" style="gap:10px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <circle cx="11" cy="11" r="8" />
                                    <path d="m21 21-4.35-4.35" />
                                </svg>
                                <input type="text" id="searchRdvNom" placeholder="Nom du patient…" required
                                    style="flex:1;">
                                <input type="tel" id="searchRdvTel" placeholder="N° Téléphone…" required
                                    style="flex:1; border-left: 1px solid #e2e8f0; padding-left: 10px;">
                                <button type="button" class="btn-primary" onclick="searchRdv()">Rechercher</button>
                            </div>
                            <span class="field-error" id="searchRdvError"></span>
                        </div>
                        <div id="searchRdvResults"></div>
                    </section>

                    <!-- SEARCH PATIENT -->
                    <section class="dash-section" id="section-search-patient">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Chercher un patient</h1>
                                <p class="section-sub">Par nom ou téléphone.</p>
                            </div>
                        </div>
                        <div class="search-bar-form">
                            <div class="search-bar" style="gap:10px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <circle cx="11" cy="11" r="8" />
                                    <path d="m21 21-4.35-4.35" />
                                </svg>
                                <input type="text" id="searchPatientNom" placeholder="Nom ou prénom…" required
                                    style="flex:1;">
                                <input type="tel" id="searchPatientTel" placeholder="N° Téléphone…" required
                                    style="flex:1; border-left: 1px solid #e2e8f0; padding-left: 10px;">
                                <button type="button" class="btn-primary" onclick="searchPatient()">Rechercher</button>
                            </div>
                            <span class="field-error" id="searchPatientError"></span>
                        </div>
                        <div id="searchPatientResults"></div>
                        <div id="patientDetailView" style="display:none;"></div>
                    </section>

                    <!-- ADD PATIENT -->
                    <!-- ADD PATIENT -->
                    <section class="dash-section" id="section-add-patient">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Ajouter un patient</h1>
                                <p class="section-sub">Enregistrez un nouveau patient.</p>
                            </div>
                        </div>
                        <div class="dash-card">
                            <form action="${pageContext.request.contextPath}/assistant/ajouter-patient" method="post"
                                class="modal-form" onsubmit="return validatePatientForm()">
                                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                                    <div class="form-group"><label for="nom">Nom *</label><input type="text" id="nom"
                                            name="nom" class="form-select" placeholder="Nom" required><span
                                            class="field-error" id="nomError"></span></div>
                                    <div class="form-group"><label for="prenom">Prénom *</label><input type="text"
                                            id="prenom" name="prenom" class="form-select" placeholder="Prénom"
                                            required><span class="field-error" id="prenomError"></span></div>
                                    <div class="form-group"><label for="telephone">Téléphone *</label><input type="tel"
                                            id="telephone" name="telephone" class="form-select"
                                            placeholder="06 XX XX XX XX" required><span class="field-error"
                                            id="telephoneError"></span></div>
                                    <div class="form-group"><label for="dateNaissance">Date de naissance *</label><input
                                            type="date" id="dateNaissance" name="dateNaissance" class="form-select"
                                            required onchange="checkAge()"><span class="field-error"
                                            id="dateNaissanceError"></span></div>
                                    <div class="form-group"><label for="sexe">Sexe *</label><select id="sexe"
                                            name="sexe" class="form-select" required>
                                            <option value="">--</option>
                                            <option value="H">Homme</option>
                                            <option value="F">Femme</option>
                                        </select><span class="field-error" id="sexeError"></span></div>
                                    <div class="form-group"><label for="adresse">Adresse *</label><input type="text"
                                            id="adresse" name="adresse" class="form-select" placeholder="Adresse"
                                            required><span class="field-error" id="adresseError"></span></div>
                                    <div class="form-group"><label for="email">Email</label><input type="email"
                                            id="email" name="email" class="form-select" placeholder="patient@email.com">
                                    </div>
                                    <div class="form-group"><label for="cnssMutuelle">CNSS / Mutuelle</label><input
                                            type="text" id="cnssMutuelle" name="cnssMutuelle" class="form-select"
                                            placeholder="N° CNSS"></div>
                                </div>

                                <!-- Responsable légal (shown if age < 18) -->
                                <div id="responsableSection"
                                    style="display:none;margin-top:20px;padding-top:20px;border-top:1px solid #e8edf3;">
                                    <div style="display:flex;align-items:center;gap:8px;margin-bottom:16px;">
                                        <span
                                            style="display:inline-flex;align-items:center;justify-content:center;width:22px;height:22px;background:#f59e0b;color:#fff;border-radius:50%;font-size:11px;font-weight:700;">!</span>
                                        <h4 style="margin:0;font-size:14px;font-weight:600;color:#92400e;">Patient
                                            mineur — Responsable légal requis</h4>
                                    </div>
                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                                        <div class="form-group">
                                            <label for="responsableNom">Nom du responsable *</label>
                                            <input type="text" id="responsableNom" name="responsableLegalNom"
                                                class="form-select" placeholder="Nom complet">
                                            <span class="field-error" id="responsableNomError"></span>
                                        </div>
                                        <div class="form-group">
                                            <label for="responsableTel">Téléphone du responsable *</label>
                                            <input type="tel" id="responsableTel" name="responsableLegalTel"
                                                class="form-select" placeholder="06 XX XX XX XX">
                                            <span class="field-error" id="responsableTelError"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-actions" style="margin-top:24px;">
                                    <button type="button" class="btn-secondary"
                                        onclick="showSection('overview')">Annuler</button>
                                    <button type="submit" class="btn-primary">Enregistrer le patient</button>
                                </div>
                            </form>
                        </div>
                    </section>

                    <!-- IMPORTER DONNÉES -->
                    <section class="dash-section" id="section-importer">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Importer des données</h1>
                                <p class="section-sub">Importez des patients depuis un fichier CSV ou Excel.</p>
                            </div>
                        </div>
                        <div class="dash-card">
                            <div style="margin-bottom:20px;">
                                <h4 style="font-size:13px;font-weight:600;color:#475569;margin-bottom:8px;">Format
                                    attendu du fichier :</h4>
                                <div
                                    style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:12px;font-size:12px;color:#64748b;font-family:monospace;">
                                    nom, prenom, telephone, dateNaissance (YYYY-MM-DD), sexe (H/F), adresse
                                </div>
                                <p style="font-size:12px;color:#94a3b8;margin-top:8px;">La première ligne peut être un
                                    en-tête (ignorée automatiquement). Formats acceptés : .csv, .txt</p>
                            </div>
                            <div id="importDropZone"
                                style="border:2px dashed #bfdbfe;border-radius:14px;padding:48px 24px;text-align:center;cursor:pointer;transition:all 0.2s;background:#f8fafc;"
                                onclick="document.getElementById('importFileInput').click()"
                                ondragover="event.preventDefault();this.style.borderColor='#1a6fa8';this.style.background='#eff6ff';"
                                ondragleave="this.style.borderColor='#bfdbfe';this.style.background='#f8fafc';"
                                ondrop="handleImportDrop(event)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="#1a6fa8" stroke-width="1.5" width="40"
                                    height="40" style="margin-bottom:12px;">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                    <polyline points="17 8 12 3 7 8" />
                                    <line x1="12" y1="3" x2="12" y2="15" />
                                </svg>
                                <p style="font-size:14px;font-weight:600;color:#1e293b;margin:0 0 6px;">Cliquez ou
                                    glissez un fichier ici</p>
                                <p style="font-size:12px;color:#94a3b8;margin:0;">CSV ou TXT uniquement</p>
                                <input type="file" id="importFileInput" accept=".csv,.txt" style="display:none;"
                                    onchange="handleImportFile(this)">
                            </div>
                            <div id="importPreview" style="display:none;margin-top:20px;"></div>
                            <div id="importActions" style="display:none;margin-top:16px;" class="modal-actions">
                                <button type="button" class="btn-secondary" onclick="importReset()">Annuler</button>
                                <button type="button" class="btn-primary" onclick="importConfirm()">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        width="15" height="15">
                                        <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z" />
                                    </svg>
                                    Importer dans la base
                                </button>
                            </div>
                            <div id="importResult" style="display:none;margin-top:16px;"></div>
                        </div>
                    </section>

                    <!-- DISPONIBILITÉ DENTISTES -->
                    <section class="dash-section" id="section-disponibilite">
                        <div class="section-hero">
                            <div>
                                <h1 class="section-title">Disponibilité des dentistes</h1>
                                <p class="section-sub">Vue d'ensemble de l'agenda du jour et de la semaine.</p>
                            </div>
                            <div class="planning-toggle">
                                <button class="toggle-btn active" id="dispBtnDay"
                                    onclick="dispSwitch('day')">Aujourd'hui</button>
                                <button class="toggle-btn" id="dispBtnWeek" onclick="dispSwitch('week')">Cette
                                    semaine</button>
                            </div>
                        </div>
                        <div id="dispContent">
                            <div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Chargement…
                            </div>
                        </div>
                    </section>

                </div><!-- end content-area -->
            </main>

            <!-- Status Modal -->
            <div class="modal-backdrop" id="statusModal">
                <div class="modal">
                    <div class="modal-header">
                        <h3>Modifier le statut</h3><button class="modal-close" onclick="closeStatusModal()"><svg
                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18" />
                                <line x1="6" y1="6" x2="18" y2="18" />
                            </svg></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/api/rdv/status" method="post" class="modal-form">
                        <input type="hidden" name="rdvId" id="statusRvId">
                        <div class="form-group">
                            <label for="newStatus">Nouveau statut</label>
                            <select name="status" id="newStatus" class="form-select">
                                <option value="PLANIFIE">Planifié</option>
                                <option value="EN_SALLE_D_ATTENTE">En salle d'attente</option>
                                <option value="ANNULE">Annulé</option>
                                <option value="NON_HONORE">Non honoré</option>
                            </select>
                        </div>
                        <div class="modal-actions"><button type="button" class="btn-secondary"
                                onclick="closeStatusModal()">Annuler</button><button type="submit"
                                class="btn-primary">Enregistrer</button></div>
                    </form>
                </div>
            </div>

            <!-- ═══ CONFIRMATION RDV MODAL (with email) ══════════════════════════ -->
            <div class="modal-backdrop" id="prdvConfirmModal">
                <div class="modal" style="max-width:560px;">
                    <div class="modal-header">
                        <h3 style="color:#15803d;">✅ Rendez-vous enregistré</h3>
                        <button class="modal-close" onclick="prdvCloseConfirm()"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18" />
                                <line x1="6" y1="6" x2="18" y2="18" />
                            </svg></button>
                    </div>
                    <div id="prdvConfirmContent" class="prdv-confirm-content" style="padding:4px 0 16px;"></div>
                    <div class="modal-actions" style="flex-wrap:wrap;gap:10px;">
                        <button type="button" class="btn-secondary" onclick="prdvCloseConfirm()">Fermer</button>
                        <button type="button" class="btn-primary" onclick="prdvGeneratePdf()">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15"
                                height="15">
                                <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                                <line x1="16" y1="13" x2="8" y2="13" />
                                <line x1="16" y1="17" x2="8" y2="17" />
                                <polyline points="10 9 9 9 8 9" />
                            </svg>
                            PDF
                        </button>
                        <button type="button" class="btn-primary" style="background:linear-gradient(135deg,#059669,#047857);" onclick="toggleRdvEmailBar()">
                            📧 Envoyer par email
                        </button>
                    </div>
                    <!-- Email send bar -->
                    <div id="rdvEmailBar" class="email-send-bar" style="display:none;">
                        <input type="email" id="rdvEmailInput" placeholder="patient@email.com" required>
                        <button type="button" class="btn-primary" style="padding:8px 16px;font-size:12px;white-space:nowrap;" onclick="sendRdvEmail()" id="rdvEmailSendBtn">Envoyer</button>
                    </div>
                    <div id="rdvEmailStatus" style="display:none;margin-top:8px;font-size:13px;padding:8px 14px;border-radius:8px;"></div>
                </div>
            </div>
            <!-- ══════════════════════════════════════════════════════════════════════ -->

            <script>
    /* EL data — must remain inline for JSP processing */
    var CTX = '${pageContext.request.contextPath}';
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
<script src="../js/dashboard-assistant.js"></script>

            <!-- ═══ EDIT RDV MODAL (full: includes dentist) ════════════════════════ -->
            <div class="modal-backdrop" id="editRdvModal">
                <div class="modal" style="max-width:600px;">
                    <div class="modal-header">
                        <h3>Modifier le rendez-vous</h3>
                        <button class="modal-close" onclick="closeEditRdvModal()"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18" />
                                <line x1="6" y1="6" x2="18" y2="18" />
                            </svg></button>
                    </div>
                    <div class="modal-form" id="editRdvForm">
                        <input type="hidden" id="editRdvId">
                        <!-- Patient info (read-only) -->
                        <div style="background:#f0f6fc;border:1.5px solid #bfdbfe;border-radius:10px;padding:12px 16px;margin-bottom:16px;">
                            <span style="font-size:11px;color:#94a3b8;text-transform:uppercase;font-weight:600;">Patient</span>
                            <div id="editRdvPatientInfo" style="font-weight:600;font-size:14px;color:#1e293b;">—</div>
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                            <div class="form-group">
                                <label for="editRdvDentiste">Dentiste *</label>
                                <select id="editRdvDentiste" class="form-select">
                                    <option value="">Chargement…</option>
                                </select>
                                <span class="field-error" id="editRdvDentisteError"></span>
                            </div>
                            <div class="form-group">
                                <label for="editRdvDate">Date *</label>
                                <input type="date" id="editRdvDate" class="form-select">
                                <span class="field-error" id="editRdvDateError"></span>
                            </div>
                            <div class="form-group">
                                <label for="editRdvHeure">Heure de début *</label>
                                <input type="time" id="editRdvHeure" class="form-select" step="900">
                                <span class="field-error" id="editRdvHeureError"></span>
                            </div>
                            <div class="form-group">
                                <label for="editRdvMotif">Motif *</label>
                                <input type="text" id="editRdvMotif" class="form-select"
                                    placeholder="Motif de la visite">
                                <span class="field-error" id="editRdvMotifError"></span>
                            </div>
                            <div class="form-group">
                                <label for="editRdvStatut">Statut *</label>
                                <select id="editRdvStatut" class="form-select">
                                    <option value="PLANIFIE">Planifié</option>
                                    <option value="EN_SALLE_D_ATTENTE">En salle d'attente</option>
                                    <option value="EN_COURS">En cours</option>
                                    <option value="TERMINE">Terminé</option>
                                    <option value="ANNULE">Annulé</option>
                                    <option value="NON_HONORE">Non honoré</option>
                                </select>
                            </div>
                            <div class="form-group" style="grid-column:1/-1;">
                                <label for="editRdvNotes">Notes internes</label>
                                <textarea id="editRdvNotes" class="form-select" rows="2"
                                    style="resize:vertical;width:100%;box-sizing:border-box;"></textarea>
                            </div>
                        </div>
                        <div class="modal-actions" style="margin-top:16px;">
                            <button type="button" class="btn-secondary" onclick="closeEditRdvModal()">Annuler</button>
                            <button type="button" class="btn-primary" onclick="saveEditRdv()">Enregistrer les
                                modifications</button>
                        </div>
                    </div>
                </div>
            </div>

            

            <!-- ═══ FACTURE MODAL ═══════════════════════════════════════════════════ -->
            <div class="modal-backdrop" id="factureModal">
                <div class="modal" style="max-width:600px;">
                    <div class="modal-header">
                        <h3>&#x1F4C4; Facturer le rendez-vous</h3>
                        <button class="modal-close" onclick="closeFactureModal()"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18" />
                                <line x1="6" y1="6" x2="18" y2="18" />
                            </svg></button>
                    </div>
                    <div id="factureModalBody" style="padding:4px 0 8px;">
                        <div style="text-align:center;padding:30px;color:#94a3b8;">Chargement des actes…</div>
                    </div>
                </div>
            </div>

            
        </body>

        </html>