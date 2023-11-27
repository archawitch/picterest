-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 27, 2023 at 05:10 PM
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
    SELECT commentID, concat(u.first_name, ' ', u.last_name) as fullname, u.profile_image_path,text, date_commented
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
    SELECT concat(u.first_name, ' ', u.last_name) as fullname, u.username, u.profile_image_path, p.pin_title, p.pin_description, p.pin_url, p.pin_image_path 
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
(14, 'my bro', 'your brother is here', '2023-11-27 23:32:09', 'brother');

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
(5, 'brother', 46, 'hey what\'s your name?', '2023-11-27 23:37:53');

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
(46, 24),
(46, 25),
(46, 26),
(46, 27),
(46, 28),
(46, 29);

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
(46, 14);

-- --------------------------------------------------------

--
-- Table structure for table `pin`
--

CREATE TABLE `pin` (
  `pinID` int(11) NOT NULL,
  `pin_title` varchar(50) DEFAULT NULL,
  `pin_description` varchar(500) DEFAULT NULL,
  `pin_url` varchar(500) DEFAULT NULL,
  `pin_image_path` varchar(255) NOT NULL,
  `date_pinned` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pin`
--

INSERT INTO `pin` (`pinID`, `pin_title`, `pin_description`, `pin_url`, `pin_image_path`, `date_pinned`, `username`) VALUES
(46, 'Brother, I love you', 'my first bro', 'https://youtu.be/dQw4w9WgXcQ?si=-RlDXHnkGRnmdUke', '/backend/images/pin_images/my bro.jpg', '2023-11-27 23:36:02', 'brother');

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
('brother', 46);

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
(24, 'bro'),
(25, 'brother'),
(26, 'i'),
(27, 'love'),
(29, 'my_love'),
(28, 'you');

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
('brother', '$2y$10$WML7LjmUNcmXKZe49BmyjOWsglUkUu3uGJeKSollPoOoz8LoJhD.C', 'admin', 'brother@example.com', 'brother', 'is my name', '/backend/images/profile_images/brother.png', '2023-11-23 14:02:04', 'my brother is my father.');

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
  MODIFY `boardID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `commentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pin`
--
ALTER TABLE `pin`
  MODIFY `pinID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tagID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
