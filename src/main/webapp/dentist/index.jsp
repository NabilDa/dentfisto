<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "overview");
    request.setAttribute("pageTitle",  "Tableau de bord");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Tableau de bord</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<!-- ══════════════════════════════════════
     OVERVIEW CONTENT
══════════════════════════════════════ -->

<div class="overview-top">
    <div class="greeting-block">
        <h1 class="section-title">Bonjour, ${sessionScope.dentistName != null ? sessionScope.dentistName : 'Dr. Martin'}</h1>
        <p class="section-sub">Voici votre espace de travail du jour.</p>
    </div>

    <!-- Waiting patient widget -->
    <div class="waiting-widget" id="waitingWidget" onclick="checkWaiting()">
        <div class="waiting-inner">
            <div class="waiting-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="22" height="22">
                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                </svg>
                <span class="waiting-dot" id="waitingDot" style="display:none"></span>
            </div>
            <div class="waiting-text">
                <span class="waiting-label">Patient en attente</span>
                <span class="waiting-sub" id="waitingSubtext">Vérifier</span>
            </div>
        </div>
    </div>
</div>

<!-- Today RVs (ordered: en_cours → confirmé → terminé → annulé, NO en_attente) -->
<div class="overview-grid">
    <div class="dash-card">
        <div class="card-header">
            <h3>RV du jour</h3>
            <a href="${pageContext.request.contextPath}/appointments" class="btn-text">Voir tout →</a>
        </div>
        <div class="rv-list">
            <c:choose>
                <c:when test="${not empty todayRvs}">
                    <c:forEach var="rv" items="${todayRvs}">
                        <c:if test="${rv.status != 'en_attente'}">
                            <div class="rv-item">
                                <div class="rv-time">${rv.time}</div>
                                <div class="rv-info">
                                    <span class="rv-patient">${rv.patientName}</span>
                                    <span class="rv-type">${rv.type}</span>
                                </div>
                                <span class="rv-status status-${rv.status}">${rv.statusLabel}</span>
                                <c:if test="${rv.status == 'termine' && rv.ordonnanceSkipped}">
                                    <a href="${pageContext.request.contextPath}/ordonnance?rvId=${rv.id}"
                                       class="btn-table btn-gen-ord">+ Ordonnance</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Demo data shown when no servlet data -->
                    <div class="rv-item">
                        <div class="rv-time">10:30</div>
                        <div class="rv-info"><span class="rv-patient">Fatima Benali</span><span class="rv-type">Extraction</span></div>
                        <span class="rv-status status-en_cours">En cours</span>
                    </div>
                    <div class="rv-item">
                        <div class="rv-time">09:00</div>
                        <div class="rv-info"><span class="rv-patient">Khalid Amrani</span><span class="rv-type">Détartrage</span></div>
                        <span class="rv-status status-confirme">Confirmé</span>
                    </div>
                    <div class="rv-item">
                        <div class="rv-time">14:00</div>
                        <div class="rv-info"><span class="rv-patient">Nadia Chraibi</span><span class="rv-type">Orthodontie</span></div>
                        <span class="rv-status status-confirme">Confirmé</span>
                    </div>
                    <div class="rv-item">
                        <div class="rv-time">08:00</div>
                        <div class="rv-info"><span class="rv-patient">Youssef Idrissi</span><span class="rv-type">Contrôle</span></div>
                        <span class="rv-status status-termine">Terminé</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Quick access -->
    <div class="dash-card">
        <div class="card-header"><h3>Accès rapide</h3></div>
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/appointments" class="qa-btn">
                <div class="qa-icon qa-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="18" height="18"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg></div>
                <div class="qa-text"><span class="qa-title">Chercher un RV</span><span class="qa-sub">Par nom ou téléphone</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/patients" class="qa-btn">
                <div class="qa-icon qa-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="18" height="18"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg></div>
                <div class="qa-text"><span class="qa-title">Chercher un patient</span><span class="qa-sub">Par nom ou téléphone</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/planning" class="qa-btn">
                <div class="qa-icon qa-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="18" height="18"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
                <div class="qa-text"><span class="qa-title">Planning</span><span class="qa-sub">Jour &amp; semaine</span></div>
            </a>
            <a href="${pageContext.request.contextPath}/dossier" class="qa-btn">
                <div class="qa-icon qa-red"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="18" height="18"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                <div class="qa-text"><span class="qa-title">Dossiers médicaux</span><span class="qa-sub">Consulter &amp; modifier</span></div>
            </a>
        </div>
    </div>
</div>

<!-- Waiting modal -->
<div class="modal-backdrop" id="waitingModal">
    <div class="modal modal-md">
        <div class="modal-header">
            <h3>Patient en attente</h3>
            <button class="modal-close" onclick="closeModal('waitingModal')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>
        <div id="waitingModalContent"></div>
    </div>
</div>

    </div><!-- /content-area -->
</main>

<script>
const ctx = '${pageContext.request.contextPath}';

function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.querySelectorAll('.modal-backdrop').forEach(bd =>
    bd.addEventListener('click', e => { if(e.target===bd) bd.classList.remove('open'); })
);

function initials(name) {
    return (name||'').split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2);
}

/* ── Waiting widget ── */
function pollWaiting() {
    fetch(ctx + '/dentist/waiting')
        .then(r => r.json())
        .then(data => {
            const dot = document.getElementById('waitingDot');
            const sub = document.getElementById('waitingSubtext');
            const w   = document.getElementById('waitingWidget');
            if (data.hasWaiting) {
                dot.style.display = 'block';
                sub.textContent   = data.patientName;
                w.classList.add('widget-alert');
            } else {
                dot.style.display = 'none';
                sub.textContent   = 'Vérifier';
                w.classList.remove('widget-alert');
            }
        })
        .catch(() => {});
}

function checkWaiting() {
    fetch(ctx + '/dentist/waiting')
        .then(r => r.json())
        .then(data => showWaitingModal(data))
        .catch(() => showWaitingModal({
            hasWaiting: true, rvId: 1,
            patientName: 'Khalid Amrani', type: 'Détartrage', time: '09:00'
        }));
}

function showWaitingModal(data) {
    const content = document.getElementById('waitingModalContent');
    if (data.hasWaiting) {
        content.innerHTML = `
            <div class="waiting-rv-info">
                <div class="waiting-avatar">${initials(data.patientName)}</div>
                <div>
                    <div class="waiting-rv-name">${data.patientName}</div>
                    <div class="waiting-rv-meta">${data.type} · ${data.time}</div>
                </div>
            </div>
            <p class="waiting-rv-hint">Démarrez la consultation pour passer ce patient <strong>En cours</strong>.</p>
            <div class="modal-actions" style="margin-top:20px">
                <button class="btn-secondary" onclick="closeModal('waitingModal')">Fermer</button>
                <a href="${ctx}/dentist/consultation?rvId=${data.rvId}" class="btn-primary">Démarrer la consultation</a>
            </div>`;
    } else {
        content.innerHTML = `
            <div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/></svg>
                <p>Aucun patient en attente pour le moment.</p>
            </div>
            <div class="modal-actions"><button class="btn-secondary" onclick="closeModal('waitingModal')">Fermer</button></div>`;
    }
    openModal('waitingModal');
}

pollWaiting();
setInterval(pollWaiting, 30000);
</script>
</body>
</html>
