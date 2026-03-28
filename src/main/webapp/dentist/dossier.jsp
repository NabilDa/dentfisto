<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dossier");
    request.setAttribute("pageTitle",  "Dossiers médicaux");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Dossiers médicaux</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<div class="section-hero">
    <div>
        <h1 class="section-title">Dossiers médicaux</h1>
        <p class="section-sub">Accédez au dossier complet d'un patient.</p>
    </div>
</div>

<!-- Search -->
<div class="dash-card">
    <form id="dossierForm" onsubmit="searchDossier(event)">
        <div class="search-bar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="17" height="17"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" id="dosQ" placeholder="Nom ou numéro de téléphone du patient…">
            <button type="submit" class="btn-primary">Ouvrir le dossier</button>
        </div>
        <p class="field-error" id="dosQErr" style="display:none">Veuillez saisir un nom ou un numéro de téléphone.</p>
    </form>
</div>

<!-- Full dossier card -->
<div id="dossierArea" style="display:none">
    <div class="dash-card dossier-big-card">

        <!-- Header -->
        <div class="dossier-header">
            <div class="dossier-avatar-lg" id="dosAvatar"></div>
            <div class="dossier-header-info">
                <h2 id="dosName"></h2>
                <div class="dossier-header-meta" id="dosMeta"></div>
            </div>
        </div>

        <!-- Info personnelles -->
        <div class="dossier-section-title">Informations personnelles</div>
        <div class="dossier-info-grid" id="dosInfoGrid"></div>

        <!-- Consultations -->
        <div class="dossier-section-title" style="margin-top:28px">
            Historique des consultations
            <span class="consult-count" id="dosConsultCount"></span>
        </div>
        <div class="consultations-list" id="dosConsults"></div>
        <div class="empty-state" id="dosConsultsEmpty" style="display:none;padding:20px 0">
            <p>Aucune consultation enregistrée pour ce patient.</p>
        </div>

        <!-- Documents -->
        <div class="dossier-section-title" style="margin-top:28px">Documents annexés</div>
        <div class="doc-list" id="dosDocList"></div>
        <div class="empty-state" id="dosDocEmpty" style="display:none;padding:16px 0">
            <p>Aucun document annexé.</p>
        </div>

    </div>
</div>

    </div></main>

<script>
const ctx = '${pageContext.request.contextPath}';

function showEl(id) { document.getElementById(id).style.display = ''; }
function hideEl(id) { document.getElementById(id).style.display = 'none'; }
function initials(n) { return (n||'').split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }

function searchDossier(e) {
    e.preventDefault();
    const q = document.getElementById('dosQ').value.trim();
    if (!q) { showEl('dosQErr'); return; }
    hideEl('dosQErr');
    fetch(`${ctx}/dentist/dossier/search?q=${encodeURIComponent(q)}`)
        .then(r => { if(!r.ok) throw r; return r.json(); })
        .then(renderDossier)
        .catch(() => renderDossier({
            id:1, firstName:'Khalid', lastName:'Amrani', age:34,
            phone:'06 61 23 45 67', dob:'15/03/1991', blood:'A+',
            allergies:'Pénicilline', address:'12 Rue des Roses, Casablanca',
            lastVisit:'20/05/2025',
            consultations:[
                {date:'20/05/2025', type:'Contrôle', diagnostic:'Carie légère dent 36',
                 acts:['Obturation composite'], note:'Hygiène bucco-dentaire satisfaisante.',
                 docs:[{name:'Photo_dent36.jpg', type:'Image', importDate:'20/05/2025'}]},
                {date:'10/01/2025', type:'Détartrage', diagnostic:'Tartre modéré généralisé',
                 acts:['Détartrage ultrason', 'Polissage'], note:'Conseils hygiène donnés.',
                 docs:[{name:'Radio_panoramique.pdf', type:'PDF', importDate:'10/01/2025'}]}
            ],
            documents:[
                {name:'Radio_panoramique.pdf', type:'PDF', importDate:'10/01/2025'},
                {name:'Consentement_eclaire.pdf', type:'PDF', importDate:'15/03/2025'}
            ]
        }));
}

function renderDossier(d) {
    showEl('dossierArea');
    const fullName = d.firstName + ' ' + d.lastName;
    document.getElementById('dosAvatar').textContent = initials(fullName);
    document.getElementById('dosName').textContent   = fullName;
    document.getElementById('dosMeta').innerHTML =
        `<span>${d.age} ans</span>` +
        (d.blood ? ` · <span class="blood-badge">${d.blood}</span>` : '') +
        ` · <span>Dernière visite : ${d.lastVisit||'—'}</span>`;

    // Info grid
    document.getElementById('dosInfoGrid').innerHTML = [
        ['Téléphone', d.phone], ['Date de naissance', d.dob||'—'],
        ['Groupe sanguin', d.blood||'—'],
        ['Allergies', d.allergies||'Aucune'], ['Adresse', d.address||'—']
    ].map(([k,v]) => `<div class="di-row"><span class="di-label">${k}</span><span class="di-val${k==='Allergies'&&v!=='Aucune'?' allergy':''}">${v}</span></div>`).join('');

    // Consultations
    const consults = d.consultations || [];
    document.getElementById('dosConsultCount').textContent = `${consults.length} consultation(s)`;
    const cl = document.getElementById('dosConsults');
    cl.innerHTML = '';
    if (consults.length === 0) {
        showEl('dosConsultsEmpty');
    } else {
        hideEl('dosConsultsEmpty');
        consults.forEach((c, i) => {
            const el = document.createElement('div');
            el.className = 'consult-entry';
            const docsHtml = (c.docs||[]).length
                ? `<div class="ce-row"><span class="ce-label">Documents</span><span>${c.docs.map(d=>`${d.name} (${d.type}, ${d.importDate})`).join(', ')}</span></div>`
                : '';
            el.innerHTML = `
                <div class="consult-entry-header" onclick="toggleConsult(this)">
                    <div class="ce-left">
                        <span class="ce-date">${c.date}</span>
                        <span class="ce-type">${c.type}</span>
                    </div>
                    <svg class="ce-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><polyline points="6 9 12 15 18 9"/></svg>
                </div>
                <div class="consult-entry-body" style="display:none">
                    <div class="ce-row"><span class="ce-label">Diagnostic</span><span>${c.diagnostic}</span></div>
                    <div class="ce-row"><span class="ce-label">Actes</span><span>${(c.acts||[]).join(', ')}</span></div>
                    ${c.note ? `<div class="ce-row"><span class="ce-label">Note</span><span>${c.note}</span></div>` : ''}
                    ${docsHtml}
                </div>`;
            cl.appendChild(el);
        });
    }

    // Documents
    const docs = d.documents || [];
    const dl = document.getElementById('dosDocList');
    if (docs.length === 0) {
        dl.innerHTML = '';
        showEl('dosDocEmpty');
    } else {
        hideEl('dosDocEmpty');
        dl.innerHTML = docs.map(doc => `
            <div class="doc-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="15" height="15"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                <span class="doc-name">${doc.name}</span>
                <span class="doc-date">${doc.type} · ${doc.importDate}</span>
                <a href="${ctx}/dentist/dossier/download?file=${encodeURIComponent(doc.name)}" class="doc-dl" title="Télécharger">↓</a>
            </div>`).join('');
    }

    document.getElementById('dossierArea').scrollIntoView({behavior:'smooth', block:'start'});
}

function toggleConsult(header) {
    const body = header.nextElementSibling;
    const open = body.style.display !== 'none';
    body.style.display = open ? 'none' : '';
    header.querySelector('.ce-chevron').style.transform = open ? '' : 'rotate(180deg)';
}
</script>
</body>
</html>
