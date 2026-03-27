<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>DentFisto – Dashboard Assistante</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        </head>

        <body class="dashboard-body">

            <!-- ═══════════════════════════════════════════
     SIDEBAR
════════════════════════════════════════════ -->
            <aside class="sidebar">

                <!-- Logo -->
                <div class="sidebar-logo">
                    <img src="${pageContext.request.contextPath}/images/logo.png" alt="DentFisto"
                        class="sidebar-logo-img">
                    <span>DentFisto</span>
                </div>

                <!-- Navigation -->
                <nav class="sidebar-nav">
                    <div class="nav-group">
                        <span class="nav-label">Principal</span>

                        <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-item active">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                <rect x="3" y="3" width="7" height="7" rx="1.5" />
                                <rect x="14" y="3" width="7" height="7" rx="1.5" />
                                <rect x="3" y="14" width="7" height="7" rx="1.5" />
                                <rect x="14" y="14" width="7" height="7" rx="1.5" />
                            </svg>
                            <span>Dashboard</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/assistant/planning" class="nav-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                <rect x="3" y="4" width="18" height="18" rx="2" />
                                <line x1="16" y1="2" x2="16" y2="6" />
                                <line x1="8" y1="2" x2="8" y2="6" />
                                <line x1="3" y1="10" x2="21" y2="10" />
                            </svg>
                            <span>Planning</span>
                        </a>
                    </div>

                    <div class="nav-group">
                        <span class="nav-label">Gestion</span>

                        <a href="${pageContext.request.contextPath}/assistant/reserver-rdv" class="nav-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                <circle cx="12" cy="12" r="9" />
                                <line x1="12" y1="8" x2="12" y2="16" />
                                <line x1="8" y1="12" x2="16" y2="12" />
                            </svg>
                            <span>Réserver RDV</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/assistant/patients" class="nav-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                <circle cx="9" cy="7" r="4" />
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                            </svg>
                            <span>Patients</span>
                        </a>


                    </div>
                </nav>

                <!-- Logout -->
                <div class="sidebar-footer">
                    <a href="${pageContext.request.contextPath}/logout" class="nav-item logout-btn">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16,17 21,12 16,7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                        <span>Déconnexion</span>
                    </a>
                </div>
            </aside>

            <!-- ═══════════════════════════════════════════
     MAIN CONTENT
════════════════════════════════════════════ -->
            <main class="dashboard-main">

                <!-- Top Bar -->
                <div class="topbar">
                    <div class="topbar-left">
                        <h1 class="page-title">Dashboard</h1>
                        <span class="page-date" id="currentDate"></span>
                    </div>
                    <div class="topbar-right">
                        <!-- Search bar -->
                        <form action="${pageContext.request.contextPath}/assistant/patients" method="get"
                            class="topbar-search">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                <circle cx="11" cy="11" r="8" />
                                <line x1="21" y1="21" x2="16.65" y2="16.65" />
                            </svg>
                            <input type="text" name="search" placeholder="Rechercher un patient…">
                        </form>
                        <!-- User badge -->
                        <div class="user-badge">
                            <div class="user-avatar">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                            </div>
                            <div class="user-info">
                                <span class="user-name">${sessionScope.username != null ? sessionScope.username :
                                    'Assistante'}</span>
                                <span class="user-role">Assistante</span>
                            </div>
                        </div>
                    </div>
                </div>



                <!-- ── Bottom Grid: Planning du jour + Quick Actions ── -->
                <section class="content-grid">

                    <!-- Planning du jour -->
                    <div class="panel planning-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <circle cx="12" cy="12" r="9" />
                                    <polyline points="12,6 12,12 16,14" />
                                </svg>
                                Planning du jour
                            </h2>
                            <a href="${pageContext.request.contextPath}/assistant/planning" class="panel-link">Voir tout
                                →</a>
                        </div>

                        <div class="planning-list">
                            <c:choose>
                                <c:when test="${not empty rdvDuJour}">
                                    <c:forEach var="rdv" items="${rdvDuJour}">
                                        <div class="planning-item">
                                            <div class="planning-time">
                                                <span>${rdv.heure}</span>
                                            </div>
                                            <div
                                                class="planning-bar ${rdv.statut == 'EN_COURS' ? 'bar-blue' : rdv.statut == 'EN_ATTENTE' ? 'bar-orange' : rdv.statut == 'TERMINE' ? 'bar-green' : 'bar-red'}">
                                            </div>
                                            <div class="planning-info">
                                                <span class="planning-patient">${rdv.patient.nom}
                                                    ${rdv.patient.prenom}</span>
                                                <span class="planning-detail">${rdv.dentiste.nom} · ${rdv.motif}</span>
                                            </div>
                                            <span
                                                class="planning-badge ${rdv.statut == 'EN_COURS' ? 'badge-blue' : rdv.statut == 'EN_ATTENTE' ? 'badge-orange' : rdv.statut == 'TERMINE' ? 'badge-green' : 'badge-red'}">
                                                ${rdv.statut}
                                            </span>
                                            <c:if test="${rdv.statut == 'TERMINE'}">
                                                <a href="${pageContext.request.contextPath}/assistant/facture?rdvId=${rdv.id}"
                                                    class="btn-facture">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="1.75">
                                                        <path
                                                            d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                        <polyline points="14,2 14,8 20,8" />
                                                    </svg>
                                                    Facture
                                                </a>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                            <rect x="3" y="4" width="18" height="18" rx="2" />
                                            <line x1="16" y1="2" x2="16" y2="6" />
                                            <line x1="8" y1="2" x2="8" y2="6" />
                                            <line x1="3" y1="10" x2="21" y2="10" />
                                        </svg>
                                        <p>Aucun rendez-vous aujourd'hui</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="panel actions-panel">
                        <div class="panel-header">
                            <h2 class="panel-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                    <polygon points="13,2 3,14 12,14 11,22 21,10 12,10 13,2" />
                                </svg>
                                Actions rapides
                            </h2>
                        </div>

                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/assistant/reserver-rdv"
                                class="quick-action-btn">
                                <div class="qa-icon qa-blue">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                        <circle cx="12" cy="12" r="9" />
                                        <line x1="12" y1="8" x2="12" y2="16" />
                                        <line x1="8" y1="12" x2="16" y2="12" />
                                    </svg>
                                </div>
                                <span>Nouveau RDV</span>
                                <svg class="qa-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="1.75">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/assistant/patients" class="quick-action-btn">
                                <div class="qa-icon qa-teal">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                        <circle cx="9" cy="7" r="4" />
                                    </svg>
                                </div>
                                <span>Voir patients</span>
                                <svg class="qa-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="1.75">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/assistant/planning" class="quick-action-btn">
                                <div class="qa-icon qa-indigo">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                        <rect x="3" y="4" width="18" height="18" rx="2" />
                                        <line x1="16" y1="2" x2="16" y2="6" />
                                        <line x1="8" y1="2" x2="8" y2="6" />
                                        <line x1="3" y1="10" x2="21" y2="10" />
                                    </svg>
                                </div>
                                <span>Planning semaine</span>
                                <svg class="qa-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="1.75">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/assistant/ajouter-patient"
                                class="quick-action-btn">
                                <div class="qa-icon qa-green">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                        <circle cx="8.5" cy="7" r="4" />
                                        <line x1="20" y1="8" x2="20" y2="14" />
                                        <line x1="23" y1="11" x2="17" y2="11" />
                                    </svg>
                                </div>
                                <span>Ajouter patient</span>
                                <svg class="qa-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="1.75">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </a>
                        </div>
                    </div>

                </section>
            </main>

            <script>
                // Set current date
                const dateEl = document.getElementById('currentDate');
                const now = new Date();
                const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                dateEl.textContent = now.toLocaleDateString('fr-FR', options);
            </script>

        </body>

        </html>