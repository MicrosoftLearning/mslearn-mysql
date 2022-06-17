-- Lab5_RepopulateAnimals
-- Version 1.0.1  12-May-2022

USE ZooDb;

DROP PROCEDURE IF EXISTS RepopulateAnimals;

DELIMITER $$

CREATE PROCEDURE RepopulateAnimals()
BEGIN

	TRUNCATE TABLE Animal;

	INSERT INTO Animal (AnimalID, Name, CategoryID, EnclosureID)
		VALUES
			(1, 'Bart Badger', 1, 2),
			(2, 'Barley Badger', 1, 2),
			(3, 'Vampire #1', 2, 4),        
			(4, 'Vampire #2', 2, 4),        
			(5, 'Flying fox', 2, 4),
			(6, 'Leo Lion', 3, 3),        
			(7, 'Leonie Lion', 3, 3),        
			(8, 'Dromedary #1', 4, 1),        
			(9, 'Dromedary #2', 4, 1),        
			(10, 'Dromedary #3', 4, 1),        
			(11, 'Ants', 5, 6),        
			(12, 'Tarantula', 5, 6),        
			(13, 'Emperor moth', 5, 6),        
			(14, 'Penguin #1', 6, 5),        
			(15, 'Penguin #2', 6, 5),        
			(16, 'Penguin #3', 6, 5),
			(17, 'Anaconda', 7, 7),
			(18, 'Monitor lizard #1', 7, 7),        
			(19, 'Monitor lizard #2', 7, 7),        
			(20, 'Chameleon', 7, 7),
			(21, 'Monkey #1', 8, 4),        
			(22, 'Monkey #2', 8, 4),        
			(23, 'Rabbit #1', 8, 1),        
			(24, 'Rabbit #2', 8, 1),        
			(25, 'Rabbit #3', 8, 1),        
			(26, 'Griselda Goat', 8, 1),        
			(27, 'George Goat', 8, 1);

END$$

DELIMITER ;
