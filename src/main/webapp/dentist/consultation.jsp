<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "overview");
    request.setAttribute("pageTitle",  "Consultation en cours");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Consultation</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<!-- Patient banner -->
<div class="consult-banner">
    <div class="consult-banner-avatar" id="bannerAvatar"></div>
    <div class="consult-banner-info">
        <h2 id="bannerName">Chargement…</h2>
        <p id="bannerMeta"></p>
    </div>
    <span class="rv-status status-en_cours">En cours</span>
</div>

<!-- Consultation form -->
<div class="dash-card" style="margin-top:0">
    <form id="consultForm" onsubmit="saveConsultation(event)">
        <input type="hidden" id="rvId" value="${param.rvId}">
        <input type="hidden" id="patientId">

        <div class="consult-form-grid">

            <!-- Diagnostic -->
            <div class="form-group">
                <label>Diagnostic <span class="req">*</span></label>
                <textarea id="diagnostic" class="form-input form-textarea" rows="3"
                          placeholder="Saisissez le diagnostic…"></textarea>
                <p class="field-error" id="diagnosticErr" style="display:none">Champ requis.</p>
            </div>

            <!-- Observations -->
            <div class="form-group">
                <label>Observations cliniques</label>
                <textarea id="observations" class="form-input form-textarea" rows="3"
                          placeholder="Observations…"></textarea>
            </div>

            <!-- Actes -->
            <div class="form-group">
                <label>Actes effectués <span class="req">*</span></label>
                <div class="acts-input-row">
                    <input type="text" id="actInput" class="form-input"
                           placeholder="Ex: Extraction, Détartrage, Obturation…"
                           onkeydown="if(event.key==='Enter'){event.preventDefault();addAct();}">
                    <button type="button" class="btn-primary btn-sm" onclick="addAct()">+ Ajouter</button>
                </div>
                <p class="field-error" id="actsErr" style="display:none">Ajoutez au moins un acte.</p>
                <div class="tags-list" id="actsList"></div>
            </div>

            <!-- Note médicale -->
            <div class="form-group">
                <label>Note médicale</label>
                <textarea id="note" class="form-input form-textarea" rows="2"
                          placeholder="Note libre…"></textarea>
            </div>

            <!-- Annexer documents -->
            <div class="form-group">
                <label>Annexer des documents</label>
                <div class="file-upload-zone" onclick="document.getElementById('docFile').click()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="24" height="24">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                        <polyline points="17 8 12 3 7 8"/>
                        <line x1="12" y1="3" x2="12" y2="15"/>
                    </svg>
                    <span>Cliquez pour importer (PDF, image, radio…)</span>
                    <small>Max 10 Mo par fichier</small>
                </div>
                <input type="file" id="docFile" style="display:none"
                       accept=".pdf,.jpg,.jpeg,.png,.dicom"
                       multiple onchange="handleFiles(this)">
                <div id="fileList" class="uploaded-files-list"></div>
            </div>

        </div><!-- /consult-form-grid -->

        <div class="consult-footer-actions">
            <a href="${pageContext.request.contextPath}/dentist/dashboard" class="btn-secondary">
                Annuler sans sauvegarder
            </a>
            <button type="submit" class="btn-primary">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v14a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/>
                    <polyline points="7 3 7 8 15 8"/>
                </svg>
                Terminer &amp; Sauvegarder
            </button>
        </div>
    </form>
</div>

<!-- Ordonnance modal (appears after save) -->
<div class="modal-backdrop" id="ordModal">
    <div class="modal modal-md">
        <div class="modal-header">
            <h3>Générer une ordonnance ?</h3>
        </div>
        <p style="font-size:13.5px;color:#64748b;margin-bottom:20px;font-family:'Inter',sans-serif">
            La consultation a été sauvegardée. Souhaitez-vous générer une ordonnance maintenant ?
        </p>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="skipOrd()">Passer (plus tard)</button>
            <a id="goOrdBtn" href="#" class="btn-primary">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                Générer l'ordonnance
            </a>
        </div>
    </div>
</div>

    </div></main>

<script>
const ctx     = '${pageContext.request.contextPath}';
const rvId    = document.getElementById('rvId').value;
let acts      = [];
let uploadedDocs = [];

/* ── Load RV + patient info ── */
fetch(`${ctx}/dentist/appointments/search?q=rvid:${rvId}`)
    .then(r => r.json())
    .then(data => {
        document.getElementById('patientId').value   = data.patientId || '';
        document.getElementById('bannerName').textContent = data.patientName || 'Patient';
        document.getElementById('bannerMeta').textContent = (data.type||'') + ' · ' + (data.time||'');
        document.getElementById('bannerAvatar').textContent = initials(data.patientName||'');
    })
    .catch(() => {
        document.getElementById('bannerName').textContent = 'Patient (demo)';
        document.getElementById('bannerMeta').textContent = 'Détartrage · 09:00';
        document.getElementById('bannerAvatar').textContent = 'KA';
    });

/* Mark status as en_cours */
fetch(`${ctx}/dentist/appointments/status`, {
    method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body: `id=${rvId}&status=en_cours`
}).catch(()=>{});

/* ── Actes ── */
function addAct() {
    const inp = document.getElementById('actInput');
    const val = inp.value.trim();
    if (!val) return;
    acts.push(val);
    renderTags();
    inp.value = '';
}
function removeAct(i) { acts.splice(i,1); renderTags(); }
function renderTags() {
    document.getElementById('actsList').innerHTML = acts.map((a,i)=>
        `<span class="tag">${a}<button type="button" onclick="removeAct(${i})">×</button></span>`
    ).join('');
}

/* ── File upload ── */
function handleFiles(input) {
    Array.from(input.files).forEach(file => {
        const typeMap = {'application/pdf':'PDF','image/jpeg':'Image','image/png':'Image'};
        const doc = {
            name: file.name,
            type: typeMap[file.type]||'Document',
            size: (file.size/1024).toFixed(0)+' Ko',
            importDate: new Date().toLocaleDateString('fr-FR'),
            path: '/uploads/'+file.name
        };
        uploadedDocs.push(doc);
        const row = document.createElement('div');
        row.className = 'uploaded-file-row';
        row.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="14" height="14"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            <span class="uf-name">${file.name}</span>
            <span class="uf-meta">${doc.type} · ${doc.size} · ${doc.importDate}</span>`;
        document.getElementById('fileList').appendChild(row);
    });
    input.value = '';
}

/* ── Save consultation ── */
function saveConsultation(e) {
    e.preventDefault();
    let ok = true;
    const diag = document.getElementById('diagnostic').value.trim();
    if (!diag) { document.getElementById('diagnosticErr').style.display=''; ok=false; }
    else document.getElementById('diagnosticErr').style.display='none';
    if (acts.length===0) { document.getElementById('actsErr').style.display=''; ok=false; }
    else document.getElementById('actsErr').style.display='none';
    if (!ok) return;

    const payload = {
        rvId:         rvId,
        patientId:    document.getElementById('patientId').value,
        diagnostic:   diag,
        observations: document.getElementById('observations').value.trim(),
        note:         document.getElementById('note').value.trim(),
        acts:         acts,
        documents:    uploadedDocs
    };

    fetch(`${ctx}/dentist/consultation/save`, {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify(payload)
    }).catch(()=>{});

    // Show ordonnance prompt
    document.getElementById('goOrdBtn').href = `${ctx}/dentist/ordonnance?rvId=${rvId}`;
    document.getElementById('ordModal').classList.add('open');
}

function skipOrd() {
    // Mark status terminé and flag ordonnance skipped
    fetch(`${ctx}/dentist/appointments/status`, {
        method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body: `id=${rvId}&status=termine&ordSkipped=true`
    }).catch(()=>{});
    window.location.href = `${ctx}/dentist/dashboard`;
}

function initials(n) { return (n||'').split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
</script>
</body>
</html>
