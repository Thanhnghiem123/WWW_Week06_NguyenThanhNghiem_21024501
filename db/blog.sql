-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.2.0-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for blog
DROP DATABASE IF EXISTS `blog`;
CREATE DATABASE IF NOT EXISTS `blog` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `blog`;

-- Dumping structure for table blog.post
DROP TABLE IF EXISTS `post`;
CREATE TABLE IF NOT EXISTS `post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `title` varchar(75) NOT NULL,
  `meta_title` varchar(100) DEFAULT NULL,
  `summary` tinytext DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `content` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_post_user` (`author_Id`),
  KEY `idx_post_parent` (`parent_Id`),
  CONSTRAINT `fk_post_parent` FOREIGN KEY (`parent_id`) REFERENCES `post` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_user` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=LATIN1_SWEDISH_CI;

-- Data exporting was unselected.

-- Dumping structure for table blog.post_comment
DROP TABLE IF EXISTS `post_comment`;
CREATE TABLE IF NOT EXISTS `post_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `user_id` BIGINT(20) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `published_at` datetime DEFAULT NULL,
  `content` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_comment_post` (`post_Id`),
  KEY `idx_comment_parent` (`parent_Id`),
  CONSTRAINT `fk_comment_parent` FOREIGN KEY (`parent_Id`) REFERENCES `post_comment` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE NO ACTION  ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

ALTER TABLE post_comment
DROP FOREIGN KEY fk_comment_post;

ALTER TABLE post_comment
ADD CONSTRAINT fk_comment_post
FOREIGN KEY (post_id) REFERENCES post(id)
ON DELETE CASCADE ON UPDATE NO ACTION;


-- Data exporting was unselected.

-- Dumping structure for table blog.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_Name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password_hash` VARCHAR(155) NOT NULL,
  `registered_at` datetime NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `intro` tinytext DEFAULT NULL,
  `profile` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mobile` (`mobile`),
  UNIQUE KEY `uq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;




INSERT INTO `user` (`first_name`, `middle_name`, `last_name`, `mobile`, `email`, `password_hash`, `registered_at`, `last_login`, `intro`, `profile`)
VALUES 
('John', 'Doe', 'Smith', '12345678900', 'john.doe@example.com', 'hashpassword123', '2023-11-20', '2023-11-20', 'Intro about John', 'Profile details about John'),
('Jane', 'Mary', 'Doe', '1234567891', 'jane.doe@example.com', 'hashpassword124', '2023-11-20', '2023-11-20', 'Intro about Jane', 'Profile details about Jane'),
('Alice', 'Lynn', 'Johnson', '1234567892', 'alice.johnson@example.com', 'hashpassword125', '2023-11-20', '2023-11-20', 'Intro about Alice', 'Profile details about Alice'),
('Bob', 'Ray', 'Williams', '1234567893', 'bob.williams@example.com', 'hashpassword126', '2023-11-20', '2023-11-20', 'Intro about Bob', 'Profile details about Bob'),
('Charlie', 'Evan', 'Brown', '1234567894', 'charlie.brown@example.com', 'hashpassword127', '2023-11-20', '2023-11-20', 'Intro about Charlie', 'Profile details about Charlie'),
('David', 'Lee', 'Davis', '1234567895', 'david.davis@example.com', 'hashpassword128', '2023-11-20', '2023-11-20', 'Intro about David', 'Profile details about David'),
('Emma', 'Grace', 'Miller', '1234567896', 'emma.miller@example.com', 'hashpassword129', '2023-11-20', '2023-11-20', 'Intro about Emma', 'Profile details about Emma'),
('Frank', 'Terry', 'Wilson', '1234567897', 'frank.wilson@example.com', 'hashpassword130', '2023-11-20', '2023-11-20', 'Intro about Frank', 'Profile details about Frank'),
('Gina', 'Marie', 'Moore', '1234567898', 'gina.moore@example.com', 'hashpassword131', '2023-11-20', '2023-11-20', 'Intro about Gina', 'Profile details about Gina'),
('Henry', 'Karl', 'Taylor', '1234567899', 'henry.taylor@example.com', 'hashpassword132', '2023-11-20', '2023-11-20', 'Intro about Henry', 'Profile details about Henry');


INSERT INTO `post` (`author_id`, `parent_id`, `title`, `meta_title`, `summary`, `published`, `created_at`, `updated_at`, `published_at`, `content`)
VALUES
(1, NULL, 'Post Title 11', 'Post Meta Title 11', 'Summary of post 11', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 11'),
(2, NULL, 'Post Title 12', 'Post Meta Title 12', 'Summary of post 12', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 12'),
(3, NULL, 'Post Title 13', 'Post Meta Title 13', 'Summary of post 13', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 13'),
(4, NULL, 'Post Title 14', 'Post Meta Title 14', 'Summary of post 14', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 14'),
(5, NULL, 'Post Title 15', 'Post Meta Title 15', 'Summary of post 15', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 15'),
(6, NULL, 'Post Title 16', 'Post Meta Title 16', 'Summary of post 16', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 16'),
(7, NULL, 'Post Title 17', 'Post Meta Title 17', 'Summary of post 17', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 17'),
(8, NULL, 'Post Title 18', 'Post Meta Title 18', 'Summary of post 18', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 18'),
(9, NULL, 'Post Title 19', 'Post Meta Title 19', 'Summary of post 19', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 19'),
(10, NULL, 'Post Title 20', 'Post Meta Title 20', 'Summary of post 20', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 20'),
(1, NULL, 'Post Title 21', 'Post Meta Title 21', 'Summary of post 21', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 21'),
(2, NULL, 'Post Title 22', 'Post Meta Title 22', 'Summary of post 22', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 22'),
(3, NULL, 'Post Title 23', 'Post Meta Title 23', 'Summary of post 23', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 23'),
(4, NULL, 'Post Title 24', 'Post Meta Title 24', 'Summary of post 24', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 24'),
(5, NULL, 'Post Title 25', 'Post Meta Title 25', 'Summary of post 25', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 25'),
(6, NULL, 'Post Title 26', 'Post Meta Title 26', 'Summary of post 26', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 26'),
(7, NULL, 'Post Title 27', 'Post Meta Title 27', 'Summary of post 27', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 27'),
(8, NULL, 'Post Title 28', 'Post Meta Title 28', 'Summary of post 28', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 28'),
(9, NULL, 'Post Title 29', 'Post Meta Title 29', 'Summary of post 29', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 29'),
(10, NULL, 'Post Title 30', 'Post Meta Title 30', 'Summary of post 30', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 30'),
(1, NULL, 'Post Title 31', 'Post Meta Title 31', 'Summary of post 31', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 31'),
(2, NULL, 'Post Title 32', 'Post Meta Title 32', 'Summary of post 32', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 32'),
(3, NULL, 'Post Title 33', 'Post Meta Title 33', 'Summary of post 33', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 33'),
(4, NULL, 'Post Title 34', 'Post Meta Title 34', 'Summary of post 34', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 34'),
(5, NULL, 'Post Title 35', 'Post Meta Title 35', 'Summary of post 35', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 35'),
(6, NULL, 'Post Title 36', 'Post Meta Title 36', 'Summary of post 36', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 36'),
(7, NULL, 'Post Title 37', 'Post Meta Title 37', 'Summary of post 37', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 37'),
(8, NULL, 'Post Title 38', 'Post Meta Title 38', 'Summary of post 38', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 38'),
(9, NULL, 'Post Title 39', 'Post Meta Title 39', 'Summary of post 39', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 39'),
(10, NULL, 'Post Title 40', 'Post Meta Title 40', 'Summary of post 40', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 40'),
(1, NULL, 'Post Title 41', 'Post Meta Title 41', 'Summary of post 41', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 41'),
(2, NULL, 'Post Title 42', 'Post Meta Title 42', 'Summary of post 42', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 42'),
(3, NULL, 'Post Title 43', 'Post Meta Title 43', 'Summary of post 43', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 43'),
(4, NULL, 'Post Title 44', 'Post Meta Title 44', 'Summary of post 44', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 44'),
(5, NULL, 'Post Title 45', 'Post Meta Title 45', 'Summary of post 45', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 45'),
(6, NULL, 'Post Title 46', 'Post Meta Title 46', 'Summary of post 46', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 46'),
(7, NULL, 'Post Title 47', 'Post Meta Title 47', 'Summary of post 47', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 47'),
(8, NULL, 'Post Title 48', 'Post Meta Title 48', 'Summary of post 48', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 48'),
(9, NULL, 'Post Title 49', 'Post Meta Title 49', 'Summary of post 49', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 49'),
(10, NULL, 'Post Title 50', 'Post Meta Title 50', 'Summary of post 50', 1, '2023-11-20', '2023-11-20', '2023-11-20', 'Content of post 50');



INSERT INTO `post_comment` (`post_id`, `parent_id`, `user_id`, `title`, `published`, `created_at`, `published_at`, `content`)
VALUES
(1, NULL, 1, 'Comment Title 11', 1, '2023-11-20', '2023-11-20', 'Content of comment 11'),
(2, NULL, 2, 'Comment Title 12', 1, '2023-11-20', '2023-11-20', 'Content of comment 12'),
(3, NULL, 3, 'Comment Title 13', 1, '2023-11-20', '2023-11-20', 'Content of comment 13'),
(4, NULL, 4, 'Comment Title 14', 1, '2023-11-20', '2023-11-20', 'Content of comment 14'),
(5, NULL, 5, 'Comment Title 15', 1, '2023-11-20', '2023-11-20', 'Content of comment 15'),
(6, NULL, 6, 'Comment Title 16', 1, '2023-11-20', '2023-11-20', 'Content of comment 16'),
(7, NULL, 7, 'Comment Title 17', 1, '2023-11-20', '2023-11-20', 'Content of comment 17'),
(8, NULL, 8, 'Comment Title 18', 1, '2023-11-20', '2023-11-20', 'Content of comment 18'),
(9, NULL, 9, 'Comment Title 19', 1, '2023-11-20', '2023-11-20', 'Content of comment 19'),
(10, NULL, 10, 'Comment Title 20', 1, '2023-11-20', '2023-11-20', 'Content of comment 20'),
(1, NULL, 1, 'Comment Title 21', 1, '2023-11-20', '2023-11-20', 'Content of comment 21'),
(2, NULL, 2, 'Comment Title 22', 1, '2023-11-20', '2023-11-20', 'Content of comment 22'),
(3, NULL, 3, 'Comment Title 23', 1, '2023-11-20', '2023-11-20', 'Content of comment 23'),
(4, NULL, 4, 'Comment Title 24', 1, '2023-11-20', '2023-11-20', 'Content of comment 24'),
(5, NULL, 5, 'Comment Title 25', 1, '2023-11-20', '2023-11-20', 'Content of comment 25'),
(6, NULL, 6, 'Comment Title 26', 1, '2023-11-20', '2023-11-20', 'Content of comment 26'),
(7, NULL, 7, 'Comment Title 27', 1, '2023-11-20', '2023-11-20', 'Content of comment 27'),
(8, NULL, 8, 'Comment Title 28', 1, '2023-11-20', '2023-11-20', 'Content of comment 28'),
(9, NULL, 9, 'Comment Title 29', 1, '2023-11-20', '2023-11-20', 'Content of comment 29'),
(10, NULL, 10, 'Comment Title 30', 1, '2023-11-20', '2023-11-20', 'Content of comment 30'),
(1, NULL, 1, 'Comment Title 31', 1, '2023-11-20', '2023-11-20', 'Content of comment 31'),
(2, NULL, 2, 'Comment Title 32', 1, '2023-11-20', '2023-11-20', 'Content of comment 32'),
(3, NULL, 3, 'Comment Title 33', 1, '2023-11-20', '2023-11-20', 'Content of comment 33'),
(4, NULL, 4, 'Comment Title 34', 1, '2023-11-20', '2023-11-20', 'Content of comment 34'),
(5, NULL, 5, 'Comment Title 35', 1, '2023-11-20', '2023-11-20', 'Content of comment 35'),
(6, NULL, 6, 'Comment Title 36', 1, '2023-11-20', '2023-11-20', 'Content of comment 36'),
(7, NULL, 7, 'Comment Title 37', 1, '2023-11-20', '2023-11-20', 'Content of comment 37'),
(8, NULL, 8, 'Comment Title 38', 1, '2023-11-20', '2023-11-20', 'Content of comment 38'),
(9, NULL, 9, 'Comment Title 39', 1, '2023-11-20', '2023-11-20', 'Content of comment 39'),
(10, NULL, 10, 'Comment Title 40', 1, '2023-11-20', '2023-11-20', 'Content of comment 40'),
(1, NULL, 1, 'Comment Title 41', 1, '2023-11-20', '2023-11-20', 'Content of comment 41'),
(2, NULL, 2, 'Comment Title 42', 1, '2023-11-20', '2023-11-20', 'Content of comment 42'),
(3, NULL, 3, 'Comment Title 43', 1, '2023-11-20', '2023-11-20', 'Content of comment 43'),
(4, NULL, 4, 'Comment Title 44', 1, '2023-11-20', '2023-11-20', 'Content of comment 44'),
(5, NULL, 5, 'Comment Title 45', 1, '2023-11-20', '2023-11-20', 'Content of comment 45'),
(6, NULL, 6, 'Comment Title 46', 1, '2023-11-20', '2023-11-20', 'Content of comment 46'),
(7, NULL, 7, 'Comment Title 47', 1, '2023-11-20', '2023-11-20', 'Content of comment 47'),
(8, NULL, 8, 'Comment Title 48', 1, '2023-11-20', '2023-11-20', 'Content of comment 48'),
(9, NULL, 9, 'Comment Title 49', 1, '2023-11-20', '2023-11-20', 'Content of comment 49'),
(10, NULL, 10, 'Comment Title 50', 1, '2023-11-20', '2023-11-20', 'Content of comment 50');










