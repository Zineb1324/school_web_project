// ==========================================================
// Exams Portal — Grading & Analytics (Task 3)
// Student & Teacher Portals
// ==========================================================

// ---- DATA (from school_management database) ----

const students = [
    { id: 2,  name: 'James Smith',       cls: 'Grade 1A' },
    { id: 3,  name: 'Emma Johnson',      cls: 'Grade 1A' },
    { id: 4,  name: 'Liam Williams',     cls: 'Grade 1A' },
    { id: 5,  name: 'Olivia Brown',      cls: 'Grade 1A' },
    { id: 6,  name: 'Noah Jones',        cls: 'Grade 1A' },
    { id: 7,  name: 'Ava Garcia',        cls: 'Grade 1A' },
    { id: 8,  name: 'Ethan Miller',      cls: 'Grade 1A' },
    { id: 9,  name: 'Sophia Davis',      cls: 'Grade 1A' },
    { id: 10, name: 'Mason Rodriguez',   cls: 'Grade 1A' },
    { id: 11, name: 'Isabella Martinez', cls: 'Grade 1A' },
    { id: 12, name: 'Lucas Hernandez',   cls: 'Grade 1A' },
    { id: 13, name: 'Mia Lopez',         cls: 'Grade 1A' },
    { id: 14, name: 'Logan Gonzalez',    cls: 'Grade 1A' },
    { id: 15, name: 'Amelia Wilson',     cls: 'Grade 1A' },
    { id: 16, name: 'Benjamin Anderson', cls: 'Grade 1A' }
];

const teachers = [
    { id: 1, name: 'Omar Ali',        subjectId: 3 },
    { id: 2, name: 'Ahmed Hassan',    subjectId: 1 },
    { id: 3, name: 'Sara Maatouk',    subjectId: 2 },
    { id: 4, name: 'Emily Clark',     subjectId: 4 },
    { id: 5, name: 'Michael Brown',   subjectId: 5 },
    { id: 6, name: 'Laura Martinez',  subjectId: 6 },
    { id: 7, name: 'David Wilson',    subjectId: 7 }
];

const subjects = [
    { id: 1, name: 'Mathematics' },
    { id: 2, name: 'Science' },
    { id: 3, name: 'English' },
    { id: 4, name: 'Geography' },
    { id: 5, name: 'Philosophy' },
    { id: 6, name: 'Physics' },
    { id: 7, name: 'French' }
];

const exams = [
    { id: 1, name: 'Mathematics Midterm', subjectId: 1 },
    { id: 2, name: 'Mathematics Final',   subjectId: 1 },
    { id: 3, name: 'Science Quiz',        subjectId: 2 },
    { id: 4, name: 'Science Midterm',     subjectId: 2 },
    { id: 5, name: 'English Midterm',     subjectId: 3 },
    { id: 6, name: 'English Final',       subjectId: 3 },
    { id: 7, name: 'Physics Quiz',        subjectId: 6 },
    { id: 8, name: 'French Midterm',      subjectId: 7 }
];

// ---- GRADES TABLE & AVERAGES (like the database) ----
let gradesTable = [];
let studentAverages = {};

// ---- TRIGGER SIMULATION ----
// Same logic as MySQL triggers: trg_after_grade_insert & trg_after_grade_update
function executeTrigger(studentId) {
    const sg = gradesTable.filter(g => g.studentId === studentId);
    if (sg.length === 0) { delete studentAverages[studentId]; return; }
    const avg = sg.reduce((a, g) => a + g.score, 0) / sg.length;
    let classification;
    if (avg >= 80)      classification = 'Excellent';
    else if (avg >= 70) classification = 'Very Good';
    else if (avg >= 60) classification = 'Good';
    else if (avg >= 50) classification = 'Pass';
    else                classification = 'Fail';
    studentAverages[studentId] = {
        studentId, average: parseFloat(avg.toFixed(2)),
        totalExams: sg.length, classification
    };
}

// ---- DATA PERSISTENCE ----
function saveData() {
    localStorage.setItem('examsPortalGrades', JSON.stringify(gradesTable));
}

// Load grades from localStorage and recalculate triggers
function loadInitialData() {
    const saved = localStorage.getItem('examsPortalGrades');
    if (saved) {
        gradesTable = JSON.parse(saved);
        const uniqueStudents = [...new Set(gradesTable.map(g => g.studentId))];
        uniqueStudents.forEach(id => executeTrigger(id));
    }
}

// ---- HELPERS ----
function getStudent(id) { return students.find(s => s.id === id); }
function getExam(id) { return exams.find(e => e.id === id); }
function getSubject(id) { return subjects.find(s => s.id === id); }
function getSubjectByExam(examId) {
    const ex = getExam(examId);
    return ex ? getSubject(ex.subjectId) : null;
}
function badgeClass(c) {
    const map = { 'Excellent': 'badge-excellent', 'Very Good': 'badge-verygood',
        'Good': 'badge-good', 'Pass': 'badge-pass', 'Fail': 'badge-fail' };
    return map[c] || '';
}

// ---- SCREEN NAVIGATION ----
let currentStudent = null;
let currentTeacher = null;

function showScreen(id) {
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
    document.getElementById(id).classList.add('active');
}

// ---- LOGIN LOGIC ----
const studentLoginSelect = document.getElementById('studentLoginSelect');
const teacherLoginSelect = document.getElementById('teacherLoginSelect');
const studentLoginBtn = document.getElementById('studentLoginBtn');
const teacherLoginBtn = document.getElementById('teacherLoginBtn');

// Populate login dropdowns
students.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id; opt.textContent = s.name + ' — ' + s.cls;
    studentLoginSelect.appendChild(opt);
});
teachers.forEach(t => {
    const sub = getSubject(t.subjectId);
    const opt = document.createElement('option');
    opt.value = t.id; opt.textContent = t.name + ' — ' + (sub ? sub.name : '');
    teacherLoginSelect.appendChild(opt);
});

// Enable/disable login buttons
studentLoginSelect.addEventListener('change', () => {
    studentLoginBtn.disabled = !studentLoginSelect.value;
});
teacherLoginSelect.addEventListener('change', () => {
    teacherLoginBtn.disabled = !teacherLoginSelect.value;
});

// Student login
studentLoginBtn.addEventListener('click', () => {
    const id = parseInt(studentLoginSelect.value);
    currentStudent = getStudent(id);
    if (!currentStudent) return;
    renderStudentDashboard();
    showScreen('studentScreen');
});

// Teacher login
teacherLoginBtn.addEventListener('click', () => {
    const id = parseInt(teacherLoginSelect.value);
    currentTeacher = teachers.find(t => t.id === id);
    if (!currentTeacher) return;
    renderTeacherDashboard();
    showScreen('teacherScreen');
});

// Logouts
document.getElementById('studentLogoutBtn').addEventListener('click', () => {
    currentStudent = null; showScreen('loginScreen');
});
document.getElementById('teacherLogoutBtn').addEventListener('click', () => {
    currentTeacher = null; showScreen('loginScreen');
});

// ---- STUDENT DASHBOARD ----
function renderStudentDashboard() {
    const s = currentStudent;
    document.getElementById('navStudentName').textContent = s.name;
    document.getElementById('welcomeStudent').textContent = 'Welcome, ' + s.name.split(' ')[0];
    document.getElementById('tagStudentClass').textContent = s.cls;

    // Stats
    const avg = studentAverages[s.id];
    document.getElementById('sAvg').textContent = avg ? avg.average.toFixed(2) : '—';
    document.getElementById('sExams').textContent = avg ? avg.totalExams : '0';
    document.getElementById('sClass').textContent = avg ? avg.classification : '—';

    // Grades table
    const tbody = document.getElementById('studentGradesBody');
    const noMsg = document.getElementById('noGradesMsg');
    const myGrades = gradesTable.filter(g => g.studentId === s.id);

    if (myGrades.length === 0) {
        tbody.innerHTML = ''; noMsg.classList.remove('hidden'); return;
    }
    noMsg.classList.add('hidden');
    tbody.innerHTML = myGrades.map(g => {
        const sub = getSubjectByExam(g.examId);
        const ex = getExam(g.examId);
        return `<tr>
            <td>${sub ? sub.name : '—'}</td>
            <td>${ex ? ex.name : '—'}</td>
            <td class="score">${g.score.toFixed(2)} / 100</td>
            <td>${g.date}</td>
        </tr>`;
    }).join('');
}

// ---- TEACHER DASHBOARD ----
function renderTeacherDashboard() {
    const t = currentTeacher;
    const sub = getSubject(t.subjectId);
    document.getElementById('navTeacherName').textContent = t.name;
    document.getElementById('welcomeTeacher').textContent = 'Welcome, ' + t.name.split(' ')[0];
    document.getElementById('tagTeacherSubject').textContent = sub ? sub.name : '';

    // Populate form dropdowns
    const fStudent = document.getElementById('fStudent');
    const fExam = document.getElementById('fExam');
    fStudent.innerHTML = '<option value="" disabled selected>Select student…</option>';
    fExam.innerHTML = '<option value="" disabled selected>Select exam…</option>';

    students.forEach(s => {
        const opt = document.createElement('option');
        opt.value = s.id; opt.textContent = s.name;
        fStudent.appendChild(opt);
    });

    const teacherExams = exams.filter(e => e.subjectId === t.subjectId);
    teacherExams.forEach(e => {
        const opt = document.createElement('option');
        opt.value = e.id; opt.textContent = e.name;
        fExam.appendChild(opt);
    });

    renderTeacherGrades();
}

function renderTeacherGrades() {
    const t = currentTeacher;
    const teacherExamIds = exams.filter(e => e.subjectId === t.subjectId).map(e => e.id);
    const myGrades = gradesTable.filter(g => teacherExamIds.includes(g.examId));
    const tbody = document.getElementById('teacherGradesBody');
    const noMsg = document.getElementById('noTeacherGrades');

    if (myGrades.length === 0) {
        tbody.innerHTML = ''; noMsg.classList.remove('hidden'); return;
    }
    noMsg.classList.add('hidden');

    tbody.innerHTML = myGrades.map(g => {
        const st = getStudent(g.studentId);
        const ex = getExam(g.examId);
        const avg = studentAverages[g.studentId];
        const avgVal = avg ? avg.average.toFixed(2) : '—';
        const cls = avg ? avg.classification : '—';
        const badge = avg ? `<span class="badge ${badgeClass(cls)}">${cls}</span>` : '—';
        return `<tr>
            <td>${st ? st.name : '—'}</td>
            <td>${ex ? ex.name : '—'}</td>
            <td class="score">${g.score.toFixed(2)} / 100</td>
            <td>${avgVal}</td>
            <td>${badge}</td>
            <td><button class="btn-delete" onclick="deleteGrade(${g.studentId}, ${g.examId})"><ion-icon name='trash-outline'></ion-icon></button></td>
        </tr>`;
    }).join('');
}

// ---- GRADE FORM ----
const gradeForm = document.getElementById('gradeForm');
const alertMsg = document.getElementById('alertMsg');
const triggerMsg = document.getElementById('triggerMsg');

gradeForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const studentId = parseInt(document.getElementById('fStudent').value);
    const examId = parseInt(document.getElementById('fExam').value);
    const score = parseFloat(document.getElementById('fScore').value);

    // Validation
    if (!studentId || !examId || isNaN(score)) {
        showAlert('⚠ Please fill in all fields.', 'error'); return;
    }
    if (score < 0 || score > 100) {
        showAlert('⚠ Score must be between 0 and 100.', 'error'); return;
    }

    // UNIQUE constraint check
    if (gradesTable.find(g => g.studentId === studentId && g.examId === examId)) {
        const sn = getStudent(studentId)?.name;
        const en = getExam(examId)?.name;
        showAlert(`⚠ ${sn} already has a grade for ${en}. UNIQUE constraint blocks duplicates!`, 'error');
        return;
    }

    // INSERT INTO Grades
    const today = new Date().toISOString().split('T')[0];
    gradesTable.push({ studentId, examId, score, date: today });
    saveData();

    // TRIGGER FIRES!
    executeTrigger(studentId);

    // Show success
    const avg = studentAverages[studentId];
    const sn = getStudent(studentId)?.name;
    showAlert(`✓ Grade saved for ${sn}: ${score}/100`, 'success');
    showTrigger(`⚡ TRIGGER FIRED — ${sn}: New Average = ${avg.average.toFixed(2)} → ${avg.classification}`);

    // Re-render
    renderTeacherGrades();
    gradeForm.reset();
});

function showAlert(msg, type) {
    alertMsg.textContent = msg;
    alertMsg.className = 'alert ' + type;
    setTimeout(() => { alertMsg.className = 'alert hidden'; }, 5000);
}

function showTrigger(msg) {
    triggerMsg.textContent = msg;
    triggerMsg.className = 'trigger-notif';
    setTimeout(() => { triggerMsg.className = 'trigger-notif hidden'; }, 6000);
}

// ---- DELETE GRADE ----
function deleteGrade(studentId, examId) {
    const idx = gradesTable.findIndex(g => g.studentId === studentId && g.examId === examId);
    if (idx === -1) return;
    gradesTable.splice(idx, 1);
    saveData();
    executeTrigger(studentId);
    renderTeacherGrades();
    showAlert('✓ Grade deleted. Teacher can now re-enter a new score.', 'success');
    showTrigger(`⚡ TRIGGER FIRED — Average recalculated for ${getStudent(studentId)?.name}`);
}

// ---- INIT ----
loadInitialData();
