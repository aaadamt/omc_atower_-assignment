-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 08, 2023 at 05:45 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `omc_tower_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `hourly_temperature`
--

CREATE TABLE `hourly_temperature` (
  `id` int(11) NOT NULL,
  `face` enum('W','E','S','N') NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `temperature_value` double NOT NULL,
  `hour` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hourly_temperature`
--

INSERT INTO `hourly_temperature` (`id`, `face`, `date`, `temperature_value`, `hour`) VALUES
(3, 'W', '2023-07-04 23:00:00', 26, 10),
(4, 'E', '2023-07-04 23:00:00', 25, 10),
(5, 'S', '2023-07-04 23:00:00', 25.05, 10),
(6, 'N', '2023-07-04 23:00:00', 25.1, 10),
(7, 'W', '2023-07-04 23:00:00', 26.17, 12),
(8, 'N', '2023-07-04 23:00:00', 26.5, 12),
(9, 'W', '2023-07-04 23:00:00', 27, 14),
(10, 'S', '2023-07-04 23:00:00', 25.5, 14),
(11, 'N', '2023-07-04 23:00:00', 26, 14),
(12, 'W', '2023-07-04 23:00:00', 27, 15),
(13, 'W', '2023-07-05 23:00:00', 30.5, 12),
(14, 'W', '2023-07-06 23:00:00', 30.29, 13),
(15, 'S', '2023-07-06 23:00:00', 28.4, 13),
(16, 'W', '2023-07-06 23:00:00', 32.38, 14);

-- --------------------------------------------------------

--
-- Table structure for table `sensor`
--

CREATE TABLE `sensor` (
  `id` int(11) NOT NULL,
  `face` enum('W','E','S','N') NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `added_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_existing` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensor`
--

INSERT INTO `sensor` (`id`, `face`, `is_active`, `added_on`, `is_existing`) VALUES
(1, 'W', 1, '2023-07-05 09:52:53', 1),
(2, 'W', 1, '2023-07-05 09:53:04', 1),
(3, 'E', 1, '2023-07-05 09:53:09', 0),
(4, 'E', 1, '2023-07-05 09:53:13', 0),
(5, 'S', 1, '2023-07-05 09:53:20', 1),
(6, 'N', 1, '2023-07-05 09:53:24', 0),
(7, 'N', 1, '2023-07-05 09:53:27', 0),
(8, 'S', 1, '2023-07-05 09:53:31', 1),
(9, 'S', 1, '2023-07-05 10:57:45', 1),
(10, 'S', 1, '2023-07-05 11:22:57', 1),
(11, 'W', 1, '2023-07-05 11:23:58', 1),
(12, 'W', 1, '2023-07-05 13:25:41', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sensor_data`
--

CREATE TABLE `sensor_data` (
  `id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `temperature_value` double(10,5) NOT NULL,
  `sensor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensor_data`
--

INSERT INTO `sensor_data` (`id`, `timestamp`, `temperature_value`, `sensor_id`) VALUES
(1, '2023-07-05 09:56:01', 25.00000, 3),
(2, '2023-07-05 09:56:08', 25.00000, 4),
(3, '2023-07-05 09:56:16', 25.10000, 6),
(4, '2023-07-05 09:56:22', 25.10000, 7),
(5, '2023-07-05 09:56:27', 25.10000, 5),
(6, '2023-07-05 09:56:32', 25.00000, 8),
(7, '2023-07-05 09:56:37', 26.00000, 1),
(8, '2023-07-05 09:56:43', 26.00000, 1),
(9, '2023-07-05 11:50:25', 25.50000, 2),
(10, '2023-07-05 11:50:50', 26.50000, 2),
(11, '2023-07-05 11:51:09', 26.50000, 2),
(12, '2023-07-05 11:51:15', 26.50000, 7),
(13, '2023-07-05 13:00:10', 26.50000, 7),
(14, '2023-07-05 13:46:55', 25.50000, 10),
(15, '2023-07-05 13:47:15', 25.50000, 10),
(16, '2023-07-05 13:47:24', 25.50000, 10),
(17, '2023-07-05 13:47:40', 25.50000, 10),
(18, '2023-07-05 13:47:54', 25.50000, 10),
(19, '2023-07-05 13:48:30', 25.50000, 9),
(20, '2023-07-05 13:48:38', 25.50000, 8),
(21, '2023-07-05 13:48:47', 25.50000, 6),
(22, '2023-07-05 13:48:55', 25.50000, 9),
(23, '2023-07-05 13:58:50', 27.00000, 11),
(24, '2023-07-05 13:59:12', 27.00000, 11),
(25, '2023-07-05 14:00:36', 27.00000, 11),
(26, '2023-07-05 14:01:04', 27.00000, 12),
(27, '2023-07-06 11:24:07', 30.00000, 12),
(28, '2023-07-06 11:25:25', 31.00000, 11),
(29, '2023-07-06 14:41:12', 25.50000, 10),
(30, '2023-07-06 14:41:37', 25.50000, 9),
(31, '2023-07-06 14:41:41', 25.50000, 8),
(32, '2023-07-06 14:41:45', 25.90000, 8),
(33, '2023-07-06 14:41:49', 26.00000, 8),
(34, '2023-07-06 14:41:53', 26.00000, 9),
(35, '2023-07-06 14:42:00', 25.10000, 10),
(36, '2023-07-06 14:42:08', 26.10000, 9),
(37, '2023-07-06 14:42:13', 26.30000, 8),
(38, '2023-07-06 14:42:15', 26.00000, 8),
(39, '2023-07-06 14:42:19', 26.00000, 9),
(40, '2023-07-06 14:42:27', 25.10000, 10),
(41, '2023-07-06 14:42:35', 26.20000, 9),
(42, '2023-07-06 14:42:37', 26.30000, 9),
(43, '2023-07-06 14:42:40', 26.30000, 8),
(44, '2023-07-06 14:42:41', 26.30000, 8),
(45, '2023-07-06 14:42:42', 26.30000, 8),
(46, '2023-07-06 14:42:42', 26.30000, 8),
(47, '2023-07-06 14:42:46', 26.30000, 9),
(48, '2023-07-06 14:42:47', 26.30000, 9),
(49, '2023-07-06 14:42:49', 26.50000, 9),
(50, '2023-07-06 14:42:51', 26.50000, 9),
(51, '2023-07-06 14:42:57', 25.50000, 10),
(52, '2023-07-06 14:42:58', 25.50000, 10),
(53, '2023-07-06 16:17:41', 26.50000, 10),
(54, '2023-07-06 16:17:58', 26.50000, 10),
(55, '2023-07-06 16:23:18', 25.50000, 10),
(56, '2023-07-06 16:45:38', 25.50000, 10),
(57, '2023-06-26 00:29:24', 33.50000, 8),
(58, '2023-06-26 00:29:24', 25.50000, 12),
(59, '2023-06-26 00:29:24', 30.50000, 12),
(60, '2023-06-26 00:29:24', 30.50000, 12),
(61, '2023-06-26 00:29:24', 30.50000, 12),
(62, '2023-07-07 12:17:47', 30.00000, 5),
(63, '2023-07-07 12:17:47', 30.00000, 5),
(64, '2023-07-07 12:17:47', 30.00000, 5),
(65, '2023-07-07 12:17:47', 30.10000, 8),
(66, '2023-07-07 12:17:47', 30.10000, 9),
(67, '2023-07-07 12:17:47', 30.10000, 10),
(68, '2023-07-07 12:19:44', 30.10000, 5),
(69, '2023-07-07 12:19:52', 30.20000, 8),
(70, '2023-07-07 12:19:52', 30.20000, 9),
(71, '2023-07-07 12:19:52', 30.20000, 10),
(72, '2023-07-07 12:20:08', 29.50000, 5),
(73, '2023-07-07 12:20:08', 30.50000, 8),
(74, '2023-07-07 12:20:08', 30.40000, 9),
(75, '2023-07-07 12:20:08', 30.60000, 10),
(76, '2023-07-07 12:20:48', 28.00000, 5),
(77, '2023-07-07 12:20:48', 30.40000, 8),
(78, '2023-07-07 12:20:48', 30.40000, 9),
(79, '2023-07-07 12:20:48', 30.40000, 10),
(80, '2023-07-07 12:20:48', 22.00000, 5),
(81, '2023-07-07 12:31:08', 20.00000, 5),
(82, '2023-07-07 12:32:20', 10.00000, 5),
(83, '2023-07-07 12:37:35', 30.00000, 1),
(84, '2023-07-07 12:37:35', 30.00000, 2),
(85, '2023-07-07 12:37:35', 30.00000, 10),
(86, '2023-07-07 12:37:35', 30.00000, 11),
(87, '2023-07-07 12:37:35', 30.00000, 11),
(88, '2023-07-07 12:37:35', 30.00000, 1),
(89, '2023-07-07 12:37:35', 30.00000, 2),
(90, '2023-07-07 12:37:35', 30.00000, 10),
(91, '2023-07-07 12:37:35', 32.00000, 11),
(92, '2023-07-07 13:17:44', 32.00000, 1),
(93, '2023-07-07 13:17:44', 32.00000, 2),
(94, '2023-07-07 13:17:44', 32.00000, 11),
(95, '2023-07-07 13:17:44', 33.50000, 12);

-- --------------------------------------------------------

--
-- Table structure for table `sensor_malfunction`
--

CREATE TABLE `sensor_malfunction` (
  `id` int(11) NOT NULL,
  `sensor_id` int(24) NOT NULL,
  `time_stamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `malfunction` binary(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensor_malfunction`
--

INSERT INTO `sensor_malfunction` (`id`, `sensor_id`, `time_stamp`, `malfunction`) VALUES
(1, 11, '2023-07-05 13:55:20.562147', 0x30),
(2, 12, '2023-07-05 13:55:20.563580', 0x30),
(3, 12, '2023-07-05 14:01:04.983323', 0x31),
(4, 12, '2023-07-07 15:12:25.353178', 0x31),
(5, 5, '2023-07-07 15:12:25.358582', 0x31),
(6, 12, '2023-07-08 15:39:44.721947', 0x31),
(7, 5, '2023-07-08 15:39:44.734836', 0x31),
(8, 12, '2023-07-08 15:41:51.372115', 0x31),
(9, 5, '2023-07-08 15:41:51.373907', 0x31);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hourly_temperature`
--
ALTER TABLE `hourly_temperature`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensor`
--
ALTER TABLE `sensor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sensor_to_id` (`sensor_id`);

--
-- Indexes for table `sensor_malfunction`
--
ALTER TABLE `sensor_malfunction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sensor_mal_to_sensor_id` (`sensor_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hourly_temperature`
--
ALTER TABLE `hourly_temperature`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `sensor`
--
ALTER TABLE `sensor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `sensor_data`
--
ALTER TABLE `sensor_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `sensor_malfunction`
--
ALTER TABLE `sensor_malfunction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD CONSTRAINT `sensor_to_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`id`);

--
-- Constraints for table `sensor_malfunction`
--
ALTER TABLE `sensor_malfunction`
  ADD CONSTRAINT `sensor_mal_to_sensor_id` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
