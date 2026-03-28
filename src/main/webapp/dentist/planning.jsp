<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "planning");
    request.setAttribute("pageTitle",  "Planning");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentFisto – Planning</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}../css/dashboard-dentist.css">
</head>
<body class="dashboard-page role-dentist">

<%@ include file="sidebar.jsp" %>

<div class="section-hero">
    <div>
        <h1 class="section-title">Planning</h1>
        <p class="section-sub">Vue journalière et hebdomadaire de vos rendez-vous.</p>
    </div>
    <div class="planning-toggle">
        <button class="toggle-btn active" id="btnDay"  onclick="switchView('day')">Jour</button>
        <button class="toggle-btn"        id="btnWeek" onclick="switchView('week')">Semaine</button>
    </div>
</div>

<!-- ── DAY VIEW ── -->
<div id="viewDay">
    <div class="dash-card">
        <div class="card-header">
            <div class="day-nav-group">
                <button class="icon-btn" id="prevDay">&#8249;</button>
                <h3 id="dayLabel"></h3>
                <button class="icon-btn" id="nextDay">&#8250;</button>
            </div>
        </div>
        <div class="calendar-day" id="calendarDay"></div>
    </div>
</div>

<!-- ── WEEK VIEW ── -->
<div id="viewWeek" style="display:none">
    <div class="dash-card">
        <div class="card-header">
            <div class="day-nav-group">
                <button class="icon-btn" id="prevWeek">&#8249;</button>
                <h3 id="weekLabel"></h3>
                <button class="icon-btn" id="nextWeek">&#8250;</button>
            </div>
        </div>
        <div class="calendar-week-wrap">
            <div class="calendar-week" id="calendarWeek"></div>
        </div>
    </div>
</div>

    </div><!-- /content-area -->
</main>

<script>
/* ── JSTL data injected by DentistPlanningServlet ── */
const serverRvs = [
    <c:forEach var="rv" items="${planningRvs}" varStatus="s">
        {id}:'${rv.id}',date:'${rv.date}',time:'${rv.time}',patient:'${rv.patientName}',
         type:'${rv.type}',status:'${rv.status}'${!s.last?',':''}
    </c:forEach>
];

/* Demo fallback */
const demoRvs = [
    {id:1, date:'2025-06-28', time:'09:00', patient:'K. Amrani',  type:'Détartrage',  status:'confirme'},
    {id:2, date:'2025-06-28', time:'10:30', patient:'F. Benali',  type:'Extraction',  status:'en_cours'},
    {id:3, date:'2025-06-28', time:'14:00', patient:'N. Chraibi', type:'Orthodontie', status:'confirme'},
    {id:4, date:'2025-06-29', time:'09:00', patient:'Y. Idrissi', type:'Contrôle',    status:'termine'},
    {id:5, date:'2025-06-30', time:'11:00', patient:'M. Tazi',    type:'Détartrage',  status:'confirme'},
    {id:6, date:'2025-07-01', time:'14:30', patient:'S. Alami',   type:'Extraction',  status:'confirme'},
    {id:7, date:'2025-07-02', time:'10:00', patient:'H. Bakkali', type:'Contrôle',    status:'en_attente'},
];
const allRvs = serverRvs.length ? serverRvs : demoRvs;

const HOURS = ['08','09','10','11','12','13','14','15','16','17','18'];
const DAY_NAMES_FR = ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'];
const MONTH_FR     = ['Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
const SHORT_DAYS   = ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'];

let currentDay  = new Date();
let currentWeekOffset = 0;
currentDay.setHours(0,0,0,0);

/* ══ helpers ══ */
function toYMD(d) {
    return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');
}
function formatDayLabel(d) {
    return DAY_NAMES_FR[d.getDay()] + ' ' + d.getDate() + ' ' + MONTH_FR[d.getMonth()] + ' ' + d.getFullYear();
}
function evClass(status) {
    const m={'confirme':'ev-confirme','en_attente':'ev-en_attente','en_cours':'ev-en_cours','termine':'ev-termine','annule':'ev-annule'};
    return m[status]||'ev-confirme';
}
function evLabel(status) {
    const m={'confirme':'Confirmé','en_attente':'En attente','en_cours':'En cours','termine':'Terminé','annule':'Annulé'};
    return m[status]||status;
}

/* ══ Day view ══ */
function buildDay() {
    const ymd = toYMD(currentDay);
    document.getElementById('dayLabel').textContent = formatDayLabel(currentDay);
    const cal = document.getElementById('calendarDay');
    cal.innerHTML = '';
    HOURS.forEach(h => {
        const row = document.createElement('div');
        row.className = 'cal-row';
        const rvs = allRvs.filter(r => r.date === ymd && r.time.startsWith(h));
        row.innerHTML = `<div class="cal-hour">${h}:00</div>
            <div class="cal-cell">${rvs.map(r=>`
                <div class="cal-event ${evClass(r.status)}">
                    <strong>${r.patient}</strong>
                    <span>${r.type}</span>
                    <span class="ev-badge">${evLabel(r.status)}</span>
                </div>`).join('')}</div>`;
        cal.appendChild(row);
    });
}

document.getElementById('prevDay').onclick = () => { currentDay.setDate(currentDay.getDate()-1); buildDay(); };
document.getElementById('nextDay').onclick = () => { currentDay.setDate(currentDay.getDate()+1); buildDay(); };

/* ══ Week view ══ */
function getMondayOfWeek(offset) {
    const d = new Date();
    d.setHours(0,0,0,0);
    const day = d.getDay()||7;
    d.setDate(d.getDate() - day + 1 + offset*7);
    return d;
}

function buildWeek() {
    const mon = getMondayOfWeek(currentWeekOffset);
    const days = Array.from({length:6}, (_,i) => { const d=new Date(mon); d.setDate(mon.getDate()+i); return d; });
    const sun  = new Date(days[5]); sun.setDate(sun.getDate()+1);
    document.getElementById('weekLabel').textContent =
        `Semaine du ${days[0].getDate()} au ${days[5].getDate()} ${MONTH_FR[days[5].getMonth()]} ${days[5].getFullYear()}`;

    const cal = document.getElementById('calendarWeek');
    const todayYmd = toYMD(new Date());

    let html = `<div class="wcal-grid">
        <div class="wcal-hour-col"></div>`;
    days.forEach(d => {
        const isToday = toYMD(d) === todayYmd;
        html += `<div class="wcal-day-header${isToday?' today-header':''}">
            ${SHORT_DAYS[d.getDay()]}<span>${d.getDate()}</span></div>`;
    });
    html += '</div>';

    HOURS.forEach(h => {
        html += `<div class="wcal-grid"><div class="wcal-hour-label">${h}:00</div>`;
        days.forEach(d => {
            const ymd = toYMD(d);
            const isToday = ymd === todayYmd;
            const rvs = allRvs.filter(r => r.date===ymd && r.time.startsWith(h));
            html += `<div class="wcal-cell${isToday?' today-col':''}">
                ${rvs.map(r=>`<div class="cal-event ${evClass(r.status)}"><strong>${r.patient}</strong><span>${r.type}</span></div>`).join('')}
            </div>`;
        });
        html += '</div>';
    });
    cal.innerHTML = html;
}

document.getElementById('prevWeek').onclick = () => { currentWeekOffset--; buildWeek(); };
document.getElementById('nextWeek').onclick = () => { currentWeekOffset++; buildWeek(); };

/* ══ Switch ══ */
function switchView(mode) {
    document.getElementById('viewDay').style.display  = mode==='day'  ? '' : 'none';
    document.getElementById('viewWeek').style.display = mode==='week' ? '' : 'none';
    document.getElementById('btnDay').classList.toggle('active',  mode==='day');
    document.getElementById('btnWeek').classList.toggle('active', mode==='week');
}

buildDay();
buildWeek();
</script>
</body>
</html>
