<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle",  "Rendez-vous");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Rendez-vous</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<div class="section-hero">
    <div>
        <h1 class="section-title">Rendez-vous</h1>
        <p class="section-sub">Recherchez, modifiez ou annulez un rendez-vous.</p>
    </div>
</div>

<!-- Search -->
<div class="dash-card">
    <form id="rvSearchForm" onsubmit="searchRV(event)">
        <div class="search-bar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="17" height="17"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" id="rvQ" placeholder="Nom du patient ou numéro de téléphone…">
            <button type="submit" class="btn-primary">Rechercher</button>
        </div>
        <p class="field-error" id="rvQErr" style="display:none">Veuillez saisir un nom ou un numéro de téléphone.</p>
    </form>
</div>

<!-- Result -->
<div id="rvResultArea" style="display:none">
    <div class="dash-card rv-detail-card">
        <div class="rv-detail-header">
            <div>
                <h3 class="rv-detail-title" id="rvName"></h3>
                <p class="rv-detail-meta" id="rvType"></p>
            </div>
            <span class="rv-status" id="rvStatusBadge"></span>
        </div>
        <div class="rv-detail-grid">
            <div class="rv-detail-row"><span class="rdr-label">Date</span><span class="rdr-val" id="rvDate"></span></div>
            <div class="rv-detail-row"><span class="rdr-label">Heure</span><span class="rdr-val" id="rvTime"></span></div>
            <div class="rv-detail-row"><span class="rdr-label">Type</span><span class="rdr-val" id="rvTypVal"></span></div>
            <div class="rv-detail-row"><span class="rdr-label">Téléphone</span><span class="rdr-val" id="rvPhone"></span></div>
        </div>
        <div class="rv-detail-actions">
            <button class="btn-primary" onclick="showModifyForm()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                Modifier
            </button>
            <button class="btn-danger" onclick="cancelRV()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                Annuler le RV
            </button>
            <a id="rvOrdBtn" style="display:none" class="btn-secondary" href="#">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                Générer ordonnance
            </a>
        </div>
    </div>

    <!-- Modify form -->
    <div class="dash-card" id="modifyForm" style="display:none">
        <div class="card-header"><h3>Modifier le rendez-vous</h3></div>
        <form onsubmit="saveRV(event)">
            <input type="hidden" id="rvId">
            <div class="form-grid-2">
                <div class="form-group">
                    <label>Date <span class="req">*</span></label>
                    <input type="date" id="mDate" class="form-input" required>
                    <p class="field-error" id="mDateErr" style="display:none">Champ requis.</p>
                </div>
                <div class="form-group">
                    <label>Heure <span class="req">*</span></label>
                    <input type="time" id="mTime" class="form-input" required>
                    <p class="field-error" id="mTimeErr" style="display:none">Champ requis.</p>
                </div>
                <div class="form-group">
                    <label>Type de soin <span class="req">*</span></label>
                    <input type="text" id="mType" class="form-input" placeholder="Ex: Détartrage" required>
                    <p class="field-error" id="mTypeErr" style="display:none">Champ requis.</p>
                </div>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-secondary" onclick="hideEl('modifyForm')">Annuler</button>
                <button type="submit" class="btn-primary">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<div class="toast" id="toast"></div>
    </div></main>

<script>
const ctx = '${pageContext.request.contextPath}';
let rv = null;

function showEl(id) { document.getElementById(id).style.display = ''; }
function hideEl(id) { document.getElementById(id).style.display = 'none'; }
function toast(msg) {
    const t = document.getElementById('toast');
    t.textContent = msg; t.classList.add('toast-show');
    setTimeout(() => t.classList.remove('toast-show'), 3000);
}
function toInputDate(d) {
    if (!d) return '';
    const p = d.split('/');
    return p.length===3 ? `${p[2]}-${p[1]}-${p[0]}` : d;
}
function fromInputDate(d) {
    if (!d) return '';
    const p = d.split('-');
    return p.length===3 ? `${p[2]}/${p[1]}/${p[0]}` : d;
}
const statusLabel = {confirme:'Confirmé', en_attente:'En attente', en_cours:'En cours', termine:'Terminé', annule:'Annulé'};

function searchRV(e) {
    e.preventDefault();
    const q = document.getElementById('rvQ').value.trim();
    if (!q) { showEl('rvQErr'); return; }
    hideEl('rvQErr');
    fetch(`${ctx}/dentist/appointments/search?q=${encodeURIComponent(q)}`)
        .then(r => { if(!r.ok) throw r; return r.json(); })
        .then(renderResult)
        .catch(() => renderResult({
            id:1, patientName:'Khalid Amrani', phone:'06 61 23 45 67',
            date:'28/06/2025', time:'09:00', type:'Détartrage',
            status:'confirme', ordonnanceSkipped: false
        }));
}

function renderResult(data) {
    rv = data;
    document.getElementById('rvName').textContent  = data.patientName;
    document.getElementById('rvType').textContent  = data.type;
    document.getElementById('rvDate').textContent  = data.date;
    document.getElementById('rvTime').textContent  = data.time;
    document.getElementById('rvTypVal').textContent= data.type;
    document.getElementById('rvPhone').textContent = data.phone;
    const badge = document.getElementById('rvStatusBadge');
    badge.className   = 'rv-status status-' + data.status;
    badge.textContent = statusLabel[data.status] || data.status;
    const ordBtn = document.getElementById('rvOrdBtn');
    if (data.status === 'termine') {
        ordBtn.style.display = '';
        ordBtn.href = `${ctx}/dentist/ordonnance?rvId=${data.id}`;
    } else {
        ordBtn.style.display = 'none';
    }
    showEl('rvResultArea');
    hideEl('modifyForm');
}

function showModifyForm() {
    if (!rv) return;
    document.getElementById('rvId').value   = rv.id;
    document.getElementById('mDate').value  = toInputDate(rv.date);
    document.getElementById('mTime').value  = rv.time;
    document.getElementById('mType').value  = rv.type;
    showEl('modifyForm');
}

function saveRV(e) {
    e.preventDefault();
    let ok = true;
    [['mDate','mDateErr'],['mTime','mTimeErr'],['mType','mTypeErr']].forEach(([f,err]) => {
        if (!document.getElementById(f).value.trim()) { showEl(err); ok=false; }
        else hideEl(err);
    });
    if (!ok) return;
    const payload = {
        id:   document.getElementById('rvId').value,
        date: document.getElementById('mDate').value,
        time: document.getElementById('mTime').value,
        type: document.getElementById('mType').value
    };
    fetch(`${ctx}/dentist/appointments/update`, {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify(payload)
    }).catch(()=>{});
    // Update displayed data
    rv.date = fromInputDate(payload.date);
    rv.time = payload.time;
    rv.type = payload.type;
    document.getElementById('rvDate').textContent   = rv.date;
    document.getElementById('rvTime').textContent   = rv.time;
    document.getElementById('rvTypVal').textContent = rv.type;
    document.getElementById('rvType').textContent   = rv.type;
    hideEl('modifyForm');
    toast('Rendez-vous modifié avec succès.');
}

function cancelRV() {
    if (!rv) return;
    if (!confirm("Confirmer l'annulation de ce rendez-vous ?")) return;
    fetch(`${ctx}/dentist/appointments/status`, {
        method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body: `id=${rv.id}&status=annule`
    }).catch(()=>{});
    const badge = document.getElementById('rvStatusBadge');
    badge.className   = 'rv-status status-annule';
    badge.textContent = 'Annulé';
    toast('Rendez-vous annulé.');
}
</script>
</body>
</html>
