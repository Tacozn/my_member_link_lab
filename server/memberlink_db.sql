-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jan 14, 2025 at 02:36 PM
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
-- Database: `memberlink_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_description` text DEFAULT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `product_description`, `product_price`, `product_quantity`, `product_image`) VALUES
(1, 'Membership T-Shirt', 'Official club t-shirt', 25.99, 33, 'tshirt.jpg'),
(2, 'Club Mug', 'Ceramic mug with club logo', 12.50, 87, 'mug.jpg'),
(3, 'Tote Bag', 'Durable canvas tote', 19.99, 54, 'totebag.jpg'),
(4, 'Membership Hoodie', 'Official Club Hoodie', 35.99, 50, 'hoodie.jpg'),
(5, 'Club Lanyard', 'Official club lanyard', 5.99, 82, 'lanyard.jpg'),
(6, 'Club Badge', 'Cute badge for decoration', 1.99, 23, 'badge.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_admins`
--

CREATE TABLE `tbl_admins` (
  `admin_id` int(3) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_pass` varchar(40) NOT NULL,
  `admin_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_admins`
--

INSERT INTO `tbl_admins` (`admin_id`, `admin_email`, `admin_pass`, `admin_datereg`) VALUES
(1, 'slumberjer@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2024-10-23 15:44:57.000000'),
(2, 'ahmadhanis@uum.edu.my', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-10-27 15:23:01.602905'),
(3, 'dasdasdasdasdasd', '00ea1da4192a2030f9ae023de3b3143ed647bbab', '2024-10-27 15:53:27.168759'),
(4, 'lab123@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '2024-11-27 04:55:21.773114'),
(5, 'class123@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '2024-12-08 15:25:48.236951'),
(6, 'aa', 'e0c9035898dd52fc65c41454cec9c4d2611bfb37', '2024-12-08 15:49:37.647002'),
(7, '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '2024-12-12 17:22:56.375256');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_memberships`
--

CREATE TABLE `tbl_memberships` (
  `membership_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `benefits` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_memberships`
--

INSERT INTO `tbl_memberships` (`membership_id`, `name`, `description`, `price`, `benefits`, `created_at`) VALUES
(1, 'Basic Membership', 'Perfect for beginners', 29.99, '- Access to basic facilities\n- Standard support\n- Monthly newsletter', '2025-01-14 19:12:35'),
(2, 'Premium Membership', 'For dedicated members', 59.99, '- Access to all facilities\n- 24/7 support\n- Weekly newsletter\n- Personal trainer', '2025-01-14 19:12:35'),
(3, 'VIP Membership', 'Ultimate experience', 99.99, '- All Premium features\n- Priority access\n- Exclusive events\n- Spa services', '2025-01-14 19:12:35');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(3) NOT NULL,
  `news_title` varchar(300) NOT NULL,
  `news_details` varchar(800) NOT NULL,
  `news_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_details`, `news_date`) VALUES
(1, 'Exclusive Member Rewards Unlocked!', 'We’re excited to announce a new rewards program exclusively for our valued members! Enjoy access to special discounts, early event registration, and a personalized dashboard to track your benefits. Log in to explore your new perks!', '2024-10-30 15:46:06.775643'),
(2, 'Exciting Updates in Your Membership!', 'Your membership app just got better! We’ve rolled out a series of updates to enhance your experience, including a redesigned profile page and streamlined access to your account history. Update the app today to check out these improvements!', '2024-10-30 15:46:32.239606'),
(3, 'New Feature Alert: Enhanced Member Dashboard', 'Keeping track of your membership benefits is now easier than ever! With our enhanced dashboard, you can view your points, redeem rewards, and get personalized offers at a glance. Log in now to explore!', '2024-10-30 15:46:51.886697'),
(4, 'Special Offer for Loyal Members!', 'Thank you for being a valued member! As a token of our appreciation, enjoy a special 15% discount on all renewals this month. Make sure to use the code MEMBER15 at checkout. Don’t miss out on this limited-time offer!', '2024-10-30 16:25:45.383816'),
(5, 'Local Businesses Thrive Amidst Economic Uncertainty', 'Despite recent economic fluctuations, local businesses have shown resilience. Many have adapted to changing consumer behaviors by offering online shopping options and innovative services.', '2024-11-27 20:56:06.072560'),
(6, 'Enhanced Search Functionality', 'We\'ve upgraded our search feature to make finding what you need faster and easier. Now, you can search by keywords, categories, or specific criteria, ensuring a seamless user experience.', '2024-11-27 20:56:50.736680'),
(7, 'Secure and Convenient Login Options', 'We\'ve added more secure and convenient login options, including biometric authentication. This ensures the safety of your account and simplifies the login process.', '2024-11-27 20:57:11.565150'),
(14, 'Testing News', 'This is a testing news for recording', '2024-11-27 21:56:47.670940');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payments`
--

CREATE TABLE `tbl_payments` (
  `payment_id` int(11) NOT NULL,
  `membership_name` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `purchase_date` datetime NOT NULL DEFAULT current_timestamp(),
  `payment_status` varchar(50) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `tbl_admins`
--
ALTER TABLE `tbl_admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `admin_email` (`admin_email`);

--
-- Indexes for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  ADD PRIMARY KEY (`membership_id`);

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_payments`
--
ALTER TABLE `tbl_payments`
  ADD PRIMARY KEY (`payment_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_admins`
--
ALTER TABLE `tbl_admins`
  MODIFY `admin_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  MODIFY `membership_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tbl_payments`
--
ALTER TABLE `tbl_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
