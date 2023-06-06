-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 03, 2023 at 05:38 PM
-- Server version: 10.6.12-MariaDB-0ubuntu0.22.04.1
-- PHP Version: 8.1.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `country_club`
--

-- --------------------------------------------------------

--
-- Table structure for table `Facilities`
--

CREATE TABLE `Facilities` (
  `facid` tinyint(4) DEFAULT NULL,
  `name` varchar(15) DEFAULT NULL,
  `membercost` decimal(2,1) DEFAULT NULL,
  `guestcost` decimal(3,1) DEFAULT NULL,
  `initialoutlay` mediumint(9) DEFAULT NULL,
  `monthlymaintenance` smallint(6) DEFAULT NULL,
  `expense_label` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Facilities`
--

INSERT INTO `Facilities` (`facid`, `name`, `membercost`, `guestcost`, `initialoutlay`, `monthlymaintenance`, `expense_label`) VALUES
(0, 'Tennis Court 1', 5.0, 25.0, 10000, 200, 'expensive'),
(1, 'Tennis Court 2', 5.0, 25.0, 8000, 200, 'expensive'),
(2, 'Badminton Court', 0.0, 15.5, 4000, 50, 'cheap'),
(3, 'Table Tennis', 0.0, 5.0, 320, 10, 'cheap'),
(4, 'Massage Room 1', 9.9, 80.0, 4000, 3000, 'expensive'),
(5, 'Massage Room 2', 9.9, 80.0, 4000, 3000, 'expensive'),
(6, 'Squash Court', 3.5, 17.5, 5000, 80, 'cheap'),
(7, 'Snooker Table', 0.0, 5.0, 450, 15, 'cheap'),
(8, 'Pool Table', 0.0, 5.0, 400, 15, 'cheap');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
