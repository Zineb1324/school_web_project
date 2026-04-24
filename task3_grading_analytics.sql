-- ============================================================
--  TASK 3 : Grading & Analytics Module
--  Advanced School Management System
-- ============================================================
--  Author  : Student 3
--  Tables  : Subjects, Exams, Grades, Student_Averages
--  Feature : Auto-calculation Trigger (trg_after_grade_insert
--            & trg_after_grade_update)
-- ============================================================
--
--  HOW TO RUN:
--  1. Open phpMyAdmin (http://localhost/phpmyadmin)
--  2. First import "school_management (3).sql" (the team database)
--  3. Then select the school_management database
--  4. Go to SQL tab and paste/import THIS file
--  5. Click "Go" — everything will be created automatically
--
-- ============================================================

-- Use the existing database created by the team
USE school_management;

-- ============================================================
-- Step 1 : SUBJECTS TABLE
-- The team database has Teachers with subject_specialty
-- but no Subjects table yet. We create it and link to teachers.
-- ============================================================

CREATE TABLE IF NOT EXISTS `Subjects` (
    `id`           INT(11) NOT NULL AUTO_INCREMENT,
    `subject_name` VARCHAR(100) NOT NULL,
    `teacher_id`   INT(11) DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`teacher_id`) REFERENCES `teachers`(`id`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert subjects based on real teacher specialties from the teachers table
INSERT INTO `Subjects` (`id`, `subject_name`, `teacher_id`) VALUES
(1, 'Mathematics', 2),   -- Ahmed Hassan   (teacher id=2)
(2, 'Science',     3),   -- Sara Maatouk   (teacher id=3)
(3, 'English',     1),   -- Omar Ali       (teacher id=1)
(4, 'Geography',   4),   -- Emily Clark    (teacher id=4)
(5, 'Philosophy',  5),   -- Michael Brown  (teacher id=5)
(6, 'Physics',     6),   -- Laura Martinez (teacher id=6)
(7, 'French',      7);   -- David Wilson   (teacher id=7)

-- ============================================================
-- Step 2 : EXAMS TABLE
-- Each exam belongs to one subject.
-- ============================================================

CREATE TABLE IF NOT EXISTS `Exams` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `subject_id` INT(11) NOT NULL,
    `exam_name`  VARCHAR(100) NOT NULL,
    `exam_date`  DATE NOT NULL,
    `max_score`  DECIMAL(5,2) NOT NULL DEFAULT 20.00,
    `exam_type`  VARCHAR(30) NOT NULL DEFAULT 'Quiz',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`subject_id`) REFERENCES `Subjects`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert exams linked to subjects
INSERT INTO `Exams` (`id`, `subject_id`, `exam_name`, `exam_date`, `max_score`, `exam_type`) VALUES
(1, 1, 'Mathematics Midterm', '2026-01-15', 20.00, 'Midterm'),
(2, 1, 'Mathematics Final',   '2026-03-20', 20.00, 'Final'),
(3, 2, 'Science Quiz',        '2026-01-20', 20.00, 'Quiz'),
(4, 2, 'Science Midterm',     '2026-02-15', 20.00, 'Midterm'),
(5, 3, 'English Midterm',     '2026-02-10', 20.00, 'Midterm'),
(6, 3, 'English Final',       '2026-03-25', 20.00, 'Final'),
(7, 6, 'Physics Quiz',        '2026-01-25', 20.00, 'Quiz'),
(8, 7, 'French Midterm',      '2026-02-20', 20.00, 'Midterm');

-- ============================================================
-- Step 3 : GRADES TABLE
-- One row per student per exam.
-- CONSTRAINTS:
--   • UNIQUE (student_id, exam_id) → prevents duplicate grades
--   • CHECK  (score >= 0)          → no negative scores
--   • CHECK  (score <= max 20)     → score cannot exceed 20
-- Uses students.id from the existing students table
-- ============================================================

CREATE TABLE IF NOT EXISTS `Grades` (
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `student_id` INT(11) NOT NULL,
    `exam_id`    INT(11) NOT NULL,
    `score`      DECIMAL(5,2) NOT NULL,
    `grade_date` DATE DEFAULT NULL,
    `remarks`    VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_student_exam` (`student_id`, `exam_id`),
    FOREIGN KEY (`student_id`) REFERENCES `students`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`exam_id`) REFERENCES `Exams`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `chk_score_not_negative` CHECK (`score` >= 0),
    CONSTRAINT `chk_score_max` CHECK (`score` <= 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- Step 4 : STUDENT_AVERAGES TABLE
-- This table is NEVER filled manually.
-- The TRIGGER fills it automatically every time a grade
-- is inserted or updated.
-- ============================================================

CREATE TABLE IF NOT EXISTS `Student_Averages` (
    `id`              INT(11) NOT NULL AUTO_INCREMENT,
    `student_id`      INT(11) NOT NULL,
    `overall_average` DECIMAL(5,2) DEFAULT 0.00,
    `total_exams`     INT(11) DEFAULT 0,
    `classification`  VARCHAR(20) DEFAULT 'Unclassified',
    `calculated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                      ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_student` (`student_id`),
    FOREIGN KEY (`student_id`) REFERENCES `students`(`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- Step 5 : TRIGGER — trg_after_grade_insert
--
-- This is the ADVANCED FEATURE of Task 3.
--
-- HOW IT WORKS:
--   1. Someone inserts a grade → INSERT INTO Grades (...)
--   2. This trigger fires AUTOMATICALLY after the insert
--   3. It calculates AVG(score) for that student
--   4. It classifies the student:
--        >= 16  →  Excellent
--        >= 14  →  Very Good
--        >= 12  →  Good
--        >= 10  →  Pass
--        <  10  →  Fail
--   5. It saves/updates the result in Student_Averages
--      using INSERT ... ON DUPLICATE KEY UPDATE (UPSERT)
-- ============================================================

DELIMITER $$

CREATE TRIGGER `trg_after_grade_insert`
AFTER INSERT ON `Grades`
FOR EACH ROW
BEGIN
    DECLARE v_avg   DECIMAL(5,2);
    DECLARE v_count INT;
    DECLARE v_class VARCHAR(20);

    -- Calculate average for this student across ALL their exams
    SELECT AVG(score), COUNT(*)
      INTO v_avg, v_count
      FROM `Grades`
     WHERE student_id = NEW.student_id;

    -- Classify based on the calculated average
    IF    v_avg >= 16 THEN SET v_class = 'Excellent';
    ELSEIF v_avg >= 14 THEN SET v_class = 'Very Good';
    ELSEIF v_avg >= 12 THEN SET v_class = 'Good';
    ELSEIF v_avg >= 10 THEN SET v_class = 'Pass';
    ELSE                     SET v_class = 'Fail';
    END IF;

    -- Insert new record or update existing one (UPSERT)
    INSERT INTO `Student_Averages`
           (student_id, overall_average, total_exams, classification)
    VALUES (NEW.student_id, v_avg, v_count, v_class)
    ON DUPLICATE KEY UPDATE
        overall_average = v_avg,
        total_exams     = v_count,
        classification  = v_class;
END$$

DELIMITER ;

-- ============================================================
-- Step 6 : TRIGGER — trg_after_grade_update
-- Same logic, but fires when a score is corrected/updated.
-- ============================================================

DELIMITER $$

CREATE TRIGGER `trg_after_grade_update`
AFTER UPDATE ON `Grades`
FOR EACH ROW
BEGIN
    DECLARE v_avg   DECIMAL(5,2);
    DECLARE v_count INT;
    DECLARE v_class VARCHAR(20);

    SELECT AVG(score), COUNT(*)
      INTO v_avg, v_count
      FROM `Grades`
     WHERE student_id = NEW.student_id;

    IF    v_avg >= 16 THEN SET v_class = 'Excellent';
    ELSEIF v_avg >= 14 THEN SET v_class = 'Very Good';
    ELSEIF v_avg >= 12 THEN SET v_class = 'Good';
    ELSEIF v_avg >= 10 THEN SET v_class = 'Pass';
    ELSE                     SET v_class = 'Fail';
    END IF;

    INSERT INTO `Student_Averages`
           (student_id, overall_average, total_exams, classification)
    VALUES (NEW.student_id, v_avg, v_count, v_class)
    ON DUPLICATE KEY UPDATE
        overall_average = v_avg,
        total_exams     = v_count,
        classification  = v_class;
END$$

DELIMITER ;

-- ============================================================
-- Step 7 : INSERT GRADES DATA
-- These use REAL student IDs from the students table.
-- The trigger fires automatically after each INSERT!
-- ============================================================

-- Grades for Grade 1A students (student ids 2-16)
INSERT INTO `Grades` (`student_id`, `exam_id`, `score`, `grade_date`) VALUES
-- James Smith (id=2) — strong student
(2, 1, 17.50, '2026-01-15'),   -- Math Midterm
(2, 3, 16.00, '2026-01-20'),   -- Science Quiz
(2, 5, 18.00, '2026-02-10'),   -- English Midterm

-- Emma Johnson (id=3) — excellent student
(3, 1, 19.00, '2026-01-15'),   -- Math Midterm
(3, 3, 18.50, '2026-01-20'),   -- Science Quiz
(3, 5, 17.00, '2026-02-10'),   -- English Midterm

-- Liam Williams (id=4) — good student
(4, 1, 14.00, '2026-01-15'),   -- Math Midterm
(4, 3, 13.50, '2026-01-20'),   -- Science Quiz
(4, 5, 12.00, '2026-02-10'),   -- English Midterm

-- Olivia Brown (id=5) — very good student
(5, 1, 15.00, '2026-01-15'),   -- Math Midterm
(5, 3, 16.00, '2026-01-20'),   -- Science Quiz
(5, 5, 14.50, '2026-02-10'),   -- English Midterm

-- Noah Jones (id=6) — pass student
(6, 1, 11.00, '2026-01-15'),   -- Math Midterm
(6, 3, 10.50, '2026-01-20'),   -- Science Quiz
(6, 5, 12.00, '2026-02-10'),   -- English Midterm

-- Ava Garcia (id=7) — fail student
(7, 1, 8.00,  '2026-01-15'),   -- Math Midterm
(7, 3, 7.50,  '2026-01-20'),   -- Science Quiz
(7, 5, 9.00,  '2026-02-10'),   -- English Midterm

-- Ethan Miller (id=8)
(8, 1, 14.50, '2026-01-15'),   -- Math Midterm
(8, 3, 15.00, '2026-01-20'),   -- Science Quiz

-- Sophia Davis (id=9)
(9, 1, 16.00, '2026-01-15'),   -- Math Midterm
(9, 3, 17.50, '2026-01-20'),   -- Science Quiz

-- Mason Rodriguez (id=10)
(10, 1, 12.50, '2026-01-15'),  -- Math Midterm
(10, 3, 11.00, '2026-01-20'),  -- Science Quiz

-- Isabella Martinez (id=11)
(11, 1, 13.00, '2026-01-15'),  -- Math Midterm
(11, 3, 14.00, '2026-01-20');  -- Science Quiz

-- ============================================================
-- Step 8 : VERIFICATION QUERIES
-- Run these to confirm everything works!
-- ============================================================

-- QUERY 1 : Show auto-calculated averages (filled by trigger!)
SELECT
    s.first_name              AS 'First Name',
    s.last_name               AS 'Last Name',
    c.name                    AS 'Class',
    sa.overall_average        AS 'Average',
    sa.total_exams            AS 'Exams Taken',
    sa.classification         AS 'Classification'
FROM `Student_Averages` sa
JOIN `students` s ON s.id = sa.student_id
LEFT JOIN `classes` c ON c.id = s.class_id
ORDER BY sa.overall_average DESC;

-- QUERY 2 : Detailed grade report per student
SELECT
    s.first_name              AS 'Student',
    sub.subject_name          AS 'Subject',
    e.exam_name               AS 'Exam',
    g.score                   AS 'Score',
    e.max_score               AS 'Max',
    g.grade_date              AS 'Date'
FROM `Grades` g
JOIN `students` s    ON s.id = g.student_id
JOIN `Exams` e       ON e.id = g.exam_id
JOIN `Subjects` sub  ON sub.id = e.subject_id
ORDER BY s.first_name, e.exam_date;

-- QUERY 3 : Class statistics — overall view
SELECT
    COUNT(*)                       AS 'Total Students',
    ROUND(AVG(overall_average),2)  AS 'Class Average',
    MAX(overall_average)           AS 'Highest Average',
    MIN(overall_average)           AS 'Lowest Average',
    SUM(CASE WHEN overall_average >= 10 THEN 1 ELSE 0 END) AS 'Passed',
    SUM(CASE WHEN overall_average <  10 THEN 1 ELSE 0 END) AS 'Failed'
FROM `Student_Averages`;

-- QUERY 4 : Show subjects with their teachers
SELECT
    sub.subject_name          AS 'Subject',
    CONCAT(t.first_name, ' ', t.last_name) AS 'Teacher',
    t.email                   AS 'Email'
FROM `Subjects` sub
JOIN `teachers` t ON t.id = sub.teacher_id
ORDER BY sub.subject_name;

-- ============================================================
-- Step 9 : LIVE DEMO — Run DURING your presentation
-- This proves the trigger works in real time!
-- ============================================================

-- DEMO 1: Check Ava Garcia's current status
-- Expected: Average ~8.17, Classification = Fail
SELECT s.first_name, s.last_name, sa.overall_average, sa.classification
FROM `Student_Averages` sa
JOIN `students` s ON s.id = sa.student_id
WHERE sa.student_id = 7;

-- DEMO 2: UPDATE her Math score from 8 to 16
UPDATE `Grades` SET score = 16.00 WHERE student_id = 7 AND exam_id = 1;

-- DEMO 3: Check again — average should jump, classification should change!
-- Expected: Average ~10.83, Classification = Pass
SELECT s.first_name, s.last_name, sa.overall_average, sa.classification
FROM `Student_Averages` sa
JOIN `students` s ON s.id = sa.student_id
WHERE sa.student_id = 7;

-- DEMO 4: Try inserting a DUPLICATE grade → should FAIL!
-- This proves the UNIQUE constraint works
-- INSERT INTO `Grades` (`student_id`, `exam_id`, `score`, `grade_date`)
-- VALUES (2, 1, 15.00, '2026-03-31');
-- ^ Uncomment and run this — it will give an error:
--   "Duplicate entry '2-1' for key 'unique_student_exam'"

-- DEMO 5: Try inserting a NEGATIVE score → should FAIL!
-- This proves the CHECK constraint works
-- INSERT INTO `Grades` (`student_id`, `exam_id`, `score`, `grade_date`)
-- VALUES (12, 1, -5.00, '2026-03-31');
-- ^ Uncomment and run this — it will give an error:
--   "Check constraint 'chk_score_not_negative' is violated"
