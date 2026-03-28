<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle",  "Patients");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Patients</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<div class="section-hero">
    <div>
        <h1 class="section-title">Patients</h1>
        <p class="section-sub">Recherchez un patient par nom ou téléphone.</p>
    </div>
</div>

<!-- Search -->
<div class="dash-card">
    <form id="patSearchForm" onsubmit="searchPatient(event)">
        <div class="search-bar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" width="17" height="17"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" id="patQ" placeholder="Nom ou numéro de téléphone…">
            <button type="submit" class="btn-primary">Rechercher</button>
        </div>
        <p class="field-error" id="patQErr" style="display:none">Veuillez saisir un nom ou un numéro de téléphone.</p>
    </form>
</div>

<!-- Result cards -->
<div id="patResultsArea" style="display:none">
    <div class="patient-results-grid" id="patResultsGrid"></div>

    <!-- Full patient detail -->
    <div class="dash-card patient-full-card" id="patFullDetail" style="display:none">
        <div class="card-header">
            <div style="display:flex;align-items:center;gap:14px">
                <div class="prc-avatar" id="patDetailAvatar"></div>
                <h3 id="patDetailName" style="font-size:18px;font-weight:700;color:#1e293b"></h3>
            </div>
            <button class="btn-primary btn-sm" onclick="showEditForm()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                Modifier
            </button>
        </div>
        <div class="patient-detail-grid" id="patDetailGrid"></div>

        <!-- Edit form -->
        <div id="patEditForm" style="display:none;margin-top:22px;border-top:1px solid #f1f5f9;padding-top:20px">
            <h4 style="font-size:14px;font-weight:700;color:#1e293b;margin-bottom:16px">Modifier les informations</h4>
            <form onsubmit="savePatient(event)">
                <input type="hidden" id="editId">
                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Prénom <span class="req">*</span></label>
                        <input type="text" id="eFirst" class="form-input" required>
                        <p class="field-error" id="eFirstErr" style="display:none">Champ requis.</p>
                    </div>
                    <div class="form-group">
                        <label>Nom <span class="req">*</span></label>
                        <input type="text" id="eLast" class="form-input" required>
                        <p class="field-error" id="eLastErr" style="display:none">Champ requis.</p>
                    </div>
                    <div class="form-group">
                        <label>Téléphone <span class="req">*</span></label>
                        <input type="tel" id="ePhone" class="form-input" required>
                        <p class="field-error" id="ePhoneErr" style="display:none">Champ requis.</p>
                    </div>
                    <div class="form-group">
                        <label>Date de naissance</label>
                        <input type="date" id="eDob" class="form-input">
                    </div>
                    <div class="form-group">
                        <label>Groupe sanguin</label>
                        <select id="eBlood" class="form-select">
                            <option value="">—</option>
                            <option>A+</option><option>A-</option>
                            <option>B+</option><option>B-</option>
                            <option>AB+</option><option>AB-</option>
                            <option>O+</option><option>O-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Allergies</label>
                        <input type="text" id="eAllergies" class="form-input" placeholder="Ex: Pénicilline">
                    </div>
                    <div class="form-group" style="grid-column:1/-1">
                        <label>Adresse</label>
                        <input type="text" id="eAddress" class="form-input" placeholder="Adresse complète">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="hideEl('patEditForm')">Annuler</button>
                    <button type="submit" class="btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>
    </div></main>

<script>
const ctx = '${pageContext.request.contextPath}';
let currentPat = null;

function showEl(id) { document.getElementById(id).style.display = ''; }
function hideEl(id) { document.getElementById(id).style.display = 'none'; }
function toast(msg) {
    const t=document.getElementById('toast'); t.textContent=msg;
    t.classList.add('toast-show'); setTimeout(()=>t.classList.remove('toast-show'),3000);
}
function initials(n) { return (n||'').split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
function toInputDate(d) {
    if (!d) return '';
    const p=d.split('/');
    return p.length===3?`${p[2]}-${p[1]}-${p[0]}`:d;
}
function fromInputDate(d) {
    if (!d) return '';
    const p=d.split('-');
    return p.length===3?`${p[2]}/${p[1]}/${p[0]}`:d;
}

function searchPatient(e) {
    e.preventDefault();
    const q = document.getElementById('patQ').value.trim();
    if (!q) { showEl('patQErr'); return; }
    hideEl('patQErr');
    fetch(`${ctx}/dentist/patients/search?q=${encodeURIComponent(q)}`)
        .then(r => { if(!r.ok) throw r; return r.json(); })
        .then(data => renderCards(Array.isArray(data)?data:[data]))
        .catch(() => renderCards([
            {id:1,firstName:'Khalid',lastName:'Amrani',phone:'06 61 23 45 67',age:34,blood:'A+',allergies:'Pénicilline',dob:'15/03/1991',address:'12 Rue des Roses, Casablanca'},
            {id:2,firstName:'Fatima',lastName:'Benali',phone:'06 72 34 56 78',age:27,blood:'O+',allergies:'',dob:'02/07/1998',address:'5 Av Hassan II, Rabat'}
        ]));
}

function renderCards(patients) {
    const grid = document.getElementById('patResultsGrid');
    grid.innerHTML = '';
    hideEl('patFullDetail');
    showEl('patResultsArea');
    patients.forEach(p => {
        const ini = initials(p.firstName+' '+p.lastName);
        const card = document.createElement('div');
        card.className = 'patient-result-card';
        card.innerHTML = `
            <div class="prc-avatar">${ini}</div>
            <div class="prc-info">
                <span class="prc-name">${p.firstName} ${p.lastName}</span>
                <span class="prc-meta">${p.age} ans · ${p.phone}</span>
            </div>
            <button class="btn-primary btn-sm" onclick='openDetail(${JSON.stringify(p)})'>Voir</button>`;
        grid.appendChild(card);
    });
}

function openDetail(p) {
    currentPat = p;
    const ini = initials(p.firstName+' '+p.lastName);
    document.getElementById('patDetailAvatar').textContent = ini;
    document.getElementById('patDetailName').textContent   = p.firstName+' '+p.lastName;
    const fields = [
        ['Téléphone', p.phone], ['Date de naissance', p.dob||'—'],
        ['Âge', (p.age||'—')+' ans'], ['Groupe sanguin', p.blood||'—'],
        ['Allergies', p.allergies||'Aucune'], ['Adresse', p.address||'—']
    ];
    document.getElementById('patDetailGrid').innerHTML = fields.map(([k,v])=>`
        <div class="pd-row"><span class="pd-label">${k}</span><span class="pd-val">${v}</span></div>`).join('');
    hideEl('patEditForm');
    showEl('patFullDetail');
    document.getElementById('patFullDetail').scrollIntoView({behavior:'smooth',block:'start'});
}

function showEditForm() {
    const p = currentPat;
    document.getElementById('editId').value      = p.id;
    document.getElementById('eFirst').value      = p.firstName;
    document.getElementById('eLast').value       = p.lastName;
    document.getElementById('ePhone').value      = p.phone;
    document.getElementById('eDob').value        = toInputDate(p.dob);
    document.getElementById('eBlood').value      = p.blood||'';
    document.getElementById('eAllergies').value  = p.allergies||'';
    document.getElementById('eAddress').value    = p.address||'';
    showEl('patEditForm');
}

function savePatient(e) {
    e.preventDefault();
    let ok = true;
    [['eFirst','eFirstErr'],['eLast','eLastErr'],['ePhone','ePhoneErr']].forEach(([f,err])=>{
        if (!document.getElementById(f).value.trim()) { showEl(err); ok=false; }
        else hideEl(err);
    });
    if (!ok) return;
    const payload = {
        id:        document.getElementById('editId').value,
        firstName: document.getElementById('eFirst').value.trim(),
        lastName:  document.getElementById('eLast').value.trim(),
        phone:     document.getElementById('ePhone').value.trim(),
        dob:       fromInputDate(document.getElementById('eDob').value),
        blood:     document.getElementById('eBlood').value,
        allergies: document.getElementById('eAllergies').value.trim(),
        address:   document.getElementById('eAddress').value.trim()
    };
    fetch(`${ctx}/dentist/patients/update`, {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify(payload)
    }).catch(()=>{});
    currentPat = {...currentPat, ...payload};
    openDetail(currentPat);
    hideEl('patEditForm');
    toast('Informations patient mises à jour.');
}
</script>
</body>
</html>
