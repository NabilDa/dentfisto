/* ============================================
   DentFisto – Admin Dashboard JS
   Extracted from admin/index.jsp
   ============================================ */

/* ── Date ── */
document.getElementById('currentDate').textContent = new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long', year:'numeric' });

/* ── Section navigation ── */
var sectionLabels = { overview:'Tableau de bord', dentists:'Dentistes', assistants:'Assistantes', statistics:'Statistiques' };

function showSection(name) {
    document.querySelectorAll('.dash-section').forEach(function(s) { s.classList.remove('active'); });
    document.querySelectorAll('.nav-item').forEach(function(n) { n.classList.remove('active'); });
    var sec = document.getElementById('section-' + name); if (sec) sec.classList.add('active');
    var nav = document.querySelector('[data-section="' + name + '"]'); if (nav) nav.classList.add('active');
    document.getElementById('breadcrumbText').textContent = sectionLabels[name] || name;
    window.scrollTo(0, 0);
}

document.querySelectorAll('.nav-item').forEach(function(item) { item.addEventListener('click', function(e) { e.preventDefault(); if (this.dataset.section) showSection(this.dataset.section); }); });
document.getElementById('sidebarToggle').addEventListener('click', function() { document.getElementById('sidebar').classList.toggle('collapsed'); document.querySelector('.dashboard-main').classList.toggle('sidebar-collapsed'); });
document.querySelectorAll('.modal-backdrop').forEach(function(m) { m.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('open'); }); });

/* ── Validation helpers ── */
function showError(id, msg) { var el = document.getElementById(id); if (el) { el.textContent = msg; el.style.display = 'block'; } }
function clearError(id) { var el = document.getElementById(id); if (el) { el.textContent = ''; el.style.display = 'none'; } }

function validateModal(prefix) {
    var fields = document.querySelectorAll('#' + prefix + 'Modal input[required]');
    var ok = true;
    fields.forEach(function(f) {
        clearError(f.id + 'Error');
        if (!f.value.trim()) { showError(f.id + 'Error', 'Ce champ est obligatoire.'); ok = false; }
    });
    return ok;
}

function validateEditModal() {
    clearError('editUserLoginError');
    var login = document.getElementById('editUserLogin').value.trim();
    if (!login) { showError('editUserLoginError', 'Le login est obligatoire.'); return false; }
    return true;
}

/* ── Edit User Modal ── */
function openEditModal(id, login, role) {
    document.getElementById('editUserId').value = id;
    document.getElementById('editUserLogin').value = login;
    document.getElementById('editUserPassword').value = '';
    document.getElementById('editUserTitle').textContent = role === 'DENTISTE' ? 'Modifier le dentiste' : 'Modifier l\'assistante';
    document.getElementById('editUserModal').classList.add('open');
}

/* ── Appointment Chart (visual bars) ── */
function buildAppointmentChart() {
    var total = parseInt(document.body.getAttribute('data-total-rdv')) || 0;
    var termine = parseInt(document.body.getAttribute('data-rdv-termine')) || 0;
    var annule = parseInt(document.body.getAttribute('data-rdv-annule')) || 0;
    var nonHonore = parseInt(document.body.getAttribute('data-rdv-non-honore')) || 0;
    var planifie = total - termine - annule - nonHonore;
    if (planifie < 0) planifie = 0;

    var items = [
        { label: 'Terminés', count: termine, color: '#16a34a', bg: '#dcfce7' },
        { label: 'Planifiés / En cours', count: planifie, color: '#1a6fa8', bg: '#dbeafe' },
        { label: 'Annulés', count: annule, color: '#dc2626', bg: '#fee2e2' },
        { label: 'Non honorés', count: nonHonore, color: '#d97706', bg: '#fef3c7' }
    ];

    var container = document.getElementById('appointmentChart');
    if (!container) return;
    var html = '';
    items.forEach(function(item) {
        var pct = total > 0 ? Math.round((item.count / total) * 100) : 0;
        html += '<div style="display:flex;align-items:center;gap:14px;">';
        html += '<span style="min-width:160px;font-size:13px;font-weight:600;color:#1e293b;">' + item.label + '</span>';
        html += '<div style="flex:1;height:28px;background:#f1f5f9;border-radius:8px;overflow:hidden;position:relative;">';
        html += '<div style="height:100%;width:' + pct + '%;background:' + item.bg + ';border-radius:8px;transition:width 0.6s cubic-bezier(.4,0,.2,1);display:flex;align-items:center;justify-content:flex-end;padding-right:8px;min-width:' + (pct > 0 ? '32px' : '0') + ';">';
        if (pct > 0) html += '<span style="font-size:11px;font-weight:700;color:' + item.color + ';">' + pct + '%</span>';
        html += '</div></div>';
        html += '<span style="min-width:36px;font-size:14px;font-weight:700;color:' + item.color + ';text-align:right;">' + item.count + '</span>';
        html += '</div>';
    });
    container.innerHTML = html;
}
buildAppointmentChart();

/* ── Entrance animation ── */
document.body.style.opacity = 0; document.body.style.transform = 'translateY(12px)';
requestAnimationFrame(function() { document.body.style.transition = 'opacity 0.4s ease, transform 0.4s ease'; document.body.style.opacity = 1; document.body.style.transform = 'translateY(0)'; });
