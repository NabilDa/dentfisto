/* ============================================
   DentFisto – Dentist Dashboard JS
   Extracted from dentist/index.jsp
   ============================================ */

/* NOTE: CTX, weekRdvData, and section-switching EL directives are set inline in the JSP */


    /* ── Date ── */
    document.getElementById('currentDate').textContent =
        new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });
    const dayLabel = document.getElementById('dayLabel');
    if (dayLabel) dayLabel.textContent = new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });

    /* ── Section navigation ── */
    const sectionLabels = { overview:'Tableau de bord', planning:'Planning', 'search-rdv':'Chercher RV', 'search-patient':'Chercher Patient', dossier:'Dossier médical' };

    function showSection(name) {
        document.querySelectorAll('.dash-section').forEach(s => { s.classList.remove('active'); s.style.display = 'none'; });
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        const sec = document.getElementById('section-' + name);
        if (sec) { sec.style.display = 'block'; sec.classList.add('active'); }
        const nav = document.querySelector('[data-section="' + name + '"]');
        if (nav) nav.classList.add('active');
        document.getElementById('breadcrumbText').textContent = sectionLabels[name] || name;
        // Also hide consultation section if not targeted
        var consultSec = document.getElementById('section-consultation');
        if (consultSec && name !== 'consultation') consultSec.style.display = 'none';
        // Also hide ordonnance section if not targeted
        var ordSec = document.getElementById('section-ordonnance-gen');
        if (ordSec && name !== 'ordonnance-gen') ordSec.style.display = 'none';
        window.scrollTo(0,0);
    }

    // If consultation data was loaded by servlet, show consultation section

    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) { e.preventDefault(); if (this.dataset.section) showSection(this.dataset.section); });
    });

    /* ── Sidebar toggle ── */
    document.getElementById('sidebarToggle').addEventListener('click', () => {
        document.getElementById('sidebar').classList.toggle('collapsed');
        document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed');
    });

    /* ── Planning switch ── */
    function switchPlanning(mode) {
        document.getElementById('planningDay').style.display = mode === 'day' ? '' : 'none';
        document.getElementById('planningWeek').style.display = mode === 'week' ? '' : 'none';
        document.getElementById('btnDay').classList.toggle('active', mode === 'day');
        document.getElementById('btnWeek').classList.toggle('active', mode === 'week');
        if (mode === 'week') buildWeeklyCalendar();
    }

    /* ── Status modal ── */
    function openStatusModal(id, currentStatus) {
        document.getElementById('statusRvId').value = id;
        document.getElementById('newStatus').value = currentStatus;
        document.getElementById('statusModal').classList.add('open');
    }
    function closeStatusModal() { document.getElementById('statusModal').classList.remove('open'); }
    document.getElementById('statusModal').addEventListener('click', function(e) { if (e.target === this) closeStatusModal(); });

    /* ── RV item click delegation ── */
    document.querySelectorAll('.rv-item[data-rdv-id], .time-slot[data-rdv-id]').forEach(function(item) {
        item.addEventListener('click', function() {
            var id = this.getAttribute('data-rdv-id');
            var statut = this.getAttribute('data-statut');
            if (statut === 'EN_SALLE_D_ATTENTE' || statut === 'PLANIFIE') {
                openStatusModal(id, statut);
            } else if (statut === 'EN_COURS') {
                window.location.href = CTX + '/dentist/consultation?rdvId=' + id;
            }
        });
    });

    /* ── Inline validation ── */
    function showError(id, msg) { const el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = 'block'; } }
    function clearError(id) { const el = document.getElementById(id); if (el) { el.textContent = ''; el.style.display = 'none'; } }

    function validateConsultation() {
        let ok = true;
        clearError('diagnosticError');
        if (!document.getElementById('diagnostic').value.trim()) { showError('diagnosticError', 'Le diagnostic est obligatoire.'); ok = false; }
        return ok;
    }

    /* ── Search RDV ── */
    function searchRdv() {
        const nom = document.getElementById('searchRdvNom').value.trim();
        const tel = document.getElementById('searchRdvTel').value.trim();
        clearError('searchRdvError');
        if (!nom || !tel) { showError('searchRdvError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        fetch(CTX + '/api/search?type=rdv&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('searchRdvResults');
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun résultat trouvé.</div>'; return; }
                let html = '<div class="dash-card"><div class="table-wrapper"><table class="data-table"><thead><tr><th>Patient</th><th>Date</th><th>Heure</th><th>Motif</th><th>Statut</th><th>Actions</th></tr></thead><tbody>';
                data.results.forEach(r => {
                    const sc = r.statut === 'EN_COURS' ? 'in_progress' : r.statut === 'PLANIFIE' ? 'confirmed' : r.statut === 'TERMINE' ? 'done' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'pending' : 'cancelled';
                    html += '<tr>';
                    html += '<td class="td-bold" style="cursor:pointer;text-decoration:underline;color:#1a6fa8;" onclick="showRdvDetail(' + r.id + ')">' + esc(r.patient) + '</td>';
                    html += '<td>' + r.date + '</td><td>' + r.heure + '</td><td>' + esc(r.motif) + '</td>';
                    html += '<td><span class="rv-status status-' + sc + '">' + r.statut + '</span></td>';
                    html += '<td class="td-actions" style="display:flex;gap:6px;">';
                    html += '<button class="btn-table btn-edit" onclick="openRdvEditModal(' + r.id + ')">Modifier</button>';
                    if (r.statut !== 'ANNULE' && r.statut !== 'TERMINE') {
                        html += '<button class="btn-table btn-cancel" onclick="cancelRdv(' + r.id + ')">Annuler</button>';
                    }
                    html += '</td></tr>';
                });
                html += '</tbody></table></div></div>';
                div.innerHTML = html;
            });
    }

    /* ── Search Patient ── */
    function searchPatient() {
        const nom = document.getElementById('searchPatientNom').value.trim();
        const tel = document.getElementById('searchPatientTel').value.trim();
        clearError('searchPatientError');
        if (!nom || !tel) { showError('searchPatientError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        fetch(CTX + '/api/search?type=patient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('searchPatientResults');
                document.getElementById('patientDetailView').style.display = 'none';
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun patient trouvé.</div>'; return; }
                let html = '<div class="patient-grid">';
                data.results.forEach(p => {
                    html += '<div class="patient-card">';
                    html += '<div class="patient-card-top" style="cursor:pointer" onclick="showPatientOnly(' + p.id + ')">';
                    html += '<div class="patient-avatar">' + p.nom.charAt(0) + p.prenom.charAt(0) + '</div>';
                    html += '<div class="patient-info"><span class="patient-name">' + esc(p.nom) + ' ' + esc(p.prenom) + '</span><span class="patient-meta">' + esc(p.tel) + '</span></div>';
                    html += '</div>';
                    html += '<div style="display:flex;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #f1f5f9;">';
                    html += '<button class="btn-table btn-edit" style="flex:1;" onclick="showPatientEditForm(' + p.id + ')">✏️ Modifier</button>';
                    html += '</div>';
                    html += '</div>';
                });
                html += '</div>';
                div.innerHTML = html;
            });
    }

    /* ── Show Patient Only (info + modify, no consultations) ── */
    function showPatientOnly(patientId) {
        // Hide search bar and results
        var section = document.getElementById('section-search-patient');
        section.querySelector('.search-bar-form').style.display = 'none';
        document.getElementById('searchPatientResults').style.display = 'none';
        var div = document.getElementById('patientDetailView');
        div.style.display = 'block';
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement…</div>';

        fetch(CTX + '/api/search?type=patientDetail&id=' + patientId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                div.innerHTML = buildPatientOnlyHTML(data);
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    function backToPatientSearch() {
        var section = document.getElementById('section-search-patient');
        section.querySelector('.search-bar-form').style.display = '';
        document.getElementById('searchPatientResults').style.display = '';
        document.getElementById('patientDetailView').style.display = 'none';
    }

    /* ── Build Patient-Only HTML (info + editable form) ── */
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
        if (p.responsableNom) html += infoRow('Responsable légal', p.responsableNom + (p.responsableTel ? ' (' + p.responsableTel + ')' : ''));
        html += '</div>';
        // Modifier button inside detail view
        html += '<div style="margin-top:20px;padding-top:16px;border-top:1px solid #f1f5f9;">';
        html += '<button class="btn-primary" onclick="showPatientEditForm(' + p.id + ')" style="width:100%;">✏️ Modifier les informations</button>';
        html += '</div>';
        html += '</div>';
        html += '</div>';
        return html;
    }

    /* ── Load Patient Detail Inline for Dossier section (AJAX) ── */
    function loadDossierDetailInline(patientId) {
        // Hide search bar and patient cards
        var section = document.getElementById('section-dossier');
        section.querySelector('.search-bar-form').style.display = 'none';
        document.getElementById('dossierPatientCards').style.display = 'none';
        var div = document.getElementById('dossierFullView');
        div.style.display = 'block';
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement du dossier…</div>';

        fetch(CTX + '/api/search?type=patientDetail&id=' + patientId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                div.innerHTML = buildPatientDetailHTML(data);
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    function backToDossierSearch() {
        var section = document.getElementById('section-dossier');
        section.querySelector('.search-bar-form').style.display = '';
        document.getElementById('dossierPatientCards').style.display = '';
        document.getElementById('dossierFullView').style.display = 'none';
    }

    /* ── Build Patient Detail HTML ── */
    function buildPatientDetailHTML(p) {
        let html = '<div class="dossier-detail-view">';

        // Back button
        html += '<button class="btn-secondary" onclick="backToDossierSearch()" style="margin-bottom:16px;">← Retour aux résultats</button>';

        // Patient banner
        html += '<div class="dash-card"><div class="dossier-layout">';

        // Left: patient info sidebar
        html += '<div class="dash-card dossier-sidebar-card" style="margin-bottom:0;border:1px solid #e8edf3;">';
        html += '<div class="dossier-patient-header">';
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
        if (p.responsableNom) html += infoRow('Responsable légal', p.responsableNom + (p.responsableTel ? ' (' + p.responsableTel + ')' : ''));
        html += '</div>';

        // Dossier reference
        if (p.dossier) {
            html += '<div style="margin-top:16px;padding-top:14px;border-top:1px solid #f1f5f9;">';
            html += '<div class="dossier-info-row"><span class="di-label">N° Dossier</span><span class="di-val">' + esc(p.dossier.ref) + '</span></div>';
            html += '<div class="dossier-info-row" style="margin-top:6px;"><span class="di-label">Créé le</span><span class="di-val">' + p.dossier.dateCreation + '</span></div>';
            html += '</div>';
        }
        html += '</div>';

        // Right: consultation history
        html += '<div>';
        html += '<h3 style="font-size:16px;font-weight:700;color:#1e293b;margin-bottom:16px;">Historique des consultations</h3>';

        if (p.consultations && p.consultations.length > 0) {
            p.consultations.forEach(function(c, idx) {
                html += '<div class="dash-card consultation-history-card" style="margin-bottom:12px;border:1px solid #e8edf3;">';
                html += '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">';
                html += '<div style="display:flex;align-items:center;gap:10px;">';
                html += '<div style="width:36px;height:36px;border-radius:10px;background:#eff6ff;display:flex;align-items:center;justify-content:center;">';
                html += '<svg viewBox="0 0 24 24" fill="none" stroke="#1a6fa8" stroke-width="1.75" width="16" height="16"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>';
                html += '</div>';
                html += '<div><span style="font-size:14px;font-weight:600;color:#1e293b;">' + (c.date || '—') + '</span>';
                if (c.heure) html += '<span style="font-size:12px;color:#94a3b8;margin-left:8px;">' + c.heure + '</span>';
                html += '</div></div>';
                if (c.motif) html += '<span class="rv-status status-confirmed" style="font-size:11px;">' + esc(c.motif) + '</span>';
                html += '</div>';

                if (c.diagnostic) {
                    html += '<div style="margin-bottom:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Diagnostic</span>';
                    html += '<p style="font-size:13.5px;color:#1e293b;margin-top:4px;font-family:Inter,sans-serif;line-height:1.6;">' + esc(c.diagnostic) + '</p></div>';
                }
                if (c.observations) {
                    html += '<div style="margin-bottom:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Observations</span>';
                    html += '<p style="font-size:13.5px;color:#475569;margin-top:4px;font-family:Inter,sans-serif;line-height:1.6;">' + esc(c.observations) + '</p></div>';
                }
                if (c.actes && c.actes.length > 0) {
                    html += '<div style="margin-bottom:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Actes réalisés</span>';
                    html += '<div style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;">';
                    c.actes.forEach(function(a) {
                        html += '<span style="font-size:12px;padding:4px 10px;background:#f0fdf4;color:#15803d;border-radius:6px;font-weight:500;">' + esc(a.nom) + ' <span style="color:#94a3b8;">(' + a.tarif + ' MAD)</span></span>';
                    });
                    html += '</div></div>';
                }
                if (c.medicaments && c.medicaments.length > 0) {
                    html += '<div style="margin-top:10px;"><span style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.07em;color:#94a3b8;">Ordonnance — Médicaments</span>';
                    html += '<div style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px;">';
                    c.medicaments.forEach(function(med, idx) {
                        html += '<span style="font-size:12px;padding:4px 10px;background:#eff6ff;color:#1a6fa8;border-radius:6px;font-weight:500;">💊 ' + esc(med) + '</span>';
                    });
                    html += '</div></div>';
                }
                html += '</div>';
            });
        } else {
            html += '<div class="dash-card" style="text-align:center;padding:30px;color:#94a3b8;border:1px dashed #e2e8f0;">Aucune consultation pour ce patient.</div>';
        }

        // Documents
        html += '<h3 style="font-size:16px;font-weight:700;color:#1e293b;margin:20px 0 12px;">Documents annexes</h3>';
        if (p.dossier && p.dossier.documents && p.dossier.documents.length > 0) {
            p.dossier.documents.forEach(function(d) {
                html += '<div class="dash-card" style="margin-bottom:10px;border:1px solid #e8edf3;padding:14px 18px;">';
                html += '<div style="display:flex;align-items:center;gap:12px;">';
                html += '<div style="width:38px;height:38px;border-radius:10px;background:#fef3c7;display:flex;align-items:center;justify-content:center;flex-shrink:0;">';
                html += '<svg viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="1.75" width="18" height="18"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>';
                html += '</div>';
                html += '<div style="flex:1;min-width:0;">';
                html += '<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">';
                html += '<span style="font-size:13.5px;font-weight:600;color:#1e293b;">' + esc(d.type) + '</span>';
                html += '<span style="font-size:11px;padding:2px 8px;background:#f1f5f9;color:#64748b;border-radius:4px;">' + d.date + '</span>';
                html += '</div>';
                html += '<div style="font-size:12px;color:#64748b;margin-top:4px;font-family:Inter,sans-serif;word-break:break-all;">' + esc(d.chemin) + '</div>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
            });
        } else {
            html += '<div class="dash-card" style="text-align:center;padding:24px;color:#94a3b8;border:1px dashed #e2e8f0;">Aucun document dans ce dossier.</div>';
        }

        html += '</div>'; // end right
        html += '</div></div>'; // end layout, end card
        html += '</div>'; // end dossier-detail-view
        return html;
    }

    function infoRow(label, val) {
        return '<div class="dossier-info-row"><span class="di-label">' + label + '</span><span class="di-val">' + esc(val || '') + '</span></div>';
    }

    function esc(s) { if (!s) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

    /* ══════════════════════════════════════
       PATIENT EDIT FORM
    ══════════════════════════════════════ */
    function showPatientEditForm(patientId) {
        var section = document.getElementById('section-search-patient');
        section.querySelector('.search-bar-form').style.display = 'none';
        document.getElementById('searchPatientResults').style.display = 'none';
        var div = document.getElementById('patientDetailView');
        div.style.display = 'block';
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement…</div>';

        fetch(CTX + '/api/search?type=patientDetail&id=' + patientId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                div.innerHTML = buildPatientEditFormHTML(data);
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    function buildPatientEditFormHTML(p) {
        var html = '<div class="dossier-detail-view">';
        html += '<button class="btn-secondary" onclick="backToPatientSearch()" style="margin-bottom:16px;">← Retour aux résultats</button>';
        html += '<div class="dash-card">';
        html += '<div class="dossier-patient-header" style="margin-bottom:20px;">';
        html += '<div class="dossier-avatar">' + (p.nom ? p.nom.charAt(0) : '') + (p.prenom ? p.prenom.charAt(0) : '') + '</div>';
        html += '<div><h3>Modifier les informations</h3><span class="dossier-meta">' + esc(p.nom) + ' ' + esc(p.prenom) + '</span></div>';
        html += '</div>';

        html += '<input type="hidden" id="editPatientId" value="' + p.id + '">';
        html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">';
        html += formField('Nom *', 'editPatientNom', 'text', p.nom || '');
        html += formField('Prénom *', 'editPatientPrenom', 'text', p.prenom || '');
        html += formField('Date de naissance *', 'editPatientDateN', 'date', p.dateNaissance || '');
        html += '<div class="form-group"><label>Sexe *</label><select id="editPatientSexe" class="form-select"><option value="H"' + (p.sexe === 'H' ? ' selected' : '') + '>Homme</option><option value="F"' + (p.sexe === 'F' ? ' selected' : '') + '>Femme</option></select></div>';
        html += formField('Adresse *', 'editPatientAdresse', 'text', p.adresse || '');
        html += formField('Téléphone *', 'editPatientTel', 'tel', p.tel || '');
        html += formField('CNSS/Mutuelle', 'editPatientCnss', 'text', p.cnssMutuelle || '');
        html += formField('Allergie critique', 'editPatientAllergie', 'text', p.allergie || '');
        html += '</div>';
        html += '<div style="display:grid;grid-template-columns:1fr;gap:14px;margin-top:14px;">';
        html += '<div class="form-group"><label>Antécédents médicaux</label><textarea id="editPatientAntecedents" class="form-select" rows="2">' + esc(p.antecedents || '') + '</textarea></div>';
        html += '</div>';
        html += '<div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:14px;">';
        html += formField('Responsable légal (nom)', 'editPatientRespNom', 'text', p.responsableNom || '');
        html += formField('Responsable légal (tél)', 'editPatientRespTel', 'tel', p.responsableTel || '');
        html += '</div>';

        html += '<span class="field-error" id="patientEditError"></span>';
        html += '<div class="modal-actions" style="margin-top:20px;">';
        html += '<button type="button" class="btn-secondary" onclick="backToPatientSearch()">Annuler</button>';
        html += '<button type="button" class="btn-primary" onclick="savePatient()">💾 Enregistrer les modifications</button>';
        html += '</div>';
        html += '</div></div>';
        return html;
    }

    function formField(label, id, type, value) {
        return '<div class="form-group"><label for="' + id + '">' + label + '</label><input type="' + type + '" id="' + id + '" class="form-select" value="' + esc(value) + '"></div>';
    }

    function savePatient() {
        clearError('patientEditError');
        var nom = document.getElementById('editPatientNom').value.trim();
        var prenom = document.getElementById('editPatientPrenom').value.trim();
        var dateN = document.getElementById('editPatientDateN').value;
        var tel = document.getElementById('editPatientTel').value.trim();
        var adresse = document.getElementById('editPatientAdresse').value.trim();

        if (!nom || !prenom || !dateN || !tel || !adresse) {
            showError('patientEditError', 'Les champs nom, prénom, date de naissance, adresse et téléphone sont obligatoires.');
            return;
        }

        var data = {
            id: parseInt(document.getElementById('editPatientId').value),
            nom: nom,
            prenom: prenom,
            dateNaissance: dateN,
            sexe: document.getElementById('editPatientSexe').value,
            adresse: adresse,
            telephone: tel,
            cnssMutuelle: document.getElementById('editPatientCnss').value.trim(),
            antecedents: document.getElementById('editPatientAntecedents').value.trim(),
            allergie: document.getElementById('editPatientAllergie').value.trim(),
            responsableNom: document.getElementById('editPatientRespNom').value.trim(),
            responsableTel: document.getElementById('editPatientRespTel').value.trim()
        };

        fetch(CTX + '/api/search?type=updatePatient', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(r => r.json())
        .then(resp => {
            if (resp.success) {
                // Reload the patient detail view to show updated info
                showPatientOnly(data.id);
                // Brief success flash
                setTimeout(function() {
                    var div = document.getElementById('patientDetailView');
                    var banner = div.querySelector('.dossier-patient-header');
                    if (banner) {
                        var msg = document.createElement('div');
                        msg.style.cssText = 'background:#f0fdf4;color:#15803d;padding:10px 16px;border-radius:8px;margin-bottom:12px;font-size:13px;font-weight:600;';
                        msg.textContent = '✅ Informations mises à jour avec succès.';
                        banner.parentNode.insertBefore(msg, banner);
                        setTimeout(function() { msg.remove(); }, 4000);
                    }
                }, 300);
            } else {
                showError('patientEditError', resp.error || 'Erreur lors de la mise à jour.');
            }
        })
        .catch(function() { showError('patientEditError', 'Erreur réseau.'); });
    }

    /* ══════════════════════════════════════
       RDV EDIT MODAL
    ══════════════════════════════════════ */
    function openRdvEditModal(rdvId) {
        clearError('rdvEditError');
        document.getElementById('editRdvId').value = rdvId;
        // Fetch RDV details
        fetch(CTX + '/api/search?type=rdvDetail&id=' + rdvId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { alert(data.error); return; }
                document.getElementById('editRdvDate').value = data.date || '';
                document.getElementById('editRdvHeureDebut').value = data.heureDebut ? data.heureDebut.substring(0,5) : '';
                document.getElementById('editRdvHeureFin').value = data.heureFin ? data.heureFin.substring(0,5) : '';
                document.getElementById('editRdvMotif').value = data.motif || '';
                document.getElementById('editRdvNotes').value = data.notes || '';
                document.getElementById('editRdvStatut').value = data.statut || 'PLANIFIE';
                document.getElementById('rdvEditModal').classList.add('open');
            })
            .catch(function() { alert('Erreur lors du chargement du RDV.'); });
    }

    function closeRdvEditModal() { document.getElementById('rdvEditModal').classList.remove('open'); }
    document.getElementById('rdvEditModal').addEventListener('click', function(e) { if (e.target === this) closeRdvEditModal(); });

    function saveRdvEdit() {
        clearError('rdvEditError');
        var date = document.getElementById('editRdvDate').value;
        var hd = document.getElementById('editRdvHeureDebut').value;
        var hf = document.getElementById('editRdvHeureFin').value;
        var motif = document.getElementById('editRdvMotif').value.trim();

        if (!date || !hd || !hf || !motif) {
            showError('rdvEditError', 'Date, heures et motif sont obligatoires.');
            return;
        }

        var data = {
            id: parseInt(document.getElementById('editRdvId').value),
            date: date,
            heureDebut: hd,
            heureFin: hf,
            motif: motif,
            notes: document.getElementById('editRdvNotes').value.trim(),
            statut: document.getElementById('editRdvStatut').value
        };

        fetch(CTX + '/api/search?type=updateRdv', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(r => r.json())
        .then(resp => {
            if (resp.success) {
                closeRdvEditModal();
                // Re-trigger search to refresh results
                searchRdv();
            } else {
                showError('rdvEditError', resp.error || 'Erreur lors de la mise à jour.');
            }
        })
        .catch(function() { showError('rdvEditError', 'Erreur réseau.'); });
    }

    /* ── Cancel RDV (set status to ANNULE) ── */
    function cancelRdv(rdvId) {
        if (!confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?')) return;

        fetch(CTX + '/api/search?type=cancelRdv', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: rdvId })
        })
        .then(r => r.json())
        .then(resp => {
            if (resp.success) {
                // Re-trigger search to refresh results
                searchRdv();
            } else {
                alert(resp.error || 'Erreur lors de l\'annulation.');
            }
        })
        .catch(function() { alert('Erreur réseau.'); });
    }

    /* ── Show RDV Detail (click on patient name in results) ── */
    function showRdvDetail(rdvId) {
        var div = document.getElementById('searchRdvResults');
        div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;"><div class="loading-spinner"></div>Chargement…</div>';

        fetch(CTX + '/api/search?type=rdvDetail&id=' + rdvId)
            .then(r => r.json())
            .then(data => {
                if (data.error) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">' + data.error + '</div>'; return; }
                var sc = data.statut === 'EN_COURS' ? 'in_progress' : data.statut === 'PLANIFIE' ? 'confirmed' : data.statut === 'TERMINE' ? 'done' : data.statut === 'EN_SALLE_D_ATTENTE' ? 'pending' : 'cancelled';
                var html = '<div class="dossier-detail-view">';
                html += '<button class="btn-secondary" onclick="searchRdv()" style="margin-bottom:16px;">← Retour aux résultats</button>';
                html += '<div class="dash-card">';
                html += '<div class="dossier-patient-header" style="margin-bottom:20px;">';
                html += '<div class="dossier-avatar">' + (data.patient ? data.patient.charAt(0) : '?') + '</div>';
                html += '<div><h3>' + esc(data.patient) + '</h3><span class="dossier-meta">' + esc(data.tel) + '</span></div>';
                html += '<span class="rv-status status-' + sc + '" style="margin-left:auto;align-self:center;">' + data.statut + '</span>';
                html += '</div>';
                html += '<div class="dossier-info-list">';
                html += infoRow('Date', data.date || '—');
                html += infoRow('Heure début', data.heureDebut || '—');
                html += infoRow('Heure fin', data.heureFin || '—');
                html += infoRow('Motif', data.motif || '—');
                html += infoRow('Notes internes', data.notes || '—');
                html += infoRow('Statut', data.statut || '—');
                html += '</div>';
                html += '<div style="display:flex;gap:10px;margin-top:20px;padding-top:16px;border-top:1px solid #f1f5f9;">';
                html += '<button class="btn-primary" style="flex:1;" onclick="openRdvEditModal(' + data.id + ')">✏️ Modifier</button>';
                if (data.statut !== 'ANNULE' && data.statut !== 'TERMINE') {
                    html += '<button class="btn-table btn-cancel" style="flex:1;padding:10px;font-size:14px;border-radius:8px;" onclick="cancelRdv(' + data.id + ')">❌ Annuler le RV</button>';
                }
                html += '</div>';
                html += '</div></div>';
                div.innerHTML = html;
            })
            .catch(function() {
                div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#ef4444;">Erreur de chargement.</div>';
            });
    }

    /* ── Search for Dossier ── */
    function searchForDossier() {
        const nom = document.getElementById('searchDossierNom').value.trim();
        const tel = document.getElementById('searchDossierTel').value.trim();
        clearError('searchDossierError');
        if (!nom || !tel) { showError('searchDossierError', 'Veuillez saisir le nom ET le téléphone.'); return; }
        document.getElementById('dossierFullView').style.display = 'none';
        fetch(CTX + '/api/search?type=patient&nom=' + encodeURIComponent(nom) + '&tel=' + encodeURIComponent(tel))
            .then(r => r.json())
            .then(data => {
                const div = document.getElementById('dossierPatientCards');
                if (!data.results.length) { div.innerHTML = '<div class="dash-card" style="text-align:center;padding:40px;color:#94a3b8;">Aucun patient trouvé.</div>'; return; }
                let html = '<div class="patient-grid">';
                data.results.forEach(p => {
                    html += '<div class="patient-card" style="cursor:pointer" onclick="loadDossierDetailInline(' + p.id + ')">';
                    html += '<div class="patient-avatar">' + p.nom.charAt(0) + p.prenom.charAt(0) + '</div>';
                    html += '<div class="patient-info"><span class="patient-name">' + p.nom + ' ' + p.prenom + '</span><span class="patient-meta">' + p.tel + '</span></div>';
                    html += '</div>';
                });
                html += '</div>';
                div.innerHTML = html;
            });
    }

    /* ══════════════════════════════════════
       WEEKLY CALENDAR
    ══════════════════════════════════════ */
    var weekRdvData = [];
            });

    function buildWeeklyCalendar() {
        var cal = document.getElementById('weeklyCalendar');
        if (!cal) return;

        var today = new Date();
        var dayOfWeek = today.getDay(); // 0=Sun
        var mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
        var monday = new Date(today);
        monday.setDate(today.getDate() + mondayOffset);

        var days = [];
        var dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
        for (var i = 0; i < 6; i++) {
            var d = new Date(monday);
            d.setDate(monday.getDate() + i);
            days.push(d);
        }

        var hours = [];
        for (var h = 8; h <= 18; h++) {
            hours.push(h);
        }

        // Build header
        var html = '<div class="wcal-grid" style="grid-template-columns: 60px repeat(6, 1fr);">';
        html += '<div class="wcal-corner"></div>';
        days.forEach(function(d, idx) {
            var isToday = d.toDateString() === today.toDateString();
            var dayNum = d.getDate();
            var monthShort = d.toLocaleDateString('fr-FR', {month:'short'});
            html += '<div class="wcal-day-header' + (isToday ? ' wcal-today' : '') + '">';
            html += '<span class="wcal-day-name">' + dayNames[idx] + '</span>';
            html += '<span class="wcal-day-num' + (isToday ? ' wcal-today-num' : '') + '">' + dayNum + '</span>';
            html += '<span class="wcal-day-month">' + monthShort + '</span>';
            html += '</div>';
        });

        // Build time rows
        hours.forEach(function(h) {
            var timeStr = (h < 10 ? '0' : '') + h + ':00';
            html += '<div class="wcal-time-label">' + timeStr + '</div>';

            days.forEach(function(d, colIdx) {
                var dateStr = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
                var isToday = d.toDateString() === today.toDateString();
                var cellRdvs = weekRdvData.filter(function(r) {
                    var rHour = parseInt(r.heure.split(':')[0], 10);
                    return r.date === dateStr && rHour === h;
                });

                html += '<div class="wcal-cell' + (isToday ? ' wcal-cell-today' : '') + '">';
                cellRdvs.forEach(function(r) {
                    var cls = r.statut === 'PLANIFIE' ? 'ev-blue' : r.statut === 'EN_SALLE_D_ATTENTE' ? 'ev-amber' : r.statut === 'EN_COURS' ? 'ev-blue' : r.statut === 'TERMINE' ? 'ev-green' : 'ev-grey';
                    html += '<div class="wcal-event ' + cls + '" title="' + esc(r.patient) + ' – ' + esc(r.motif) + '" style="cursor:pointer;" onclick="openStatusModal(' + r.id + ',\'' + r.statut + '\')">';
                    html += '<span class="wcal-event-time">' + r.heure.substring(0,5) + '</span>';
                    html += '<span class="wcal-event-name">' + esc(r.patient) + '</span>';
                    html += '</div>';
                });
                html += '</div>';
            });
        });

        html += '</div>';
        cal.innerHTML = html;
    }

    /* ── Ordonnance: medication table ── */
    let medications = [];
    function addMedication() {
        const input = document.getElementById('medInput');
        const val = input.value.trim();
        clearError('medError');
        if (!val) { showError('medError', 'Veuillez saisir un médicament.'); return; }
        medications.push(val);
        input.value = '';
        renderMedTable();
    }
    function removeMed(i) { medications.splice(i, 1); renderMedTable(); }
    function renderMedTable() {
        const tbody = document.getElementById('medTableBody');
        if (!tbody) return;
        tbody.innerHTML = medications.map((m, i) =>
            '<tr><td>' + (i+1) + '</td><td>' + m + '</td><td><button type="button" class="btn-table btn-cancel" onclick="removeMed(' + i + ')">✕</button></td></tr>'
        ).join('');
    }
    function submitOrdonnance() {
        if (!medications.length) { showError('medError', 'Ajoutez au moins un médicament.'); return false; }
        document.getElementById('medicationsHidden').value = medications.join('|||');
        return true;
    }
    function printOrdonnance() {
        if (!medications.length) { showError('medError', 'Ajoutez au moins un médicament pour imprimer.'); return; }
        const w = window.open('', '_blank');
        let html = '<html><head><title>Ordonnance</title><style>body{font-family:serif;padding:40px;} h1{font-size:20px;} .med{margin:8px 0;padding:8px;border-bottom:1px solid #eee;} .header{border-bottom:2px solid #333;padding-bottom:10px;margin-bottom:20px;} .footer{margin-top:40px;border-top:1px solid #ccc;padding-top:10px;font-size:12px;color:#888;}</style></head><body>';
        html += '<div class="header"><h1>DentFisto – Ordonnance Médicale</h1>';
        html += '<p>Patient: <b>' + patientName + '</b></p>';
        html += '<p>Date: ' + new Date().toLocaleDateString('fr-FR') + '</p></div>';
        html += '<h2>Prescription</h2>';
        medications.forEach((m, i) => { html += '<div class="med">' + (i+1) + '. ' + m + '</div>'; });
        html += '<div class="footer"><p>Signature du médecin: _____________________</p></div>';
        html += '</body></html>';
        w.document.write(html);
        w.document.close();
        w.print();
    }

    /* ── Initial Section Loader ── */
        // Ordonnance section has ID 'section-ordonnance-gen', handle it specially
        document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
        var ordSec = document.getElementById('section-ordonnance-gen');
        if (ordSec) { ordSec.style.display = 'block'; ordSec.classList.add('active'); }
        document.getElementById('breadcrumbText').textContent = 'Ordonnance';

    /* ── Auto-load dossier if showDossier + patient data ── */
        (function() {
        })();

    /* ── Page entrance ── */
    document.body.style.opacity = 0;
    document.body.style.transform = 'translateY(12px)';
    requestAnimationFrame(() => {
        document.body.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        document.body.style.opacity = 1;
        document.body.style.transform = 'translateY(0)';
    });
