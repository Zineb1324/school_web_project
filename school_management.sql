-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2026 at 01:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_student` (IN `p_student_username` VARCHAR(50), IN `p_student_password` VARCHAR(255), IN `p_student_email` VARCHAR(100), IN `p_student_first_name` VARCHAR(50), IN `p_student_last_name` VARCHAR(50), IN `p_student_dob` DATE, IN `p_student_address` TEXT, IN `p_student_phone` VARCHAR(20), IN `p_enrollment_date` DATE, IN `p_parent_username` VARCHAR(50), IN `p_parent_password` VARCHAR(255), IN `p_parent_email` VARCHAR(100), IN `p_parent_first_name` VARCHAR(50), IN `p_parent_last_name` VARCHAR(50), IN `p_parent_phone` VARCHAR(20), IN `p_parent_address` TEXT, IN `p_parent_occupation` VARCHAR(100))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Users (username, password, email, role_id)
    VALUES (p_student_username, p_student_password, p_student_email, 
            (SELECT id FROM Roles WHERE name = 'student'));

    SET @student_user_id = LAST_INSERT_ID();

    INSERT INTO Students (user_id, first_name, last_name, date_of_birth, address, phone, enrollment_date)
    VALUES (@student_user_id, p_student_first_name, p_student_last_name, p_student_dob,
            p_student_address, p_student_phone, p_enrollment_date);

    SET @student_id = LAST_INSERT_ID();

    INSERT INTO Users (username, password, email, role_id)
    VALUES (p_parent_username, p_parent_password, p_parent_email,
            (SELECT id FROM Roles WHERE name = 'parent'));

    SET @parent_user_id = LAST_INSERT_ID();

    INSERT INTO Parents (user_id, first_name, last_name, phone, email, address, occupation)
    VALUES (@parent_user_id, p_parent_first_name, p_parent_last_name,
            p_parent_phone, p_parent_email, p_parent_address, p_parent_occupation);

    SET @parent_id = LAST_INSERT_ID();

    INSERT INTO Student_Parent (student_id, parent_id)
    VALUES (@student_id, @parent_id);

    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'Grade 1A', 'First year', '2026-03-27 17:05:59'),
(2, 'Grade 1B', 'First year', '2026-03-27 17:05:59'),
(3, 'Grade 1C', 'First year', '2026-03-27 17:05:59'),
(4, 'Grade 2A', 'Second year', '2026-03-28 09:29:16'),
(5, 'Grade 2B', 'Second year', '2026-03-28 09:29:16'),
(6, 'Grade 2C', 'Second year', '2026-03-28 09:29:16'),
(7, 'Grade 3A', 'Third year', '2026-03-28 09:29:16'),
(8, 'Grade 3B', 'Third year', '2026-03-28 09:29:16'),
(9, 'Grade 3C', 'Third year', '2026-03-28 09:29:16');

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`id`, `user_id`, `first_name`, `last_name`, `phone`, `email`, `address`, `occupation`) VALUES
(2, 8, 'Robert', 'Smith', '7138135818', 'robert.smith@parent.com', '705 Hillcrest Rd, Chicago, USA', 'Engineer'),
(3, 10, 'Patricia', 'Johnson', '3129237734', 'patricia.johnson@parent.com', '842 Pine St, Phoenix, USA', 'Engineer'),
(4, 12, 'John', 'Williams', '2127068382', 'john.williams@parent.com', '585 Main St, San Antonio, USA', 'Engineer'),
(5, 14, 'Jennifer', 'Brown', '2123951131', 'jennifer.brown@parent.com', '175 Oak Ave, Los Angeles, USA', 'Engineer'),
(6, 16, 'Michael', 'Jones', '5128278892', 'michael.jones@parent.com', '309 Pine St, Phoenix, USA', 'Engineer'),
(7, 18, 'Linda', 'Garcia', '2155576131', 'linda.garcia@parent.com', '374 Main St, Los Angeles, USA', 'Engineer'),
(8, 20, 'David', 'Miller', '2125126430', 'david.miller@parent.com', '893 Pine St, Los Angeles, USA', 'Engineer'),
(9, 22, 'Barbara', 'Davis', '6196867456', 'barbara.davis@parent.com', '515 Lakeview Dr, San Diego, USA', 'Engineer'),
(10, 24, 'William', 'Rodriguez', '2124218694', 'william.rodriguez@parent.com', '836 Maple Dr, San Antonio, USA', 'Engineer'),
(11, 26, 'Susan', 'Martinez', '5123693734', 'susan.martinez@parent.com', '919 Pine St, New York, USA', 'Engineer'),
(12, 28, 'Richard', 'Hernandez', '7137559540', 'richard.hernandez@parent.com', '682 Maple Dr, Houston, USA', 'Engineer'),
(13, 30, 'Jessica', 'Lopez', '7136815969', 'jessica.lopez@parent.com', '219 Oak Ave, Houston, USA', 'Engineer'),
(14, 32, 'Joseph', 'Gonzalez', '2147038632', 'joseph.gonzalez@parent.com', '804 Elm St, San Antonio, USA', 'Engineer'),
(15, 34, 'Karen', 'Wilson', '2155213419', 'karen.wilson@parent.com', '306 Hillcrest Rd, Austin, USA', 'Engineer'),
(16, 36, 'Thomas', 'Anderson', '2155583244', 'thomas.anderson@parent.com', '724 Main St, San Diego, USA', 'Engineer'),
(17, 38, 'Nancy', 'Smith', '6197478163', 'nancy.smith@parent.com', '864 Main St, Los Angeles, USA', 'Engineer'),
(18, 40, 'Charles', 'Johnson', '3101865976', 'charles.johnson@parent.com', '985 Cedar Ln, Chicago, USA', 'Engineer'),
(19, 42, 'Lisa', 'Williams', '3106817477', 'lisa.williams@parent.com', '444 Oak Ave, Philadelphia, USA', 'Engineer'),
(20, 44, 'Christopher', 'Brown', '7138544683', 'christopher.brown@parent.com', '451 Maple Dr, Philadelphia, USA', 'Engineer'),
(21, 46, 'Betty', 'Jones', '7137783136', 'betty.jones@parent.com', '998 Oak Ave, New York, USA', 'Engineer'),
(22, 48, 'Daniel', 'Garcia', '2142648800', 'daniel.garcia@parent.com', '394 Lakeview Dr, Philadelphia, USA', 'Engineer'),
(23, 50, 'Margaret', 'Miller', '2151336203', 'margaret.miller@parent.com', '968 Main St, Chicago, USA', 'Engineer'),
(24, 52, 'Matthew', 'Davis', '7137137790', 'matthew.davis@parent.com', '956 Main St, Austin, USA', 'Engineer'),
(25, 54, 'Sandra', 'Rodriguez', '2149769140', 'sandra.rodriguez@parent.com', '711 Main St, Chicago, USA', 'Engineer'),
(26, 56, 'Anthony', 'Martinez', '7139555199', 'anthony.martinez@parent.com', '162 Park Ave, Los Angeles, USA', 'Engineer'),
(27, 58, 'Ashley', 'Hernandez', '2127396776', 'ashley.hernandez@parent.com', '128 Park Ave, Houston, USA', 'Engineer'),
(28, 60, 'Donald', 'Lopez', '3103372451', 'donald.lopez@parent.com', '371 Elm St, Los Angeles, USA', 'Engineer'),
(29, 62, 'Kimberly', 'Gonzalez', '3103994414', 'kimberly.gonzalez@parent.com', '703 Maple Dr, Phoenix, USA', 'Engineer'),
(30, 64, 'Mark', 'Wilson', '3108089653', 'mark.wilson@parent.com', '963 Washington Blvd, Houston, USA', 'Engineer'),
(31, 66, 'Emily', 'Anderson', '3127722222', 'emily.anderson@parent.com', '743 Hillcrest Rd, Phoenix, USA', 'Engineer'),
(32, 68, 'Paul', 'Smith', '2106305520', 'paul.smith@parent.com', '380 Oak Ave, Austin, USA', 'Engineer'),
(33, 70, 'Donna', 'Johnson', '3105111783', 'donna.johnson@parent.com', '775 Elm St, Los Angeles, USA', 'Engineer'),
(34, 72, 'Steven', 'Williams', '5121685006', 'steven.williams@parent.com', '143 Main St, Los Angeles, USA', 'Engineer'),
(35, 74, 'Michelle', 'Brown', '2151976736', 'michelle.brown@parent.com', '997 Washington Blvd, Phoenix, USA', 'Engineer'),
(36, 76, 'Andrew', 'Jones', '3125717724', 'andrew.jones@parent.com', '536 Pine St, Phoenix, USA', 'Engineer'),
(37, 78, 'Dorothy', 'Garcia', '2125137527', 'dorothy.garcia@parent.com', '317 Park Ave, Philadelphia, USA', 'Engineer'),
(38, 80, 'Kenneth', 'Miller', '2157682845', 'kenneth.miller@parent.com', '857 Maple Dr, Houston, USA', 'Engineer'),
(39, 82, 'Carol', 'Davis', '5121214943', 'carol.davis@parent.com', '283 Pine St, Houston, USA', 'Engineer'),
(40, 84, 'Joshua', 'Rodriguez', '7132082660', 'joshua.rodriguez@parent.com', '915 Main St, New York, USA', 'Engineer'),
(41, 86, 'Amanda', 'Martinez', '7137494948', 'amanda.martinez@parent.com', '645 Pine St, San Antonio, USA', 'Engineer'),
(42, 88, 'Kevin', 'Hernandez', '3129481377', 'kevin.hernandez@parent.com', '321 Maple Dr, Phoenix, USA', 'Engineer'),
(43, 90, 'Melissa', 'Lopez', '2147990848', 'melissa.lopez@parent.com', '808 Cedar Ln, Houston, USA', 'Engineer'),
(44, 92, 'Brian', 'Gonzalez', '2102822580', 'brian.gonzalez@parent.com', '278 Hillcrest Rd, Los Angeles, USA', 'Engineer'),
(45, 94, 'Deborah', 'Wilson', '3125961337', 'deborah.wilson@parent.com', '916 Washington Blvd, Los Angeles, USA', 'Engineer'),
(46, 96, 'George', 'Anderson', '2124015829', 'george.anderson@parent.com', '438 Washington Blvd, Philadelphia, USA', 'Engineer'),
(47, 98, 'Robert', 'Grade 2A', '3105024492', 'grade2a_student1_parent@example.com', '843 Maple Dr, Chicago, USA', 'Engineer'),
(48, 100, 'Patricia', 'Grade 2A', '2107950541', 'grade2a_student2_parent@example.com', '256 Park Ave, Austin, USA', 'Engineer'),
(49, 102, 'John', 'Grade 2A', '2144083592', 'grade2a_student3_parent@example.com', '512 Washington Blvd, Philadelphia, USA', 'Engineer'),
(50, 104, 'Jennifer', 'Grade 2A', '5126094130', 'grade2a_student4_parent@example.com', '611 Washington Blvd, Los Angeles, USA', 'Engineer'),
(51, 106, 'Michael', 'Grade 2A', '7131485636', 'grade2a_student5_parent@example.com', '225 Lakeview Dr, San Antonio, USA', 'Engineer'),
(52, 108, 'Linda', 'Grade 2A', '5128176351', 'grade2a_student6_parent@example.com', '507 Elm St, San Diego, USA', 'Engineer'),
(53, 110, 'David', 'Grade 2A', '3127839688', 'grade2a_student7_parent@example.com', '796 Washington Blvd, New York, USA', 'Engineer'),
(54, 112, 'Barbara', 'Grade 2A', '3105295297', 'grade2a_student8_parent@example.com', '853 Oak Ave, Chicago, USA', 'Engineer'),
(55, 114, 'William', 'Grade 2A', '6020314841', 'grade2a_student9_parent@example.com', '402 Oak Ave, Phoenix, USA', 'Engineer'),
(56, 116, 'Susan', 'Grade 2A', '5128336276', 'grade2a_student10_parent@example.com', '285 Pine St, San Diego, USA', 'Engineer'),
(57, 118, 'Richard', 'Grade 2A', '2148039661', 'grade2a_student11_parent@example.com', '132 Cedar Ln, Philadelphia, USA', 'Engineer'),
(58, 120, 'Jessica', 'Grade 2A', '2109385353', 'grade2a_student12_parent@example.com', '455 Park Ave, San Antonio, USA', 'Engineer'),
(59, 122, 'Joseph', 'Grade 2A', '3108861872', 'grade2a_student13_parent@example.com', '628 Oak Ave, San Diego, USA', 'Engineer'),
(60, 124, 'Karen', 'Grade 2A', '7132920172', 'grade2a_student14_parent@example.com', '741 Washington Blvd, Phoenix, USA', 'Engineer'),
(61, 126, 'Thomas', 'Grade 2A', '2158816725', 'grade2a_student15_parent@example.com', '260 Hillcrest Rd, Phoenix, USA', 'Engineer'),
(62, 128, 'Robert', 'Grade 2B', '6197895559', 'grade2b_student1_parent@example.com', '453 Washington Blvd, Austin, USA', 'Engineer'),
(63, 130, 'Patricia', 'Grade 2B', '5124502913', 'grade2b_student2_parent@example.com', '173 Oak Ave, Houston, USA', 'Engineer'),
(64, 132, 'John', 'Grade 2B', '6021176313', 'grade2b_student3_parent@example.com', '548 Oak Ave, San Diego, USA', 'Engineer'),
(65, 134, 'Jennifer', 'Grade 2B', '2149137527', 'grade2b_student4_parent@example.com', '288 Main St, Houston, USA', 'Engineer'),
(66, 136, 'Michael', 'Grade 2B', '2124902337', 'grade2b_student5_parent@example.com', '527 Maple Dr, Los Angeles, USA', 'Engineer'),
(67, 138, 'Linda', 'Grade 2B', '2123754171', 'grade2b_student6_parent@example.com', '456 Park Ave, Los Angeles, USA', 'Engineer'),
(68, 140, 'David', 'Grade 2B', '7132490434', 'grade2b_student7_parent@example.com', '480 Main St, Chicago, USA', 'Engineer'),
(69, 142, 'Barbara', 'Grade 2B', '2152945523', 'grade2b_student8_parent@example.com', '223 Park Ave, San Antonio, USA', 'Engineer'),
(70, 144, 'William', 'Grade 2B', '2120521989', 'grade2b_student9_parent@example.com', '239 Oak Ave, Phoenix, USA', 'Engineer'),
(71, 146, 'Susan', 'Grade 2B', '6027575849', 'grade2b_student10_parent@example.com', '837 Main St, Phoenix, USA', 'Engineer'),
(72, 148, 'Richard', 'Grade 2B', '6194354147', 'grade2b_student11_parent@example.com', '472 Maple Dr, Chicago, USA', 'Engineer'),
(73, 150, 'Jessica', 'Grade 2B', '2122772559', 'grade2b_student12_parent@example.com', '350 Elm St, San Diego, USA', 'Engineer'),
(74, 152, 'Joseph', 'Grade 2B', '6190226333', 'grade2b_student13_parent@example.com', '430 Oak Ave, Phoenix, USA', 'Engineer'),
(75, 154, 'Karen', 'Grade 2B', '5120337048', 'grade2b_student14_parent@example.com', '499 Hillcrest Rd, Phoenix, USA', 'Engineer'),
(76, 156, 'Thomas', 'Grade 2B', '5129363011', 'grade2b_student15_parent@example.com', '957 Hillcrest Rd, San Diego, USA', 'Engineer'),
(77, 158, 'Robert', 'Grade 2C', '2152303289', 'grade2c_student1_parent@example.com', '272 Cedar Ln, New York, USA', 'Engineer'),
(78, 160, 'Patricia', 'Grade 2C', '5123656927', 'grade2c_student2_parent@example.com', '593 Oak Ave, Chicago, USA', 'Engineer'),
(79, 162, 'John', 'Grade 2C', '5125628766', 'grade2c_student3_parent@example.com', '920 Cedar Ln, New York, USA', 'Engineer'),
(80, 164, 'Jennifer', 'Grade 2C', '3127931172', 'grade2c_student4_parent@example.com', '597 Washington Blvd, New York, USA', 'Engineer'),
(81, 166, 'Michael', 'Grade 2C', '2152991116', 'grade2c_student5_parent@example.com', '434 Hillcrest Rd, Dallas, USA', 'Engineer'),
(82, 168, 'Linda', 'Grade 2C', '3128941639', 'grade2c_student6_parent@example.com', '193 Elm St, Los Angeles, USA', 'Engineer'),
(83, 170, 'David', 'Grade 2C', '3127907896', 'grade2c_student7_parent@example.com', '487 Elm St, Austin, USA', 'Engineer'),
(84, 172, 'Barbara', 'Grade 2C', '6197333513', 'grade2c_student8_parent@example.com', '958 Park Ave, New York, USA', 'Engineer'),
(85, 174, 'William', 'Grade 2C', '3100059404', 'grade2c_student9_parent@example.com', '907 Main St, Chicago, USA', 'Engineer'),
(86, 176, 'Susan', 'Grade 2C', '2155463595', 'grade2c_student10_parent@example.com', '692 Pine St, Phoenix, USA', 'Engineer'),
(87, 178, 'Richard', 'Grade 2C', '6194856258', 'grade2c_student11_parent@example.com', '401 Park Ave, Houston, USA', 'Engineer'),
(88, 180, 'Jessica', 'Grade 2C', '5124700765', 'grade2c_student12_parent@example.com', '730 Oak Ave, Austin, USA', 'Engineer'),
(89, 182, 'Joseph', 'Grade 2C', '2151550444', 'grade2c_student13_parent@example.com', '517 Oak Ave, Chicago, USA', 'Engineer'),
(90, 184, 'Karen', 'Grade 2C', '3123782090', 'grade2c_student14_parent@example.com', '735 Park Ave, Philadelphia, USA', 'Engineer'),
(91, 186, 'Thomas', 'Grade 2C', '2156017503', 'grade2c_student15_parent@example.com', '969 Lakeview Dr, San Diego, USA', 'Engineer'),
(92, 188, 'Robert', 'Grade 3A', '3126038488', 'grade3a_student1_parent@example.com', '511 Hillcrest Rd, Austin, USA', 'Engineer'),
(93, 190, 'Patricia', 'Grade 3A', '7132585224', 'grade3a_student2_parent@example.com', '704 Hillcrest Rd, San Diego, USA', 'Engineer'),
(94, 192, 'John', 'Grade 3A', '5127418480', 'grade3a_student3_parent@example.com', '134 Lakeview Dr, Dallas, USA', 'Engineer'),
(95, 194, 'Jennifer', 'Grade 3A', '3104480045', 'grade3a_student4_parent@example.com', '629 Oak Ave, Philadelphia, USA', 'Engineer'),
(96, 196, 'Michael', 'Grade 3A', '6029164502', 'grade3a_student5_parent@example.com', '862 Elm St, Houston, USA', 'Engineer'),
(97, 198, 'Linda', 'Grade 3A', '7136799517', 'grade3a_student6_parent@example.com', '853 Elm St, Los Angeles, USA', 'Engineer'),
(98, 200, 'David', 'Grade 3A', '3100734198', 'grade3a_student7_parent@example.com', '211 Oak Ave, Dallas, USA', 'Engineer'),
(99, 202, 'Barbara', 'Grade 3A', '6198510009', 'grade3a_student8_parent@example.com', '137 Park Ave, Phoenix, USA', 'Engineer'),
(100, 204, 'William', 'Grade 3A', '6024272158', 'grade3a_student9_parent@example.com', '628 Elm St, Houston, USA', 'Engineer'),
(101, 206, 'Susan', 'Grade 3A', '3129514379', 'grade3a_student10_parent@example.com', '260 Pine St, New York, USA', 'Engineer'),
(102, 208, 'Richard', 'Grade 3A', '6193496847', 'grade3a_student11_parent@example.com', '670 Maple Dr, Austin, USA', 'Engineer'),
(103, 210, 'Jessica', 'Grade 3A', '2149087140', 'grade3a_student12_parent@example.com', '284 Main St, Austin, USA', 'Engineer'),
(104, 212, 'Joseph', 'Grade 3A', '2147429493', 'grade3a_student13_parent@example.com', '279 Lakeview Dr, Phoenix, USA', 'Engineer'),
(105, 214, 'Karen', 'Grade 3A', '3125391882', 'grade3a_student14_parent@example.com', '961 Maple Dr, Chicago, USA', 'Engineer'),
(106, 216, 'Thomas', 'Grade 3A', '3100116880', 'grade3a_student15_parent@example.com', '636 Elm St, San Diego, USA', 'Engineer'),
(107, 218, 'Robert', 'Grade 3B', '2127110440', 'grade3b_student1_parent@example.com', '996 Park Ave, Phoenix, USA', 'Engineer'),
(108, 220, 'Patricia', 'Grade 3B', '2146578381', 'grade3b_student2_parent@example.com', '306 Cedar Ln, Austin, USA', 'Engineer'),
(109, 222, 'John', 'Grade 3B', '2147133102', 'grade3b_student3_parent@example.com', '970 Park Ave, Phoenix, USA', 'Engineer'),
(110, 224, 'Jennifer', 'Grade 3B', '2153407182', 'grade3b_student4_parent@example.com', '562 Elm St, Phoenix, USA', 'Engineer'),
(111, 226, 'Michael', 'Grade 3B', '3108901194', 'grade3b_student5_parent@example.com', '714 Washington Blvd, Chicago, USA', 'Engineer'),
(112, 228, 'Linda', 'Grade 3B', '2127436581', 'grade3b_student6_parent@example.com', '544 Oak Ave, San Diego, USA', 'Engineer'),
(113, 230, 'David', 'Grade 3B', '7132839037', 'grade3b_student7_parent@example.com', '930 Pine St, Phoenix, USA', 'Engineer'),
(114, 232, 'Barbara', 'Grade 3B', '7138955749', 'grade3b_student8_parent@example.com', '637 Maple Dr, Austin, USA', 'Engineer'),
(115, 234, 'William', 'Grade 3B', '7139545884', 'grade3b_student9_parent@example.com', '459 Oak Ave, Chicago, USA', 'Engineer'),
(116, 236, 'Susan', 'Grade 3B', '7136171218', 'grade3b_student10_parent@example.com', '589 Main St, Chicago, USA', 'Engineer'),
(117, 238, 'Richard', 'Grade 3B', '2102875832', 'grade3b_student11_parent@example.com', '390 Hillcrest Rd, Dallas, USA', 'Engineer'),
(118, 240, 'Jessica', 'Grade 3B', '3126322533', 'grade3b_student12_parent@example.com', '853 Oak Ave, New York, USA', 'Engineer'),
(119, 242, 'Joseph', 'Grade 3B', '2126229392', 'grade3b_student13_parent@example.com', '786 Pine St, Dallas, USA', 'Engineer'),
(120, 244, 'Karen', 'Grade 3B', '3100883476', 'grade3b_student14_parent@example.com', '602 Oak Ave, Dallas, USA', 'Engineer'),
(121, 246, 'Thomas', 'Grade 3B', '5121985958', 'grade3b_student15_parent@example.com', '557 Park Ave, San Antonio, USA', 'Engineer'),
(122, 248, 'Robert', 'Grade 3C', '2156341734', 'grade3c_student1_parent@example.com', '892 Hillcrest Rd, Dallas, USA', 'Engineer'),
(123, 250, 'Patricia', 'Grade 3C', '6195925602', 'grade3c_student2_parent@example.com', '769 Hillcrest Rd, Los Angeles, USA', 'Engineer'),
(124, 252, 'John', 'Grade 3C', '2103516977', 'grade3c_student3_parent@example.com', '573 Pine St, Phoenix, USA', 'Engineer'),
(125, 254, 'Jennifer', 'Grade 3C', '6023844823', 'grade3c_student4_parent@example.com', '882 Main St, San Diego, USA', 'Engineer'),
(126, 256, 'Michael', 'Grade 3C', '2106271541', 'grade3c_student5_parent@example.com', '472 Lakeview Dr, Los Angeles, USA', 'Engineer'),
(127, 258, 'Linda', 'Grade 3C', '7134711491', 'grade3c_student6_parent@example.com', '800 Hillcrest Rd, San Diego, USA', 'Engineer'),
(128, 260, 'David', 'Grade 3C', '3107431189', 'grade3c_student7_parent@example.com', '642 Maple Dr, Houston, USA', 'Engineer'),
(129, 262, 'Barbara', 'Grade 3C', '6198059034', 'grade3c_student8_parent@example.com', '278 Pine St, Philadelphia, USA', 'Engineer'),
(130, 264, 'William', 'Grade 3C', '2101130917', 'grade3c_student9_parent@example.com', '390 Lakeview Dr, Dallas, USA', 'Engineer'),
(131, 266, 'Susan', 'Grade 3C', '3127804399', 'grade3c_student10_parent@example.com', '137 Hillcrest Rd, Houston, USA', 'Engineer'),
(132, 268, 'Richard', 'Grade 3C', '5120935074', 'grade3c_student11_parent@example.com', '110 Main St, Philadelphia, USA', 'Engineer'),
(133, 270, 'Jessica', 'Grade 3C', '5122523915', 'grade3c_student12_parent@example.com', '437 Washington Blvd, San Diego, USA', 'Engineer'),
(134, 272, 'Joseph', 'Grade 3C', '2121300029', 'grade3c_student13_parent@example.com', '530 Elm St, Philadelphia, USA', 'Engineer'),
(135, 274, 'Karen', 'Grade 3C', '2125103004', 'grade3c_student14_parent@example.com', '235 Park Ave, San Diego, USA', 'Engineer'),
(136, 276, 'Thomas', 'Grade 3C', '2128572307', 'grade3c_student15_parent@example.com', '692 Elm St, San Antonio, USA', 'Engineer');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(4, 'admin'),
(2, 'parent'),
(1, 'student'),
(3, 'teacher');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `enrollment_date` date NOT NULL,
  `class_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `user_id`, `first_name`, `last_name`, `date_of_birth`, `address`, `phone`, `enrollment_date`, `class_id`) VALUES
(2, 7, 'James', 'Smith', '2013-03-27', '705 Hillcrest Rd, Chicago, USA', '7136966388', '2026-03-27', 1),
(3, 9, 'Emma', 'Johnson', '2010-04-03', '842 Pine St, Phoenix, USA', '3124558086', '2026-03-27', 1),
(4, 11, 'Liam', 'Williams', '2010-03-19', '585 Main St, San Antonio, USA', '2121203450', '2026-03-27', 1),
(5, 13, 'Olivia', 'Brown', '2013-04-27', '175 Oak Ave, Los Angeles, USA', '2121191792', '2026-03-27', 1),
(6, 15, 'Noah', 'Jones', '2013-02-16', '309 Pine St, Phoenix, USA', '5129998563', '2026-03-27', 1),
(7, 17, 'Ava', 'Garcia', '2015-04-26', '374 Main St, Los Angeles, USA', '2155846588', '2026-03-27', 1),
(8, 19, 'Ethan', 'Miller', '2008-06-14', '893 Pine St, Los Angeles, USA', '2125156521', '2026-03-27', 1),
(9, 21, 'Sophia', 'Davis', '2012-01-12', '515 Lakeview Dr, San Diego, USA', '6194262280', '2026-03-27', 1),
(10, 23, 'Mason', 'Rodriguez', '2014-08-18', '836 Maple Dr, San Antonio, USA', '2123315635', '2026-03-27', 1),
(11, 25, 'Isabella', 'Martinez', '2015-02-15', '919 Pine St, New York, USA', '5123258962', '2026-03-27', 1),
(12, 27, 'Lucas', 'Hernandez', '2011-03-27', '682 Maple Dr, Houston, USA', '7135899388', '2026-03-27', 1),
(13, 29, 'Mia', 'Lopez', '2011-05-21', '219 Oak Ave, Houston, USA', '7138271323', '2026-03-27', 1),
(14, 31, 'Logan', 'Gonzalez', '2008-12-28', '804 Elm St, San Antonio, USA', '2148435770', '2026-03-27', 1),
(15, 33, 'Amelia', 'Wilson', '2009-09-13', '306 Hillcrest Rd, Austin, USA', '2151534003', '2026-03-27', 1),
(16, 35, 'Benjamin', 'Anderson', '2011-06-10', '724 Main St, San Diego, USA', '2151368302', '2026-03-27', 1),
(17, 37, 'Harper', 'Smith', '2015-07-26', '864 Main St, Los Angeles, USA', '6199525479', '2026-03-27', 2),
(18, 39, 'Elijah', 'Johnson', '2012-08-19', '985 Cedar Ln, Chicago, USA', '3103849982', '2026-03-27', 2),
(19, 41, 'Evelyn', 'Williams', '2012-12-04', '444 Oak Ave, Philadelphia, USA', '3104178667', '2026-03-27', 2),
(20, 43, 'Oliver', 'Brown', '2010-07-03', '451 Maple Dr, Philadelphia, USA', '7134810418', '2026-03-27', 2),
(21, 45, 'Abigail', 'Jones', '2010-08-01', '998 Oak Ave, New York, USA', '7134135559', '2026-03-27', 2),
(22, 47, 'Jacob', 'Garcia', '2010-11-15', '394 Lakeview Dr, Philadelphia, USA', '2149016285', '2026-03-27', 2),
(23, 49, 'Emily', 'Miller', '2010-10-17', '968 Main St, Chicago, USA', '2154004960', '2026-03-27', 2),
(24, 51, 'Michael', 'Davis', '2011-08-25', '956 Main St, Austin, USA', '7138550932', '2026-03-27', 2),
(25, 53, 'Elizabeth', 'Rodriguez', '2014-04-26', '711 Main St, Chicago, USA', '2149258856', '2026-03-27', 2),
(26, 55, 'Alexander', 'Martinez', '2009-02-13', '162 Park Ave, Los Angeles, USA', '7132393587', '2026-03-27', 2),
(27, 57, 'Sofia', 'Hernandez', '2008-08-30', '128 Park Ave, Houston, USA', '2121081391', '2026-03-27', 2),
(28, 59, 'Daniel', 'Lopez', '2010-07-05', '371 Elm St, Los Angeles, USA', '3102201189', '2026-03-27', 2),
(29, 61, 'Avery', 'Gonzalez', '2009-10-25', '703 Maple Dr, Phoenix, USA', '3109481763', '2026-03-27', 2),
(30, 63, 'Matthew', 'Wilson', '2015-06-08', '963 Washington Blvd, Houston, USA', '3103738362', '2026-03-27', 2),
(31, 65, 'Ella', 'Anderson', '2008-02-23', '743 Hillcrest Rd, Phoenix, USA', '3127763342', '2026-03-27', 2),
(32, 67, 'Jackson', 'Smith', '2014-01-06', '380 Oak Ave, Austin, USA', '2102312909', '2026-03-27', 3),
(33, 69, 'Madison', 'Johnson', '2014-07-20', '775 Elm St, Los Angeles, USA', '3105859673', '2026-03-27', 3),
(34, 71, 'David', 'Williams', '2013-09-01', '143 Main St, Los Angeles, USA', '5128494066', '2026-03-27', 3),
(35, 73, 'Scarlett', 'Brown', '2011-08-04', '997 Washington Blvd, Phoenix, USA', '2156493495', '2026-03-27', 3),
(36, 75, 'Joseph', 'Jones', '2008-07-22', '536 Pine St, Phoenix, USA', '3123968382', '2026-03-27', 3),
(37, 77, 'Victoria', 'Garcia', '2011-06-19', '317 Park Ave, Philadelphia, USA', '2124687060', '2026-03-27', 3),
(38, 79, 'Samuel', 'Miller', '2015-11-18', '857 Maple Dr, Houston, USA', '2157695059', '2026-03-27', 3),
(39, 81, 'Aria', 'Davis', '2012-02-04', '283 Pine St, Houston, USA', '5128884615', '2026-03-27', 3),
(40, 83, 'Carter', 'Rodriguez', '2013-02-17', '915 Main St, New York, USA', '7133546717', '2026-03-27', 3),
(41, 85, 'Grace', 'Martinez', '2015-09-30', '645 Pine St, San Antonio, USA', '7134227501', '2026-03-27', 3),
(42, 87, 'Owen', 'Hernandez', '2010-07-03', '321 Maple Dr, Phoenix, USA', '3124245798', '2026-03-27', 3),
(43, 89, 'Chloe', 'Lopez', '2011-09-19', '808 Cedar Ln, Houston, USA', '2142000608', '2026-03-27', 3),
(44, 91, 'Wyatt', 'Gonzalez', '2010-04-08', '278 Hillcrest Rd, Los Angeles, USA', '2109236530', '2026-03-27', 3),
(45, 93, 'Camila', 'Wilson', '2015-12-28', '916 Washington Blvd, Los Angeles, USA', '3129606373', '2026-03-27', 3),
(46, 95, 'John', 'Anderson', '2010-05-11', '438 Washington Blvd, Philadelphia, USA', '2123831786', '2026-03-27', 3),
(47, 97, 'James', 'Smith', '2013-05-31', '843 Maple Dr, Chicago, USA', '3103348372', '2026-03-28', 4),
(48, 99, 'Emma', 'Thomas', '2008-10-18', '256 Park Ave, Austin, USA', '2108743922', '2026-03-28', 4),
(49, 101, 'Liam', 'Taylor', '2008-07-13', '512 Washington Blvd, Philadelphia, USA', '2148573660', '2026-03-28', 4),
(50, 103, 'Olivia', 'Moore', '2008-04-18', '611 Washington Blvd, Los Angeles, USA', '5120821900', '2026-03-28', 4),
(51, 105, 'Noah', 'Jackson', '2009-06-29', '225 Lakeview Dr, San Antonio, USA', '7133226387', '2026-03-28', 4),
(52, 107, 'Ava', 'Martin', '2008-12-29', '507 Elm St, San Diego, USA', '5127542518', '2026-03-28', 4),
(53, 109, 'Ethan', 'Lee', '2014-06-09', '796 Washington Blvd, New York, USA', '3120033284', '2026-03-28', 4),
(54, 111, 'Sophia', 'Perez', '2013-09-15', '853 Oak Ave, Chicago, USA', '3106334565', '2026-03-28', 4),
(55, 113, 'Mason', 'Thompson', '2013-01-20', '402 Oak Ave, Phoenix, USA', '6021780964', '2026-03-28', 4),
(56, 115, 'Isabella', 'White', '2013-04-18', '285 Pine St, San Diego, USA', '5123266378', '2026-03-28', 4),
(57, 117, 'Lucas', 'Harris', '2012-10-08', '132 Cedar Ln, Philadelphia, USA', '2141194381', '2026-03-28', 4),
(58, 119, 'Mia', 'Sanchez', '2009-08-28', '455 Park Ave, San Antonio, USA', '2109383333', '2026-03-28', 4),
(59, 121, 'Logan', 'Clark', '2009-01-01', '628 Oak Ave, San Diego, USA', '3100299210', '2026-03-28', 4),
(60, 123, 'Amelia', 'Ramirez', '2010-04-17', '741 Washington Blvd, Phoenix, USA', '7130278581', '2026-03-28', 4),
(61, 125, 'Benjamin', 'Lewis', '2015-06-23', '260 Hillcrest Rd, Phoenix, USA', '2157752121', '2026-03-28', 4),
(62, 127, 'James', 'Robinson', '2013-01-21', '453 Washington Blvd, Austin, USA', '6191601545', '2026-03-28', 5),
(63, 129, 'Emma', 'Walker', '2011-12-23', '173 Oak Ave, Houston, USA', '5128002636', '2026-03-28', 5),
(64, 131, 'Liam', 'Young', '2014-07-03', '548 Oak Ave, San Diego, USA', '6029294150', '2026-03-28', 5),
(65, 133, 'Olivia', 'Allen', '2011-12-31', '288 Main St, Houston, USA', '2146921096', '2026-03-28', 5),
(66, 135, 'Noah', 'King', '2014-08-04', '527 Maple Dr, Los Angeles, USA', '2125398212', '2026-03-28', 5),
(67, 137, 'Ava', 'Wright', '2008-10-16', '456 Park Ave, Los Angeles, USA', '2121158768', '2026-03-28', 5),
(68, 139, 'Ethan', 'Scott', '2012-11-28', '480 Main St, Chicago, USA', '7135551995', '2026-03-28', 5),
(69, 141, 'Sophia', 'Torres', '2014-12-11', '223 Park Ave, San Antonio, USA', '2157976633', '2026-03-28', 5),
(70, 143, 'Mason', 'Nguyen', '2009-11-30', '239 Oak Ave, Phoenix, USA', '2128663086', '2026-03-28', 5),
(71, 145, 'Isabella', 'Hill', '2008-02-20', '837 Main St, Phoenix, USA', '6025704229', '2026-03-28', 5),
(72, 147, 'Lucas', 'Flores', '2010-07-14', '472 Maple Dr, Chicago, USA', '6190309957', '2026-03-28', 5),
(73, 149, 'Mia', 'Green', '2008-01-18', '350 Elm St, San Diego, USA', '2126414335', '2026-03-28', 5),
(74, 151, 'Logan', 'Adams', '2012-10-12', '430 Oak Ave, Phoenix, USA', '6195205705', '2026-03-28', 5),
(75, 153, 'Amelia', 'Nelson', '2008-09-30', '499 Hillcrest Rd, Phoenix, USA', '5122406896', '2026-03-28', 5),
(76, 155, 'Benjamin', 'Baker', '2012-01-15', '957 Hillcrest Rd, San Diego, USA', '5121497489', '2026-03-28', 5),
(77, 157, 'James', 'Hall', '2011-02-12', '272 Cedar Ln, New York, USA', '2154378193', '2026-03-28', 6),
(78, 159, 'Emma', 'Rivera', '2010-07-24', '593 Oak Ave, Chicago, USA', '5122837737', '2026-03-28', 6),
(79, 161, 'Liam', 'Campbell', '2011-04-21', '920 Cedar Ln, New York, USA', '5120430171', '2026-03-28', 6),
(80, 163, 'Olivia', 'Mitchell', '2008-03-10', '597 Washington Blvd, New York, USA', '3127336188', '2026-03-28', 6),
(81, 165, 'Noah', 'Carter', '2011-05-25', '434 Hillcrest Rd, Dallas, USA', '2157493928', '2026-03-28', 6),
(82, 167, 'Ava', 'Roberts', '2014-10-10', '193 Elm St, Los Angeles, USA', '3128683037', '2026-03-28', 6),
(83, 169, 'Ethan', 'Gomez', '2010-04-11', '487 Elm St, Austin, USA', '3124613893', '2026-03-28', 6),
(84, 171, 'Sophia', 'Phillips', '2013-03-29', '958 Park Ave, New York, USA', '6199121774', '2026-03-28', 6),
(85, 173, 'Mason', 'Henderson', '2009-07-10', '907 Main St, Chicago, USA', '3108537267', '2026-03-28', 6),
(86, 175, 'Isabella', 'Coleman', '2011-05-22', '692 Pine St, Phoenix, USA', '2158387382', '2026-03-28', 6),
(87, 177, 'Lucas', 'Jenkis', '2015-05-06', '401 Park Ave, Houston, USA', '6192657781', '2026-03-28', 6),
(88, 179, 'Mia', 'Perry', '2009-03-10', '730 Oak Ave, Austin, USA', '5124513170', '2026-03-28', 6),
(89, 181, 'Logan', 'Powell', '2009-05-09', '517 Oak Ave, Chicago, USA', '2150054629', '2026-03-28', 6),
(90, 183, 'Amelia', 'Long', '2009-05-10', '735 Park Ave, Philadelphia, USA', '3129192139', '2026-03-28', 6),
(91, 185, 'Benjamin', 'Patterson', '2010-04-16', '969 Lakeview Dr, San Diego, USA', '2157413337', '2026-03-28', 6),
(92, 187, 'James', 'Hughes', '2009-02-04', '511 Hillcrest Rd, Austin, USA', '3126537215', '2026-03-28', 7),
(93, 189, 'Emma', 'Flores', '2012-06-08', '704 Hillcrest Rd, San Diego, USA', '7139133472', '2026-03-28', 7),
(94, 191, 'Liam', 'Washingtoon', '2012-04-15', '134 Lakeview Dr, Dallas, USA', '5129266363', '2026-03-28', 7),
(95, 193, 'Olivia', 'Butler', '2009-03-30', '629 Oak Ave, Philadelphia, USA', '3107966466', '2026-03-28', 7),
(96, 195, 'Noah', 'Simmons', '2012-07-28', '862 Elm St, Houston, USA', '6029356146', '2026-03-28', 7),
(97, 197, 'Ava', 'Foster', '2009-06-06', '853 Elm St, Los Angeles, USA', '7137832186', '2026-03-28', 7),
(98, 199, 'Ethan', 'Gonzales', '2012-01-07', '211 Oak Ave, Dallas, USA', '3104697250', '2026-03-28', 7),
(99, 201, 'Sophia', 'Bryant', '2012-12-30', '137 Park Ave, Phoenix, USA', '6193750015', '2026-03-28', 7),
(100, 203, 'Mason', 'Alexander', '2012-03-07', '628 Elm St, Houston, USA', '6023347965', '2026-03-28', 7),
(101, 205, 'Isabella', 'Russell', '2011-06-24', '260 Pine St, New York, USA', '3121382929', '2026-03-28', 7),
(102, 207, 'Lucas', 'Griffin', '2010-07-14', '670 Maple Dr, Austin, USA', '6197499705', '2026-03-28', 7),
(103, 209, 'Mia', 'Diaz', '2014-03-04', '284 Main St, Austin, USA', '2146108364', '2026-03-28', 7),
(104, 211, 'Logan', 'Hayes', '2011-11-18', '279 Lakeview Dr, Phoenix, USA', '2143230575', '2026-03-28', 7),
(105, 213, 'Amelia', 'Myers', '2011-06-21', '961 Maple Dr, Chicago, USA', '3123773041', '2026-03-28', 7),
(106, 215, 'Benjamin', 'Ford', '2009-08-01', '636 Elm St, San Diego, USA', '3101857894', '2026-03-28', 7),
(107, 217, 'James', 'Hamilton', '2009-10-19', '996 Park Ave, Phoenix, USA', '2120545415', '2026-03-28', 8),
(108, 219, 'Emma', 'Graham', '2009-10-03', '306 Cedar Ln, Austin, USA', '2147496775', '2026-03-28', 8),
(109, 221, 'Liam', 'Sullivan', '2008-09-14', '970 Park Ave, Phoenix, USA', '2144809483', '2026-03-28', 8),
(110, 223, 'Olivia', 'Wallas', '2014-05-02', '562 Elm St, Phoenix, USA', '2153905639', '2026-03-28', 8),
(111, 225, 'Noah', 'Woods', '2009-10-27', '714 Washington Blvd, Chicago, USA', '3108514655', '2026-03-28', 8),
(112, 227, 'Ava', 'Cole', '2014-08-05', '544 Oak Ave, San Diego, USA', '2126968307', '2026-03-28', 8),
(113, 229, 'Ethan', 'West', '2011-12-22', '930 Pine St, Phoenix, USA', '7132482842', '2026-03-28', 8),
(114, 231, 'Sophia', 'Jordan', '2008-09-06', '637 Maple Dr, Austin, USA', '7131862039', '2026-03-28', 8),
(115, 233, 'Mason', 'Owens', '2011-05-30', '459 Oak Ave, Chicago, USA', '7135865923', '2026-03-28', 8),
(116, 235, 'Isabella', 'Reynolds', '2009-02-04', '589 Main St, Chicago, USA', '7131798393', '2026-03-28', 8),
(117, 237, 'Lucas', 'Fisher', '2010-07-27', '390 Hillcrest Rd, Dallas, USA', '2100404832', '2026-03-28', 8),
(118, 239, 'Mia', 'Gibson', '2011-05-03', '853 Oak Ave, New York, USA', '3120555672', '2026-03-28', 8),
(119, 241, 'Logan', 'Cruz', '2008-04-25', '786 Pine St, Dallas, USA', '2123817313', '2026-03-28', 8),
(120, 243, 'Amelia', 'Gomez', '2013-07-03', '602 Oak Ave, Dallas, USA', '3101110493', '2026-03-28', 8),
(121, 245, 'Benjamin', 'Kim', '2010-12-29', '557 Park Ave, San Antonio, USA', '5129954823', '2026-03-28', 8),
(122, 247, 'James', 'ET', '2009-07-19', '892 Hillcrest Rd, Dallas, USA', '2154847465', '2026-03-28', 9),
(123, 249, 'Emma', 'Elite', '2009-12-09', '769 Hillcrest Rd, Los Angeles, USA', '6197265998', '2026-03-28', 9),
(124, 251, 'Liam', 'Koki', '2015-01-03', '573 Pine St, Phoenix, USA', '2103512629', '2026-03-28', 9),
(125, 253, 'Olivia', 'Ortiz', '2012-12-23', '882 Main St, San Diego, USA', '6022692375', '2026-03-28', 9),
(126, 255, 'Noah', 'Marshall', '2013-05-17', '472 Lakeview Dr, Los Angeles, USA', '2108681626', '2026-03-28', 9),
(127, 257, 'Ava', 'Ellis', '2014-07-18', '800 Hillcrest Rd, San Diego, USA', '7139577330', '2026-03-28', 9),
(128, 259, 'Ethan', 'Ross', '2014-09-08', '642 Maple Dr, Houston, USA', '3108125089', '2026-03-28', 9),
(129, 261, 'Sophia', 'Barnes', '2015-11-16', '278 Pine St, Philadelphia, USA', '6196686018', '2026-03-28', 9),
(130, 263, 'Mason', 'Wood', '2010-11-28', '390 Lakeview Dr, Dallas, USA', '2108871597', '2026-03-28', 9),
(131, 265, 'Isabella', 'Bennett', '2014-11-07', '137 Hillcrest Rd, Houston, USA', '3123139026', '2026-03-28', 9),
(132, 267, 'Lucas', 'Price', '2013-07-22', '110 Main St, Philadelphia, USA', '5121958217', '2026-03-28', 9),
(133, 269, 'Mia', 'Sandres', '2015-05-12', '437 Washington Blvd, San Diego, USA', '5125399303', '2026-03-28', 9),
(134, 271, 'Logan', 'Brooks', '2012-07-14', '530 Elm St, Philadelphia, USA', '2121432281', '2026-03-28', 9),
(135, 273, 'Amelia', 'Watson', '2012-03-28', '235 Park Ave, San Diego, USA', '2125875196', '2026-03-28', 9),
(136, 275, 'Benjamin', 'Kelly', '2015-11-25', '692 Elm St, San Antonio, USA', '2127273594', '2026-03-28', 9);

-- --------------------------------------------------------

--
-- Table structure for table `student_parent`
--

CREATE TABLE `student_parent` (
  `student_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_parent`
--

INSERT INTO `student_parent` (`student_id`, `parent_id`) VALUES
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34),
(35, 35),
(36, 36),
(37, 37),
(38, 38),
(39, 39),
(40, 40),
(41, 41),
(42, 42),
(43, 43),
(44, 44),
(45, 45),
(46, 46),
(47, 47),
(48, 48),
(49, 49),
(50, 50),
(51, 51),
(52, 52),
(53, 53),
(54, 54),
(55, 55),
(56, 56),
(57, 57),
(58, 58),
(59, 59),
(60, 60),
(61, 61),
(62, 62),
(63, 63),
(64, 64),
(65, 65),
(66, 66),
(67, 67),
(68, 68),
(69, 69),
(70, 70),
(71, 71),
(72, 72),
(73, 73),
(74, 74),
(75, 75),
(76, 76),
(77, 77),
(78, 78),
(79, 79),
(80, 80),
(81, 81),
(82, 82),
(83, 83),
(84, 84),
(85, 85),
(86, 86),
(87, 87),
(88, 88),
(89, 89),
(90, 90),
(91, 91),
(92, 92),
(93, 93),
(94, 94),
(95, 95),
(96, 96),
(97, 97),
(98, 98),
(99, 99),
(100, 100),
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(106, 106),
(107, 107),
(108, 108),
(109, 109),
(110, 110),
(111, 111),
(112, 112),
(113, 113),
(114, 114),
(115, 115),
(116, 116),
(117, 117),
(118, 118),
(119, 119),
(120, 120),
(121, 121),
(122, 122),
(123, 123),
(124, 124),
(125, 125),
(126, 126),
(127, 127),
(128, 128),
(129, 129),
(130, 130),
(131, 131),
(132, 132),
(133, 133),
(134, 134),
(135, 135),
(136, 136);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `subject_specialty` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `user_id`, `first_name`, `last_name`, `phone`, `email`, `hire_date`, `subject_specialty`) VALUES
(1, 6, 'Omar', 'Ali', '0103333333', 'teacher3@school.com', '2021-09-01', 'English'),
(2, 4, 'Ahmed', 'Hassan', '0101111111', 'teacher1@school.com', '2020-09-01', 'Mathematics'),
(3, 5, 'Sara', 'Maatouk', '0102222222', 'teacher2@school.com', '2019-03-03', 'Science'),
(4, 277, 'Emily', 'Clark', '2125551234', 'teacher4@school.com', '2021-08-15', 'Geography'),
(5, 278, 'Michael', 'Brown', '3105555678', 'teacher5@school.com', '2020-09-01', 'Philosophy'),
(6, 279, 'Laura', 'Martinez', '7135559012', 'teacher6@school.com', '2022-01-10', 'Physics'),
(7, 280, 'David', 'Wilson', '6025553456', 'teacher7@school.com', '2021-08-20', 'French');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role_id`, `created_at`) VALUES
(1, 'student1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'student1@example.com', 1, '2026-03-27 11:10:40'),
(2, 'parent1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'parent1@example.com', 2, '2026-03-27 11:10:40'),
(4, 'teacher1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'teacher1@school.com', 3, '2026-03-27 17:11:11'),
(5, 'teacher2', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'teacher2@school.com', 3, '2026-03-27 17:11:23'),
(6, 'teacher3', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'teacher3@school.com', 3, '2026-03-27 17:13:29'),
(7, 'grade1a_student1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'james.smith@school.com', 1, '2026-03-27 17:13:29'),
(8, 'grade1a_student1_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student1_parent@example.com', 2, '2026-03-27 17:13:29'),
(9, 'grade1a_student2', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'emma.johnson@school.com', 1, '2026-03-27 17:13:29'),
(10, 'grade1a_student2_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student2_parent@example.com', 2, '2026-03-27 17:13:29'),
(11, 'grade1a_student3', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'liam.williams@school.com', 1, '2026-03-27 17:13:30'),
(12, 'grade1a_student3_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student3_parent@example.com', 2, '2026-03-27 17:13:30'),
(13, 'grade1a_student4', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'olivia.brown@school.com', 1, '2026-03-27 17:13:30'),
(14, 'grade1a_student4_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student4_parent@example.com', 2, '2026-03-27 17:13:30'),
(15, 'grade1a_student5', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'noah.jones@school.com', 1, '2026-03-27 17:13:30'),
(16, 'grade1a_student5_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student5_parent@example.com', 2, '2026-03-27 17:13:30'),
(17, 'grade1a_student6', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'ava.garcia@school.com', 1, '2026-03-27 17:13:31'),
(18, 'grade1a_student6_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student6_parent@example.com', 2, '2026-03-27 17:13:31'),
(19, 'grade1a_student7', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'ethan.miller@school.com', 1, '2026-03-27 17:13:31'),
(20, 'grade1a_student7_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student7_parent@example.com', 2, '2026-03-27 17:13:31'),
(21, 'grade1a_student8', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'sophia.davis@school.com', 1, '2026-03-27 17:13:31'),
(22, 'grade1a_student8_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student8_parent@example.com', 2, '2026-03-27 17:13:31'),
(23, 'grade1a_student9', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'mason.rodriguez@school.com', 1, '2026-03-27 17:13:31'),
(24, 'grade1a_student9_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student9_parent@example.com', 2, '2026-03-27 17:13:31'),
(25, 'grade1a_student10', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'isabella.martinez@school.com', 1, '2026-03-27 17:13:32'),
(26, 'grade1a_student10_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student10_parent@example.com', 2, '2026-03-27 17:13:32'),
(27, 'grade1a_student11', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'lucas.hernandez@school.com', 1, '2026-03-27 17:13:32'),
(28, 'grade1a_student11_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student11_parent@example.com', 2, '2026-03-27 17:13:32'),
(29, 'grade1a_student12', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'mia.lopez@school.com', 1, '2026-03-27 17:13:32'),
(30, 'grade1a_student12_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student12_parent@example.com', 2, '2026-03-27 17:13:32'),
(31, 'grade1a_student13', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'logan.gonzalez@school.com', 1, '2026-03-27 17:13:33'),
(32, 'grade1a_student13_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student13_parent@example.com', 2, '2026-03-27 17:13:33'),
(33, 'grade1a_student14', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'amelia.wilson@school.com', 1, '2026-03-27 17:13:33'),
(34, 'grade1a_student14_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student14_parent@example.com', 2, '2026-03-27 17:13:33'),
(35, 'grade1a_student15', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'benjamin.anderson@school.com', 1, '2026-03-27 17:13:33'),
(36, 'grade1a_student15_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1a_student15_parent@example.com', 2, '2026-03-27 17:13:33'),
(37, 'grade1b_student1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'harper.smith@school.com', 1, '2026-03-27 17:13:34'),
(38, 'grade1b_student1_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student1_parent@example.com', 2, '2026-03-27 17:13:34'),
(39, 'grade1b_student2', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'elijah.johnson@school.com', 1, '2026-03-27 17:13:34'),
(40, 'grade1b_student2_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student2_parent@example.com', 2, '2026-03-27 17:13:34'),
(41, 'grade1b_student3', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'evelyn.williams@school.com', 1, '2026-03-27 17:13:34'),
(42, 'grade1b_student3_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student3_parent@example.com', 2, '2026-03-27 17:13:34'),
(43, 'grade1b_student4', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'oliver.brown@school.com', 1, '2026-03-27 17:13:34'),
(44, 'grade1b_student4_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student4_parent@example.com', 2, '2026-03-27 17:13:34'),
(45, 'grade1b_student5', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'abigail.jones@school.com', 1, '2026-03-27 17:13:35'),
(46, 'grade1b_student5_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student5_parent@example.com', 2, '2026-03-27 17:13:35'),
(47, 'grade1b_student6', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'jacob.garcia@school.com', 1, '2026-03-27 17:13:35'),
(48, 'grade1b_student6_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student6_parent@example.com', 2, '2026-03-27 17:13:35'),
(49, 'grade1b_student7', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'emily.miller@school.com', 1, '2026-03-27 17:13:35'),
(50, 'grade1b_student7_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student7_parent@example.com', 2, '2026-03-27 17:13:35'),
(51, 'grade1b_student8', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'michael.davis@school.com', 1, '2026-03-27 17:13:36'),
(52, 'grade1b_student8_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student8_parent@example.com', 2, '2026-03-27 17:13:36'),
(53, 'grade1b_student9', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'elizabeth.rodriguez@school.com', 1, '2026-03-27 17:13:36'),
(54, 'grade1b_student9_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student9_parent@example.com', 2, '2026-03-27 17:13:36'),
(55, 'grade1b_student10', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'alexander.martinez@school.com', 1, '2026-03-27 17:13:36'),
(56, 'grade1b_student10_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student10_parent@example.com', 2, '2026-03-27 17:13:36'),
(57, 'grade1b_student11', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'sofia.hernandez@school.com', 1, '2026-03-27 17:13:36'),
(58, 'grade1b_student11_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student11_parent@example.com', 2, '2026-03-27 17:13:36'),
(59, 'grade1b_student12', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'daniel.lopez@school.com', 1, '2026-03-27 17:13:37'),
(60, 'grade1b_student12_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student12_parent@example.com', 2, '2026-03-27 17:13:37'),
(61, 'grade1b_student13', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'avery.gonzalez@school.com', 1, '2026-03-27 17:13:37'),
(62, 'grade1b_student13_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student13_parent@example.com', 2, '2026-03-27 17:13:37'),
(63, 'grade1b_student14', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'matthew.wilson@school.com', 1, '2026-03-27 17:13:37'),
(64, 'grade1b_student14_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student14_parent@example.com', 2, '2026-03-27 17:13:37'),
(65, 'grade1b_student15', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'ella.anderson@school.com', 1, '2026-03-27 17:13:38'),
(66, 'grade1b_student15_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1b_student15_parent@example.com', 2, '2026-03-27 17:13:38'),
(67, 'grade1c_student1', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'jackson.smith@school.com', 1, '2026-03-27 17:13:38'),
(68, 'grade1c_student1_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student1_parent@example.com', 2, '2026-03-27 17:13:38'),
(69, 'grade1c_student2', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'madison.johnson@school.com', 1, '2026-03-27 17:13:38'),
(70, 'grade1c_student2_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student2_parent@example.com', 2, '2026-03-27 17:13:38'),
(71, 'grade1c_student3', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'david.williams@school.com', 1, '2026-03-27 17:13:39'),
(72, 'grade1c_student3_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student3_parent@example.com', 2, '2026-03-27 17:13:39'),
(73, 'grade1c_student4', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'scarlett.brown@school.com', 1, '2026-03-27 17:13:39'),
(74, 'grade1c_student4_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student4_parent@example.com', 2, '2026-03-27 17:13:39'),
(75, 'grade1c_student5', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'joseph.jones@school.com', 1, '2026-03-27 17:13:39'),
(76, 'grade1c_student5_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student5_parent@example.com', 2, '2026-03-27 17:13:39'),
(77, 'grade1c_student6', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'victoria.garcia@school.com', 1, '2026-03-27 17:13:39'),
(78, 'grade1c_student6_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student6_parent@example.com', 2, '2026-03-27 17:13:39'),
(79, 'grade1c_student7', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'samuel.miller@school.com', 1, '2026-03-27 17:13:40'),
(80, 'grade1c_student7_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student7_parent@example.com', 2, '2026-03-27 17:13:40'),
(81, 'grade1c_student8', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'aria.davis@school.com', 1, '2026-03-27 17:13:40'),
(82, 'grade1c_student8_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student8_parent@example.com', 2, '2026-03-27 17:13:40'),
(83, 'grade1c_student9', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'carter.rodriguez@school.com', 1, '2026-03-27 17:13:40'),
(84, 'grade1c_student9_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student9_parent@example.com', 2, '2026-03-27 17:13:40'),
(85, 'grade1c_student10', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grace.martinez@school.com', 1, '2026-03-27 17:13:41'),
(86, 'grade1c_student10_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student10_parent@example.com', 2, '2026-03-27 17:13:41'),
(87, 'grade1c_student11', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'owen.hernandez@school.com', 1, '2026-03-27 17:13:41'),
(88, 'grade1c_student11_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student11_parent@example.com', 2, '2026-03-27 17:13:41'),
(89, 'grade1c_student12', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'chloe.lopez@school.com', 1, '2026-03-27 17:13:41'),
(90, 'grade1c_student12_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student12_parent@example.com', 2, '2026-03-27 17:13:41'),
(91, 'grade1c_student13', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'wyatt.gonzalez@school.com', 1, '2026-03-27 17:13:42'),
(92, 'grade1c_student13_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student13_parent@example.com', 2, '2026-03-27 17:13:42'),
(93, 'grade1c_student14', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'camila.wilson@school.com', 1, '2026-03-27 17:13:42'),
(94, 'grade1c_student14_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student14_parent@example.com', 2, '2026-03-27 17:13:42'),
(95, 'grade1c_student15', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'john.anderson@school.com', 1, '2026-03-27 17:13:42'),
(96, 'grade1c_student15_parent', '$2y$10$tnsS0NG2056se/utnDfBzO1c65KkzC7AFHHsnl1TWTBxKSnyvLfom', 'grade1c_student15_parent@example.com', 2, '2026-03-27 17:13:42'),
(97, 'grade2a_student1', '$2y$10$0PWwNV3U/ZwbG5.5q/voseMKYsAdtPES6R4edTJmtpOtEp/FuY6zm', 'grade2a_student1@example.com', 1, '2026-03-28 09:29:16'),
(98, 'grade2a_student1_parent', '$2y$10$Rdni1zxkde0V2/x.e1BG1ud5VfD9qE/M6eA6lEb4URLVevKSt1cHC', 'grade2a_student1_parent@example.com', 2, '2026-03-28 09:29:16'),
(99, 'grade2a_student2', '$2y$10$jkSfLOMgnY3fVXLftEZGUuAlLNyIUsOnCJL6MHKvFSueFtbe72eN.', 'grade2a_student2@example.com', 1, '2026-03-28 09:29:16'),
(100, 'grade2a_student2_parent', '$2y$10$IDdyOa4PVRyZdT9VejUET.FwBmcW7RTUF8UT8uDEoXxzj0ytHZ42y', 'grade2a_student2_parent@example.com', 2, '2026-03-28 09:29:16'),
(101, 'grade2a_student3', '$2y$10$6mHSbj4WmP1J0OoAhQJ8/unnq1Nks/PLuDYlvGZ1UpNb/4VWnYrIG', 'grade2a_student3@example.com', 1, '2026-03-28 09:29:16'),
(102, 'grade2a_student3_parent', '$2y$10$lXwpYeO2fBG9fAJr4llR6uIyo3yztKRlApx9gUguBiXN5bOeZNqtO', 'grade2a_student3_parent@example.com', 2, '2026-03-28 09:29:16'),
(103, 'grade2a_student4', '$2y$10$9t7N1DqAobkJ29njV9fJKeyw3kmXqjcPgu.0SXAZ7o4kR/QjQNbHq', 'grade2a_student4@example.com', 1, '2026-03-28 09:29:17'),
(104, 'grade2a_student4_parent', '$2y$10$bOAGTEyjazV6h62EZXeLPurdR3ps0kGZ9eWKptD4iwPaqfBZqeun2', 'grade2a_student4_parent@example.com', 2, '2026-03-28 09:29:17'),
(105, 'grade2a_student5', '$2y$10$VXhiRebMr4TtiWin14jdUOgFNjG1m5J4wgXrZyn/P7cvjuAXB48XW', 'grade2a_student5@example.com', 1, '2026-03-28 09:29:17'),
(106, 'grade2a_student5_parent', '$2y$10$SOO4LNe672DYItS8NUiAbO60BxnXzRl0Ir/jDhz6jDJcIKZZ.G2cK', 'grade2a_student5_parent@example.com', 2, '2026-03-28 09:29:17'),
(107, 'grade2a_student6', '$2y$10$ggGjTrGxeyBUskt06jxOgeU8U9.29GXkPXoiJSk91MrwlISDOv7UG', 'grade2a_student6@example.com', 1, '2026-03-28 09:29:17'),
(108, 'grade2a_student6_parent', '$2y$10$dYjYLqA0POR7DwgdlgjFsuDDj88ySB5ebPB8V.MD474nvIn.9vnmi', 'grade2a_student6_parent@example.com', 2, '2026-03-28 09:29:17'),
(109, 'grade2a_student7', '$2y$10$Z1WwANP2c2lgHsuxv.VSuuemwHceaNjj/0yFzaRPP965VUUfatDTO', 'grade2a_student7@example.com', 1, '2026-03-28 09:29:17'),
(110, 'grade2a_student7_parent', '$2y$10$xIMOzQcKOtncs.7VUvU0X.G0w3XQ21VoijSafOSSWi.bs45Y.09J2', 'grade2a_student7_parent@example.com', 2, '2026-03-28 09:29:17'),
(111, 'grade2a_student8', '$2y$10$tYSiABOpul9hmAYFzWntpOxT44ZMu/n3cnXNz94166Qx0SWL1eWoC', 'grade2a_student8@example.com', 1, '2026-03-28 09:29:17'),
(112, 'grade2a_student8_parent', '$2y$10$EWdK1/nccXdpMj6fgdX1AOL7BRKYea.M39MUqOzrR1HGkviu8p2ai', 'grade2a_student8_parent@example.com', 2, '2026-03-28 09:29:17'),
(113, 'grade2a_student9', '$2y$10$cxLbSgNM.I1JPxytuNjBq.vIq9njL6jNeweNllF3/CBzfoJG06Bzq', 'grade2a_student9@example.com', 1, '2026-03-28 09:29:17'),
(114, 'grade2a_student9_parent', '$2y$10$V9yorw6FYwUWRejD8WAViOa0jD4ETnRkMRyexmbC7fMrbzG6nEWSS', 'grade2a_student9_parent@example.com', 2, '2026-03-28 09:29:17'),
(115, 'grade2a_student10', '$2y$10$3jjpfJAwROwPzXv8NtUq/.4dG4cPblslyiWWKrfllDknaVpV.GSUK', 'grade2a_student10@example.com', 1, '2026-03-28 09:29:17'),
(116, 'grade2a_student10_parent', '$2y$10$ft4yv4sK.jK7SZcw/BR9ZOXBe1MuKq4KlJD0dfaayQ/2ANM7ubPzm', 'grade2a_student10_parent@example.com', 2, '2026-03-28 09:29:17'),
(117, 'grade2a_student11', '$2y$10$f/eSXdej4RJ6s/J/4H9xvuNISnq.ErdVNZarruFbOmpa0jE1JPy4m', 'grade2a_student11@example.com', 1, '2026-03-28 09:29:17'),
(118, 'grade2a_student11_parent', '$2y$10$hWyigN/TYWRo.ZyoIKGDmOcaZQYazns5opKqmaz2u0C/lqLiuxSZe', 'grade2a_student11_parent@example.com', 2, '2026-03-28 09:29:17'),
(119, 'grade2a_student12', '$2y$10$vBjfalcKZl.CRZe9QXDAtukb.nhYy.Hja7/DCg3oj63I9PnDP9/Qm', 'grade2a_student12@example.com', 1, '2026-03-28 09:29:18'),
(120, 'grade2a_student12_parent', '$2y$10$FSIHGmZmXS/GFaRAoXG6q.fLm1wgqWbO1ZtQvmCJ042o/ewiJ6ODq', 'grade2a_student12_parent@example.com', 2, '2026-03-28 09:29:18'),
(121, 'grade2a_student13', '$2y$10$yDLIew3i5CUSV.tpyHlghOuiKuP9RHrJnzefViaSVtfQDaLzc1OiG', 'grade2a_student13@example.com', 1, '2026-03-28 09:29:18'),
(122, 'grade2a_student13_parent', '$2y$10$f/lrdaUSGk6JfTmoCshOzue/7rlO5TeN/QS3XfkeVDk..4H7BXg8W', 'grade2a_student13_parent@example.com', 2, '2026-03-28 09:29:18'),
(123, 'grade2a_student14', '$2y$10$ypIPPx835IZhprYxUarvqOTIhffFVfJoqwrJW3cHeLXFT3.oxKUA.', 'grade2a_student14@example.com', 1, '2026-03-28 09:29:18'),
(124, 'grade2a_student14_parent', '$2y$10$8NGHvFHgkoL7cDzH1e3aZuoxNnpHlkYFbntGxU/eSax.O97UuAir6', 'grade2a_student14_parent@example.com', 2, '2026-03-28 09:29:18'),
(125, 'grade2a_student15', '$2y$10$.tdy9PCJzqMsBRWP2yAatOHfP6eLaBCsh36xM74dfFemc6Emr14bG', 'grade2a_student15@example.com', 1, '2026-03-28 09:29:18'),
(126, 'grade2a_student15_parent', '$2y$10$gNggViNpqhHydTj.mWtqke5dwiFBGBLvnMUsYUig2dsJBtcFArPkO', 'grade2a_student15_parent@example.com', 2, '2026-03-28 09:29:18'),
(127, 'grade2b_student1', '$2y$10$rizHbGMkTg9rnMQTrgR68.q5jZDUOMAvm8E2c1NTHTWwOm.d1Fulm', 'grade2b_student1@example.com', 1, '2026-03-28 09:29:18'),
(128, 'grade2b_student1_parent', '$2y$10$k4LDVNucf1yjbUmjdLKN6eZDAIF9rdyAwP4SW8Vmms2w.vAmChyMu', 'grade2b_student1_parent@example.com', 2, '2026-03-28 09:29:18'),
(129, 'grade2b_student2', '$2y$10$KXPUamqpzq4pfi.bBV0SFeF.V.Q6QlF.tuS6cgjFSFIQWiLkuSIQG', 'grade2b_student2@example.com', 1, '2026-03-28 09:29:18'),
(130, 'grade2b_student2_parent', '$2y$10$7.9o21AAG/aiSwxOGKHjmeKuGznz/bL3U9tHw6J0/dLqBLumOGija', 'grade2b_student2_parent@example.com', 2, '2026-03-28 09:29:18'),
(131, 'grade2b_student3', '$2y$10$hvjhFZZ4SJ2Mdy.A/YdLMO0yd6KDYjcKHMZ7APd3M41h.Ci0UI2Lq', 'grade2b_student3@example.com', 1, '2026-03-28 09:29:18'),
(132, 'grade2b_student3_parent', '$2y$10$.geMp0jN5hMVfcE6BVzLreoTaFfQllvBNW2Gv5X5tDuV68IKOkCUi', 'grade2b_student3_parent@example.com', 2, '2026-03-28 09:29:18'),
(133, 'grade2b_student4', '$2y$10$gVnNIzMVAjLcLSAX9jGuf.ejp/P3OIjx7nbxRpsA4c7L3a1/KHNHy', 'grade2b_student4@example.com', 1, '2026-03-28 09:29:18'),
(134, 'grade2b_student4_parent', '$2y$10$aWwvQzEvz1TSS/kHQa1mCOO6B7K9VpiOdHllK913pE2OF3caK..He', 'grade2b_student4_parent@example.com', 2, '2026-03-28 09:29:18'),
(135, 'grade2b_student5', '$2y$10$P2.9/zYc2jMPiWfRYCF3aervGeZram9p6seBw/306IwFRNmxd7lAi', 'grade2b_student5@example.com', 1, '2026-03-28 09:29:19'),
(136, 'grade2b_student5_parent', '$2y$10$8KjwSWAb/yKSgpgsv7QWE.Ho9tjRi105UbfPL.zSPnJOU3ayePH2S', 'grade2b_student5_parent@example.com', 2, '2026-03-28 09:29:19'),
(137, 'grade2b_student6', '$2y$10$MSaVPlg0jZtWop6udJe0deS5JvBR0.yhhApZvB5j2EOjB7mwwCSzu', 'grade2b_student6@example.com', 1, '2026-03-28 09:29:19'),
(138, 'grade2b_student6_parent', '$2y$10$P5qKpVsFeF.x.OFdPMqmjOu3jy0MdSoCwlXb9GjU5QW5sWdT5hClq', 'grade2b_student6_parent@example.com', 2, '2026-03-28 09:29:19'),
(139, 'grade2b_student7', '$2y$10$JafVQmzfsWEhTaJiuALt8u.BSEW6/3mUP3HjUZei4AV1Wi2zTbnoG', 'grade2b_student7@example.com', 1, '2026-03-28 09:29:19'),
(140, 'grade2b_student7_parent', '$2y$10$xyjOTj95NTXGPOVj.weH4.F9B94bg9q4IOBBDw4e3RzKNF8wfq8H2', 'grade2b_student7_parent@example.com', 2, '2026-03-28 09:29:19'),
(141, 'grade2b_student8', '$2y$10$..SDFH8U6./PqYaI.OTgnO/Dym/4TRCgk1K4KNWZkAELBQOgMk.a.', 'grade2b_student8@example.com', 1, '2026-03-28 09:29:19'),
(142, 'grade2b_student8_parent', '$2y$10$O1yHLSL7kJf2gZ302bKq0eBwezXLA7F76U3s4Jm7.bOP.jspH7j56', 'grade2b_student8_parent@example.com', 2, '2026-03-28 09:29:19'),
(143, 'grade2b_student9', '$2y$10$qQI4oZd0mjEVnPTKHD8mrOC5X2hhsUQ2rapLEG8WgDwajo9841qZK', 'grade2b_student9@example.com', 1, '2026-03-28 09:29:19'),
(144, 'grade2b_student9_parent', '$2y$10$ZiuFFz90tJSS5/nZI.eUzezMSgVDiOwy1jCWmvfZhM2UqL8boWVxG', 'grade2b_student9_parent@example.com', 2, '2026-03-28 09:29:19'),
(145, 'grade2b_student10', '$2y$10$jz5GtM3XVOKSaagOwLjU2...Ix0nFbjPeFTLvt5//2vJhaAL8/3lO', 'grade2b_student10@example.com', 1, '2026-03-28 09:29:19'),
(146, 'grade2b_student10_parent', '$2y$10$ccbFqtx1ytaMrKcPjWxMxec46HEG7qcuttqczx5fqQlOYXEGTJGku', 'grade2b_student10_parent@example.com', 2, '2026-03-28 09:29:19'),
(147, 'grade2b_student11', '$2y$10$CMfFdTAzmc4ux7pPs4HGo.27MhOiNr5VpGAAttvKq8F1woJL9lo6W', 'grade2b_student11@example.com', 1, '2026-03-28 09:29:19'),
(148, 'grade2b_student11_parent', '$2y$10$8YcuJo4YHIZkuFGXO/HeLOIes0Doq7z1qahp.jx5B1RhxUiDR4JKe', 'grade2b_student11_parent@example.com', 2, '2026-03-28 09:29:19'),
(149, 'grade2b_student12', '$2y$10$.uSY6WaysgigKSAJFFUfI.CkNqj0GTNDMRf56rxRfKY5CaoKEXHvm', 'grade2b_student12@example.com', 1, '2026-03-28 09:29:19'),
(150, 'grade2b_student12_parent', '$2y$10$tOEnxoBmrcJ3Mn7w3/pJbesO8ah/AN4w3XiBOZoF03jhp4Z9YEdyy', 'grade2b_student12_parent@example.com', 2, '2026-03-28 09:29:19'),
(151, 'grade2b_student13', '$2y$10$/xW.81DmH6tcr/olReTGJO/9ySUJjiPkJPoB5b1adtuIgvmthY5l2', 'grade2b_student13@example.com', 1, '2026-03-28 09:29:20'),
(152, 'grade2b_student13_parent', '$2y$10$R24jdDqeuYDHx6BTbJ0g9e8JFWIokim3xTY.DyyOH7Ek/caRokW96', 'grade2b_student13_parent@example.com', 2, '2026-03-28 09:29:20'),
(153, 'grade2b_student14', '$2y$10$MXjfZTJ16CeVpxccKRLofe46mH.y2VIt8x97cXtJ0k.Q4n.ToCcQa', 'grade2b_student14@example.com', 1, '2026-03-28 09:29:20'),
(154, 'grade2b_student14_parent', '$2y$10$BhacQ8OCJTM07ceO.f8gT.RZOsLJvCNuceS9kw3wCAwttPUK15E.C', 'grade2b_student14_parent@example.com', 2, '2026-03-28 09:29:20'),
(155, 'grade2b_student15', '$2y$10$n6O2rXKrlYL/Y2DTdUhx/uv.Ww.Cp/CskACy6BMS2wdrcKVaM3tka', 'grade2b_student15@example.com', 1, '2026-03-28 09:29:20'),
(156, 'grade2b_student15_parent', '$2y$10$W5GqITK2LjMmNFaFKxOwJu3LrVLHFUZFYlYUixtVHwI1296tSwpei', 'grade2b_student15_parent@example.com', 2, '2026-03-28 09:29:20'),
(157, 'grade2c_student1', '$2y$10$.Elc2GBPI9vE/E82vERfsevfgXCsen4BjLqWSmVRIOXQW6uDxbjMi', 'grade2c_student1@example.com', 1, '2026-03-28 09:29:20'),
(158, 'grade2c_student1_parent', '$2y$10$UOH1jB.ryQqxm6ISJe0/WugbgLouSFASo7kWDcT83oxnruQWgjVUq', 'grade2c_student1_parent@example.com', 2, '2026-03-28 09:29:20'),
(159, 'grade2c_student2', '$2y$10$rgqdqSAvDEav4Y6.oLSN5eMdT4IBe1yrZ5D6aq87kpIAcFC9ho3K6', 'grade2c_student2@example.com', 1, '2026-03-28 09:29:20'),
(160, 'grade2c_student2_parent', '$2y$10$0zzKxI5MrnKioEaXGeaYK.gZuMtPynD8NgM4FMFPNL.kwJ24d5/oC', 'grade2c_student2_parent@example.com', 2, '2026-03-28 09:29:20'),
(161, 'grade2c_student3', '$2y$10$8R5tiNBAVCHu/sjOqi3PDunqOVzKmCM5Cifu0u74O60e2a46.i4/W', 'grade2c_student3@example.com', 1, '2026-03-28 09:29:20'),
(162, 'grade2c_student3_parent', '$2y$10$Bo5prrAR04KWddmjV.RTF.iO6pvzjhblPM.eY7QkZLz1EimHh6xaq', 'grade2c_student3_parent@example.com', 2, '2026-03-28 09:29:20'),
(163, 'grade2c_student4', '$2y$10$4XD0XDwe2BADFv8Elifi9OCYKLnO3ZdTVQN8fOxGKPGQIWwSqF8Ym', 'grade2c_student4@example.com', 1, '2026-03-28 09:29:20'),
(164, 'grade2c_student4_parent', '$2y$10$JLO0bIqeaAiFK.ddvPsYWOxv0vEexe8mF4HUJ1i2WaH8R3J4Pi/J2', 'grade2c_student4_parent@example.com', 2, '2026-03-28 09:29:20'),
(165, 'grade2c_student5', '$2y$10$mB/o5FWc4uLFHHP5vWW9au2I2CikijWeC3Bzs5zlqnnD8tG7oRcS.', 'grade2c_student5@example.com', 1, '2026-03-28 09:29:20'),
(166, 'grade2c_student5_parent', '$2y$10$XIYKeMgl1Yt05TYCWJICQ.te28x.OGzEprmPMeJ2jUv0/PaefeK.m', 'grade2c_student5_parent@example.com', 2, '2026-03-28 09:29:20'),
(167, 'grade2c_student6', '$2y$10$fhV3Pq1gbEoy0PaaZVToguO0mMFqsrDH7t1JqpdC0ufNpTiCOZMny', 'grade2c_student6@example.com', 1, '2026-03-28 09:29:21'),
(168, 'grade2c_student6_parent', '$2y$10$dThaaFKhbkLnz1JyHGHIh.H5y3p2eQjDlhmqlVLBymv/fd9Sf9C3m', 'grade2c_student6_parent@example.com', 2, '2026-03-28 09:29:21'),
(169, 'grade2c_student7', '$2y$10$GDCZuWfXL26NHOsoP7BFru/Cy94BhjFhfSVtjns8QylfsE2DuruV2', 'grade2c_student7@example.com', 1, '2026-03-28 09:29:21'),
(170, 'grade2c_student7_parent', '$2y$10$bt.NMx6V/TERgaFnbKBmXesUFthvXF4IuG5.fEdlcbAA95ltvw3aO', 'grade2c_student7_parent@example.com', 2, '2026-03-28 09:29:21'),
(171, 'grade2c_student8', '$2y$10$kPMQzZJcRlLfU/9sWYF7p.cssyMsLQI8YSXRwoAHn6xDPwViAxH02', 'grade2c_student8@example.com', 1, '2026-03-28 09:29:21'),
(172, 'grade2c_student8_parent', '$2y$10$L9.Qhb0te8APUHomEkW4G.nG0LjxjEyDK69TigFB6gCFt1agTtwc.', 'grade2c_student8_parent@example.com', 2, '2026-03-28 09:29:21'),
(173, 'grade2c_student9', '$2y$10$H31bHV13Si735xDHw8JkgubQGTK9PJKQ0TQisekA1A3BpBY2k7f.i', 'grade2c_student9@example.com', 1, '2026-03-28 09:29:21'),
(174, 'grade2c_student9_parent', '$2y$10$0H4v9rqUxyqDMn8tLKJ.Z.Aoi0tFFqy3VHzTHX/BH0H0OK9eVfQPy', 'grade2c_student9_parent@example.com', 2, '2026-03-28 09:29:21'),
(175, 'grade2c_student10', '$2y$10$lKrxRGHrQfSyIUCUkkbMg.VkzlsrcHNsILmhF0yso8p0rjuzeIW0u', 'grade2c_student10@example.com', 1, '2026-03-28 09:29:21'),
(176, 'grade2c_student10_parent', '$2y$10$Jw/hJAM3iMd5jym1fX6DYuZpyQUy4e.UShF3V5a7prEEuB//P9LMG', 'grade2c_student10_parent@example.com', 2, '2026-03-28 09:29:21'),
(177, 'grade2c_student11', '$2y$10$N8jTAo8ByAU535SWafwKQOjTr4PrRIKd8i5c1dpQLa.2RFZWeDzuC', 'grade2c_student11@example.com', 1, '2026-03-28 09:29:21'),
(178, 'grade2c_student11_parent', '$2y$10$13c5yj5zTbrSrFW3YbpW.OKtL4v6hCO5Ce9I2sVmJJLJgU8M43YXK', 'grade2c_student11_parent@example.com', 2, '2026-03-28 09:29:21'),
(179, 'grade2c_student12', '$2y$10$AH8FUfafyVu0DnnGTJ7Yi.66y3ttCV08VW1hF2k8nQkaAf1UGgBQC', 'grade2c_student12@example.com', 1, '2026-03-28 09:29:21'),
(180, 'grade2c_student12_parent', '$2y$10$ZbBZ/E6kTWYpvL2ScBgJ3OvPyU1kWNFLBcMPQeSkPgByL6101gn0W', 'grade2c_student12_parent@example.com', 2, '2026-03-28 09:29:21'),
(181, 'grade2c_student13', '$2y$10$UtDTxTPu.yg6jksjVnzNbueHA2cgQ6qQxKAghCm6nllKO5ycTwnRS', 'grade2c_student13@example.com', 1, '2026-03-28 09:29:22'),
(182, 'grade2c_student13_parent', '$2y$10$osnR9/mHKiGR.I2OleMCKum4ccWMKHuuKj6ZzXiwBO5fo6pH60MBa', 'grade2c_student13_parent@example.com', 2, '2026-03-28 09:29:22'),
(183, 'grade2c_student14', '$2y$10$ko5zjRDEPuvqv6O/r7kG1O95q1Oq1yqgDfJO8g1.nZxdHSUH3LNn6', 'grade2c_student14@example.com', 1, '2026-03-28 09:29:22'),
(184, 'grade2c_student14_parent', '$2y$10$VtZHZ02vI.ZbI8zHMluLVeZS3UNdfXx2rAGI0HeLfG25q.FCST5Nq', 'grade2c_student14_parent@example.com', 2, '2026-03-28 09:29:22'),
(185, 'grade2c_student15', '$2y$10$rGKAk1uzdJgGa6CrMKoa6emqZaLldf7f1/B0niEjhI0t/k0GS6z5S', 'grade2c_student15@example.com', 1, '2026-03-28 09:29:22'),
(186, 'grade2c_student15_parent', '$2y$10$k7kfQStRqnKEZtCyNg3zqOmG1uJ9vG/Zex4IrWxD9WnYBmt6R78Oy', 'grade2c_student15_parent@example.com', 2, '2026-03-28 09:29:22'),
(187, 'grade3a_student1', '$2y$10$s0SFfqKQqZHMqxbO9ZUY7Ok/IJi87PcJIGGBSmvW/bvgJTVgmurRe', 'grade3a_student1@example.com', 1, '2026-03-28 09:29:22'),
(188, 'grade3a_student1_parent', '$2y$10$GiBxxuh07QJBnftQGfygIO9n07e28CwanwoBpB1o2b/mDJCk7tvqu', 'grade3a_student1_parent@example.com', 2, '2026-03-28 09:29:22'),
(189, 'grade3a_student2', '$2y$10$RN3ZwFjbo8NIwvlrQdtl6Oglh493uwCrKy23mhkV9g1wrgr9kY33m', 'grade3a_student2@example.com', 1, '2026-03-28 09:29:22'),
(190, 'grade3a_student2_parent', '$2y$10$70QjrNy5TxHqjLt9gLzJJuRVaAHISndJj8EYqeJ7cnireOHdfB.dS', 'grade3a_student2_parent@example.com', 2, '2026-03-28 09:29:22'),
(191, 'grade3a_student3', '$2y$10$Fr0cSAheo7WBvpwUfqrlOeTqd1PezKh.OAtXhn1eSrBS62IgRiFkO', 'grade3a_student3@example.com', 1, '2026-03-28 09:29:22'),
(192, 'grade3a_student3_parent', '$2y$10$IE8LwTy57tmUWjfsAmnwJOqEkPgXLF7gfqZdDlZZBxFNCv.gZNeF.', 'grade3a_student3_parent@example.com', 2, '2026-03-28 09:29:22'),
(193, 'grade3a_student4', '$2y$10$y3tJyglKpkGMm5YJGZ3IKO7uewREXac0GT/jmwjIxdZAU64V/BsIC', 'grade3a_student4@example.com', 1, '2026-03-28 09:29:22'),
(194, 'grade3a_student4_parent', '$2y$10$JRJHn6rpCI3y6.oB0xSof.GaP131T.vkuwMRzhdtQNlQaTThIbRUq', 'grade3a_student4_parent@example.com', 2, '2026-03-28 09:29:22'),
(195, 'grade3a_student5', '$2y$10$uVAclrc53eEzYzV7eyakzu787dRd11PNrkiuc9/d8A6MhMPhcirlS', 'grade3a_student5@example.com', 1, '2026-03-28 09:29:22'),
(196, 'grade3a_student5_parent', '$2y$10$UWeIriiUNH2j5RmR/3VcCOZ6MR4IiqM79cuFpCsFNFwgWNA5SbyUi', 'grade3a_student5_parent@example.com', 2, '2026-03-28 09:29:22'),
(197, 'grade3a_student6', '$2y$10$ZDSfy2WsX/l1FIci2/Y6qeXgngHsorQtIlMR8Thb5LHvpgkNoK/q2', 'grade3a_student6@example.com', 1, '2026-03-28 09:29:23'),
(198, 'grade3a_student6_parent', '$2y$10$Zc.CqiQlr1D/L5PDf.7VcuPsxX5Ky7EQR1U4k0i47Tiw9wim6lY1O', 'grade3a_student6_parent@example.com', 2, '2026-03-28 09:29:23'),
(199, 'grade3a_student7', '$2y$10$cn.X4OWUu9cM3Cjt/1iw8.gAjh8UkFFSAfr8Dt9IB6nA8NuBne.le', 'grade3a_student7@example.com', 1, '2026-03-28 09:29:23'),
(200, 'grade3a_student7_parent', '$2y$10$gDenpotePs4xFY8J1HBWsec.a5GC4hWv77qy78fpcpcu2wd6vwiOi', 'grade3a_student7_parent@example.com', 2, '2026-03-28 09:29:23'),
(201, 'grade3a_student8', '$2y$10$LuYPCA9BJ3cNiK5GGQ9WbO8lPWkaChg2F38ATOLb7wmeF/ccIH5O6', 'grade3a_student8@example.com', 1, '2026-03-28 09:29:23'),
(202, 'grade3a_student8_parent', '$2y$10$swY.ssjUVVApjioRpAnxP./CmxarXy2YABIr/YnuSBUhxzV1R2DwK', 'grade3a_student8_parent@example.com', 2, '2026-03-28 09:29:23'),
(203, 'grade3a_student9', '$2y$10$vIBKybvFqQbuVBw1PPsrwOdSZ8KbIrOycb1EFIvDcmmDO.y2tAckC', 'grade3a_student9@example.com', 1, '2026-03-28 09:29:23'),
(204, 'grade3a_student9_parent', '$2y$10$PpGUF40NSzAk1Coe21c0CuejTm2mgGZJ/uXrK1x5ARrWVBModkcZ.', 'grade3a_student9_parent@example.com', 2, '2026-03-28 09:29:23'),
(205, 'grade3a_student10', '$2y$10$WN0yTfZmjK.cv1ETAktLYelbHEpWZvQu6ecw0eA8YK0NOs7WdcxR2', 'grade3a_student10@example.com', 1, '2026-03-28 09:29:23'),
(206, 'grade3a_student10_parent', '$2y$10$QuO1z670MzcyeZz0D178vOnt8.jQJcOsyYVfi/EFpTMBQbMAVKREe', 'grade3a_student10_parent@example.com', 2, '2026-03-28 09:29:23'),
(207, 'grade3a_student11', '$2y$10$7j2YPJp0wx91fHQcELMs4ejLwOg4uVrY3j5Tivs.7NFGS40un7BwO', 'grade3a_student11@example.com', 1, '2026-03-28 09:29:23'),
(208, 'grade3a_student11_parent', '$2y$10$2PGLQ.NUrVg.9qPJrkC7q.0JZzeyGVGW33r.XvhMltchlSYDgnfyu', 'grade3a_student11_parent@example.com', 2, '2026-03-28 09:29:23'),
(209, 'grade3a_student12', '$2y$10$G1Sf71XJrC6HFJBlEURS6uJsVhKyQL.JraRgU5Fzm/AxP9pSzqoua', 'grade3a_student12@example.com', 1, '2026-03-28 09:29:23'),
(210, 'grade3a_student12_parent', '$2y$10$GOeP70QSblcDDkoFkOX6I.aZViB4npiHiuzP/BdzEnPXOARGkNDyG', 'grade3a_student12_parent@example.com', 2, '2026-03-28 09:29:23'),
(211, 'grade3a_student13', '$2y$10$kt02H1NTMVPBInITf8Pg0.cOx4nuJNAmYiBfrfXtHiHSrUHQRVmgC', 'grade3a_student13@example.com', 1, '2026-03-28 09:29:23'),
(212, 'grade3a_student13_parent', '$2y$10$ZR9fqn3b7xsy91v2m7OG7ubpcNH18souq3UoORmYUkrGoYH1GwKGC', 'grade3a_student13_parent@example.com', 2, '2026-03-28 09:29:23'),
(213, 'grade3a_student14', '$2y$10$zTc6Tu/XWFsbN..yNhzoZO0wFIENbbT2MU.0jY.UjEw.tyXOJJlJ.', 'grade3a_student14@example.com', 1, '2026-03-28 09:29:24'),
(214, 'grade3a_student14_parent', '$2y$10$k6pJEOaMXqjDr2.Fe3MymukHwoL8PgCHROmRfRAZlCdBo.6zojT6G', 'grade3a_student14_parent@example.com', 2, '2026-03-28 09:29:24'),
(215, 'grade3a_student15', '$2y$10$c.HwiNTP1D8BeeHz9acKYe.S00.yCxLFeiSRsXHAj4BEZL5kyhTlK', 'grade3a_student15@example.com', 1, '2026-03-28 09:29:24'),
(216, 'grade3a_student15_parent', '$2y$10$4rlSohtziuXnSy1Rygu8gOdhV1opozeyO2qWjffFaVjVxlw8DGw6.', 'grade3a_student15_parent@example.com', 2, '2026-03-28 09:29:24'),
(217, 'grade3b_student1', '$2y$10$M57BlN26bZs5tjvvSc3hWOxl/xr8ZgRHerS8gxqiBXScYzPirSKNa', 'grade3b_student1@example.com', 1, '2026-03-28 09:29:24'),
(218, 'grade3b_student1_parent', '$2y$10$BNkg88JgNI2i/7AULDHSBeJnk.fChO3p5oi8OGZs1yiHmEJax/H3i', 'grade3b_student1_parent@example.com', 2, '2026-03-28 09:29:24'),
(219, 'grade3b_student2', '$2y$10$rT4Om2kNesWCiCuEvEFzUOAcCQfeY71Xatlk5GHVlNYMjb71X6s4y', 'grade3b_student2@example.com', 1, '2026-03-28 09:29:24'),
(220, 'grade3b_student2_parent', '$2y$10$JfiT173RW2IbuezNClbjj.qVGTJF97n2zqK8cEZ1fxfK6hJzFz8E6', 'grade3b_student2_parent@example.com', 2, '2026-03-28 09:29:24'),
(221, 'grade3b_student3', '$2y$10$ETW5fzaHC4arW8SBGFVUjewxa/kXRm2bYEgUpmMbn37I7Jl9OqWhO', 'grade3b_student3@example.com', 1, '2026-03-28 09:29:24'),
(222, 'grade3b_student3_parent', '$2y$10$qrM2.HvABQ9Iec0OA4YBhuqPC9ytvN90fcE4uBBYJpxXnce2nA6Vi', 'grade3b_student3_parent@example.com', 2, '2026-03-28 09:29:24'),
(223, 'grade3b_student4', '$2y$10$1T6gS.6I/s51ZNHsa8l5zePozw5kzqosHFVdqxVGyUXLqi9IapV2u', 'grade3b_student4@example.com', 1, '2026-03-28 09:29:24'),
(224, 'grade3b_student4_parent', '$2y$10$LQYtdZ40Rr9DLryJfIFC2OiKIgVFpJCv8HRMiXSM.yKfXReHHroY6', 'grade3b_student4_parent@example.com', 2, '2026-03-28 09:29:24'),
(225, 'grade3b_student5', '$2y$10$DxZHgZR5QEWGgN7fGxJeXuMJlbZ.SLsD8EPnTKi7z0MF7/Q.0Yzce', 'grade3b_student5@example.com', 1, '2026-03-28 09:29:24'),
(226, 'grade3b_student5_parent', '$2y$10$0yk6jIHjfNJU1uHiQPhvjuzp9ybXKT2qiS5erMyOobrcYPkc4hu2W', 'grade3b_student5_parent@example.com', 2, '2026-03-28 09:29:24'),
(227, 'grade3b_student6', '$2y$10$7aXekOBVIEzEGd8mD19y0.UDhL2g71DTn22nixjPjVz5MzCT4Gjuy', 'grade3b_student6@example.com', 1, '2026-03-28 09:29:24'),
(228, 'grade3b_student6_parent', '$2y$10$dkDDyMxwHTnbd/VVYwuGB.CLTQ.Eb3pffWw1rvHlenT/JMTDpfdh6', 'grade3b_student6_parent@example.com', 2, '2026-03-28 09:29:24'),
(229, 'grade3b_student7', '$2y$10$DeYVCq7QbXI38WOv9BI9Oe4afqzCISR8Q49oupnNm8pRZGA1xJCDq', 'grade3b_student7@example.com', 1, '2026-03-28 09:29:25'),
(230, 'grade3b_student7_parent', '$2y$10$iYlB70bSEZ15USnO2/kUi.RN7FFzjxaoc1Dq79B0R4QPd6JtNVDAO', 'grade3b_student7_parent@example.com', 2, '2026-03-28 09:29:25'),
(231, 'grade3b_student8', '$2y$10$ut/BZnLAwLMWRPGqoFkaDu3H599ak5O1uySIv0FAbVhB3CIPGsy8u', 'grade3b_student8@example.com', 1, '2026-03-28 09:29:25'),
(232, 'grade3b_student8_parent', '$2y$10$5HW/wIKx4CwnsqIaWIcA1OtEVIJYtdVDidHjlnULC3tsYe/BUJ.8G', 'grade3b_student8_parent@example.com', 2, '2026-03-28 09:29:25'),
(233, 'grade3b_student9', '$2y$10$B/DD7SPpnXFJkEbFM/wEgeTV0/lp13.jnkIW3hboEfXBx1qB8GH56', 'grade3b_student9@example.com', 1, '2026-03-28 09:29:25'),
(234, 'grade3b_student9_parent', '$2y$10$uADj0588Z6UWULwUigYa8uXZAhBeQzJN5W5V3uqiXvK89aqJHrksK', 'grade3b_student9_parent@example.com', 2, '2026-03-28 09:29:25'),
(235, 'grade3b_student10', '$2y$10$RhT7J81AhMcYE2MqLWLiX..fdFg8mQZ5sfAMsyulGussXlkGpQoPi', 'grade3b_student10@example.com', 1, '2026-03-28 09:29:25'),
(236, 'grade3b_student10_parent', '$2y$10$6JI7WbKMZymygnlUwSxlXO2co.46YVMRBuhsZ//79J/rxwG6tK7Uy', 'grade3b_student10_parent@example.com', 2, '2026-03-28 09:29:25'),
(237, 'grade3b_student11', '$2y$10$z.V9QW5PYZAjgJzR5PUegemUiowtXVZLexymwHGEfvYyWw/YpemTu', 'grade3b_student11@example.com', 1, '2026-03-28 09:29:25'),
(238, 'grade3b_student11_parent', '$2y$10$yB/PR30bWLAX.GaFAwMcf.W5gi0LV75vUTYeOFj2nn2dPZgE8rw3m', 'grade3b_student11_parent@example.com', 2, '2026-03-28 09:29:25'),
(239, 'grade3b_student12', '$2y$10$.ZSLXOhaOzhZ0ksvJSoWTe0h7LlNmDcsZghUcM52TNr9akpF20vHe', 'grade3b_student12@example.com', 1, '2026-03-28 09:29:25'),
(240, 'grade3b_student12_parent', '$2y$10$/3QnX1m4H7klw2.1OOYiUuUf1Bi150fybdkpKzF2IuDBbiGUKRZDm', 'grade3b_student12_parent@example.com', 2, '2026-03-28 09:29:25'),
(241, 'grade3b_student13', '$2y$10$rE7qPxkQgM9kpD2Cs7N6ne.wjLzTvgTIFoRPwfzc6zpOHokqLbD46', 'grade3b_student13@example.com', 1, '2026-03-28 09:29:25'),
(242, 'grade3b_student13_parent', '$2y$10$J1r841x5HKS/F4iJU3B6eOsesGqHckaXioXs2WHzUZA2JdR5zIK.m', 'grade3b_student13_parent@example.com', 2, '2026-03-28 09:29:25'),
(243, 'grade3b_student14', '$2y$10$fdO3Y6sqeRDVhxAh2TPo0.vZyrhnJMFIcyG6D1hWUBYpVacGo3z8a', 'grade3b_student14@example.com', 1, '2026-03-28 09:29:26'),
(244, 'grade3b_student14_parent', '$2y$10$2SdNxQ4WwznNjd6.x6FCfe/UNRJiN5Mcs31Z5KH0rB20pMavTIJMy', 'grade3b_student14_parent@example.com', 2, '2026-03-28 09:29:26'),
(245, 'grade3b_student15', '$2y$10$vSoXDtH6cwvmyw3erftJiuUOvx3J84onXX95zrtkKPDldhCy9Gf7C', 'grade3b_student15@example.com', 1, '2026-03-28 09:29:26'),
(246, 'grade3b_student15_parent', '$2y$10$brEITr7u.NWRe0lJ7Y7ubuP6JxSkDzwFUQ/D5nf4767FZG644AGTK', 'grade3b_student15_parent@example.com', 2, '2026-03-28 09:29:26'),
(247, 'grade3c_student1', '$2y$10$syjIOkjW4e.DntvgCrikYeZDiO3AHyziX.yWQN0QHziHtyBXr3yIO', 'grade3c_student1@example.com', 1, '2026-03-28 09:29:26'),
(248, 'grade3c_student1_parent', '$2y$10$Hvj19Wo4pt4UFDFdeW4Dr.hd0cVVyusDXlqEdH6iMxMXQQ1A237By', 'grade3c_student1_parent@example.com', 2, '2026-03-28 09:29:26'),
(249, 'grade3c_student2', '$2y$10$D91FccT5ZwtCS7.WW4wq5OmJ7rjmYSknnuHjCvFT99Vp7gLq0601S', 'grade3c_student2@example.com', 1, '2026-03-28 09:29:26'),
(250, 'grade3c_student2_parent', '$2y$10$Nrupih5lUM2WpykdVKX.eORV4LsvRJl4XeqU1H80lnSFD2H7lZ6fq', 'grade3c_student2_parent@example.com', 2, '2026-03-28 09:29:26'),
(251, 'grade3c_student3', '$2y$10$J0fFOWwGO8C7wUWmLZvvlO6j3GXsNZ6R4pEQlf6f6tO1NzHyRyqI6', 'grade3c_student3@example.com', 1, '2026-03-28 09:29:26'),
(252, 'grade3c_student3_parent', '$2y$10$uAQS/slmRJIZcT51cXP1reirNN.J6cKymjMqIiFhqUxr4VwmUuzJK', 'grade3c_student3_parent@example.com', 2, '2026-03-28 09:29:26'),
(253, 'grade3c_student4', '$2y$10$ASWkoaubn1qHt2g4/zhg..MGColK2See7rdsiOrxn5Yale4d1cE5q', 'grade3c_student4@example.com', 1, '2026-03-28 09:29:26'),
(254, 'grade3c_student4_parent', '$2y$10$FZgWb88jzANE8exdsPq7z.OtX7Y66cCKcGX9.g61CeB8q4UYufahS', 'grade3c_student4_parent@example.com', 2, '2026-03-28 09:29:26'),
(255, 'grade3c_student5', '$2y$10$Et8moqj1DviweQXIFXBuoO2ZA0Qr.PSEo1QETON/Ztn8N8G.Oc3Y2', 'grade3c_student5@example.com', 1, '2026-03-28 09:29:26'),
(256, 'grade3c_student5_parent', '$2y$10$3OOJf9GnNrveXkn/328ucOY55g.XwdgQTbwP.Idn1rSqkcBsrbn7G', 'grade3c_student5_parent@example.com', 2, '2026-03-28 09:29:26'),
(257, 'grade3c_student6', '$2y$10$HMVNDpgLsPLTugmbQ7B.xukunFTN9EdYDkCm2QCB6JSdDxYsfpIUe', 'grade3c_student6@example.com', 1, '2026-03-28 09:29:26'),
(258, 'grade3c_student6_parent', '$2y$10$XXGTSgb1WL9ZTOkDsKBuLeuEgPyzmeGvSgFMhmvHpmNV9856kvykK', 'grade3c_student6_parent@example.com', 2, '2026-03-28 09:29:26'),
(259, 'grade3c_student7', '$2y$10$0k/sP7NHkAbBE/4QBfRJIezVKt5/1g.C0.WRZ3T/KkaJvW1d3iZ96', 'grade3c_student7@example.com', 1, '2026-03-28 09:29:27'),
(260, 'grade3c_student7_parent', '$2y$10$T9QfXAJ//O.0gYct8x0hSOv9KPKVmomti0t0zBBtKWllIsRxSiHRe', 'grade3c_student7_parent@example.com', 2, '2026-03-28 09:29:27'),
(261, 'grade3c_student8', '$2y$10$Bozdwu79OVnuvKHyYdyzXeG/q76dXjT0Fv/HmQeGvFOz4uUskFu3u', 'grade3c_student8@example.com', 1, '2026-03-28 09:29:27'),
(262, 'grade3c_student8_parent', '$2y$10$MY/.mKuuOtCh4ksFn.DFBe/bRoudF0JagKT3tGIMxovBfM97IQHOi', 'grade3c_student8_parent@example.com', 2, '2026-03-28 09:29:27'),
(263, 'grade3c_student9', '$2y$10$fe2xuy6kGPgUmRky2qGSButSoWVDlDqKXDJWvyHigRrjxZRahOb4u', 'grade3c_student9@example.com', 1, '2026-03-28 09:29:27'),
(264, 'grade3c_student9_parent', '$2y$10$xirrTuu4a2SE8ThDZiI4Iu7HFeMubCK4GyIrfbNoT7iKk3cpShK1q', 'grade3c_student9_parent@example.com', 2, '2026-03-28 09:29:27'),
(265, 'grade3c_student10', '$2y$10$JGGodP1cq8KsFsXiMLsn2.I3fGwjFJ9BIxgNGn8SXZMlUI/ThSyKW', 'grade3c_student10@example.com', 1, '2026-03-28 09:29:27'),
(266, 'grade3c_student10_parent', '$2y$10$/Xv01P6Wc7OlqznxvZrL.u4jFQEDfhq39dUezZFMX25Ki1hmkvpA.', 'grade3c_student10_parent@example.com', 2, '2026-03-28 09:29:27'),
(267, 'grade3c_student11', '$2y$10$S.zOMoWtDYNQo1XgKCpRv.CuucEKXMlQjzPUnUUg2gSzXWpPrTzHu', 'grade3c_student11@example.com', 1, '2026-03-28 09:29:27'),
(268, 'grade3c_student11_parent', '$2y$10$UzO.UO5dvTz5B5x8hCDEqOG6F/P8YTveGY.ucQcQFwJ1GpK6dtPf6', 'grade3c_student11_parent@example.com', 2, '2026-03-28 09:29:27'),
(269, 'grade3c_student12', '$2y$10$RaEZjvCLxtB1nGM169Uda.kfBywVUf5OUPGalBy.Jk3WLfUj25kKm', 'grade3c_student12@example.com', 1, '2026-03-28 09:29:27'),
(270, 'grade3c_student12_parent', '$2y$10$jjVYIrGIvj04LlmO/cniEuHQGo3bKcCaB6cDW/S2en4a6vnhk/wAK', 'grade3c_student12_parent@example.com', 2, '2026-03-28 09:29:27'),
(271, 'grade3c_student13', '$2y$10$QveSnyb4N9sTx/AiktNCdeO.ngIxWLPa56ZNXRbECDZd2HptGpiOq', 'grade3c_student13@example.com', 1, '2026-03-28 09:29:27'),
(272, 'grade3c_student13_parent', '$2y$10$1sPsqz9GH91qiydbaBXqFuRayKDtx7jkBgK.axNqmjD/JfqKxX3p2', 'grade3c_student13_parent@example.com', 2, '2026-03-28 09:29:27'),
(273, 'grade3c_student14', '$2y$10$zudWHGAtdo7w2MREc8lkY.ewZ.GrIzKgCKDxuYW5Z0nxsueHEXAna', 'grade3c_student14@example.com', 1, '2026-03-28 09:29:27'),
(274, 'grade3c_student14_parent', '$2y$10$aaxs9kzAQdGv9gsRVyTn.eRPwNPgNOk.yw6jp5PfYf2dNDe/ulB0m', 'grade3c_student14_parent@example.com', 2, '2026-03-28 09:29:27'),
(275, 'grade3c_student15', '$2y$10$fkSUtoyJmmluZiVw117TluviKclNywgTz5nEmmiL8OTqvLXoQlb96', 'grade3c_student15@example.com', 1, '2026-03-28 09:29:28'),
(276, 'grade3c_student15_parent', '$2y$10$2V3A8t1owuIvSgQGi6.5ueE549k8fLKimDOfpQiKeGNZC1mulOS1m', 'grade3c_student15_parent@example.com', 2, '2026-03-28 09:29:28'),
(277, 'teacher4', '$2y$10$HWpiFj2zbjnBIAThHR9.8.sFrsMw286RHzXkWCo3fatTMO9JrRiMi', 'teacher4@school.com', 3, '2026-03-28 09:46:17'),
(278, 'teacher5', '$2y$10$7t.qbqK1VcvMEim3AaSt9emX3qGA/44IMdYlhJvJc4DeN62W4G4IC', 'teacher5@school.com', 3, '2026-03-28 09:46:17'),
(279, 'teacher6', '$2y$10$hhlXUZYISGoCCkzmeNGGuOnLBaFqmPynrCsfnTolVN0zUPYd5pVJO', 'teacher6@school.com', 3, '2026-03-28 09:46:18'),
(280, 'teacher7', '$2y$10$HeBcBfFnIPlz4.GN8wvgsOtQVnvn3QvEcYiiVm2CmUe3nl3dzWhO6', 'teacher7@school.com', 3, '2026-03-28 09:46:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Indexes for table `student_parent`
--
ALTER TABLE `student_parent`
  ADD PRIMARY KEY (`student_id`,`parent_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=281;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `student_parent`
--
ALTER TABLE `student_parent`
  ADD CONSTRAINT `student_parent_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_parent_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
