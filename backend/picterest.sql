-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 28, 2023 at 10:04 AM
-- Server version: 5.7.24
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP DATABASE IF EXISTS picterest;

CREATE DATABASE picterest;
USE picterest;

--
-- Database: `picterest`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteFollow` (IN `p_username_following` VARCHAR(20), IN `p_username_follower` VARCHAR(20))   BEGIN
    DELETE FROM follow WHERE usernameFollowing = p_username_following AND usernameFollower = p_username_follower;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertComment` (IN `p_username` VARCHAR(255), IN `p_pin_id` INT, IN `p_text` VARCHAR(255))   BEGIN
    INSERT INTO comment (username, pinID, text) VALUES (p_username, p_pin_id, p_text);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertFollow` (IN `p_username_following` VARCHAR(20), IN `p_username_follower` VARCHAR(20))   BEGIN
    INSERT INTO follow (usernameFollowing, usernameFollower, date_followed) VALUES (p_username_following, p_username_follower, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPin` (IN `p_pin_title` VARCHAR(255), IN `p_pin_description` VARCHAR(255), IN `p_pin_url` VARCHAR(255), IN `p_pin_image_path` VARCHAR(255), IN `p_pin_username` VARCHAR(255), OUT `p_pin_id` INT)   BEGIN
    -- Insert into pin table
    INSERT INTO pin (pin_title, pin_description, pin_url, pin_image_path, username) VALUES (p_pin_title, p_pin_description, p_pin_url, p_pin_image_path, p_pin_username);

    -- Retrieve the pin_id
    SELECT LAST_INSERT_ID() INTO p_pin_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTagAndSave` (IN `p_pin_id` INT, IN `p_tag_name` VARCHAR(255))   BEGIN
    DECLARE v_tag_id INT;

    -- Check if the tag already exists
    SELECT tagID INTO v_tag_id FROM tag WHERE tag_name = p_tag_name LIMIT 1;

    -- If tag doesn't exist, insert into tag table
    IF v_tag_id IS NULL THEN

        -- Step 1: Insert into tag table
        INSERT INTO tag (tag_name) VALUES (p_tag_name);
        SET v_tag_id = LAST_INSERT_ID();
    
    END IF;

    -- Step 2: Insert into save table
    INSERT INTO has (tagID, pinID) VALUES (v_tag_id, p_pin_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadCommentsByPinID` (IN `p_pin_id` INT)   BEGIN
    SELECT commentID, concat(ifnull(u.first_name, ''), ' ', ifnull(u.last_name, '')) as fullname, u.profile_image_path,text, date_commented
    FROM comment c
    INNER JOIN user u
    ON u.username = c.username
    WHERE pinID = p_pin_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadFollowerCount` (IN `p_username` VARCHAR(20))   BEGIN
    SELECT COUNT(*) AS followerCount FROM follow WHERE usernameFollowing = p_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadFollowingCount` (IN `p_username` VARCHAR(20))   BEGIN
    SELECT COUNT(*) AS followingCount FROM follow WHERE usernameFollower = p_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadPin` (IN `p_pin_id` INT)   BEGIN
    SELECT concat(ifnull(u.first_name, ''), ' ', ifnull(u.last_name, '')) as fullname, u.username, u.profile_image_path, p.pin_title, p.pin_description, p.pin_url, p.pin_image_path 
    FROM pin p
    INNER JOIN user u
    ON p.username = u.username and p.pinID = p_pin_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadTags` (IN `p_pin_id` INT)   BEGIN
    SELECT t.tagID, t.tag_name
    FROM pin p
    INNER JOIN has h
    ON p.pinID = h.pinID and h.pinID = p_pin_id
    INNER JOIN tag t
    ON h.tagID = t.tagID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchPins` (IN `query` VARCHAR(255), IN `username` VARCHAR(50))   BEGIN
SELECT DISTINCT p.pinID, p.pin_image_path, p.pin_url
    FROM pin p
    LEFT JOIN save s
    ON s.pinID = p.pinID
    LEFT JOIN has h
    ON p.pinID = h.pinID
    LEFT JOIN tag t
    ON h.tagID = t.tagID 
    WHERE p.username != username 
    and p.pinID NOT IN (
        SELECT pinID 
        FROM save
        WHERE save.username = username
    ) 
    and (p.pin_title like concat('%', query, '%') or t.tag_name like concat('%', query, '%'));
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `board`
--

CREATE TABLE `board` (
  `boardID` int(11) NOT NULL,
  `board_name` varchar(50) NOT NULL,
  `board_description` varchar(500) DEFAULT NULL,
  `date_boardCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `board`
--

INSERT INTO `board` (`boardID`, `board_name`, `board_description`, `date_boardCreated`, `username`) VALUES
(14, 'my bro', 'your brother is here', '2023-11-27 23:32:09', 'brother'),
(15, 'my bro meme', 'memes i love', '2023-11-28 15:26:13', 'brother'),
(16, 'my board', 'board no. 1', '2023-11-28 15:33:20', 'test'),
(17, 'messi 1', '', '2023-11-28 15:40:52', 'messi'),
(18, 'asia', NULL, '2023-11-28 15:58:58', 'geographer'),
(19, 'europe', NULL, '2023-11-28 15:59:11', 'geographer'),
(20, 'north america', NULL, '2023-11-28 15:59:20', 'geographer'),
(21, 'south america', NULL, '2023-11-28 15:59:24', 'geographer'),
(22, '<3', NULL, '2023-11-28 16:27:56', 'mangaboy'),
(23, 'alone', NULL, '2023-11-28 16:44:14', 'girl1'),
(24, 'ART', NULL, '2023-11-28 16:47:50', 'artbae');

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `commentID` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `pinID` int(11) NOT NULL,
  `text` varchar(100) NOT NULL,
  `date_commented` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`commentID`, `username`, `pinID`, `text`, `date_commented`) VALUES
(5, 'brother', 46, 'hey what\'s your name?', '2023-11-27 23:37:53'),
(6, 'geographer', 68, 'hi, do you want to go there?', '2023-11-28 16:08:17'),
(7, 'brother', 94, 'i love it', '2023-11-28 16:54:31'),
(8, 'brother', 95, 'big HUG!', '2023-11-28 16:54:41'),
(9, 'brother', 57, 'i love you goat', '2023-11-28 16:54:50'),
(10, 'brother', 77, 'cool!', '2023-11-28 16:55:06'),
(11, 'brother', 100, 'love love', '2023-11-28 16:57:23'),
(12, 'mangaboy', 57, 'wowww', '2023-11-28 16:58:03'),
(13, 'mangaboy', 47, 'what is it?', '2023-11-28 16:58:16'),
(14, 'girl1', 50, 'Christmas!', '2023-11-28 16:59:04'),
(15, 'girl1', 68, 'no', '2023-11-28 16:59:22'),
(16, 'geographer', 60, 'santa boy', '2023-11-28 17:00:02'),
(17, 'geographer', 46, 'see my profile', '2023-11-28 17:00:48'),
(18, 'artbae', 59, 'love you goat', '2023-11-28 17:01:22'),
(19, 'artbae', 50, 'LOL', '2023-11-28 17:01:36'),
(20, 'girl1', 81, 'perfect pic', '2023-11-28 17:03:52');

-- --------------------------------------------------------

--
-- Table structure for table `follow`
--

CREATE TABLE `follow` (
  `usernameFollowing` varchar(20) NOT NULL,
  `usernameFollower` varchar(20) NOT NULL,
  `date_followed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `follow`
--

INSERT INTO `follow` (`usernameFollowing`, `usernameFollower`, `date_followed`) VALUES
('artbae', 'brother', '2023-11-28 16:57:18'),
('brother', 'girl1', '2023-11-28 16:59:09'),
('brother', 'test', '2023-11-28 14:15:22'),
('geographer', 'artbae', '2023-11-28 17:01:47'),
('geographer', 'brother', '2023-11-28 16:56:56'),
('geographer', 'mangaboy', '2023-11-28 16:58:44'),
('girl1', 'brother', '2023-11-28 16:54:26'),
('girl1', 'geographer', '2023-11-28 17:00:34'),
('girl1', 'mangaboy', '2023-11-28 16:58:37'),
('mangaboy', 'artbae', '2023-11-28 17:01:51'),
('mangaboy', 'brother', '2023-11-28 16:54:19'),
('mangaboy', 'geographer', '2023-11-28 17:00:27'),
('mangaboy', 'girl1', '2023-11-28 16:59:16'),
('messi', 'artbae', '2023-11-28 17:01:15'),
('messi', 'brother', '2023-11-28 16:56:58'),
('messi', 'geographer', '2023-11-28 16:59:55'),
('messi', 'girl1', '2023-11-28 16:59:34'),
('messi', 'mangaboy', '2023-11-28 16:57:59');

-- --------------------------------------------------------

--
-- Table structure for table `has`
--

CREATE TABLE `has` (
  `pinID` int(11) NOT NULL,
  `tagID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `has`
--

INSERT INTO `has` (`pinID`, `tagID`) VALUES
(46, 24),
(54, 24),
(55, 24),
(46, 25),
(46, 26),
(55, 26),
(46, 27),
(55, 27),
(62, 27),
(46, 28),
(55, 28),
(62, 28),
(46, 29),
(48, 30),
(48, 31),
(49, 32),
(51, 32),
(49, 33),
(50, 34),
(60, 34),
(51, 35),
(52, 36),
(52, 37),
(53, 38),
(54, 39),
(54, 40),
(56, 41),
(57, 41),
(60, 41),
(61, 41),
(63, 41),
(64, 41),
(65, 41),
(66, 41),
(56, 42),
(57, 43),
(58, 44),
(61, 45),
(62, 46),
(62, 47),
(64, 48),
(65, 49),
(68, 50),
(68, 51),
(68, 52),
(70, 52),
(74, 52),
(70, 53),
(72, 54),
(74, 55),
(75, 56),
(76, 57),
(77, 58),
(77, 59),
(77, 60),
(79, 61),
(81, 62),
(88, 63),
(88, 64),
(88, 65),
(90, 66),
(94, 67),
(95, 68),
(97, 69);

-- --------------------------------------------------------

--
-- Table structure for table `is_in`
--

CREATE TABLE `is_in` (
  `pinID` int(11) NOT NULL,
  `boardID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `is_in`
--

INSERT INTO `is_in` (`pinID`, `boardID`) VALUES
(46, 14),
(47, 14),
(52, 14),
(54, 14),
(55, 14),
(57, 14),
(48, 15),
(49, 15),
(50, 15),
(51, 15),
(57, 17),
(58, 17),
(63, 17),
(64, 17),
(66, 17),
(68, 18),
(69, 18),
(70, 18),
(71, 19),
(72, 19),
(73, 19),
(74, 20),
(75, 20),
(76, 20),
(77, 21),
(78, 21),
(79, 21),
(81, 22),
(82, 22),
(85, 22),
(88, 22),
(81, 23),
(92, 23),
(95, 23),
(97, 24),
(98, 24),
(99, 24),
(100, 24),
(101, 24);

-- --------------------------------------------------------

--
-- Table structure for table `pin`
--

CREATE TABLE `pin` (
  `pinID` int(11) NOT NULL,
  `pin_title` varchar(100) DEFAULT NULL,
  `pin_description` varchar(1000) DEFAULT NULL,
  `pin_url` varchar(500) DEFAULT NULL,
  `pin_image_path` varchar(255) NOT NULL,
  `date_pinned` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pin`
--

INSERT INTO `pin` (`pinID`, `pin_title`, `pin_description`, `pin_url`, `pin_image_path`, `date_pinned`, `username`) VALUES
(46, 'Brother, I love you', 'my first bro', 'https://youtu.be/dQw4w9WgXcQ?si=-RlDXHnkGRnmdUke', '/backend/images/pin_images/my bro.jpg', '2023-11-27 23:36:02', 'brother'),
(47, '1', NULL, NULL, '/backend/images/pin_images/pluto.jpg', '2023-11-28 14:14:34', 'brother'),
(48, 'TikTok stuff', NULL, NULL, '/backend/images/pin_images/61af6048a3e4f9c5b8d3539dff854f79.jpg', '2023-11-28 15:26:56', 'brother'),
(49, 'I love u bro', NULL, NULL, '/backend/images/pin_images/3c3f19baf2a3963ad9b71dc2711bdb1a.jpg', '2023-11-28 15:27:29', 'brother'),
(50, 'Christmas won\'t be coming', 'stop it.', NULL, '/backend/images/pin_images/87c438.jpg', '2023-11-28 15:28:09', 'brother'),
(51, 'Shake just selfie', NULL, NULL, '/backend/images/pin_images/19e361e142c3fc32dac8952372ff3322.jpg', '2023-11-28 15:28:54', 'brother'),
(52, 'Love boo my bro', 'fit and firm', NULL, '/backend/images/pin_images/2dd56fa4083ea2678972c403b26667d3.jpg', '2023-11-28 15:29:30', 'brother'),
(53, 'non sense', NULL, NULL, '/backend/images/pin_images/8552e527684cddc32670acc359ee049a.jpg', '2023-11-28 15:30:17', 'brother'),
(54, 'horse bro', NULL, NULL, '/backend/images/pin_images/3a8cea397a6dea64ec09ccab4823bb6c.jpg', '2023-11-28 15:30:48', 'brother'),
(55, 'nice pos bro', NULL, NULL, '/backend/images/pin_images/71a98efed64240e15e0918255a648606.jpg', '2023-11-28 15:31:55', 'brother'),
(56, 'hehe', 'my meme', NULL, '/backend/images/pin_images/a6978cc3b942a23d14acccb6a01bcb79.jpg', '2023-11-28 15:40:35', 'messi'),
(57, 'yeah', NULL, NULL, '/backend/images/pin_images/12980f9b45cf3660e848ca2b70f29621.jpg', '2023-11-28 15:41:38', 'messi'),
(58, 'NO 1', 'just for fun', 'https://www.youtube.com/watch?v=zhEWqfP6V_w', '/backend/images/pin_images/ae879770271177c32ea326a6183ffc0c.jpg', '2023-11-28 15:42:52', 'messi'),
(59, 'little messi', NULL, NULL, '/backend/images/pin_images/f569459c4a65d56157394cfc5f0f3846.jpg', '2023-11-28 15:43:07', 'messi'),
(60, 'Santa Messi', NULL, NULL, '/backend/images/pin_images/4b3642daeb1827ccf1faaf59ff916d60.jpg', '2023-11-28 15:43:34', 'messi'),
(61, 'Do you know GOAT?', NULL, 'https://www.youtube.com/watch?v=sphHO8-dGnk', '/backend/images/pin_images/165c49d4333ae9be01f3c06597cc8317.jpg', '2023-11-28 15:44:33', 'messi'),
(62, 'My girl :>', NULL, NULL, '/backend/images/pin_images/9505c8c55efc6e2ec41e1c3bda8d7273.jpg', '2023-11-28 15:45:15', 'messi'),
(63, 'cool', NULL, NULL, '/backend/images/pin_images/a31475b59500e3d34356baf2afa129cc.jpg', '2023-11-28 15:45:30', 'messi'),
(64, '8th : ()', NULL, NULL, '/backend/images/pin_images/f1c14cf4cda0efcbce784e49df6da857.jpg', '2023-11-28 15:46:15', 'messi'),
(65, 'cr7 !!!', NULL, NULL, '/backend/images/pin_images/bb3b1fcd60c23a55cbeb549ee20883a1.jpg', '2023-11-28 15:47:10', 'messi'),
(66, 'three', NULL, NULL, '/backend/images/pin_images/b5a56a30680023d17c91d43f1c642373.jpg', '2023-11-28 15:51:19', 'messi'),
(67, NULL, NULL, NULL, '/backend/images/pin_images/8c207094406ef3e932de4dfb01f8fb3d.jpg', '2023-11-28 15:51:29', 'messi'),
(68, 'Cormorant Fishermen in Guilin, China', 'China Travel Destinations', 'http://annemckinnell.com/2017/06/25/cormorant-fishermen-guilin-china/', '/backend/images/pin_images/2d2f62f4a02c78085331e91e301ed1a2.jpg', '2023-11-28 16:01:37', 'geographer'),
(69, NULL, NULL, NULL, '/backend/images/pin_images/c9f5a3c58c5a31b2b825907b7333888f.jpg', '2023-11-28 16:12:51', 'geographer'),
(70, 'A guide to romantic Japan: where to eat, stay, love', 'Manga comics, blazing neon, speeding trains, supersized pedestrian crossings – Japan might not immediately inspire a vision of traditional romance, but don’t…', 'https://www.lonelyplanet.com/articles/a-guide-to-romantic-japan-where-to-eat-stay-love', '/backend/images/pin_images/deeb14358042b9f77581e923740c1b4c.jpg', '2023-11-28 16:13:42', 'geographer'),
(71, 'Barcelona Has Many Amazing Views But I Suggest This One From The Rooftop Bar Across From The Cathedr', 'Spain is the fourth-largest country in Europe. It has everything from stone castles and sophisticated cities to flat plains, and snowcapped mountains, all of which have made it a favored travel destination.', 'https://www.boredpanda.com/interesting-things-spain/?media_id=4312788', '/backend/images/pin_images/a28f1a7faa37b262efae5b4f1a619663.jpg', '2023-11-28 16:16:09', 'geographer'),
(72, '30 Interesting Facts About London', 'London is one of those cities that is constantly changing with new and exciting things sprouting up almost every day!', 'https://handluggageonly.co.uk/2016/06/20/30-travel-tips-need-know-visiting-london/', '/backend/images/pin_images/cc7de17a60590666bdda600a2c8a448d.jpg', '2023-11-28 16:16:41', 'geographer'),
(73, 'Switzerland', NULL, NULL, '/backend/images/pin_images/20c288c92fe8b841db2c0093ae890767.jpg', '2023-11-28 16:18:53', 'geographer'),
(74, 'Vancouver', 'Best things to do in Vancouver, Canada', 'https://www.cntraveller.com/gallery/vancouver-canada-best-things-to-do', '/backend/images/pin_images/0c29fb4da51353b3f1feee56520bb374.jpg', '2023-11-28 16:20:41', 'geographer'),
(75, 'Arizona', 'Whenever I travel anywhere, I always try to find the best views of the city/landscape.', 'https://www.lilyslensonlife.com/post/hiking-camelback-mountain-arizona', '/backend/images/pin_images/26e2f7a74452e68b09ec37b52934286b.jpg', '2023-11-28 16:21:27', 'geographer'),
(76, 'Vancouver life', 'Vancouver holiday with Canadian', 'http://www.canadianaffair.com/british-columbia/vancouver/', '/backend/images/pin_images/8ed5a83f48d896f00f9a3de516717c23.jpg', '2023-11-28 16:22:06', 'geographer'),
(77, 'Machu Picchu', 'Machu Picchu by suedeonfilm', 'https://www.reddit.com/r/itookapicture/comments/acyn8c/itap_of_machu_picchu/?utm_source=ifttt', '/backend/images/pin_images/54742c95ea172829ae0b39688243e7c3.jpg', '2023-11-28 16:24:12', 'geographer'),
(78, 'De mooiste plaatsen in Guatemala', NULL, 'https://www.naturescanner.nl/midden-amerika/guatemala', '/backend/images/pin_images/1fd6c823a7ae856e2f38a9abfc1124a0.jpg', '2023-11-28 16:24:57', 'geographer'),
(79, NULL, NULL, NULL, '/backend/images/pin_images/2499cae20d5e97444d0b1bb05b347efb.jpg', '2023-11-28 16:25:11', 'geographer'),
(80, NULL, 'These stories aren\'t creepy. They\'re traumatizing.', NULL, '/backend/images/pin_images/33f14f3cc7af847c9d5d703b6c33fe24.jpg', '2023-11-28 16:29:18', 'mangaboy'),
(81, 'omao', '“これを見た人は俯瞰絵を貼る見た人もやる これからもどんどん生産していくよ”', 'https://twitter.com/omao51061954/status/1273514483529351168/photo/4', '/backend/images/pin_images/1b69a8a2712ccb7d2de6e57800a40e67.jpg', '2023-11-28 16:30:11', 'mangaboy'),
(82, 'Johan Liebert', NULL, NULL, '/backend/images/pin_images/3f07c298e1c39fd37827940fc255a0fc.jpg', '2023-11-28 16:31:46', 'mangaboy'),
(83, 'Scene 1', 'Shohei Manabe 真鍋昌平', NULL, '/backend/images/pin_images/3330a61f7408ac174d108d9696e4b321.jpg', '2023-11-28 16:32:14', 'mangaboy'),
(84, NULL, NULL, NULL, '/backend/images/pin_images/bd15d8a09a48e9e33d84163e7e015ce7.jpg', '2023-11-28 16:32:38', 'mangaboy'),
(85, 'Kiyohiko Azuma', NULL, NULL, '/backend/images/pin_images/bd5b1c85750b154283ddb60048f56ca3.jpg', '2023-11-28 16:33:45', 'mangaboy'),
(86, 'A Very Normal Person', 'Yoshihiro Tatsumi’s Tokyo noir.', 'http://www.theparisreview.org/blog/2015/03/11/a-very-normal-person/', '/backend/images/pin_images/4268c1afe10c6a5b9ebceb1929f0e87f.jpg', '2023-11-28 16:34:30', 'mangaboy'),
(87, 'Scene 2', NULL, NULL, '/backend/images/pin_images/009db7660adf6d55ec90ac0ea786070c.jpg', '2023-11-28 16:36:44', 'mangaboy'),
(88, '☆ fubuki ☆', NULL, NULL, '/backend/images/pin_images/2c341424bac973216a3143713fa20232.jpg', '2023-11-28 16:37:30', 'mangaboy'),
(89, 'Berserk', 'Berserk Chapter 179', NULL, '/backend/images/pin_images/670f8c239956ca77910ca1feb2470832.jpg', '2023-11-28 16:38:19', 'mangaboy'),
(90, 'Vintage', 'exactly what vintage does', NULL, '/backend/images/pin_images/7a16c397d545fe218d7272ff68e3b793.jpg', '2023-11-28 16:42:26', 'girl1'),
(91, NULL, NULL, 'https://i.redd.it/hxj2oftuwvn11.jpg', '/backend/images/pin_images/ce638990f9771cb735de8654c4f51ad9.jpg', '2023-11-28 16:44:06', 'girl1'),
(92, 'japan', NULL, NULL, '/backend/images/pin_images/c2b9ca7608666e14afccfda82c927b6d.jpg', '2023-11-28 16:44:25', 'girl1'),
(93, NULL, NULL, NULL, '/backend/images/pin_images/2ce0d4971b85818712d38974d7d47801.jpg', '2023-11-28 16:44:32', 'girl1'),
(94, 'marble 1', NULL, NULL, '/backend/images/pin_images/d7fb3386f1748d69f82d4257225d78a3.jpg', '2023-11-28 16:45:00', 'girl1'),
(95, 'enjoying art alone', NULL, NULL, '/backend/images/pin_images/f2a1f5a00ceefc664add2f820689bf57.jpg', '2023-11-28 16:45:30', 'girl1'),
(96, 'my profile pic', NULL, NULL, '/backend/images/pin_images/bfb3c66e314f282d0b45e599705f132f.jpg', '2023-11-28 16:48:03', 'artbae'),
(97, 'Beach Path', 'ames Nelson Lewis \"Beach Path\" An impressionist beach landscape painted with lots of texture.', NULL, '/backend/images/pin_images/98ba8467730b0e6d738734915a0b56c5.jpg', '2023-11-28 16:49:20', 'artbae'),
(98, 'A Positive Spin on Negative Space by Tang Yau Hoong', 'Tang Yau Hoong is a visual artist and graphic designer from Kuala Lumpur, Malaysia, whose series \"Negative Space\" uses the area in between the primary objects', 'https://www.manmadediy.com/2120-a-positive-spin-on-negative-space-by-tang-yau-hoong/', '/backend/images/pin_images/9601957948743f6f89b10a78eafcd87a.jpg', '2023-11-28 16:50:14', 'artbae'),
(99, 'Susan Hale: Gorgeous & Impressionistic Oil Landscape Paintings', 'By Cassie Rief in Featured Artists', NULL, '/backend/images/pin_images/3d979b82b559873e57378412bcccffa6.jpg', '2023-11-28 16:50:40', 'artbae'),
(100, 'Claude Monet\'s', NULL, NULL, '/backend/images/pin_images/32ece3fe527790f15007a3576c8f1070.jpg', '2023-11-28 16:51:10', 'artbae'),
(101, NULL, NULL, NULL, '/backend/images/pin_images/78a0ad9cc7a0da429ae6bc7be28743d0.jpg', '2023-11-28 16:51:25', 'artbae');

-- --------------------------------------------------------

--
-- Table structure for table `save`
--

CREATE TABLE `save` (
  `username` varchar(20) NOT NULL,
  `pinID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `save`
--

INSERT INTO `save` (`username`, `pinID`) VALUES
('brother', 46),
('brother', 47),
('test', 47),
('brother', 48),
('brother', 49),
('brother', 50),
('brother', 51),
('brother', 52),
('brother', 53),
('brother', 54),
('brother', 55),
('artbae', 56),
('messi', 56),
('brother', 57),
('messi', 57),
('messi', 58),
('artbae', 59),
('messi', 59),
('messi', 60),
('messi', 61),
('messi', 62),
('messi', 63),
('messi', 64),
('messi', 65),
('messi', 66),
('messi', 67),
('geographer', 68),
('geographer', 69),
('geographer', 70),
('geographer', 71),
('geographer', 72),
('geographer', 73),
('geographer', 74),
('geographer', 75),
('geographer', 76),
('geographer', 77),
('geographer', 78),
('geographer', 79),
('mangaboy', 80),
('geographer', 81),
('girl1', 81),
('mangaboy', 81),
('mangaboy', 82),
('mangaboy', 83),
('mangaboy', 84),
('mangaboy', 85),
('mangaboy', 86),
('mangaboy', 87),
('mangaboy', 88),
('brother', 89),
('mangaboy', 89),
('girl1', 90),
('girl1', 91),
('girl1', 92),
('girl1', 93),
('brother', 94),
('girl1', 94),
('girl1', 95),
('artbae', 96),
('artbae', 97),
('artbae', 98),
('artbae', 99),
('artbae', 100),
('brother', 100),
('artbae', 101);

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `tagID` int(11) NOT NULL,
  `tag_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`tagID`, `tag_name`) VALUES
(68, 'alone'),
(59, 'amazingworld'),
(63, 'anime'),
(56, 'arizona'),
(69, 'art'),
(48, 'ballond\'or'),
(24, 'bro'),
(25, 'brother'),
(34, 'christmas'),
(35, 'cool'),
(49, 'cr7'),
(31, 'dog'),
(37, 'firm'),
(36, 'fit'),
(64, 'fubuki'),
(62, 'girl'),
(45, 'goat'),
(38, 'gun'),
(51, 'honeymoon'),
(39, 'horse'),
(26, 'i'),
(53, 'japan'),
(55, 'lake'),
(54, 'london'),
(27, 'love'),
(65, 'manga'),
(67, 'marble'),
(33, 'meme'),
(41, 'messi'),
(47, 'mygirl'),
(29, 'my_love'),
(60, 'photography'),
(58, 'photos'),
(30, 'pirunya'),
(40, 'sea'),
(42, 'skinhead'),
(32, 'snapshot'),
(61, 'southamerica'),
(43, 'sunglasses'),
(50, 'travel'),
(46, 'u'),
(52, 'vacation'),
(57, 'vancouver'),
(66, 'vintage'),
(44, 'wc2022'),
(28, 'you');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `email` varchar(500) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `profile_image_path` varchar(255) DEFAULT NULL,
  `date_joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bio` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `user_type`, `email`, `first_name`, `last_name`, `profile_image_path`, `date_joined`, `bio`) VALUES
('artbae', '$2y$10$EFKrzhbjbuhMNV92E8MHlehwJU0JIJTKh6Zihf45DLveIyXku3dqy', 'user', 'bwrpaHT0rsqNyHQb', 'pure', 'art', '/backend/images/profile_images/bfb3c66e314f282d0b45e599705f132f.jpg', '2023-11-28 16:45:48', NULL),
('brother', '$2y$10$4zpFVCqG8HAOAfGFLAgs2OLQ5gceYxL3.UX6DnfR0l9tgH8ju9dH6', 'admin', 'bAryXHHwtebG03ob65NQ6j4vQg==', 'brother', 'is my name', '/backend/images/profile_images/brother.png', '2023-11-23 14:02:04', 'my brother is my father.'),
('geographer', '$2y$10$0Sr/nbbXBfSvwlOAJufVeOigEtd6zaX2am8ZHFF88lT1tpG2kd0oO', 'user', 'aR3yT2v0t87G2Vsb+pZZ6j4vQg==', 'geographer', NULL, '/backend/images/profile_images/6d9f445255e07173a534a79e1cd97f2e.jpg', '2023-11-28 15:52:18', NULL),
('girl1', '$2y$10$fSe5jl.7Jo/KV2oa/gBgqOjqiCM/U.fq2Tu8AIJJNMRD6JfVLeLKW', 'user', 'aRHvRHb7oubExnof99FWqzA=', 'lonely', 'girl', '/backend/images/profile_images/786972cceb9f7bf266778a5775848b12.jpg', '2023-11-28 16:41:26', 'where'),
('mangaboy', '$2y$10$aJ7SA8kTftyt2QivgeWqb.e44zZRJ2U94bPVQdIS0I3liwCWgliEa', 'user', 'YxnzT3j3qN/jxnof99FWqzA=', 'mangaboy', NULL, '/backend/images/profile_images/07cfa632a6e2992b57156fec6a64c62b.jpg', '2023-11-28 16:26:36', 'manga stuffs'),
('messi', '$2y$10$y9itIVE/7jFWDNshueKDOOEbsb4Bj48MEPnW5j.5Y9T6vGbKdhrWq', 'user', 'Yx3uW3DVoMnC3zUV9JI=', 'Leonel', 'Messi', '/backend/images/profile_images/messi.jpg', '2023-11-28 15:35:49', 'I am GOAT.'),
('test', '$2y$10$j7cdLghDG9E5DTPg9zV14uzCU8g13r43M2Kx2.DCKn8SOOQnIe3/G', 'user', 'eh3uXFnhotXXhXgZ9g==', 'Test', 'test', '/backend/images/profile_images/default-profile-image.png', '2023-11-28 14:10:43', 'I am a cat lover.');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `board`
--
ALTER TABLE `board`
  ADD PRIMARY KEY (`boardID`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`commentID`),
  ADD KEY `username` (`username`),
  ADD KEY `pinID` (`pinID`);

--
-- Indexes for table `follow`
--
ALTER TABLE `follow`
  ADD PRIMARY KEY (`usernameFollowing`,`usernameFollower`),
  ADD KEY `usernameFollower` (`usernameFollower`);

--
-- Indexes for table `has`
--
ALTER TABLE `has`
  ADD PRIMARY KEY (`pinID`,`tagID`),
  ADD KEY `tagID` (`tagID`);

--
-- Indexes for table `is_in`
--
ALTER TABLE `is_in`
  ADD PRIMARY KEY (`pinID`,`boardID`),
  ADD KEY `boardID` (`boardID`);

--
-- Indexes for table `pin`
--
ALTER TABLE `pin`
  ADD PRIMARY KEY (`pinID`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `save`
--
ALTER TABLE `save`
  ADD PRIMARY KEY (`username`,`pinID`),
  ADD KEY `pinID` (`pinID`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tagID`),
  ADD UNIQUE KEY `tag_name` (`tag_name`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `board`
--
ALTER TABLE `board`
  MODIFY `boardID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `commentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `pin`
--
ALTER TABLE `pin`
  MODIFY `pinID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tagID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `board`
--
ALTER TABLE `board`
  ADD CONSTRAINT `fk_board_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `fk_comment_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `follow`
--
ALTER TABLE `follow`
  ADD CONSTRAINT `fk_follower_user` FOREIGN KEY (`usernameFollower`) REFERENCES `user` (`username`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_following_user` FOREIGN KEY (`usernameFollowing`) REFERENCES `user` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `has`
--
ALTER TABLE `has`
  ADD CONSTRAINT `fk_has_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_has_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagID`) ON DELETE CASCADE;

--
-- Constraints for table `is_in`
--
ALTER TABLE `is_in`
  ADD CONSTRAINT `fk_is_in_board` FOREIGN KEY (`boardID`) REFERENCES `board` (`boardID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_is_in_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`) ON DELETE CASCADE;

--
-- Constraints for table `pin`
--
ALTER TABLE `pin`
  ADD CONSTRAINT `fk_pin_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `save`
--
ALTER TABLE `save`
  ADD CONSTRAINT `fk_save_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_save_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
