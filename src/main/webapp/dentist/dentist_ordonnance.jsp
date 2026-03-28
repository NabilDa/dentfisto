<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "overview");
    request.setAttribute("pageTitle",  "Ordonnance");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Ordonnance</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<div class="section-hero">
    <div>
        <h1 class="section-title">Générer une ordonnance</h1>
        <p class="section-sub">Ajoutez les médicaments puis générez le PDF.</p>
    </div>
</div>

<!-- Patient info bar (populated by JS) -->
<div class="dash-card ord-patient-bar">
    <div class="ord-patient-info">
        <div class="waiting-avatar" id="ordAvatar">…</div>
        <div>
            <div class="waiting-rv-name" id="ordPatientName">Chargement…</div>
            <div class="waiting-rv-meta" id="ordPatientMeta"></div>
        </div>
    </div>
</div>

<!-- Builder -->
<div class="dash-card">
    <div class="card-header"><h3>Médicaments prescrits</h3></div>

    <div class="form-group">
        <label>Ajouter un médicament</label>
        <div class="acts-input-row">
            <input type="text" id="medInput" class="form-input"
                   placeholder="Ex: Amoxicilline 500mg – 1 cp × 3/j pendant 5 jours"
                   onkeydown="if(event.key==='Enter'){event.preventDefault();addMed();}">
            <button type="button" class="btn-primary" onclick="addMed()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                Ajouter
            </button>
        </div>
        <p class="field-error" id="medErr" style="display:none">Ajoutez au moins un médicament avant de générer.</p>
    </div>

    <div class="tags-list meds-list" id="medsList"></div>

    <!-- Preview -->
    <div id="ordPreview" style="display:none;margin-top:20px;border-top:1px solid #f1f5f9;padding-top:20px">
        <div class="dossier-section-title">Aperçu de l'ordonnance</div>
        <div class="ord-preview-card">
            <div class="ord-preview-header">
                <div>
                    <strong>DentFisto – Cabinet Dentaire</strong><br>
                    <span id="prvDocName"></span><br>
                    Tél: 05 22 XX XX XX
                </div>
                <div style="text-align:right">
                    <strong>ORDONNANCE MÉDICALE</strong><br>
                    <span id="prvDate"></span><br>
                    N° <span id="prvNum"></span>
                </div>
            </div>
            <div class="ord-preview-patient">
                Pour : <strong id="prvPatient"></strong>
            </div>
            <div id="prvMeds" class="ord-preview-meds"></div>
            <div class="ord-preview-footer">
                <div class="ord-signature-line">Signature &amp; Cachet du Praticien</div>
            </div>
        </div>
    </div>

    <div class="form-actions" style="margin-top:24px">
        <a href="${pageContext.request.contextPath}/dentist/dashboard" class="btn-secondary">
            Passer (plus tard)
        </a>
        <button type="button" class="btn-primary" onclick="generatePdf()">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
                <polyline points="6 9 6 2 18 2 18 9"/>
                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                <rect x="6" y="14" width="12" height="8"/>
            </svg>
            Générer le PDF
        </button>
    </div>
</div>

<div class="toast" id="toast"></div>
    </div></main>

<script>
const ctx   = '${pageContext.request.contextPath}';
const rvId  = new URLSearchParams(location.search).get('rvId') || '${param.rvId}';
let meds    = [];
let patientName = 'Patient';
let doctorName  = '${sessionScope.dentistName}' || 'Dr. Martin';

/* ── Load patient info ── */
fetch(`${ctx}/dentist/appointments/search?q=rvid:${rvId}`)
    .then(r => r.json())
    .then(d => {
        patientName = d.patientName || 'Patient';
        document.getElementById('ordAvatar').textContent     = initials(patientName);
        document.getElementById('ordPatientName').textContent = patientName;
        document.getElementById('ordPatientMeta').textContent = (d.type||'') + ' · ' + (d.date||'');
    })
    .catch(() => {
        patientName = 'Khalid Amrani';
        document.getElementById('ordAvatar').textContent      = 'KA';
        document.getElementById('ordPatientName').textContent = patientName;
        document.getElementById('ordPatientMeta').textContent = 'Détartrage · 28/06/2025';
    });

/* ── Meds ── */
function addMed() {
    const inp = document.getElementById('medInput');
    const val = inp.value.trim();
    if (!val) return;
    meds.push(val);
    renderMeds();
    inp.value = '';
    document.getElementById('medErr').style.display = 'none';
    updatePreview();
}
function removeMed(i) { meds.splice(i,1); renderMeds(); updatePreview(); }
function renderMeds() {
    document.getElementById('medsList').innerHTML = meds.map((m,i)=>
        `<span class="tag">${m}<button type="button" onclick="removeMed(${i})">×</button></span>`
    ).join('');
}

/* ── Preview ── */
function updatePreview() {
    if (meds.length === 0) { document.getElementById('ordPreview').style.display='none'; return; }
    document.getElementById('ordPreview').style.display = '';
    const now = new Date();
    document.getElementById('prvDocName').textContent = doctorName || 'Dr. Martin';
    document.getElementById('prvDate').textContent    = now.toLocaleDateString('fr-FR');
    document.getElementById('prvNum').textContent     = Math.floor(Math.random()*9000+1000);
    document.getElementById('prvPatient').textContent = patientName;
    document.getElementById('prvMeds').innerHTML      = meds.map((m,i)=>
        `<div class="ord-med-item"><span class="ord-med-num">${i+1}.</span> ${m}</div>`
    ).join('');
}

/* ── Generate PDF via servlet (OpenPDF) ── */
function generatePdf() {
    if (meds.length === 0) { document.getElementById('medErr').style.display=''; return; }

    const payload = {
        rvId:        rvId,
        patientName: patientName,
        doctorName:  doctorName,
        date:        new Date().toLocaleDateString('fr-FR'),
        medications: meds
    };

    // POST to servlet — servlet returns PDF as binary
    fetch(`${ctx}/dentist/ordonnance/generate`, {
        method:  'POST',
        headers: {'Content-Type':'application/json'},
        body:    JSON.stringify(payload)
    })
    .then(r => {
        if (!r.ok) throw new Error('Erreur serveur');
        return r.blob();
    })
    .then(blob => {
        // Trigger download
        const url  = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href     = url;
        link.download = `Ordonnance_${patientName.replace(/\s+/g,'_')}_${new Date().toISOString().slice(0,10)}.pdf`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
        // Mark RV as terminé
        fetch(`${ctx}/dentist/appointments/status`, {
            method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body: `id=${rvId}&status=termine`
        }).catch(()=>{});
        showToast('Ordonnance générée et téléchargée.');
        setTimeout(() => window.location.href=`${ctx}/dentist/dashboard`, 1500);
    })
    .catch(() => {
        showToast('Erreur lors de la génération. Vérifiez le serveur.');
    });
}

function initials(n) { return (n||'').split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
function showToast(msg) {
    const t=document.getElementById('toast'); t.textContent=msg;
    t.classList.add('toast-show'); setTimeout(()=>t.classList.remove('toast-show'),3500);
}
</script>
</body>
</html>
