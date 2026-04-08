/* ============================================
   DentFisto – Assistant Dashboard JS
   Extracted from assistant/index.jsp
   ============================================ */

/* NOTE: CTX and weekRdvData are set inline in the JSP */


                /* ════════════════════════════════════════════════════════
                   CONTEXT PATH (extracted from logout link)
                ════════════════════════════════════════════════════════ */

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
                    html += '<div style="display:flex;gap:10px;margin-bottom:16px;">';
                    html += '<button class="btn-secondary" onclick="backToPatientSearch()">← Retour aux résultats</button>';
                    html += '<button class="btn-primary" style="font-size:12px;padding:6px 14px;" onclick="toggleEditPatient(' + p.id + ')">✏️ Modifier les informations</button>';
                    html += '</div>';
                    html += '<div class="dash-card">';
                    html += '<div class="dossier-patient-header" style="margin-bottom:20px;">';
                    html += '<div class="dossier-avatar">' + (p.nom ? p.nom.charAt(0) : '') + (p.prenom ? p.prenom.charAt(0) : '') + '</div>';
                    html += '<div><h3>' + esc(p.nom) + ' ' + esc(p.prenom) + '</h3><span class="dossier-meta">' + esc(p.tel) + '</span></div>';
                    html += '</div>';
                    // Info display
                    html += '<div id="patientInfoDisplay" class="dossier-info-list">';
                    html += infoRow('Sexe', p.sexe === 'H' ? 'Homme' : p.sexe === 'F' ? 'Femme' : (p.sexe || '—'));
                    html += infoRow('Date de naissance', p.dateNaissance || '—');
                    html += infoRow('Adresse', p.adresse || '—');
                    html += infoRow('Téléphone', p.tel || '—');
                    html += infoRow('CNSS/Mutuelle', p.cnssMutuelle || '—');
                    if (p.allergie) html += '<div class="dossier-info-row"><span class="di-label">Allergie</span><span class="di-val allergy">⚠ ' + esc(p.allergie) + '</span></div>';
                    if (p.antecedents) html += infoRow('Antécédents', p.antecedents);
                    html += '</div>'; // end info display
                    // Edit form (hidden)
                    html += '<div id="patientEditForm" style="display:none;border-top:1px solid #e8edf3;padding-top:20px;margin-top:16px;">';
                    html += '<h4 style="font-size:14px;font-weight:600;color:#1e293b;margin-bottom:12px;">Modifier les informations</h4>';
                    html += '<div class="edit-patient-form">';
                    html += '<div class="form-group"><label>Nom *</label><input type="text" id="epNom" class="form-select" value="' + esc(p.nom||'') + '"></div>';
                    html += '<div class="form-group"><label>Prénom *</label><input type="text" id="epPrenom" class="form-select" value="' + esc(p.prenom||'') + '"></div>';
                    html += '<div class="form-group"><label>Téléphone *</label><input type="tel" id="epTel" class="form-select" value="' + esc(p.tel||'') + '"></div>';
                    html += '<div class="form-group"><label>Date de naissance *</label><input type="date" id="epDateNaissance" class="form-select" value="' + esc(p.dateNaissance||'') + '"></div>';
                    html += '<div class="form-group"><label>Sexe *</label><select id="epSexe" class="form-select"><option value="H"' + (p.sexe==='H'?' selected':'') + '>Homme</option><option value="F"' + (p.sexe==='F'?' selected':'') + '>Femme</option></select></div>';
                    html += '<div class="form-group"><label>Adresse *</label><input type="text" id="epAdresse" class="form-select" value="' + esc(p.adresse||'') + '"></div>';
                    html += '<div class="form-group"><label>CNSS/Mutuelle</label><input type="text" id="epCnss" class="form-select" value="' + esc(p.cnssMutuelle||'') + '"></div>';
                    html += '<div class="form-group"><label>Allergie</label><input type="text" id="epAllergie" class="form-select" value="' + esc(p.allergie||'') + '"></div>';
                    html += '<div class="form-group" style="grid-column:1/-1;"><label>Antécédents</label><textarea id="epAntecedents" class="form-select" rows="2" style="resize:vertical;width:100%;box-sizing:border-box;">' + esc(p.antecedents||'') + '</textarea></div>';
                    html += '<div class="form-group"><label>Responsable légal (nom)</label><input type="text" id="epRespNom" class="form-select" value="' + esc(p.responsableNom||'') + '"></div>';
                    html += '<div class="form-group"><label>Responsable légal (tél.)</label><input type="text" id="epRespTel" class="form-select" value="' + esc(p.responsableTel||'') + '"></div>';
                    html += '</div>';
                    html += '<div class="modal-actions" style="margin-top:16px;"><button class="btn-secondary" onclick="toggleEditPatient()">Annuler</button><button class="btn-primary" onclick="saveEditPatient(' + p.id + ')">Enregistrer</button></div>';
                    html += '<div id="epStatus" style="display:none;margin-top:8px;"></div>';
                    html += '</div>';
                    html += '</div></div>';
                    return html;
                }

                function infoRow(label, val) {
                    return '<div class="dossier-info-row"><span class="di-label">' + label + '</span><span class="di-val">' + esc(val || '') + '</span></div>';
                }

                /* ════════════════════════════════════════════════════════
                   WEEKLY CALENDAR (Planning section)
                   Shows today + 6 days. Sunday is barred.
                ════════════════════════════════════════════════════════ */
                /* weekRdvData is populated inline in the JSP via JSTL */

                function buildWeeklyCalendar() {
                    var cal = document.getElementById('weeklyCalendar');
                    if (!cal) return;
                    var today = new Date();
                    // Show today + 6 days (7 days total)
                    var days = [];
                    var dayNames = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
                    for (var i = 0; i < 7; i++) {
                        var d = new Date(today);
                        d.setDate(today.getDate() + i);
                        days.push(d);
                    }
                    var hours = [];
                    for (var h = 8; h <= 18; h++) hours.push(h);
                    var html = '<div class="wcal-grid" style="grid-template-columns: 60px repeat(7, 1fr);">';
                    html += '<div class="wcal-corner"></div>';
                    days.forEach(function (d) {
                        var isToday = d.toDateString() === today.toDateString();
                        var isSunday = d.getDay() === 0;
                        html += '<div class="wcal-day-header' + (isToday ? ' wcal-today' : '') + (isSunday ? ' wcal-sunday' : '') + '">';
                        html += '<span class="wcal-day-name">' + dayNames[d.getDay()] + '</span>';
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
                            var isSunday = d.getDay() === 0;
                            if (isSunday) {
                                html += '<div class="wcal-cell wcal-sunday-cell" style="display:flex;align-items:center;justify-content:center;font-size:10px;color:#94a3b8;text-decoration:line-through;">Fermé</div>';
                                return;
                            }
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

                /* ── Step 2b: Calendar (today + 6 days, Sunday barred) ───── */
                function prdvGetWeekDays() {
                    var today = new Date();
                    var baseDate = new Date(today);
                    baseDate.setDate(today.getDate() + prdvState.weekOffset * 7);
                    var days = [];
                    for (var i = 0; i < 7; i++) {
                        var d = new Date(baseDate);
                        d.setDate(baseDate.getDate() + i);
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

                /* Working hours slots */
                var PRDV_SLOTS = [
                    '09:00', '10:00', '11:00', '14:00',
                    '15:00', '16:00', '17:00', '18:00'
                ];
                var PRDV_DAY_NAMES = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];

                function prdvRenderCalendar() {
                    var days = prdvGetWeekDays();
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

                        // Columns: time label + 7 days (today+6)
                        var cols = 8;
                        var gridStyle = 'grid-template-columns: 64px repeat(7, 1fr);';

                        var html = '<div class="prdv-cal-grid"><div class="prdv-cal-header" style="' + gridStyle + '">';
                        html += '<div class="prdv-cal-day-head" style="background:#f8fafc;"></div>';
                        days.forEach(function (d) {
                            var isToday = d.toDateString() === new Date().toDateString();
                            var isSunday = d.getDay() === 0;
                            html += '<div class="prdv-cal-day-head' + (isToday ? ' today' : '') + (isSunday ? ' sunday-head' : '') + '">';
                            html += '<div>' + PRDV_DAY_NAMES[d.getDay()] + '</div>';
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
                                var isSunday = d.getDay() === 0;
                                // Sunday: barred, no booking
                                if (isSunday) {
                                    html += '<div class="prdv-slot sunday">Fermé</div>';
                                    return;
                                }
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
                   CHANGE 4 — Edit RDV full form modal (with dentist)
                ════════════════════════════════════════════════════════════ */
                function openEditRdvModal(rdvId) {
                    // Fetch RDV details + dentist list from assistant full endpoint
                    fetch(CTX + '/assistant/modifier-rdv-full?action=getRdvFull&id=' + rdvId)
                        .then(function (r) { return r.json(); })
                        .then(function (d) {
                            if (d.error) { alert('RDV introuvable.'); return; }
                            document.getElementById('editRdvId').value = d.id;
                            document.getElementById('editRdvDate').value = d.dateRdv;
                            document.getElementById('editRdvHeure').value = d.heureDebut ? d.heureDebut.substring(0, 5) : '';
                            document.getElementById('editRdvMotif').value = d.motif || '';
                            document.getElementById('editRdvStatut').value = d.statut || 'PLANIFIE';
                            document.getElementById('editRdvNotes').value = d.notes || '';
                            // Patient info (read-only)
                            document.getElementById('editRdvPatientInfo').textContent = (d.patientNom || '') + ' ' + (d.patientPrenom || '') + (d.patientTel ? ' — ' + d.patientTel : '');
                            // Populate dentist dropdown
                            var sel = document.getElementById('editRdvDentiste');
                            sel.innerHTML = '<option value="">— Choisir un dentiste —</option>';
                            (d.dentistes || []).forEach(function (dent) {
                                var opt = document.createElement('option');
                                opt.value = dent.id;
                                opt.textContent = 'Dr. ' + dent.login;
                                if (dent.id === d.dentisteId) opt.selected = true;
                                sel.appendChild(opt);
                            });
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
                    var dentiste = document.getElementById('editRdvDentiste').value;
                    var date = document.getElementById('editRdvDate').value;
                    var heure = document.getElementById('editRdvHeure').value;
                    var motif = document.getElementById('editRdvMotif').value.trim();
                    var statut = document.getElementById('editRdvStatut').value;
                    var notes = document.getElementById('editRdvNotes').value.trim();

                    var ok = true;
                    ['editRdvDateError', 'editRdvHeureError', 'editRdvMotifError', 'editRdvDentisteError'].forEach(function (e) { var el = document.getElementById(e); if (el) { el.textContent = ''; el.style.display = 'none'; } });
                    if (!dentiste) { var el = document.getElementById('editRdvDentisteError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!date) { var el = document.getElementById('editRdvDateError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!heure) { var el = document.getElementById('editRdvHeureError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!motif) { var el = document.getElementById('editRdvMotifError'); el.textContent = 'Obligatoire'; el.style.display = 'block'; ok = false; }
                    if (!ok) return;

                    var params = new URLSearchParams();
                    params.append('rdvId', id);
                    params.append('dentisteId', dentiste);
                    params.append('dateRdv', date);
                    params.append('heureDebut', heure + ':00');
                    params.append('motif', motif);
                    params.append('statut', statut);
                    params.append('notesInternes', notes);

                    fetch(CTX + '/assistant/modifier-rdv-full', {
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
                            // Store for email sending later
                            factureState.lastFactureData = data;
                            showFactureResult(data);
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

                /* ════════════════════════════════════════════════════════════════
                   FACTURE RESULT: PDF + Email buttons
                ════════════════════════════════════════════════════════════════ */
                function showFactureResult(d) {
                    // Show a result modal with PDF + email buttons
                    var html = '<div class="modal-backdrop open" id="factureResultModal">';
                    html += '<div class="modal" style="max-width:560px;">';
                    html += '<div class="modal-header"><h3 style="color:#15803d;">✅ Facture enregistrée</h3>';
                    html += '<button class="modal-close" onclick="closeFactureResult()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>';
                    html += '<div style="padding:8px 0 16px;"><p style="font-size:14px;color:#1e293b;">Facture <strong>FAC-' + d.factureId + '</strong> — Total: <strong>' + parseFloat(d.total).toFixed(2) + ' MAD</strong></p></div>';
                    html += '<div class="modal-actions" style="flex-wrap:wrap;gap:10px;">';
                    html += '<button class="btn-secondary" onclick="closeFactureResult()">Fermer</button>';
                    html += '<button class="btn-primary" onclick="generateFacturePdf(factureState.lastFactureData)">📄 PDF</button>';
                    html += '<button class="btn-primary" style="background:linear-gradient(135deg,#059669,#047857);" onclick="toggleFactureEmailBar()">📧 Envoyer par email</button>';
                    html += '</div>';
                    html += '<div id="factureEmailBar" class="email-send-bar" style="display:none;">';
                    html += '<input type="email" id="factureEmailInput" placeholder="patient@email.com">';
                    html += '<button class="btn-primary" style="padding:8px 16px;font-size:12px;white-space:nowrap;" onclick="sendFactureEmail()" id="factureEmailSendBtn">Envoyer</button>';
                    html += '</div>';
                    html += '<div id="factureEmailStatus" style="display:none;margin-top:8px;font-size:13px;padding:8px 14px;border-radius:8px;"></div>';
                    html += '</div></div>';
                    document.body.insertAdjacentHTML('beforeend', html);
                    document.getElementById('factureResultModal').addEventListener('click', function(e) { if (e.target === this) closeFactureResult(); });
                }

                function closeFactureResult() {
                    var el = document.getElementById('factureResultModal');
                    if (el) el.remove();
                }

                function toggleFactureEmailBar() {
                    var bar = document.getElementById('factureEmailBar');
                    bar.style.display = bar.style.display === 'none' ? 'flex' : 'none';
                    if (bar.style.display === 'flex') document.getElementById('factureEmailInput').focus();
                }

                function sendFactureEmail() {
                    var email = document.getElementById('factureEmailInput').value.trim();
                    var statusEl = document.getElementById('factureEmailStatus');
                    if (!email) { statusEl.style.display = 'block'; statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626'; statusEl.textContent = 'Veuillez saisir une adresse email.'; return; }

                    var d = factureState.lastFactureData;
                    if (!d) return;

                    // Build facture HTML WITHOUT payment method
                    var body = '<html><body style="font-family:Arial,sans-serif;color:#1e293b;padding:20px;">';
                    body += '<div style="border-bottom:3px solid #1a6fa8;padding-bottom:15px;margin-bottom:20px;"><span style="font-size:20px;font-weight:700;color:#1a6fa8;">🦷 DentFisto</span>';
                    body += '<span style="float:right;font-size:11px;color:#94a3b8;">Date: ' + new Date().toLocaleDateString('fr-FR') + '<br>N° Facture: FAC-' + d.factureId + '</span></div>';
                    body += '<h2 style="font-size:16px;color:#1e293b;">Facture de consultation</h2>';
                    body += '<table style="width:100%;border-collapse:collapse;margin:16px 0;">';
                    body += '<tr style="background:#f1f5f9;"><td style="padding:8px;font-weight:700;font-size:11px;text-transform:uppercase;color:#475569;">Patient</td><td style="padding:8px;font-weight:700;font-size:11px;text-transform:uppercase;color:#475569;">Dentiste</td></tr>';
                    body += '<tr><td style="padding:8px;">' + esc(d.patientNom) + ' ' + esc(d.patientPrenom) + (d.patientTel ? '<br><span style="font-size:12px;color:#64748b;">☎ ' + esc(d.patientTel) + '</span>' : '') + '</td>';
                    body += '<td style="padding:8px;">Dr. ' + esc(d.dentiste) + '</td></tr></table>';
                    body += '<table style="width:100%;border-collapse:collapse;margin:16px 0;">';
                    body += '<tr style="background:#f1f5f9;"><th style="padding:8px;text-align:left;font-size:11px;text-transform:uppercase;color:#475569;">Code</th><th style="padding:8px;text-align:left;font-size:11px;text-transform:uppercase;color:#475569;">Acte</th><th style="padding:8px;text-align:right;font-size:11px;text-transform:uppercase;color:#475569;">Tarif (MAD)</th></tr>';
                    (d.actes || []).forEach(function(a) {
                        body += '<tr><td style="padding:8px;color:#64748b;border-bottom:1px solid #f1f5f9;">' + esc(a.code) + '</td><td style="padding:8px;border-bottom:1px solid #f1f5f9;">' + esc(a.nom) + '</td><td style="padding:8px;text-align:right;font-weight:600;border-bottom:1px solid #f1f5f9;">' + parseFloat(a.tarif).toFixed(2) + '</td></tr>';
                    });
                    body += '</table>';
                    body += '<div style="text-align:right;padding:12px;background:#f0fdf4;border-radius:8px;"><span style="font-size:14px;color:#475569;">TOTAL </span><span style="font-size:20px;font-weight:700;color:#15803d;">' + parseFloat(d.total).toFixed(2) + ' MAD</span></div>';
                    body += '<div style="margin-top:30px;padding-top:15px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;text-align:center;">DentFisto – Cabinet dentaire • Merci de votre confiance.</div>';
                    body += '</body></html>';

                    var btn = document.getElementById('factureEmailSendBtn');
                    btn.disabled = true; btn.textContent = 'Envoi…';

                    var params = new URLSearchParams();
                    params.append('email', email);
                    params.append('subject', 'Facture DentFisto - FAC-' + d.factureId);
                    params.append('htmlBody', body);

                    fetch(CTX + '/assistant/send-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(res) {
                        btn.disabled = false; btn.textContent = 'Envoyer';
                        statusEl.style.display = 'block';
                        if (res.success) {
                            statusEl.style.background = '#f0fdf4'; statusEl.style.color = '#15803d';
                            statusEl.textContent = '✅ Email envoyé avec succès !';
                        } else {
                            statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626';
                            statusEl.textContent = '❌ ' + (res.message || 'Erreur.');
                        }
                    })
                    .catch(function() {
                        btn.disabled = false; btn.textContent = 'Envoyer';
                        statusEl.style.display = 'block'; statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626';
                        statusEl.textContent = '❌ Erreur de connexion.';
                    });
                }

                /* ════════════════════════════════════════════════════════════════
                   RDV CONFIRMATION EMAIL
                ════════════════════════════════════════════════════════════════ */
                function toggleRdvEmailBar() {
                    var bar = document.getElementById('rdvEmailBar');
                    bar.style.display = bar.style.display === 'none' ? 'flex' : 'none';
                    if (bar.style.display === 'flex') document.getElementById('rdvEmailInput').focus();
                }

                function sendRdvEmail() {
                    var email = document.getElementById('rdvEmailInput').value.trim();
                    var statusEl = document.getElementById('rdvEmailStatus');
                    if (!email) { statusEl.style.display = 'block'; statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626'; statusEl.textContent = 'Veuillez saisir une adresse email.'; return; }

                    var d = prdvState.lastRdvData;
                    if (!d) return;

                    var endTime = d.heureFin ? d.heureFin.substring(0, 5) : '';

                    // Build RV confirmation HTML email
                    var body = '<html><body style="font-family:Arial,sans-serif;color:#1e293b;padding:20px;">';
                    body += '<div style="border-bottom:3px solid #1a6fa8;padding-bottom:15px;margin-bottom:20px;"><span style="font-size:20px;font-weight:700;color:#1a6fa8;">🦷 DentFisto</span></div>';
                    body += '<h2 style="font-size:16px;color:#1e293b;">Confirmation de Rendez-vous</h2>';
                    body += '<table style="width:100%;border-collapse:collapse;margin:16px 0;">';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;width:140px;border-bottom:1px solid #f1f5f9;">Patient</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">' + esc(d.patientNom) + ' ' + esc(d.patientPrenom) + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;border-bottom:1px solid #f1f5f9;">Téléphone</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">' + esc(d.patientTel) + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;border-bottom:1px solid #f1f5f9;">Dentiste</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">Dr. ' + esc(d.dentiste) + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;border-bottom:1px solid #f1f5f9;">Date</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">' + prdvFmtDate(d.dateRdv) + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;border-bottom:1px solid #f1f5f9;">Horaire</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">' + d.heureDebut.substring(0,5) + ' – ' + endTime + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;border-bottom:1px solid #f1f5f9;">Motif</td><td style="padding:10px;font-weight:500;border-bottom:1px solid #f1f5f9;">' + esc(d.motif) + '</td></tr>';
                    body += '<tr><td style="padding:10px;color:#64748b;font-size:12px;font-weight:600;text-transform:uppercase;">Statut</td><td style="padding:10px;"><span style="background:#dcfce7;color:#15803d;padding:3px 12px;border-radius:12px;font-size:12px;font-weight:700;">PLANIFIÉ</span></td></tr>';
                    body += '</table>';
                    if (d.notes) body += '<div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:12px;font-size:13px;color:#475569;margin-top:12px;"><strong style="color:#64748b;font-size:11px;text-transform:uppercase;">Notes:</strong><br>' + esc(d.notes) + '</div>';
                    body += '<div style="margin-top:30px;padding-top:15px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;text-align:center;">DentFisto – Cabinet dentaire • Merci de votre confiance.</div>';
                    body += '</body></html>';

                    var btn = document.getElementById('rdvEmailSendBtn');
                    btn.disabled = true; btn.textContent = 'Envoi…';

                    var params = new URLSearchParams();
                    params.append('email', email);
                    params.append('subject', 'Confirmation RDV DentFisto – ' + prdvFmtDate(d.dateRdv));
                    params.append('htmlBody', body);

                    fetch(CTX + '/assistant/send-email', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(res) {
                        btn.disabled = false; btn.textContent = 'Envoyer';
                        statusEl.style.display = 'block';
                        if (res.success) {
                            statusEl.style.background = '#f0fdf4'; statusEl.style.color = '#15803d';
                            statusEl.textContent = '✅ Email envoyé avec succès !';
                        } else {
                            statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626';
                            statusEl.textContent = '❌ ' + (res.message || 'Erreur.');
                        }
                    })
                    .catch(function() {
                        btn.disabled = false; btn.textContent = 'Envoyer';
                        statusEl.style.display = 'block'; statusEl.style.background = '#fef2f2'; statusEl.style.color = '#dc2626';
                        statusEl.textContent = '❌ Erreur de connexion.';
                    });
                }

                /* ════════════════════════════════════════════════════════════════
                   PATIENT EDIT (Assistant — same logic as dentist via SearchServlet PUT)
                ════════════════════════════════════════════════════════════════ */
                var editPatientVisible = false;
                function toggleEditPatient(patientId) {
                    editPatientVisible = !editPatientVisible;
                    var info = document.getElementById('patientInfoDisplay');
                    var form = document.getElementById('patientEditForm');
                    if (info) info.style.display = editPatientVisible ? 'none' : '';
                    if (form) form.style.display = editPatientVisible ? 'block' : 'none';
                }

                function saveEditPatient(patientId) {
                    var data = {
                        id: patientId,
                        nom: document.getElementById('epNom').value.trim(),
                        prenom: document.getElementById('epPrenom').value.trim(),
                        telephone: document.getElementById('epTel').value.trim(),
                        dateNaissance: document.getElementById('epDateNaissance').value,
                        sexe: document.getElementById('epSexe').value,
                        adresse: document.getElementById('epAdresse').value.trim(),
                        cnssMutuelle: document.getElementById('epCnss').value.trim(),
                        allergie: document.getElementById('epAllergie').value.trim(),
                        antecedents: document.getElementById('epAntecedents').value.trim(),
                        responsableNom: document.getElementById('epRespNom').value.trim(),
                        responsableTel: document.getElementById('epRespTel').value.trim()
                    };

                    if (!data.nom || !data.prenom || !data.telephone || !data.dateNaissance || !data.adresse) {
                        alert('Les champs Nom, Prénom, Téléphone, Date de naissance et Adresse sont obligatoires.');
                        return;
                    }

                    fetch(CTX + '/api/search?type=updatePatient', {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(data)
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(res) {
                        var statusEl = document.getElementById('epStatus');
                        statusEl.style.display = 'block';
                        if (res.success) {
                            statusEl.innerHTML = '<div style="background:#f0fdf4;border:1px solid #86efac;border-radius:8px;padding:10px;font-size:13px;color:#15803d;">✅ Patient mis à jour avec succès.</div>';
                            // Reload patient detail after 1s
                            setTimeout(function() { showPatientOnly(patientId); editPatientVisible = false; }, 1000);
                        } else {
                            statusEl.innerHTML = '<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:10px;font-size:13px;color:#dc2626;">❌ ' + (res.error || 'Erreur.') + '</div>';
                        }
                    })
                    .catch(function() {
                        var statusEl = document.getElementById('epStatus');
                        statusEl.style.display = 'block';
                        statusEl.innerHTML = '<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:10px;font-size:13px;color:#dc2626;">❌ Erreur de connexion.</div>';
                    });
                }

