-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 21, 2023 at 04:10 PM
-- Server version: 5.7.24
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `picterest`
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP DATABASE IF EXISTS picterest;
CREATE DATABASE picterest;

-- --------------------------------------------------------

--
-- Table structure for table `board`
--

USE picterest;

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

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `profile_image_path` varchar(255) DEFAULT NULL,
  `date_joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bio` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  MODIFY `pinID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tagID` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `fk_comment_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`);

--
-- Constraints for table `follow`
--
ALTER TABLE `follow`
  ADD CONSTRAINT `fk_following_user` FOREIGN KEY (`usernameFollowing`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `fk_follower_user` FOREIGN KEY (`usernameFollower`) REFERENCES `user` (`username`);

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
  ADD CONSTRAINT `fk_is_in_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`),
  ADD CONSTRAINT `fk_is_in_board` FOREIGN KEY (`boardID`) REFERENCES `board` (`boardID`);

--
-- Constraints for table `pin`
--
ALTER TABLE `pin`
  ADD CONSTRAINT `fk_pin_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `save`
--
ALTER TABLE `save`
  ADD CONSTRAINT `fk_save_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `fk_save_pin` FOREIGN KEY (`pinID`) REFERENCES `pin` (`pinID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
