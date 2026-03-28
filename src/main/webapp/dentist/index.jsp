<!-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> -->
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

<!-- ═══════════════════════════════════════════
     SIDEBAR
════════════════════════════════════════════ -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <img src="${pageContext.request.contextPath}/images/logo.png" class="sidebar-logo" alt="logo">
        <span>DentFisto</span>
    </div>

    <nav class="sidebar-nav">
        <p class="nav-section-label">Principal</p>

        <a href="#overview"   class="nav-item active" data-section="overview">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <p class="nav-item-name">Tableau de bord</p>
        </a>
        <a href="#planning" class="nav-item" data-section="planning">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
             <p class="nav-item-name">Planning</p>
        </a>
        <a href="#appointments" class="nav-item" data-section="appointments">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg>
             <p class="nav-item-name">Rendez-vous</p>
        </a>

        <p class="nav-section-label">Patients</p>

        <a href="#patients" class="nav-item" data-section="patients">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
             <p class="nav-item-name">Patients</p>
        </a>
        <a href="#dossier" class="nav-item" data-section="dossier">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
             <p class="nav-item-name">Dossiers médicaux</p>
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="user-avatar">Dr</div>
            <div class="user-info">
                <span class="user-name">Dr. Martin</span>
                <span class="user-role">Dentiste</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Déconnexion">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        </a>
    </div>
</aside>

<!-- ═══════════════════════════════════════════
     MAIN CONTENT
════════════════════════════════════════════ -->
<main class="dashboard-main">

    <!-- Top bar -->
    <header class="topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle" id="sidebarToggle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <div class="breadcrumb">
                <span id="breadcrumbText">Tableau de bord</span>
            </div>
        </div>
        <div class="topbar-right">
            <div class="topbar-date">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="14" height="14"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                <span id="currentDate"></span>
            </div>
            <div class="topbar-notif">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                <span class="notif-dot"></span>
            </div>
        </div>
    </header>

    <div class="content-area">

        <!-- ══════════════════════════════════
             SECTION: OVERVIEW
        ══════════════════════════════════ -->
        <section class="dash-section active" id="section-overview">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Bonjour, Dr. Sultan<span class="wave">👋</span></h1>
                    <p class="section-sub">Voici un aperçu de votre journée.</p>
                </div>
            </div>

            <!-- KPI cards -->
            <div class="kpi-grid">
                <div class="kpi-card kpi-blue">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                    </div>
                    <div class="kpi-body">
                        <span class="kpi-value">8</span>
                        <span class="kpi-label">RV aujourd'hui</span>
                    </div>
                </div>
                <div class="kpi-card kpi-green">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                    </div>
                    <div class="kpi-body">
                        <span class="kpi-value">124</span>
                        <span class="kpi-label">Patients actifs</span>
                    </div>
                </div>
                <div class="kpi-card kpi-amber">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </div>
                    <div class="kpi-body">
                        <span class="kpi-value">2</span>
                        <span class="kpi-label">En attente</span>
                    </div>
                </div>
                <div class="kpi-card kpi-red">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                    </div>
                    <div class="kpi-body">
                        <span class="kpi-value">3</span>
                        <span class="kpi-label">Ordonnances</span>
                    </div>
                </div>
            </div>

            <!-- Today's appointments quick view -->
            <div class="overview-grid">
                <div class="dash-card">
                    <div class="card-header">
                        <h3>RV du jour</h3>
                        <button class="btn-text" onclick="showSection('appointments')">Voir tout →</button>
                    </div>
                    <div class="rv-list">
                        <div class="rv-item">
                            <div class="rv-time">09:00</div>
                            <div class="rv-info">
                                <span class="rv-patient">Khalid Amrani</span>
                                <span class="rv-type">Détartrage</span>
                            </div>
                            <span class="rv-status status-confirmed">Confirmé</span>
                        </div>
                        <div class="rv-item">
                            <div class="rv-time">10:30</div>
                            <div class="rv-info">
                                <span class="rv-patient">Fatima Benali</span>
                                <span class="rv-type">Extraction</span>
                            </div>
                            <span class="rv-status status-pending">En attente</span>
                        </div>
                        <div class="rv-item">
                            <div class="rv-time">11:00</div>
                            <div class="rv-info">
                                <span class="rv-patient">Youssef El Idrissi</span>
                                <span class="rv-type">Contrôle</span>
                            </div>
                            <span class="rv-status status-confirmed">Confirmé</span>
                        </div>
                        <div class="rv-item">
                            <div class="rv-time">14:00</div>
                            <div class="rv-info">
                                <span class="rv-patient">Nadia Chraibi</span>
                                <span class="rv-type">Orthodontie</span>
                            </div>
                            <span class="rv-status status-cancelled">Annulé</span>
                        </div>
                    </div>
                </div>

                <div class="dash-card">
                    <div class="card-header">
                        <h3>Accès rapide</h3>
                    </div>
                    <div class="quick-actions">
                        <button class="qa-btn" onclick="showSection('appointments')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                            Chercher un RV
                        </button>
                        <button class="qa-btn" onclick="showSection('patients')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                            Chercher un patient
                        </button>
                        <button class="qa-btn" onclick="showSection('planning')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                            Voir le planning
                        </button>
                        <button class="qa-btn" onclick="showSection('dossier')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                            Dossiers médicaux
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══════════════════════════════════
             SECTION: PLANNING
        ══════════════════════════════════ -->
        <section class="dash-section" id="section-planning">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Planning</h1>
                    <p class="section-sub">Consultez et gérez votre planning.</p>
                </div>
                <div class="planning-toggle">
                    <button class="toggle-btn active" id="btnDay" onclick="switchPlanning('day')">Jour</button>
                    <button class="toggle-btn" id="btnWeek" onclick="switchPlanning('week')">Semaine</button>
                </div>
            </div>

            <!-- Daily view -->
            <div id="planningDay" class="planning-view">
                <div class="dash-card">
                    <div class="card-header">
                        <h3 id="dayLabel">Lundi 28 Juin 2025</h3>
                        <div class="day-nav">
                            <button class="icon-btn" onclick="changeDay(-1)">&#8249;</button>
                            <button class="icon-btn" onclick="changeDay(1)">&#8250;</button>
                        </div>
                    </div>
                    <div class="day-timeline">
                        <c:forEach var="slot" items="${dailySlots}">
                            <div class="time-slot ${slot.status}">
                                <div class="slot-time">${slot.time}</div>
                                <div class="slot-body">
                                    <span class="slot-patient">${slot.patientName}</span>
                                    <span class="slot-type">${slot.type}</span>
                                </div>
                                <div class="slot-actions">
                                    <span class="slot-badge badge-${slot.status}">${slot.statusLabel}</span>
                                    <button class="btn-icon-sm" title="Modifier statut"
                                            onclick="openStatusModal('${slot.id}', '${slot.status}')">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                        <!-- Static demo slots when no JSTL data -->
                        <div class="time-slot slot-confirmed">
                            <div class="slot-time">09:00</div>
                            <div class="slot-body"><span class="slot-patient">Khalid Amrani</span><span class="slot-type">Détartrage</span></div>
                            <div class="slot-actions"><span class="slot-badge badge-confirmed">Confirmé</span><button class="btn-icon-sm" onclick="openStatusModal('1','confirmed')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></button></div>
                        </div>
                        <div class="time-slot slot-pending">
                            <div class="slot-time">10:30</div>
                            <div class="slot-body"><span class="slot-patient">Fatima Benali</span><span class="slot-type">Extraction</span></div>
                            <div class="slot-actions"><span class="slot-badge badge-pending">En attente</span><button class="btn-icon-sm" onclick="openStatusModal('2','pending')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></button></div>
                        </div>
                        <div class="time-slot slot-confirmed">
                            <div class="slot-time">14:00</div>
                            <div class="slot-body"><span class="slot-patient">Nadia Chraibi</span><span class="slot-type">Orthodontie</span></div>
                            <div class="slot-actions"><span class="slot-badge badge-confirmed">Confirmé</span><button class="btn-icon-sm" onclick="openStatusModal('3','confirmed')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></button></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Weekly view -->
            <div id="planningWeek" class="planning-view" style="display:none;">
                <div class="dash-card">
                    <div class="card-header">
                        <h3>Semaine du 23 au 29 Juin 2025</h3>
                        <div class="day-nav">
                            <button class="icon-btn" onclick="changeWeek(-1)">&#8249;</button>
                            <button class="icon-btn" onclick="changeWeek(1)">&#8250;</button>
                        </div>
                    </div>
                    <div class="week-grid">
                        <div class="week-header">
                            <div class="week-cell week-label"></div>
                            <div class="week-cell week-day">Lun <span>23</span></div>
                            <div class="week-cell week-day">Mar <span>24</span></div>
                            <div class="week-cell week-day">Mer <span>25</span></div>
                            <div class="week-cell week-day">Jeu <span>26</span></div>
                            <div class="week-cell week-day">Ven <span>27</span></div>
                            <div class="week-cell week-day today-col">Sam <span>28</span></div>
                        </div>
                        <c:forEach var="hour" items="09,10,11,14,15,16">
                            <div class="week-row">
                                <div class="week-cell week-label">${hour}:00</div>
                                <c:forEach begin="1" end="6">
                                    <div class="week-cell week-slot"></div>
                                </c:forEach>
                            </div>
                        </c:forEach>
                        <!-- Static demo week rows -->
                        <div class="week-row">
                            <div class="week-cell week-label">09:00</div>
                            <div class="week-cell week-slot"><div class="week-event ev-blue">K. Amrani</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"><div class="week-event ev-green">F. Benali</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"><div class="week-event ev-blue">N. Chraibi</div></div>
                            <div class="week-cell week-slot today-col"></div>
                        </div>
                        <div class="week-row">
                            <div class="week-cell week-label">10:30</div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"><div class="week-event ev-amber">Y. Idrissi</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"><div class="week-event ev-blue">M. Tazi</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot today-col"><div class="week-event ev-green">K. Amrani</div></div>
                        </div>
                        <div class="week-row">
                            <div class="week-cell week-label">14:00</div>
                            <div class="week-cell week-slot"><div class="week-event ev-green">H. Bakkali</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot"><div class="week-event ev-amber">S. Alami</div></div>
                            <div class="week-cell week-slot"></div>
                            <div class="week-cell week-slot today-col"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══════════════════════════════════
             SECTION: RENDEZ-VOUS
        ══════════════════════════════════ -->
        <section class="dash-section" id="section-appointments">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Rendez-vous</h1>
                    <p class="section-sub">Recherchez, modifiez ou annulez un rendez-vous.</p>
                </div>
            </div>

            <!-- Search bar -->
            <form action="${pageContext.request.contextPath}/dentist/appointments" method="get" class="search-bar-form">
                <div class="search-bar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" name="q" placeholder="Nom du patient, date, type de soin…"
                           value="${param.q}">
                    <button type="submit" class="btn-primary">Rechercher</button>
                </div>
            </form>

            <div class="dash-card">
                <div class="card-header">
                    <h3>Liste des rendez-vous</h3>
                    <span class="count-badge">${not empty appointments ? appointments.size() : '4'} résultats</span>
                </div>
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Type</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="rv" items="${appointments}">
                                        <tr>
                                            <td class="td-bold">${rv.patientName}</td>
                                            <td>${rv.date}</td>
                                            <td>${rv.time}</td>
                                            <td>${rv.type}</td>
                                            <td><span class="rv-status status-${rv.status}">${rv.statusLabel}</span></td>
                                            <td class="td-actions">
                                                <a href="${pageContext.request.contextPath}/dentist/appointments/edit?id=${rv.id}" class="btn-table btn-edit" title="Modifier">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                    Modifier
                                                </a>
                                                <a href="${pageContext.request.contextPath}/dentist/appointments/cancel?id=${rv.id}"
                                                   class="btn-table btn-cancel"
                                                   onclick="return confirm('Confirmer l\'annulation ?')"
                                                   title="Annuler">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                                    Annuler
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Demo rows -->
                                    <tr>
                                        <td class="td-bold">Khalid Amrani</td>
                                        <td>28/06/2025</td><td>09:00</td><td>Détartrage</td>
                                        <td><span class="rv-status status-confirmed">Confirmé</span></td>
                                        <td class="td-actions">
                                            <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                            <a href="#" class="btn-table btn-cancel" onclick="return confirm('Confirmer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Annuler</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td-bold">Fatima Benali</td>
                                        <td>28/06/2025</td><td>10:30</td><td>Extraction</td>
                                        <td><span class="rv-status status-pending">En attente</span></td>
                                        <td class="td-actions">
                                            <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                            <a href="#" class="btn-table btn-cancel" onclick="return confirm('Confirmer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Annuler</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td-bold">Youssef El Idrissi</td>
                                        <td>29/06/2025</td><td>11:00</td><td>Contrôle</td>
                                        <td><span class="rv-status status-confirmed">Confirmé</span></td>
                                        <td class="td-actions">
                                            <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                            <a href="#" class="btn-table btn-cancel" onclick="return confirm('Confirmer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Annuler</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td-bold">Nadia Chraibi</td>
                                        <td>30/06/2025</td><td>14:00</td><td>Orthodontie</td>
                                        <td><span class="rv-status status-cancelled">Annulé</span></td>
                                        <td class="td-actions">
                                            <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                            <a href="#" class="btn-table btn-cancel" onclick="return confirm('Confirmer ?')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg> Annuler</a>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- ══════════════════════════════════
             SECTION: PATIENTS
        ══════════════════════════════════ -->
        <section class="dash-section" id="section-patients">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Patients</h1>
                    <p class="section-sub">Recherchez un patient et accédez à ses informations.</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/dentist/patients" method="get" class="search-bar-form">
                <div class="search-bar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" name="q" placeholder="Nom, prénom, téléphone…" value="${param.q}">
                    <button type="submit" class="btn-primary">Rechercher</button>
                </div>
            </form>

            <div class="patient-grid">
                <c:choose>
                    <c:when test="${not empty patients}">
                        <c:forEach var="p" items="${patients}">
                            <div class="patient-card">
                                <div class="patient-avatar">${p.initials}</div>
                                <div class="patient-info">
                                    <span class="patient-name">${p.fullName}</span>
                                    <span class="patient-meta">${p.age} ans · ${p.phone}</span>
                                </div>
                                <div class="patient-card-actions">
                                    <a href="${pageContext.request.contextPath}/dentist/patients/edit?id=${p.id}" class="btn-table btn-edit">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                        Modifier
                                    </a>
                                    <a href="${pageContext.request.contextPath}/dentist/dossier?patientId=${p.id}" class="btn-table btn-dossier">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                        Dossier
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Demo patients -->
                        <div class="patient-card">
                            <div class="patient-avatar">KA</div>
                            <div class="patient-info"><span class="patient-name">Khalid Amrani</span><span class="patient-meta">34 ans · 06 61 23 45 67</span></div>
                            <div class="patient-card-actions">
                                <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                <a href="#" class="btn-table btn-dossier"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Dossier</a>
                            </div>
                        </div>
                        <div class="patient-card">
                            <div class="patient-avatar">FB</div>
                            <div class="patient-info"><span class="patient-name">Fatima Benali</span><span class="patient-meta">27 ans · 06 72 34 56 78</span></div>
                            <div class="patient-card-actions">
                                <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                <a href="#" class="btn-table btn-dossier"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Dossier</a>
                            </div>
                        </div>
                        <div class="patient-card">
                            <div class="patient-avatar">YI</div>
                            <div class="patient-info"><span class="patient-name">Youssef El Idrissi</span><span class="patient-meta">41 ans · 06 83 45 67 89</span></div>
                            <div class="patient-card-actions">
                                <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                <a href="#" class="btn-table btn-dossier"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Dossier</a>
                            </div>
                        </div>
                        <div class="patient-card">
                            <div class="patient-avatar">NC</div>
                            <div class="patient-info"><span class="patient-name">Nadia Chraibi</span><span class="patient-meta">29 ans · 06 94 56 78 90</span></div>
                            <div class="patient-card-actions">
                                <a href="#" class="btn-table btn-edit"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg> Modifier</a>
                                <a href="#" class="btn-table btn-dossier"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg> Dossier</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- ══════════════════════════════════
             SECTION: DOSSIER MÉDICAL
        ══════════════════════════════════ -->
        <section class="dash-section" id="section-dossier">
            <div class="section-hero">
                <div>
                    <h1 class="section-title">Dossier médical</h1>
                    <p class="section-sub">Consultez, modifiez et gérez les dossiers patients.</p>
                </div>
            </div>

            <!-- Patient selector -->
            <form action="${pageContext.request.contextPath}/dentist/dossier" method="get" class="search-bar-form">
                <div class="search-bar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                    <input type="text" name="patient" placeholder="Rechercher le dossier d'un patient…" value="${param.patient}">
                    <button type="submit" class="btn-primary">Ouvrir</button>
                </div>
            </form>

            <!-- Dossier card (shown when patient is selected or demo) -->
            <div class="dossier-layout">

                <!-- Left: patient summary -->
                <div class="dossier-sidebar-card dash-card">
                    <div class="dossier-patient-header">
                        <div class="dossier-avatar">KA</div>
                        <div>
                            <h3>Khalid Amrani</h3>
                            <span class="dossier-meta">34 ans · Groupe A+</span>
                        </div>
                    </div>
                    <div class="dossier-info-list">
                        <div class="dossier-info-row"><span class="di-label">Téléphone</span><span class="di-val">06 61 23 45 67</span></div>
                        <div class="dossier-info-row"><span class="di-label">Naissance</span><span class="di-val">15/03/1991</span></div>
                        <div class="dossier-info-row"><span class="di-label">Allergies</span><span class="di-val allergy">Pénicilline</span></div>
                        <div class="dossier-info-row"><span class="di-label">Dernière visite</span><span class="di-val">20/05/2025</span></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/dentist/patients/edit?id=1" class="btn-secondary btn-full">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                        Modifier informations
                    </a>
                </div>

                <!-- Right: dossier content -->
                <div class="dossier-main">

                    <!-- Notes médicales -->
                    <div class="dash-card">
                        <div class="card-header">
                            <h3>Notes médicales</h3>
                            <a href="${pageContext.request.contextPath}/dentist/dossier/edit?id=1" class="btn-table btn-edit">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                Modifier dossier
                            </a>
                        </div>
                        <div class="medical-notes">
                            <c:if test="${not empty dossier.notes}">
                                <p>${dossier.notes}</p>
                            </c:if>
                            <c:if test="${empty dossier.notes}">
                                <p class="notes-demo">Patient suivi pour traitement orthodontique depuis 2023. Dernière séance : pose de bagues le 20/05/2025. Prochain contrôle prévu dans 6 semaines. Hygiène bucco-dentaire satisfaisante.</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Documents annexés -->
                    <div class="dash-card">
                        <div class="card-header">
                            <h3>Documents annexés</h3>
                            <a href="${pageContext.request.contextPath}/dentist/dossier/upload?id=1" class="btn-primary btn-sm">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                Annexer document
                            </a>
                        </div>
                        <div class="doc-list">
                            <c:choose>
                                <c:when test="${not empty dossier.documents}">
                                    <c:forEach var="doc" items="${dossier.documents}">
                                        <div class="doc-item">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                            <span class="doc-name">${doc.name}</span>
                                            <span class="doc-date">${doc.uploadDate}</span>
                                            <a href="${pageContext.request.contextPath}/dentist/dossier/document?id=${doc.id}" class="doc-dl">↓</a>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="doc-item"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg><span class="doc-name">Radio_panoramique.pdf</span><span class="doc-date">10/01/2025</span><a href="#" class="doc-dl">↓</a></div>
                                    <div class="doc-item"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg><span class="doc-name">Consentement_eclaire.pdf</span><span class="doc-date">15/03/2025</span><a href="#" class="doc-dl">↓</a></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Ordonnances -->
                    <div class="dash-card">
                        <div class="card-header">
                            <h3>Ordonnances</h3>
                            <a href="${pageContext.request.contextPath}/dentist/ordonnance/new?patientId=1" class="btn-primary btn-sm">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                Générer ordonnance
                            </a>
                        </div>
                        <div class="doc-list">
                            <c:choose>
                                <c:when test="${not empty dossier.ordonnances}">
                                    <c:forEach var="ord" items="${dossier.ordonnances}">
                                        <div class="doc-item">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                                            <span class="doc-name">${ord.title}</span>
                                            <span class="doc-date">${ord.date}</span>
                                            <a href="${pageContext.request.contextPath}/dentist/ordonnance/print?id=${ord.id}" class="doc-dl">⎙</a>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="doc-item"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg><span class="doc-name">Ordonnance_Amoxicilline.pdf</span><span class="doc-date">20/05/2025</span><a href="#" class="doc-dl">⎙</a></div>
                                    <div class="doc-item"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="16" height="16"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg><span class="doc-name">Ordonnance_Ibuprofene.pdf</span><span class="doc-date">10/01/2025</span><a href="#" class="doc-dl">⎙</a></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>
        </section>

    </div><!-- /content-area -->
</main>

<!-- ═══════════════════════════════════════════
     MODAL: Modifier statut RV
════════════════════════════════════════════ -->
<div class="modal-backdrop" id="statusModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Modifier le statut</h3>
            <button class="modal-close" onclick="closeStatusModal()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/dentist/appointments/status" method="post" class="modal-form">
            <input type="hidden" name="id" id="statusRvId">
            <div class="form-group">
                <label for="newStatus">Nouveau statut</label>
                <select name="status" id="newStatus" class="form-select">
                    <option value="confirmed">Confirmé</option>
                    <option value="pending">En attente</option>
                    <option value="in_progress">En cours</option>
                    <option value="done">Terminé</option>
                    <option value="cancelled">Annulé</option>
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

    /* ── Section navigation ── */
    const sectionLabels = {
        overview: 'Tableau de bord',
        planning: 'Planning',
        appointments: 'Rendez-vous',
        patients: 'Patients',
        dossier: 'Dossiers médicaux'
    };

    function showSection(name) {
        document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        document.getElementById('section-' + name).classList.add('active');
        document.querySelector('[data-section="' + name + '"]').classList.add('active');
        document.getElementById('breadcrumbText').textContent = sectionLabels[name];
        window.scrollTo(0,0);
    }

    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            showSection(this.dataset.section);
        });
    });

    /* ── Sidebar toggle ── */
    document.getElementById('sidebarToggle').addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('collapsed');
        document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed');
    });

    /* ── Planning switch ── */
    function switchPlanning(mode) {
        document.getElementById('planningDay').style.display  = mode === 'day'  ? '' : 'none';
        document.getElementById('planningWeek').style.display = mode === 'week' ? '' : 'none';
        document.getElementById('btnDay').classList.toggle('active',  mode === 'day');
        document.getElementById('btnWeek').classList.toggle('active', mode === 'week');
    }

    /* ── Status modal ── */
    function openStatusModal(id, currentStatus) {
        document.getElementById('statusRvId').value = id;
        document.getElementById('newStatus').value  = currentStatus;
        document.getElementById('statusModal').classList.add('open');
    }
    function closeStatusModal() {
        document.getElementById('statusModal').classList.remove('open');
    }
    document.getElementById('statusModal').addEventListener('click', function(e) {
        if (e.target === this) closeStatusModal();
    });

    /* ── Page entrance animation ── */
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
