-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 25, 2023 at 08:21 AM
-- Server version: 5.7.24
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `picterest`
--

DELIMITER $$
--
-- Procedures
--
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadPin` (IN `p_pin_id` INT)   BEGIN
    SELECT concat(u.first_name, ' ', u.last_name) as fullname, p.pin_title, p.pin_description, p.pin_url, p.pin_image_path 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchPins` (IN `query` VARCHAR(255))   BEGIN
    SELECT DISTINCT p.pinID, p.pin_image_path, p.pin_url
    FROM pin p
    LEFT JOIN has h
    ON p.pinID = h.pinID
    LEFT JOIN tag t
    ON h.tagID = t.tagID
    WHERE p.pin_title like concat('%', query, '%') or t.tag_name like concat('%', query, '%');
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

-- --------------------------------------------------------

--
-- Table structure for table `follow`
--

CREATE TABLE `follow` (
  `usernameFollowing` varchar(20) NOT NULL,
  `usernameFollower` varchar(20) NOT NULL,
  `date_followed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(3, 2),
(4, 2),
(3, 3),
(4, 4),
(6, 5),
(7, 6),
(7, 7);

-- --------------------------------------------------------

--
-- Table structure for table `is_in`
--

CREATE TABLE `is_in` (
  `pinID` int(11) NOT NULL,
  `boardID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pin`
--

CREATE TABLE `pin` (
  `pinID` int(11) NOT NULL,
  `pin_url` varchar(500) DEFAULT NULL,
  `pin_description` varchar(500) DEFAULT NULL,
  `date_pinned` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pin_title` varchar(50) DEFAULT NULL,
  `pin_image_path` varchar(255) NOT NULL,
  `username` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pin`
--

INSERT INTO `pin` (`pinID`, `pin_url`, `pin_description`, `date_pinned`, `pin_title`, `pin_image_path`, `username`) VALUES
(3, '', 'Hello World!', '2023-11-23 23:47:33', 'My first pin', '/backend/images/pin_images/download.jpg', 'adam'),
(4, '', 'Hello Venus!', '2023-11-23 23:49:28', 'My second pin', '/backend/images/pin_images/24 Crazy Funny Pics to Smile Up Your Day _ Team Jimmy Joe.jpg', 'johndoe'),
(5, '', 'Hello Neptune!', '2023-11-24 00:47:31', 'My third pin', '/backend/images/pin_images/download (1).jpg', 'johndoe'),
(6, 'https://en.wikipedia.org/wiki/Mars', 'Hello Mars!', '2023-11-24 11:37:05', 'My forth pin', '/backend/images/pin_images/Mars_-_August_30_2021_-_Flickr_-_Kevin_M._Gill.png', 'adam'),
(7, 'https://en.wikipedia.org/wiki/Pluto', 'Hello Pluto!', '2023-11-25 14:36:45', 'Pluto', '/backend/images/pin_images/pluto.jpg', 'johndoe');

-- --------------------------------------------------------

--
-- Table structure for table `save`
--

CREATE TABLE `save` (
  `username` varchar(20) NOT NULL,
  `pinID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(2, 'Hello'),
(3, 'World'),
(4, 'Venus'),
(5, 'mars'),
(6, 'pluto'),
(7, 'milky_way');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
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
('adam', '$2y$10$lBx8wFfxFzzZ0QcNpq7BcOO.oiAfua69GJ78oiLEpxgvGiYb7UEXG', 'user', NULL, NULL, NULL, '/src/assets/images/user/default-profile-image.png', '2023-11-22 23:30:07', NULL),
('brother', '$2y$10$dQ6dl7XoWfsfYXD8Nkdwb.7Y.flM7HpBJKeM2NS2S4EyH7hT8wIX6', 'admin', NULL, NULL, NULL, '/src/assets/images/user/default-profile-image.png', '2023-11-23 14:02:04', NULL),
('johndoe', '$2y$10$C7e.v/OeNCpb22slT.17VObOfUdeeTmY4szPp8uZ0WN8TRvZdE1nK', 'user', 'johndoe@example.com', 'John', 'Doe', '/backend/images/profile_images/steve.jpg', '2023-11-22 21:26:11', 'I am a cat lover.'),
('messi', '$2y$10$QrHdOkbsjBMbkk.OYTZfbeyRbgAmjWfDNKaYtGixy0Yu9iFbLz9Fi', 'user', NULL, NULL, NULL, '/src/assets/images/user/default-profile-image.png', '2023-11-23 20:33:05', NULL),
('ronaldo', '$2y$10$4rCFH2JBnWglwa9OSgoWlu6tQ9dfRQk0SEHJqQ1eoqJdOOquSNzq6', 'user', NULL, NULL, NULL, '/src/assets/images/user/default-profile-image.png', '2023-11-23 13:55:29', NULL);

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
  ADD PRIMARY KEY (`tagID`);

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
  MODIFY `boardID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `commentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pin`
--
ALTER TABLE `pin`
  MODIFY `pinID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tagID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `board`
--
ALTER TABLE `board`
  ADD CONSTRAINT `fk_board_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `fk_comment_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`),
  ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `follow`
--
ALTER TABLE `follow`
  ADD CONSTRAINT `fk_follower_user` FOREIGN KEY (`usernameFollower`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `fk_following_user` FOREIGN KEY (`usernameFollowing`) REFERENCES `user` (`username`);

--
-- Constraints for table `has`
--
ALTER TABLE `has`
  ADD CONSTRAINT `fk_has_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`),
  ADD CONSTRAINT `fk_has_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagID`);

--
-- Constraints for table `is_in`
--
ALTER TABLE `is_in`
  ADD CONSTRAINT `fk_is_in_board` FOREIGN KEY (`boardID`) REFERENCES `board` (`boardID`),
  ADD CONSTRAINT `fk_is_in_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`);

--
-- Constraints for table `pin`
--
ALTER TABLE `pin`
  ADD CONSTRAINT `fk_pin_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `save`
--
ALTER TABLE `save`
  ADD CONSTRAINT `fk_save_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`),
  ADD CONSTRAINT `fk_save_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
