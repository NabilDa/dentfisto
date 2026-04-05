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
            <style>
                /* ── Programmer RDV specific styles ── */
                .prdv-step-badge {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 22px;
                    height: 22px;
                    background: linear-gradient(135deg, #1a6fa8, #0f4f7e);
                    color: #fff;
                    border-radius: 50%;
                    font-size: 12px;
                    font-weight: 700;
                    margin-right: 8px;
                    flex-shrink: 0;
                }

                .prdv-patient-selected {
                    display: flex;
                    align-items: center;
                    gap: 14px;
                    background: #f0f6fc;
                    border: 1.5px solid #bfdbfe;
                    border-radius: 12px;
                    padding: 12px 16px;
                }

                .prdv-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #1a6fa8, #0f4f7e);
                    color: #fff;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 14px;
                    font-weight: 700;
                    flex-shrink: 0;
                }

                /* Calendar grid */
                .prdv-calendar {
                    overflow-x: auto;
                }

                .prdv-cal-grid {
                    display: grid;
                    min-width: 560px;
                    border: 1px solid #e8edf3;
                    border-radius: 12px;
                    overflow: hidden;
                }

                .prdv-cal-header {
                    display: grid;
                    background: #f8fafc;
                    border-bottom: 1px solid #e8edf3;
                }

                .prdv-cal-day-head {
                    padding: 10px 6px;
                    text-align: center;
                    font-size: 12px;
                    font-weight: 600;
                    color: #475569;
                    border-right: 1px solid #e8edf3;
                }

                .prdv-cal-day-head:last-child {
                    border-right: none;
                }

                .prdv-cal-day-head.today {
                    color: #1a6fa8;
                    background: #eff6ff;
                }

                .prdv-cal-body {
                    display: grid;
                }

                .prdv-cal-row {
                    display: grid;
                    border-bottom: 1px solid #f1f5f9;
                }

                .prdv-cal-row:last-child {
                    border-bottom: none;
                }

                .prdv-time-label {
                    padding: 0 10px;
                    display: flex;
                    align-items: center;
                    font-size: 11px;
                    font-weight: 600;
                    color: #94a3b8;
                    background: #f8fafc;
                    border-right: 1px solid #e8edf3;
                    white-space: nowrap;
                    min-height: 44px;
                }

                .prdv-slot {
                    min-height: 44px;
                    border-right: 1px solid #f1f5f9;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 11px;
                    transition: background 0.15s;
                }

                .prdv-slot:last-child {
                    border-right: none;
                }

                .prdv-slot.booked {
                    background: #fef2f2;
                    color: #ef4444;
                    font-weight: 600;
                    cursor: not-allowed;
                    font-size: 10px;
                    text-align: center;
                    padding: 2px;
                }

                .prdv-slot.available {
                    background: #f0fdf4;
                    color: #15803d;
                    cursor: pointer;
                }

                .prdv-slot.available:hover {
                    background: #dcfce7;
                }

                .prdv-slot.selected {
                    background: linear-gradient(135deg, #1a6fa8, #0f4f7e);
                    color: #fff;
                    font-weight: 700;
                    cursor: pointer;
                }

                .prdv-slot.past {
                    background: #f8fafc;
                    color: #cbd5e1;
                    cursor: not-allowed;
                }

                .prdv-slot.lunch {
                    background: #fffbeb;
                    color: #d97706;
                    cursor: not-allowed;
                    font-size: 10px;
                }

                .prdv-slot-selected-info {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    background: #eff6ff;
                    border: 1.5px solid #bfdbfe;
                    border-radius: 10px;
                    padding: 10px 14px;
                    font-size: 13px;
                    color: #1a6fa8;
                    font-weight: 500;
                }

                .prdv-confirm-content .ci-row {
                    display: flex;
                    gap: 10px;
                    padding: 9px 0;
                    border-bottom: 1px solid #f1f5f9;
                    font-size: 13.5px;
                }

                .prdv-confirm-content .ci-row:last-child {
                    border-bottom: none;
                }

                .prdv-confirm-content .ci-label {
                    min-width: 130px;
                    color: #64748b;
                    font-size: 12px;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                }

                .prdv-confirm-content .ci-val {
                    color: #1e293b;
                    font-weight: 500;
                }

                .prdv-cal-nav {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
            </style>
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

            <!-- ═══ CONFIRMATION RDV MODAL ════════════════════════════════════════════ -->
            <div class="modal-backdrop" id="prdvConfirmModal">
                <div class="modal" style="max-width:520px;">
                    <div class="modal-header">
                        <h3 style="color:#15803d;">✅ Rendez-vous enregistré</h3>
                        <button class="modal-close" onclick="prdvCloseConfirm()"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18" />
                                <line x1="6" y1="6" x2="18" y2="18" />
                            </svg></button>
                    </div>
                    <div id="prdvConfirmContent" class="prdv-confirm-content" style="padding:4px 0 16px;"></div>
                    <div class="modal-actions">
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
                            Télécharger confirmation PDF
                        </button>
                    </div>
                </div>
            </div>
            <!-- ══════════════════════════════════════════════════════════════════════ -->

            <script>
                /* ════════════════════════════════════════════════════════
                   CONTEXT PATH (extracted from logout link)
                ════════════════════════════════════════════════════════ */
                var CTX = '${pageContext.request.contextPath}';

                /* ════════════════════════════════════════════════════════
                   GENERAL HELPERS
                ════════════════════════════════════════════════════════ */
                document.getElementById('currentDate').textContent = new Date().toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
                var dayLabel = document.getElementById('dayLabel');
                if (dayLabel) dayLabel.textContent = new Date().toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

                var sectionLabels = {
                    overview: 'Tableau de bord',
                    planning: 'Planning',
                    'programmer-rdv': 'Programmer RDV',
                    'search-rdv': 'Chercher RV',
                    'search-patient': 'Chercher Patient',
                    'add-patient': 'Ajouter patient',
                    'importer': 'Importer données',
                    'disponibilite': 'Disponibilité dentistes'
                };

                function showSection(name) {
                    document.querySelectorAll('.dash-section').forEach(function (s) { s.classList.remove('active'); });
                    document.querySelectorAll('.nav-item').forEach(function (n) { n.classList.remove('active'); });
                    var sec = document.getElementById('section-' + name); if (sec) sec.classList.add('active');
                    var nav = document.querySelector('[data-section="' + name + '"]'); if (nav) nav.classList.add('active');
                    document.getElementById('breadcrumbText').textContent = sectionLabels[name] || name;
                    window.scrollTo(0, 0);
                }

                document.querySelectorAll('.nav-item').forEach(function (item) {
                    item.addEventListener('click', function (e) { e.preventDefault(); if (this.dataset.section) showSection(this.dataset.section); });
                });

                document.getElementById('sidebarToggle').addEventListener('click', function () {
                    document.getElementById('sidebar').classList.toggle('collapsed');
                    document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed');
                });

                function switchPlanning(mode) {
                    document.getElementById('planningDay').style.display = mode === 'day' ? '' : 'none';
                    document.getElementById('planningWeek').style.display = mode === 'week' ? '' : 'none';
                    document.getElementById('btnDay').classList.toggle('active', mode === 'day');
                    document.getElementById('btnWeek').classList.toggle('active', mode === 'week');
                    if (mode === 'week') buildWeeklyCalendar();
                }

                function openStatusModal(id, status) { document.getElementById('statusRvId').value = id; document.getElementById('newStatus').value = status; document.getElementById('statusModal').classList.add('open'); }
                function closeStatusModal() { document.getElementById('statusModal').classList.remove('open'); }
                document.getElementById('statusModal').addEventListener('click', function (e) { if (e.target === this) closeStatusModal(); });

                document.querySelectorAll('.rv-item[data-rdv-id], .time-slot[data-rdv-id]').forEach(function (item) {
                    item.addEventListener('click', function () {
                        var id = this.getAttribute('data-rdv-id');
                        var statut = this.getAttribute('data-statut');
                        if (statut === 'EN_SALLE_D_ATTENTE' || statut === 'PLANIFIE') openStatusModal(id, statut);
                    });
                });

                function showError(id, msg) { var el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = 'block'; } }
                function clearError(id) { var el = document.getElementById(id); if (el) { el.textContent = ''; el.style.display = 'none'; } }
                function esc(s) { if (!s) return ''; return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }

                /* ════════════════════════════════════════════════════════
                   SEARCH RDV
                ════════════════════════════════════════════════════════ */
                function searchRdv() {
                    var nom = document.getElementById('searchRdvNom').value.trim();
                    var tel = document.getElementById('searchRdvTel').value.trim();
                    clearError('searchRdvError');
                    if (!nom || !tel) { showError('searchRdvError', 'Veuillez saisir le nom ET le téléphone.'); return; }
                    fetch(CTX + '/api/search?type=rdv&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            var div = document.getElementById('searchRdvResults');
                            if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun résultat.</div>'; return; }
                            var html = '<div class="dash-card"><div class="table-wrapper"><table class="data-table"><thead><tr><th>Patient</th><th>Date</th><th>Heure</th><th>Motif</th><th>Statut</th><th>Actions</th></tr></thead><tbody>';
                            data.results.forEach(function (r) {
                                var sc = r.statut === 'EN_COURS' ? 'in_progress' : r.statut === 'PLANIFIE' ? 'confirmed' : r.statut === 'TERMINE' ? 'done' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'pending' : 'cancelled';
                                html += '<tr><td class="td-bold">' + r.patient + '</td><td>' + r.date + '</td><td>' + r.heure + '</td><td>' + r.motif + '</td><td><span class="rv-status status-' + sc + '">' + r.statut + '</span></td>';
                                html += '<td class="td-actions"><button class="btn-table btn-edit" onclick="openEditRdvModal(' + r.id + ')">Modifier</button>';
                                if (r.statut === 'TERMINE') {
                                    html += ' <button class="btn-table" style="background:#f0fdf4;color:#15803d;border:1px solid #86efac;margin-left:6px;" onclick="openFactureModal(' + r.id + ',\'' + esc(r.patient) + '\',\'' + esc(r.date) + '\',' + r.patientId + ')">&#x1F4B6; Facturer</button>';
                                }
                                html += '</td></tr>';
                            });
                            html += '</tbody></table></div></div>';
                            div.innerHTML = html;
                        });
                }

                /* ════════════════════════════════════════════════════════
                   SEARCH PATIENT
                ════════════════════════════════════════════════════════ */
                function searchPatient() {
                    var nom = document.getElementById('searchPatientNom').value.trim();
                    var tel = document.getElementById('searchPatientTel').value.trim();
                    clearError('searchPatientError');
                    if (!nom || !tel) { showError('searchPatientError', 'Veuillez saisir le nom ET le téléphone.'); return; }
                    fetch(CTX + '/api/search?type=patient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            var div = document.getElementById('searchPatientResults');
                            document.getElementById('patientDetailView').style.display = 'none';
                            if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun patient trouvé.</div>'; return; }
                            var html = '<div class="patient-grid">';
                            data.results.forEach(function (p) {
                                html += '<div class="patient-card" style="cursor:pointer" onclick="showPatientOnly(' + p.id + ')">';
                                html += '<div class="patient-avatar">' + p.nom.charAt(0) + p.prenom.charAt(0) + '</div>';
                                html += '<div class="patient-info"><span class="patient-name">' + p.nom + ' ' + p.prenom + '</span><span class="patient-meta">' + p.tel + '</span></div>';
                                html += '</div>';
                            });
                            html += '</div>';
                            div.innerHTML = html;
                        });
                }

                function showPatientOnly(patientId) {
                    var section = document.getElementById('section-search-patient');
                    section.querySelector('.search-bar-form').style.display = 'none';
                    document.getElementById('searchPatientResults').style.display = 'none';
                    var div = document.getElementById('patientDetailView');
                    div.style.display = 'block';
                    div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement…</div>';
                    fetch(CTX + '/api/search?type=patientDetail&id=' + patientId)
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                            div.innerHTML = buildPatientOnlyHTML(data);
                        })
                        .catch(function () { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>'; });
                }

                function backToPatientSearch() {
                    var section = document.getElementById('section-search-patient');
                    section.querySelector('.search-bar-form').style.display = '';
                    document.getElementById('searchPatientResults').style.display = '';
                    document.getElementById('patientDetailView').style.display = 'none';
                }

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
                    html += '</div></div></div>';
                    return html;
                }

                function infoRow(label, val) {
                    return '<div class="dossier-info-row"><span class="di-label">' + label + '</span><span class="di-val">' + esc(val || '') + '</span></div>';
                }

                /* ════════════════════════════════════════════════════════
                   WEEKLY CALENDAR (Planning section)
                ════════════════════════════════════════════════════════ */
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
                    var dayOfWeek = today.getDay();
                    var mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
                    var monday = new Date(today);
                    monday.setDate(today.getDate() + mondayOffset);
                    var days = [];
                    var dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
                    for (var i = 0; i < 6; i++) { var d = new Date(monday); d.setDate(monday.getDate() + i); days.push(d); }
                    var hours = [];
                    for (var h = 8; h <= 18; h++) hours.push(h);
                    var html = '<div class="wcal-grid" style="grid-template-columns: 60px repeat(6, 1fr);">';
                    html += '<div class="wcal-corner"></div>';
                    days.forEach(function (d, idx) {
                        var isToday = d.toDateString() === today.toDateString();
                        html += '<div class="wcal-day-header' + (isToday ? ' wcal-today' : '') + '">';
                        html += '<span class="wcal-day-name">' + dayNames[idx] + '</span>';
                        html += '<span class="wcal-day-num' + (isToday ? ' wcal-today-num' : '') + '">' + d.getDate() + '</span>';
                        html += '<span class="wcal-day-month">' + d.toLocaleDateString('fr-FR', { month: 'short' }) + '</span>';
                        html += '</div>';
                    });
                    hours.forEach(function (h) {
                        var timeStr = (h < 10 ? '0' : '') + h + ':00';
                        html += '<div class="wcal-time-label">' + timeStr + '</div>';
                        days.forEach(function (d) {
                            var dateStr = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
                            var isToday = d.toDateString() === today.toDateString();
                            var cellRdvs = weekRdvData.filter(function (r) { return r.date === dateStr && parseInt(r.heure.split(':')[0], 10) === h; });
                            html += '<div class="wcal-cell' + (isToday ? ' wcal-cell-today' : '') + '">';
                            cellRdvs.forEach(function (r) {
                                var cls = r.statut === 'PLANIFIE' ? 'ev-blue' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'ev-amber' : r.statut === 'EN_COURS' ? 'ev-blue' : r.statut === 'TERMINE' ? 'ev-green' : 'ev-grey';
                                html += '<div class="wcal-event ' + cls + '" title="' + esc(r.patient) + ' – ' + esc(r.motif) + '">';
                                html += '<span class="wcal-event-time">' + r.heure.substring(0, 5) + '</span>';
                                html += '<span class="wcal-event-name">' + esc(r.patient) + '</span>';
                                html += '</div>';
                            });
                            html += '</div>';
                        });
                    });
                    html += '</div>';
                    cal.innerHTML = html;
                }

                function validatePatientForm() {
                    var ok = true;
                    ['nom', 'prenom', 'telephone', 'dateNaissance', 'sexe', 'adresse'].forEach(function (f) {
                        clearError(f + 'Error');
                        if (!document.getElementById(f).value.trim()) { showError(f + 'Error', 'Ce champ est obligatoire.'); ok = false; }
                    });
                    return ok;
                }

                /* ════════════════════════════════════════════════════════════════════
                   PROGRAMMER RDV — Full feature
                ════════════════════════════════════════════════════════════════════ */
                var prdvState = {
                    patientId: null,
                    patientNom: '', patientPrenom: '', patientTel: '',
                    isNewPatient: false,
                    dentisteId: null,
                    selectedDate: null,   // 'YYYY-MM-DD'
                    selectedHeure: null,  // 'HH:MM'
                    weekOffset: 0,
                    bookedSlots: [],
                    lastRdvData: null
                };

                function prdvErr(id, msg) { var el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = msg ? 'block' : 'none'; } }
                function prdvClearErr(id) { prdvErr(id, ''); }

                function prdvInitials(nom, prenom) { return ((nom || '').charAt(0) + (prenom || '').charAt(0)).toUpperCase(); }

                function prdvFmtDate(str) {
                    if (!str) return '';
                    var d = new Date(str + 'T00:00:00');
                    return d.toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
                }

                /* ── Step 1: Patient Search ───────────────────────────────────── */
                function prdvSearchPatient() {
                    var nom = document.getElementById('prdvSearchNom').value.trim();
                    var tel = document.getElementById('prdvSearchTel').value.trim();
                    prdvClearErr('prdvSearchError');
                    if (!nom) { prdvErr('prdvSearchError', 'Saisissez au moins le nom.'); return; }

                    // Uses dedicated endpoint that accepts empty tel (searches by name only if no tel given)
                    fetch(CTX + '/assistant/programmer-rdv?action=searchPatient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            var div = document.getElementById('prdvSearchResults');
                            document.getElementById('prdvFicheMinimale').style.display = 'none';
                            if (!data.results || !data.results.length) {
                                document.getElementById('prdvNouveauNom').value = nom;
                                document.getElementById('prdvNouveauTel').value = tel;
                                div.innerHTML = '<p style="color:#f59e0b;font-size:13px;padding:8px 0;margin:0;">Aucun patient trouvé avec ces critères.</p>';
                                document.getElementById('prdvFicheMinimale').style.display = 'block';
                                return;
                            }
                            var html = '<div class="patient-grid" style="margin-top:12px;">';
                            data.results.forEach(function (p) {
                                html += '<div class="patient-card" style="cursor:pointer;border:1.5px solid #e8edf3;transition:border-color 0.15s;" onmouseover="this.style.borderColor=\'#1a6fa8\'" onmouseout="this.style.borderColor=\'#e8edf3\'" onclick="prdvSelectPatient(' + p.id + ',\'' + esc(p.nom) + '\',\'' + esc(p.prenom) + '\',\'' + esc(p.tel) + '\')">';
                                html += '<div class="patient-avatar">' + (p.nom || '').charAt(0) + (p.prenom || '').charAt(0) + '</div>';
                                html += '<div class="patient-info"><span class="patient-name">' + esc(p.nom) + ' ' + esc(p.prenom) + '</span><span class="patient-meta">' + esc(p.tel) + '</span></div>';
                                html += '<svg viewBox="0 0 24 24" fill="none" stroke="#1a6fa8" stroke-width="2" width="18" height="18" style="margin-left:auto;flex-shrink:0;"><polyline points="9 18 15 12 9 6"/></svg>';
                                html += '</div>';
                            });
                            html += '</div>';
                            div.innerHTML = html;
                        })
                        .catch(function () { prdvErr('prdvSearchError', 'Erreur de connexion.'); });
                }

                function prdvSelectPatient(id, nom, prenom, tel) {
                    prdvState.patientId = parseInt(id, 10);  // ensure integer
                    prdvState.patientNom = nom;
                    prdvState.patientPrenom = prenom;
                    prdvState.patientTel = tel;
                    prdvState.isNewPatient = false;
                    prdvShowPatientBadge();
                    prdvShowForm();
                }

                function prdvConfirmNewPatient() {
                    var nom = document.getElementById('prdvNouveauNom').value.trim();
                    var prenom = document.getElementById('prdvNouveauPrenom').value.trim();
                    var tel = document.getElementById('prdvNouveauTel').value.trim();
                    var ok = true;
                    ['prdvNouveauNomError', 'prdvNouveauPrenomError', 'prdvNouveauTelError'].forEach(function (e) { prdvClearErr(e); });
                    if (!nom) { prdvErr('prdvNouveauNomError', 'Obligatoire'); ok = false; }
                    if (!prenom) { prdvErr('prdvNouveauPrenomError', 'Obligatoire'); ok = false; }
                    if (!tel) { prdvErr('prdvNouveauTelError', 'Obligatoire'); ok = false; }
                    if (!ok) return;
                    prdvState.patientId = null;         // will be created server-side at save
                    prdvState.isNewPatient = true;      // must be true so save sends nouveauNom/Prenom/Tel
                    prdvState.patientNom = nom;
                    prdvState.patientPrenom = prenom;
                    prdvState.patientTel = tel;
                    prdvShowPatientBadge();
                    prdvShowForm();
                }

                function prdvShowPatientBadge() {
                    document.getElementById('prdvAvatarText').textContent = prdvInitials(prdvState.patientNom, prdvState.patientPrenom);
                    document.getElementById('prdvPatientName').textContent = prdvState.patientNom + ' ' + prdvState.patientPrenom + (prdvState.isNewPatient ? ' (nouveau)' : '');
                    document.getElementById('prdvPatientTel').textContent = prdvState.patientTel;
                    document.getElementById('prdvPatientBadge').style.display = 'block';
                    document.getElementById('prdvSearchResults').innerHTML = '';
                    document.getElementById('prdvFicheMinimale').style.display = 'none';
                }

                function prdvResetPatient() {
                    prdvState.patientId = null; prdvState.isNewPatient = false;
                    document.getElementById('prdvPatientBadge').style.display = 'none';
                    document.getElementById('prdvFormCard').style.display = 'none';
                    document.getElementById('prdvSearchNom').value = '';
                    document.getElementById('prdvSearchTel').value = '';
                    document.getElementById('prdvSearchResults').innerHTML = '';
                    document.getElementById('prdvFicheMinimale').style.display = 'none';
                    prdvState.selectedDate = null; prdvState.selectedHeure = null;
                }

                function prdvShowForm() {
                    document.getElementById('prdvFormCard').style.display = 'block';
                    prdvLoadDentistes();
                    prdvState.weekOffset = 0;
                    prdvRenderCalendar();
                }

                /* ── Step 2a: Load dentists ──────────────────────────────────── */
                function prdvLoadDentistes() {
                    fetch(CTX + '/assistant/programmer-rdv?action=dentistes')
                        .then(function (r) { return r.json(); })
                        .then(function (dentistes) {
                            var sel = document.getElementById('prdvDentiste');
                            sel.innerHTML = '<option value="">— Choisir un dentiste —</option>';
                            dentistes.forEach(function (d) {
                                var opt = document.createElement('option');
                                opt.value = d.id;
                                opt.textContent = 'Dr. ' + d.login;
                                sel.appendChild(opt);
                            });
                        })
                        .catch(function () {
                            document.getElementById('prdvDentiste').innerHTML = '<option value="">Erreur de chargement</option>';
                        });
                }

                function prdvDentisteChanged() {
                    prdvState.dentisteId = document.getElementById('prdvDentiste').value || null;
                    prdvState.selectedDate = null;
                    prdvState.selectedHeure = null;
                    document.getElementById('prdvSelectedSlot').style.display = 'none';
                    prdvRenderCalendar();
                }

                /* ── Step 2b: Calendar ───────────────────────────────────────── */
                function prdvGetWeekDays() {
                    var today = new Date();
                    var dow = today.getDay();
                    var mondayOff = dow === 0 ? -6 : 1 - dow;
                    var monday = new Date(today);
                    monday.setDate(today.getDate() + mondayOff + prdvState.weekOffset * 7);
                    var days = [];
                    for (var i = 0; i < 6; i++) {
                        var d = new Date(monday);
                        d.setDate(monday.getDate() + i);
                        days.push(d);
                    }
                    return days;
                }

                function prdvDateStr(d) {
                    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
                }

                function prdvChangeWeek(delta) {
                    prdvState.weekOffset += delta;
                    prdvState.selectedDate = null;
                    prdvState.selectedHeure = null;
                    document.getElementById('prdvSelectedSlot').style.display = 'none';
                    prdvRenderCalendar();
                }

                /* Working hours: 09:00–12:00 and 14:00–18:00 in 45-min slots */
                var PRDV_SLOTS = [
                    '09:00', '10:00', '11:00', '14:00',
                    '15:00', '16:00', '17:00', '18:00'
                ];

                function prdvRenderCalendar() {
                    var days = prdvGetWeekDays();
                    var dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
                    var today = new Date(); today.setHours(0, 0, 0, 0);

                    // Week label
                    var first = days[0], last = days[days.length - 1];
                    document.getElementById('prdvWeekLabel').textContent =
                        first.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' }) + ' – ' +
                        last.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short', year: 'numeric' });

                    if (!prdvState.dentisteId) {
                        document.getElementById('prdvCalendar').innerHTML =
                            '<p style="color:#94a3b8;padding:20px;text-align:center;">Sélectionnez d\'abord un dentiste.</p>';
                        return;
                    }

                    // Fetch booked slots for each visible day then render
                    var fetchPromises = days.map(function (d) {
                        return fetch(CTX + '/assistant/programmer-rdv?action=creneaux&dentisteId=' + prdvState.dentisteId + '&date=' + prdvDateStr(d))
                            .then(function (r) { return r.json(); })
                            .then(function (slots) { return { date: prdvDateStr(d), slots: slots }; })
                            .catch(function () { return { date: prdvDateStr(d), slots: [] }; });
                    });

                    Promise.all(fetchPromises).then(function (results) {
                        // Build booked map
                        var bookedMap = {};
                        results.forEach(function (r) { bookedMap[r.date] = r.slots; });

                        // Columns: time label + 6 days
                        var cols = 7;
                        var gridStyle = 'grid-template-columns: 64px repeat(6, 1fr);';

                        var html = '<div class="prdv-cal-grid"><div class="prdv-cal-header" style="' + gridStyle + '">';
                        html += '<div class="prdv-cal-day-head" style="background:#f8fafc;"></div>';
                        days.forEach(function (d, idx) {
                            var isToday = d.toDateString() === new Date().toDateString();
                            html += '<div class="prdv-cal-day-head' + (isToday ? ' today' : '') + '">';
                            html += '<div>' + dayNames[idx] + '</div>';
                            html += '<div style="font-size:16px;font-weight:700;">' + d.getDate() + '</div>';
                            html += '<div style="font-size:10px;color:#94a3b8;">' + d.toLocaleDateString('fr-FR', { month: 'short' }) + '</div>';
                            html += '</div>';
                        });
                        html += '</div>'; // end header

                        html += '<div class="prdv-cal-body">';
                        PRDV_SLOTS.forEach(function (slot) {
                            html += '<div class="prdv-cal-row" style="' + gridStyle + '">';
                            html += '<div class="prdv-time-label">' + slot + '</div>';
                            days.forEach(function (d) {
                                var ds = prdvDateStr(d);
                                var isPast = d < today || (d.toDateString() === new Date().toDateString() && slot < new Date().toTimeString().substring(0, 5));
                                var booked = (bookedMap[ds] || []).some(function (b) {
                                    return b.debut.substring(0, 5) === slot;
                                });
                                var isSelected = prdvState.selectedDate === ds && prdvState.selectedHeure === slot;

                                var cls, label, clickable;
                                if (isSelected) {
                                    cls = 'selected'; label = '✓ ' + slot; clickable = false;
                                } else if (booked) {
                                    cls = 'booked'; label = 'Occupé'; clickable = false;
                                } else if (isPast) {
                                    cls = 'past'; label = ''; clickable = false;
                                } else {
                                    cls = 'available'; label = slot; clickable = true;
                                }

                                html += '<div class="prdv-slot ' + cls + '"' +
                                    (clickable ? ' onclick="prdvSelectSlot(\'' + ds + '\',\'' + slot + '\')" title="Sélectionner ' + slot + '"' : '') + '>' +
                                    label + '</div>';
                            });
                            html += '</div>'; // end row
                        });
                        html += '</div></div>'; // end body + grid

                        document.getElementById('prdvCalendar').innerHTML = html;

                        // Restore selected slot display
                        if (prdvState.selectedDate && prdvState.selectedHeure) {
                            prdvShowSlotInfo();
                        }
                    });
                }

                function prdvSelectSlot(dateStr, heure) {
                    prdvState.selectedDate = dateStr;
                    prdvState.selectedHeure = heure;
                    prdvClearErr('prdvCreneauError');
                    prdvRenderCalendar(); // re-render to show selection
                    prdvShowSlotInfo();
                }

                function prdvShowSlotInfo() {
                    var el = document.getElementById('prdvSelectedSlot');
                    el.style.display = 'flex';
                    var endH = prdvState.selectedHeure ? (function () {
                        var parts = prdvState.selectedHeure.split(':');
                        var totalMin = parseInt(parts[0]) * 60 + parseInt(parts[1]) + 60;
                        return String(Math.floor(totalMin / 60)).padStart(2, '0') + ':' + String(totalMin % 60).padStart(2, '0');
                    })() : '';
                    document.getElementById('prdvSlotText').textContent =
                        prdvFmtDate(prdvState.selectedDate) + ' de ' + prdvState.selectedHeure + ' à ' + endH;
                }

                /* ── Save RDV ─────────────────────────────────────────────────── */
                function prdvSaveRdv() {
                    var ok = true;
                    prdvClearErr('prdvDentisteError');
                    prdvClearErr('prdvMotifError');
                    prdvClearErr('prdvCreneauError');

                    if (!document.getElementById('prdvDentiste').value) { prdvErr('prdvDentisteError', 'Choisissez un dentiste.'); ok = false; }
                    if (!document.getElementById('prdvMotif').value.trim()) { prdvErr('prdvMotifError', 'Le motif est obligatoire.'); ok = false; }
                    if (!prdvState.selectedDate || !prdvState.selectedHeure) { prdvErr('prdvCreneauError', 'Sélectionnez un créneau sur le calendrier.'); ok = false; }
                    if (!ok) return;

                    var params = new URLSearchParams();

                    // Determine patient source: existing ID takes priority over new-patient fields
                    if (prdvState.patientId !== null && prdvState.patientId !== undefined && String(prdvState.patientId).trim() !== '' && String(prdvState.patientId) !== '0') {
                        params.append('patientId', String(prdvState.patientId));
                    } else if (prdvState.isNewPatient && prdvState.patientNom && prdvState.patientPrenom && prdvState.patientTel) {
                        params.append('nouveauNom', prdvState.patientNom);
                        params.append('nouveauPrenom', prdvState.patientPrenom);
                        params.append('nouveauTel', prdvState.patientTel);
                    } else {
                        alert('Erreur : aucun patient sélectionné. Veuillez relancer la recherche patient.');
                        return;
                    }

                    params.append('dentisteId', document.getElementById('prdvDentiste').value);
                    params.append('motif', document.getElementById('prdvMotif').value.trim());
                    params.append('notesInternes', document.getElementById('prdvNotes').value.trim());
                    params.append('dateRdv', prdvState.selectedDate);
                    params.append('heureDebut', prdvState.selectedHeure + ':00');

                    var saveBtn = document.querySelector('[onclick="prdvSaveRdv()"]');
                    saveBtn.disabled = true; saveBtn.textContent = 'Enregistrement…';

                    var postBody = params.toString();
                    console.log('[PRDV] patientId=' + prdvState.patientId + ' isNewPatient=' + prdvState.isNewPatient);
                    console.log('[PRDV] POST body:', postBody);

                    fetch(CTX + '/assistant/programmer-rdv', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: postBody
                    })
                        .then(function (r) {
                            console.log('[PRDV] HTTP status:', r.status);
                            return r.text();
                        })
                        .then(function (text) {
                            console.log('[PRDV] Raw response:', text);
                            saveBtn.disabled = false;
                            saveBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg> Enregistrer le RDV';
                            var data;
                            try { data = JSON.parse(text); }
                            catch (e) { alert('Réponse invalide:\n' + text.substring(0, 300)); return; }
                            if (!data.success) {
                                alert('Erreur : ' + (data.message || 'Impossible d\'enregistrer.'));
                                return;
                            }
                            prdvState.lastRdvData = data;
                            prdvShowConfirm(data);
                        })
                        .catch(function (err) {
                            saveBtn.disabled = false;
                            console.error('[PRDV] Fetch error:', err);
                            alert('Erreur de connexion. Voir console F12.');
                        });
                }

                function prdvShowConfirm(d) {
                    var html = '';
                    function ciRow(label, val) { return '<div class="ci-row"><span class="ci-label">' + label + '</span><span class="ci-val">' + esc(val) + '</span></div>'; }
                    html += ciRow('Patient', d.patientNom + ' ' + d.patientPrenom);
                    html += ciRow('Téléphone', d.patientTel);
                    html += ciRow('Dentiste', 'Dr. ' + d.dentiste);
                    html += ciRow('Date', prdvFmtDate(d.dateRdv));
                    html += ciRow('Horaire', d.heureDebut.substring(0, 5) + ' – ' + d.heureFin.substring(0, 5));
                    html += ciRow('Motif', d.motif);
                    if (d.notes) html += ciRow('Notes', d.notes);
                    html += ciRow('Statut', 'PLANIFIÉ');
                    document.getElementById('prdvConfirmContent').innerHTML = html;
                    document.getElementById('prdvConfirmModal').classList.add('open');
                }

                function prdvCloseConfirm() {
                    document.getElementById('prdvConfirmModal').classList.remove('open');
                    prdvReset();
                }

                document.getElementById('prdvConfirmModal').addEventListener('click', function (e) {
                    if (e.target === this) prdvCloseConfirm();
                });

                /* ── PDF Generation (client-side via print) ───────────────────── */
                function prdvGeneratePdf() {
                    var d = prdvState.lastRdvData;
                    if (!d) return;

                    var endTime = d.heureFin ? d.heureFin.substring(0, 5) : '';

                    var html = '<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8">' +
                        '<title>Confirmation RDV – DentFisto</title>' +
                        '<style>' +
                        'body{font-family:Arial,sans-serif;color:#1e293b;margin:0;padding:40px;background:#fff;}' +
                        '.header{display:flex;align-items:center;justify-content:space-between;border-bottom:3px solid #1a6fa8;padding-bottom:20px;margin-bottom:30px;}' +
                        '.clinic-name{font-size:22px;font-weight:700;color:#1a6fa8;letter-spacing:-0.5px;}' +
                        '.doc-title{font-size:18px;font-weight:700;color:#1e293b;margin-bottom:24px;}' +
                        '.info-table{width:100%;border-collapse:collapse;margin-bottom:28px;}' +
                        '.info-table td{padding:11px 14px;font-size:13px;border-bottom:1px solid #f1f5f9;}' +
                        '.info-table .label{color:#64748b;font-weight:600;text-transform:uppercase;font-size:11px;letter-spacing:0.05em;width:160px;}' +
                        '.info-table .val{color:#1e293b;font-weight:500;}' +
                        '.status-badge{display:inline-block;background:#dcfce7;color:#15803d;padding:4px 14px;border-radius:20px;font-size:12px;font-weight:700;letter-spacing:0.05em;}' +
                        '.footer{margin-top:40px;padding-top:20px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;text-align:center;}' +
                        '.note-box{background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:14px;font-size:13px;color:#475569;margin-top:8px;}' +
                        '@media print{body{padding:20px;}button{display:none!important;}}' +
                        '</style></head><body>' +
                        '<div class="header"><div class="clinic-name">🦷 DentFisto</div>' +
                        '<div style="text-align:right;font-size:11px;color:#94a3b8;">Imprimé le ' + new Date().toLocaleDateString('fr-FR') + '</div></div>' +
                        '<div class="doc-title">Confirmation de Rendez-vous</div>' +
                        '<table class="info-table">' +
                        '<tr><td class="label">Patient</td><td class="val">' + esc(d.patientNom) + ' ' + esc(d.patientPrenom) + '</td></tr>' +
                        '<tr><td class="label">Téléphone</td><td class="val">' + esc(d.patientTel) + '</td></tr>' +
                        '<tr><td class="label">Dentiste</td><td class="val">Dr. ' + esc(d.dentiste) + '</td></tr>' +
                        '<tr><td class="label">Date</td><td class="val">' + prdvFmtDate(d.dateRdv) + '</td></tr>' +
                        '<tr><td class="label">Horaire</td><td class="val">' + d.heureDebut.substring(0, 5) + ' – ' + endTime + '</td></tr>' +
                        '<tr><td class="label">Motif</td><td class="val">' + esc(d.motif) + '</td></tr>' +
                        '<tr><td class="label">Statut</td><td class="val"><span class="status-badge">PLANIFIÉ</span></td></tr>' +
                        '</table>';

                    if (d.notes) {
                        html += '<div style="margin-bottom:4px;font-size:12px;font-weight:600;color:#64748b;text-transform:uppercase;letter-spacing:0.05em;">Notes</div>';
                        html += '<div class="note-box">' + esc(d.notes) + '</div>';
                    }

                    html += '<div class="footer">Ce document est une confirmation de rendez-vous générée par DentFisto.<br>' +
                        'En cas de question, veuillez contacter votre cabinet dentaire.</div>' +
                        '</body></html>';

                    var win = window.open('', '_blank', 'width=700,height=900');
                    win.document.write(html);
                    win.document.close();
                    win.focus();
                    setTimeout(function () { win.print(); }, 400);
                }

                /* ── Reset full form ──────────────────────────────────────────── */
                function prdvReset() {
                    prdvState = {
                        patientId: null, patientNom: '', patientPrenom: '', patientTel: '',
                        isNewPatient: false, dentisteId: null, selectedDate: null,
                        selectedHeure: null, weekOffset: 0, bookedSlots: [], lastRdvData: null
                    };
                    document.getElementById('prdvPatientBadge').style.display = 'none';
                    document.getElementById('prdvFormCard').style.display = 'none';
                    document.getElementById('prdvSearchResults').innerHTML = '';
                    document.getElementById('prdvFicheMinimale').style.display = 'none';
                    document.getElementById('prdvSearchNom').value = '';
                    document.getElementById('prdvSearchTel').value = '';
                    document.getElementById('prdvMotif').value = '';
                    document.getElementById('prdvNotes').value = '';
                    document.getElementById('prdvSelectedSlot').style.display = 'none';
                    ['prdvSearchError', 'prdvDentisteError', 'prdvMotifError', 'prdvCreneauError'].forEach(prdvClearErr);
                    showSection('overview');
                }
                /* ═══════════════════════════════════════════════════════════════════ */

                /* Page load animation */
                document.body.style.opacity = 0; document.body.style.transform = 'translateY(12px)';
                requestAnimationFrame(function () {
                    document.body.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
                    document.body.style.opacity = 1; document.body.style.transform = 'translateY(0)';
                });
            </script>

            <!-- ═══ EDIT RDV MODAL ═══════════════════════════════════════════════════ -->
            <div class="modal-backdrop" id="editRdvModal">
                <div class="modal" style="max-width:560px;">
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
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
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

            <script>
                /* ════════════════════════════════════════════════════════════
                   CHANGE 1 — Age check → show responsable légal
                ════════════════════════════════════════════════════════════ */
                function checkAge() {
                    var dateVal = document.getElementById('dateNaissance').value;
                    var sec = document.getElementById('responsableSection');
                    if (!dateVal) { sec.style.display = 'none'; return; }
                    var birth = new Date(dateVal);
                    var today = new Date();
                    var age = today.getFullYear() - birth.getFullYear();
                    var m = today.getMonth() - birth.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;
                    sec.style.display = age < 18 ? 'block' : 'none';
                    // toggle required
                    document.getElementById('responsableNom').required = age < 18;
                    document.getElementById('responsableTel').required = age < 18;
                }

                // Extend validatePatientForm to include responsable if visible
                var _origValidate = validatePatientForm;
                function validatePatientForm() {
                    var ok = _origValidate();
                    var sec = document.getElementById('responsableSection');
                    if (sec && sec.style.display !== 'none') {
                        if (!document.getElementById('responsableNom').value.trim()) {
                            showError('responsableNomError', 'Obligatoire pour un mineur.'); ok = false;
                        } else clearError('responsableNomError');
                        if (!document.getElementById('responsableTel').value.trim()) {
                            showError('responsableTelError', 'Obligatoire pour un mineur.'); ok = false;
                        } else clearError('responsableTelError');
                    }
                    return ok;
                }

                /* ════════════════════════════════════════════════════════════
                   CHANGE 2 — Import CSV
                ════════════════════════════════════════════════════════════ */
                var importParsedRows = [];

                function handleImportDrop(e) {
                    e.preventDefault();
                    document.getElementById('importDropZone').style.borderColor = '#bfdbfe';
                    document.getElementById('importDropZone').style.background = '#f8fafc';
                    var file = e.dataTransfer.files[0];
                    if (file) parseImportFile(file);
                }

                function handleImportFile(input) {
                    if (input.files[0]) parseImportFile(input.files[0]);
                }

                function parseImportFile(file) {
                    if (!file.name.match(/\.(csv|txt)$/i)) {
                        alert('Format non supporté. Utilisez un fichier .csv ou .txt');
                        return;
                    }
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var lines = e.target.result.split(/\r?\n/).filter(function (l) { return l.trim(); });
                        importParsedRows = [];
                        var startIdx = 0;
                        // Skip header if first line looks like labels
                        if (lines[0] && /nom|prenom|telephone|date/i.test(lines[0])) startIdx = 1;

                        var errors = [];
                        lines.slice(startIdx).forEach(function (line, idx) {
                            var cols = line.split(/[,;\t]/).map(function (c) { return c.trim().replace(/^"|"$/g, ''); });
                            if (cols.length < 3) { errors.push('Ligne ' + (idx + startIdx + 1) + ': pas assez de colonnes'); return; }
                            var row = {
                                nom: cols[0] || '',
                                prenom: cols[1] || '',
                                telephone: cols[2] || '',
                                dateNaissance: cols[3] || '1900-01-01',
                                sexe: cols[4] || 'H',
                                adresse: cols[5] || '—'
                            };
                            if (!row.nom || !row.prenom || !row.telephone) {
                                errors.push('Ligne ' + (idx + startIdx + 1) + ': nom, prénom ou téléphone manquant');
                                return;
                            }
                            importParsedRows.push(row);
                        });

                        var previewDiv = document.getElementById('importPreview');
                        previewDiv.style.display = 'block';
                        var html = '<div class="dash-card" style="padding:16px;">';
                        html += '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">';
                        html += '<strong style="font-size:14px;">' + importParsedRows.length + ' patient(s) prêts à importer</strong>';
                        if (errors.length) html += '<span style="font-size:12px;color:#ef4444;">' + errors.length + ' ligne(s) ignorée(s)</span>';
                        html += '</div>';
                        if (importParsedRows.length > 0) {
                            html += '<div class="table-wrapper"><table class="data-table"><thead><tr><th>Nom</th><th>Prénom</th><th>Téléphone</th><th>Date naissance</th><th>Sexe</th></tr></thead><tbody>';
                            importParsedRows.slice(0, 10).forEach(function (r) {
                                html += '<tr><td>' + esc(r.nom) + '</td><td>' + esc(r.prenom) + '</td><td>' + esc(r.telephone) + '</td><td>' + esc(r.dateNaissance) + '</td><td>' + esc(r.sexe) + '</td></tr>';
                            });
                            if (importParsedRows.length > 10) html += '<tr><td colspan="5" style="text-align:center;color:#94a3b8;font-size:12px;">… et ' + (importParsedRows.length - 10) + ' autres</td></tr>';
                            html += '</tbody></table></div>';
                        }
                        if (errors.length) {
                            html += '<div style="margin-top:10px;font-size:12px;color:#ef4444;">' + errors.join('<br>') + '</div>';
                        }
                        html += '</div>';
                        previewDiv.innerHTML = html;
                        document.getElementById('importActions').style.display = importParsedRows.length > 0 ? 'flex' : 'none';
                        document.getElementById('importResult').style.display = 'none';
                    };
                    reader.readAsText(file, 'UTF-8');
                }

                function importConfirm() {
                    if (!importParsedRows.length) return;
                    var btn = document.querySelector('[onclick="importConfirm()"]');
                    btn.disabled = true; btn.textContent = 'Importation en cours…';

                    var params = new URLSearchParams();
                    params.append('data', JSON.stringify(importParsedRows));

                    fetch(CTX + '/assistant/importer-patients', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            btn.disabled = false; btn.textContent = 'Importer dans la base';
                            var res = document.getElementById('importResult');
                            res.style.display = 'block';
                            if (data.success) {
                                res.innerHTML = '<div style="background:#f0fdf4;border:1px solid #86efac;border-radius:10px;padding:14px;font-size:13px;color:#15803d;">✅ ' + data.imported + ' patient(s) importé(s) avec succès. ' + (data.skipped > 0 ? data.skipped + ' ignoré(s) (doublons).' : '') + '</div>';
                                importReset();
                            } else {
                                res.innerHTML = '<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:10px;padding:14px;font-size:13px;color:#dc2626;">❌ Erreur : ' + esc(data.message) + '</div>';
                            }
                        })
                        .catch(function () {
                            btn.disabled = false;
                            alert('Erreur de connexion.');
                        });
                }

                function importReset() {
                    importParsedRows = [];
                    document.getElementById('importPreview').style.display = 'none';
                    document.getElementById('importActions').style.display = 'none';
                    document.getElementById('importFileInput').value = '';
                }

                /* ════════════════════════════════════════════════════════════
                   CHANGE 3 — Disponibilité dentistes
                ════════════════════════════════════════════════════════════ */
                var dispMode = 'day';

                document.querySelector('[data-section="disponibilite"]').addEventListener('click', function () {
                    loadDisponibilite();
                });

                function dispSwitch(mode) {
                    dispMode = mode;
                    document.getElementById('dispBtnDay').classList.toggle('active', mode === 'day');
                    document.getElementById('dispBtnWeek').classList.toggle('active', mode === 'week');
                    loadDisponibilite();
                }

                function loadDisponibilite() {
                    var div = document.getElementById('dispContent');
                    div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Chargement…</div>';
                    fetch(CTX + '/assistant/programmer-rdv?action=dentistes')
                        .then(function (r) { return r.json(); })
                        .then(function (dentistes) {
                            if (!dentistes.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun dentiste trouvé.</div>'; return; }

                            var today = new Date();
                            var dates = [];
                            if (dispMode === 'day') {
                                dates = [today];
                            } else {
                                var dow = today.getDay(); var off = dow === 0 ? -6 : 1 - dow;
                                for (var i = 0; i < 6; i++) { var d = new Date(today); d.setDate(today.getDate() + off + i); dates.push(d); }
                            }

                            var dateStrs = dates.map(function (d) {
                                return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
                            });

                            // Fetch all slots for all dentists × all dates
                            var fetches = [];
                            dentistes.forEach(function (dent) {
                                dateStrs.forEach(function (ds) {
                                    fetches.push(
                                        fetch(CTX + '/assistant/programmer-rdv?action=creneaux&dentisteId=' + dent.id + '&date=' + ds)
                                            .then(function (r) { return r.json(); })
                                            .then(function (slots) { return { dentId: dent.id, date: ds, slots: slots }; })
                                            .catch(function () { return { dentId: dent.id, date: ds, slots: [] }; })
                                    );
                                });
                            });

                            Promise.all(fetches).then(function (results) {
                                // Build map: dentId → date → bookedSlots[]
                                var map = {};
                                results.forEach(function (r) {
                                    if (!map[r.dentId]) map[r.dentId] = {};
                                    map[r.dentId][r.date] = r.slots;
                                });

                                var SLOTS = ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00', '18:00'];
                                var html = '';

                                dentistes.forEach(function (dent) {
                                    html += '<div class="dash-card" style="margin-bottom:16px;padding:0;overflow:hidden;">';
                                    html += '<div class="card-header" style="padding:16px 20px;border-bottom:1px solid #f1f5f9;">';
                                    html += '<div style="display:flex;align-items:center;gap:10px;">';
                                    html += '<div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,#1a6fa8,#0f4f7e);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;">Dr</div>';
                                    html += '<span style="font-weight:600;font-size:14px;">Dr. ' + esc(dent.login) + '</span>';
                                    html += '</div></div>';
                                    html += '<div style="padding:16px 20px;overflow-x:auto;">';

                                    // Grid: dates as columns, slots as rows
                                    var cols = dates.length;
                                    html += '<div style="display:grid;grid-template-columns:64px repeat(' + cols + ',1fr);gap:2px;min-width:' + (cols * 100 + 70) + 'px;">';
                                    // Header
                                    html += '<div></div>';
                                    dates.forEach(function (d) {
                                        var isToday = d.toDateString() === today.toDateString();
                                        html += '<div style="text-align:center;padding:6px;font-size:11px;font-weight:600;color:' + (isToday ? '#1a6fa8' : '#475569') + ';background:' + (isToday ? '#eff6ff' : '#f8fafc') + ';border-radius:6px;">';
                                        html += d.toLocaleDateString('fr-FR', { weekday: 'short', day: 'numeric', month: 'short' });
                                        html += '</div>';
                                    });
                                    // Rows
                                    SLOTS.forEach(function (slot) {
                                        html += '<div style="font-size:11px;color:#94a3b8;display:flex;align-items:center;padding:2px 4px;font-weight:600;">' + slot + '</div>';
                                        dateStrs.forEach(function (ds) {
                                            var booked = (map[dent.id][ds] || []).some(function (b) { return b.debut.substring(0, 5) === slot; });
                                            if (booked) {
                                                html += '<div style="background:#fef2f2;border-radius:6px;padding:4px;text-align:center;font-size:10px;color:#ef4444;font-weight:600;">Occupé</div>';
                                            } else {
                                                html += '<div style="background:#f0fdf4;border-radius:6px;padding:4px;text-align:center;font-size:10px;color:#15803d;font-weight:600;">Libre</div>';
                                            }
                                        });
                                    });
                                    html += '</div></div></div>';
                                });

                                div.innerHTML = html || '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucune donnée.</div>';
                            });
                        })
                        .catch(function () {
                            div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
                        });
                }

                /* ════════════════════════════════════════════════════════════
                   CHANGE 4 — Edit RDV full form modal
                ════════════════════════════════════════════════════════════ */
                function openEditRdvModal(rdvId) {
                    // Fetch RDV details from search API
                    fetch(CTX + '/assistant/programmer-rdv?action=getRdv&id=' + rdvId)
                        .then(function (r) { return r.json(); })
                        .then(function (d) {
                            if (d.error) { alert('RDV introuvable.'); return; }
                            document.getElementById('editRdvId').value = d.id;
                            document.getElementById('editRdvDate').value = d.dateRdv;
                            document.getElementById('editRdvHeure').value = d.heureDebut ? d.heureDebut.substring(0, 5) : '';
                            document.getElementById('editRdvMotif').value = d.motif || '';
                            document.getElementById('editRdvStatut').value = d.statut || 'PLANIFIE';
                            document.getElementById('editRdvNotes').value = d.notes || '';
                            document.getElementById('editRdvModal').classList.add('open');
                        })
                        .catch(function () { alert('Erreur de chargement du RDV.'); });
                }

                function closeEditRdvModal() {
                    document.getElementById('editRdvModal').classList.remove('open');
                }
                document.getElementById('editRdvModal').addEventListener('click', function (e) { if (e.target === this) closeEditRdvModal(); });

                function saveEditRdv() {
                    var id = document.getElementById('editRdvId').value;
                    var date = document.getElementById('editRdvDate').value;
                    var heure = document.getElementById('editRdvHeure').value;
                    var motif = document.getElementById('editRdvMotif').value.trim();
                    var statut = document.getElementById('editRdvStatut').value;
                    var notes = document.getElementById('editRdvNotes').value.trim();

                    var ok = true;
                    ['editRdvDateError', 'editRdvHeureError', 'editRdvMotifError'].forEach(function (e) { var el = document.getElementById(e); if (el) { el.textContent = ''; el.style.display = 'none'; } });
                    if (!date) { var el = document.getElementById('editRdvDateError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!heure) { var el = document.getElementById('editRdvHeureError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!motif) { var el = document.getElementById('editRdvMotifError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!ok) return;

                    var params = new URLSearchParams();
                    params.append('rdvId', id);
                    params.append('dateRdv', date);
                    params.append('heureDebut', heure + ':00');
                    params.append('motif', motif);
                    params.append('statut', statut);
                    params.append('notesInternes', notes);

                    fetch(CTX + '/assistant/modifier-rdv', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            if (data.success) {
                                closeEditRdvModal();
                                searchRdv(); // refresh results
                            } else {
                                alert('Erreur : ' + (data.message || 'Impossible de modifier.'));
                            }
                        })
                        .catch(function () { alert('Erreur de connexion.'); });
                }
            </script>

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

            <script>
                /* ════════════════════════════════════════════════════════════════
                   FACTURATION
                ════════════════════════════════════════════════════════════════ */
                var factureState = { rdvId: null, patientNom: '', dateRdv: '', patientId: null, actes: [], total: 0 };

                function openFactureModal(rdvId, patientNom, dateRdv, patientId) {
                    factureState.rdvId = rdvId;
                    factureState.patientNom = patientNom;
                    factureState.dateRdv = dateRdv;
                    factureState.patientId = patientId;
                    document.getElementById('factureModalBody').innerHTML = '<div style="text-align:center;padding:30px;color:#94a3b8;">Chargement des actes…</div>';
                    document.getElementById('factureModal').classList.add('open');

                    fetch(CTX + '/assistant/facturer?action=getActes&rdvId=' + rdvId)
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            factureState.actes = data.actes || [];
                            factureState.total = data.total || 0;
                            renderFactureModal(data);
                        })
                        .catch(function () {
                            document.getElementById('factureModalBody').innerHTML = '<p style="color:#ef4444;padding:20px;">Erreur de chargement. Vérifiez que la consultation est enregistrée.</p>';
                        });
                }

                function renderFactureModal(data) {
                    var actes = data.actes || [];
                    var total = data.total || 0;
                    var dentiste = data.dentiste || '—';
                    var html = '';

                    // Patient + dentist info
                    html += '<div style="background:#f8fafc;border-radius:10px;padding:14px 16px;margin-bottom:16px;font-size:13px;">';
                    html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;">';
                    html += '<div><span style="color:#94a3b8;font-size:11px;text-transform:uppercase;font-weight:600;">Patient</span><div style="font-weight:600;color:#1e293b;">' + esc(factureState.patientNom) + '</div></div>';
                    html += '<div><span style="color:#94a3b8;font-size:11px;text-transform:uppercase;font-weight:600;">Dentiste</span><div style="font-weight:600;color:#1e293b;">Dr. ' + esc(dentiste) + '</div></div>';
                    html += '<div><span style="color:#94a3b8;font-size:11px;text-transform:uppercase;font-weight:600;">Date RDV</span><div style="font-weight:600;color:#1e293b;">' + esc(factureState.dateRdv) + '</div></div>';
                    html += '</div></div>';

                    // Actes table
                    if (actes.length === 0) {
                        html += '<div style="background:#fffbeb;border:1px solid #fcd34d;border-radius:10px;padding:14px;font-size:13px;color:#92400e;margin-bottom:16px;">⚠ Aucun acte enregistré pour cette consultation. Veuillez d abord ajouter les actes depuis le tableau de bord du dentiste."</div>';
                    } else {
                        html += '<div class="table-wrapper" style="margin-bottom:16px;"><table class="data-table"><thead><tr><th>Code</th><th>Acte</th><th style="text-align:right;">Tarif (MAD)</th></tr></thead><tbody>';
                        actes.forEach(function (a) {
                            html += '<tr><td style="color:#64748b;font-size:12px;">' + esc(a.code) + '</td><td>' + esc(a.nom) + '</td><td style="text-align:right;font-weight:600;">' + parseFloat(a.tarif).toFixed(2) + '</td></tr>';
                        });
                        html += '</tbody></table></div>';
                        html += '<div style="display:flex;justify-content:flex-end;align-items:center;gap:12px;padding:12px 16px;background:#f0fdf4;border-radius:10px;margin-bottom:20px;">';
                        html += '<span style="font-size:14px;color:#475569;">Total</span>';
                        html += '<span style="font-size:20px;font-weight:700;color:#15803d;">' + parseFloat(total).toFixed(2) + ' MAD</span>';
                        html += '</div>';
                    }

                    // Payment method
                    html += '<div style="margin-bottom:20px;">';
                    html += '<label style="font-size:13px;font-weight:600;color:#1e293b;display:block;margin-bottom:12px;">Mode de paiement *</label>';
                    html += '<div style="display:flex;gap:12px;flex-wrap:wrap;">';
                    [['ESPECES', '💵 Espèces'], ['CHEQUE', '🏦 Chèque'], ['CARTE_BANCAIRE', '💳 Carte bancaire']].forEach(function (opt) {
                        html += '<label style="display:flex;align-items:center;gap:8px;padding:10px 18px;border:1.5px solid #e2e8f0;border-radius:10px;cursor:pointer;font-size:13px;font-weight:500;transition:all 0.15s;" id="pay-label-' + opt[0] + '">';
                        html += '<input type="radio" name="modeReglement" value="' + opt[0] + '" onchange="highlightPayment()" style="accent-color:#1a6fa8;">';
                        html += opt[1] + '</label>';
                    });
                    html += '</div>';
                    html += '<span class="field-error" id="paymentError" style="display:none;margin-top:8px;"></span>';
                    html += '</div>';

                    // Actions
                    html += '<div class="modal-actions">';
                    html += '<button type="button" class="btn-secondary" onclick="closeFactureModal()">Annuler</button>';
                    if (actes.length > 0) {
                        html += '<button type="button" class="btn-primary" onclick="saveFacture()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/></svg> Enregistrer & Générer PDF</button>';
                    }
                    html += '</div>';

                    document.getElementById('factureModalBody').innerHTML = html;
                }

                function highlightPayment() {
                    ['ESPECES', 'CHEQUE', 'CARTE_BANCAIRE'].forEach(function (v) {
                        var lbl = document.getElementById('pay-label-' + v);
                        var inp = lbl ? lbl.querySelector('input') : null;
                        if (lbl && inp) {
                            lbl.style.borderColor = inp.checked ? '#1a6fa8' : '#e2e8f0';
                            lbl.style.background = inp.checked ? '#eff6ff' : '';
                        }
                    });
                }

                function saveFacture() {
                    var mode = document.querySelector('input[name="modeReglement"]:checked');
                    var errEl = document.getElementById('paymentError');
                    if (!mode) { errEl.textContent = 'Choisissez un mode de paiement.'; errEl.style.display = 'block'; return; }
                    errEl.style.display = 'none';

                    var btn = document.querySelector('[onclick="saveFacture()"]');
                    btn.disabled = true; btn.textContent = 'Enregistrement…';

                    var params = new URLSearchParams();
                    params.append('rdvId', factureState.rdvId);
                    params.append('modeReglement', mode.value);

                    fetch(CTX + '/assistant/facturer', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            btn.disabled = false;
                            btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/></svg> Enregistrer & Générer PDF';
                            if (!data.success) { alert('Erreur : ' + (data.message || 'Impossible de facturer.')); return; }
                            closeFactureModal();
                            generateFacturePdf(data);
                        })
                        .catch(function () { btn.disabled = false; alert('Erreur de connexion.'); });
                }

                function closeFactureModal() {
                    document.getElementById('factureModal').classList.remove('open');
                }
                document.getElementById('factureModal').addEventListener('click', function (e) { if (e.target === this) closeFactureModal(); });

                function generateFacturePdf(d) {
                    var html = '<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8"><title>Facture DentFisto</title><style>';
                    html += 'body{font-family:Arial,sans-serif;color:#1e293b;margin:0;padding:40px;background:#fff;}';
                    html += '.header{display:flex;justify-content:space-between;align-items:flex-start;border-bottom:3px solid #1a6fa8;padding-bottom:20px;margin-bottom:30px;}';
                    html += '.clinic{font-size:22px;font-weight:700;color:#1a6fa8;}.doc-title{font-size:18px;font-weight:700;margin-bottom:24px;}';
                    html += '.info-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:28px;}';
                    html += '.info-box{background:#f8fafc;border-radius:8px;padding:14px;}';
                    html += '.info-label{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.05em;color:#94a3b8;margin-bottom:4px;}';
                    html += '.info-val{font-size:13.5px;font-weight:600;color:#1e293b;}';
                    html += 'table{width:100%;border-collapse:collapse;margin-bottom:20px;}';
                    html += 'th{background:#f1f5f9;padding:10px 14px;text-align:left;font-size:12px;font-weight:700;color:#475569;text-transform:uppercase;}';
                    html += 'td{padding:10px 14px;border-bottom:1px solid #f1f5f9;font-size:13px;}';
                    html += '.total-row{display:flex;justify-content:flex-end;align-items:center;gap:16px;background:#f0fdf4;border-radius:8px;padding:14px 20px;margin-bottom:30px;}';
                    html += '.total-label{font-size:14px;color:#475569;}.total-val{font-size:22px;font-weight:700;color:#15803d;}';
                    html += '.footer{margin-top:40px;padding-top:20px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;text-align:center;}';
                    html += '@media print{body{padding:20px;}}';
                    html += '</style></head><body>';
                    html += '<div class="header"><div class="clinic">&#x1F9B7; DentFisto</div>';
                    html += '<div style="text-align:right;font-size:11px;color:#94a3b8;">Date : ' + new Date().toLocaleDateString('fr-FR') + '<br>N° Facture : FAC-' + d.factureId + '</div></div>';
                    html += '<div class="doc-title">Facture de consultation</div>';
                    html += '<div class="info-grid">';
                    html += '<div class="info-box"><div class="info-label">Patient</div><div class="info-val">' + esc(d.patientNom) + ' ' + esc(d.patientPrenom) + '</div>';
                    if (d.patientTel) html += '<div style="font-size:12px;color:#64748b;margin-top:4px;">&#x260E; ' + esc(d.patientTel) + '</div>';
                    html += '</div>';
                    html += '<div class="info-box"><div class="info-label">Dentiste</div><div class="info-val">Dr. ' + esc(d.dentiste) + '</div>';
                    html += '<div style="font-size:12px;color:#64748b;margin-top:4px;">Date RDV : ' + esc(factureState.dateRdv) + '</div></div>';
                    html += '</div>';
                    html += '<table><thead><tr><th>Code</th><th>Acte médical</th><th style="text-align:right;">Tarif (MAD)</th></tr></thead><tbody>';
                    (d.actes || factureState.actes).forEach(function (a) {
                        html += '<tr><td style="color:#64748b;">' + esc(a.code) + '</td><td>' + esc(a.nom) + '</td><td style="text-align:right;font-weight:600;">' + parseFloat(a.tarif).toFixed(2) + '</td></tr>';
                    });
                    html += '</tbody></table>';
                    html += '<div class="total-row"><span class="total-label">TOTAL</span><span class="total-val">' + parseFloat(d.total).toFixed(2) + ' MAD</span></div>';
                    html += '<div class="footer">DentFisto – Cabinet dentaire • Merci de votre confiance.<br>Ce document est une facture officielle.</div>';
                    html += '</body></html>';

                    var win = window.open('', '_blank', 'width=750,height=950');
                    win.document.write(html);
                    win.document.close();
                    win.focus();
                    setTimeout(function () { win.print(); }, 400);
                }
            </script>
        </body>

        </html>