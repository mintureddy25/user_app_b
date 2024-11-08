-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 07, 2024 at 11:39 AM
-- Server version: 11.5.2-MariaDB-ubu2404
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `user_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `friend_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `gender` enum('Male','Female','Trans') DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `profile_picture` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `gender`, `age`, `profile_picture`) VALUES
(1, 'sai teja reddy', 'chappetasaitejareddy@gmail.com', '$^&^T63tetr##%W#', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`friend_id`),
  ADD KEY `friend_id` (`friend_id`),
  ADD KEY `idx_user_friend` (`user_id`,`friend_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
INSERT INTO users (name, email, password) 
VALUES
  ('Jane Doe', 'jane.doe@example.com', SHA2('password123', 256)),
  ('John Smith', 'john.smith@example.com', SHA2('securePassword!456', 256)),
  ('Alice Johnson', 'alice.johnson@example.com', SHA2('alicePass789', 256)),
  ('Bob Brown', 'bob.brown@example.com', SHA2('bobSecure#2024', 256)),
  ('Charlie White', 'charlie.white@example.com', SHA2('charlie123!', 256)),
  ('Eve Black', 'eve.black@example.com', SHA2('evePassword!321', 256)),
  ('Frank Green', 'frank.green@example.com', SHA2('frankPass@123', 256)),
  ('Grace Blue', 'grace.blue@example.com', SHA2('grace@1234', 256)),
  ('Hannah Pink', 'hannah.pink@example.com', SHA2('pinkSecure123', 256)),
  ('Ian Grey', 'ian.grey@example.com', SHA2('grey!Password789', 256));

-- Insert random friendships for users with at least 4 friends each

-- User 1 has 4 friends: User 2, User 3, User 4, User 5
INSERT INTO friends (user_id, friend_id)
VALUES 
    (1, 2), (2, 1),  -- User 1 <-> User 2
    (1, 3), (3, 1),  -- User 1 <-> User 3
    (1, 4), (4, 1),  -- User 1 <-> User 4
    (1, 5), (5, 1);  -- User 1 <-> User 5

-- User 2 has 5 friends: User 1, User 3, User 6, User 7, User 8
INSERT INTO friends (user_id, friend_id)
VALUES 
    (2, 1), (1, 2),  -- User 2 <-> User 1
    (2, 3), (3, 2),  -- User 2 <-> User 3
    (2, 6), (6, 2),  -- User 2 <-> User 6
    (2, 7), (7, 2),  -- User 2 <-> User 7
    (2, 8), (8, 2);  -- User 2 <-> User 8

-- User 3 has 4 friends: User 1, User 2, User 4, User 9
INSERT INTO friends (user_id, friend_id)
VALUES 
    (3, 1), (1, 3),  -- User 3 <-> User 1
    (3, 2), (2, 3),  -- User 3 <-> User 2
    (3, 4), (4, 3),  -- User 3 <-> User 4
    (3, 9), (9, 3);  -- User 3 <-> User 9

-- User 4 has 4 friends: User 1, User 3, User 5, User 6
INSERT INTO friends (user_id, friend_id)
VALUES 
    (4, 1), (1, 4),  -- User 4 <-> User 1
    (4, 3), (3, 4),  -- User 4 <-> User 3
    (4, 5), (5, 4),  -- User 4 <-> User 5
    (4, 6), (6, 4);  -- User 4 <-> User 6

-- User 5 has 5 friends: User 1, User 4, User 7, User 9, User 10
INSERT INTO friends (user_id, friend_id)
VALUES 
    (5, 1), (1, 5),  -- User 5 <-> User 1
    (5, 4), (4, 5),  -- User 5 <-> User 4
    (5, 7), (7, 5),  -- User 5 <-> User 7
    (5, 9), (9, 5),  -- User 5 <-> User 9
    (5, 10), (10, 5); -- User 5 <-> User 10

-- User 6 has 4 friends: User 2, User 4, User 8, User 10
INSERT INTO friends (user_id, friend_id)
VALUES 
    (6, 2), (2, 6),  -- User 6 <-> User 2
    (6, 4), (4, 6),  -- User 6 <-> User 4
    (6, 8), (8, 6),  -- User 6 <-> User 8
    (6, 10), (10, 6);-- User 6 <-> User 10

-- User 7 has 4 friends: User 2, User 5, User 8, User 9
INSERT INTO friends (user_id, friend_id)
VALUES 
    (7, 2), (2, 7),  -- User 7 <-> User 2
    (7, 5), (5, 7),  -- User 7 <-> User 5
    (7, 8), (8, 7),  -- User 7 <-> User 8
    (7, 9), (9, 7);  -- User 7 <-> User 9

-- User 8 has 5 friends: User 2, User 6, User 7, User 9, User 10
INSERT INTO friends (user_id, friend_id)
VALUES 
    (8, 2), (2, 8),  -- User 8 <-> User 2
    (8, 6), (6, 8),  -- User 8 <-> User 6
    (8, 7), (7, 8),  -- User 8 <-> User 7
    (8, 9), (9, 8),  -- User 8 <-> User 9
    (8, 10), (10, 8);-- User 8 <-> User 10

-- User 9 has 4 friends: User 3, User 5, User 7, User 8
INSERT INTO friends (user_id, friend_id)
VALUES 
    (9, 3), (3, 9),  -- User 9 <-> User 3
    (9, 5), (5, 9),  -- User 9 <-> User 5
    (9, 7), (7, 9),  -- User 9 <-> User 7
    (9, 8), (8, 9);  -- User 9 <-> User 8

-- User 10 has 4 friends: User 5, User 6, User 8, User 9
INSERT INTO friends (user_id, friend_id)
VALUES 
    (10, 5), (5, 10),  -- User 10 <-> User 5
    (10, 6), (6, 10),  -- User 10 <-> User 6
    (10, 8), (8, 10),  -- User 10 <-> User 8
    (10, 9), (9, 10);  -- User 10 <-> User 9


