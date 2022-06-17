-- Lab5_transactions
-- Version 1.0.2  13-May-2022

/*********************************************************************************
Basic transactions
	Autocommit and Explicit
*********************************************************************************/

-- Use the ZooDb database
USE ZooDb;
SELECT DATABASE();

-- Repopulate Animal table
CALL RepopulateAnimals();

-- Query Autocommit 
SELECT @@autocommit;

-- When autocommit is on, each SQL statement is a transaction
UPDATE Animal
	SET Name = 'Vampire bat #1'
	WHERE AnimalID = 3;

-- Name has been changed to "Vampire bat #1"
SELECT *
	FROM Animal
    WHERE CategoryID = 2
    ORDER BY AnimalID;
    

-- Explicit transaction
START TRANSACTION;

UPDATE Animal
	SET Name = 'Vampire bat #2'
	WHERE AnimalID = 4;

COMMIT;

SELECT *
	FROM Animal
    WHERE CategoryID = 2
    ORDER BY AnimalID;


-- A transaction is Atomic
START TRANSACTION;

UPDATE Animal
	SET Name = 'Flying fox #1'
	WHERE AnimalID = 5;

INSERT INTO Animal (AnimalID, Name, CategoryID, EnclosureID)
	VALUES
		(28, "Flying fox #2", 2, 4);

COMMIT;

SELECT *
	FROM Animal
    WHERE CategoryID = 2
    ORDER BY AnimalID;


-- Rollback the transaction.
START TRANSACTION;

UPDATE Animal
	SET Name = 'Foxx Flyer'
	WHERE AnimalID = 5;

INSERT INTO Animal (AnimalID, Name, CategoryID, EnclosureID)
	VALUES
		(29, "Fruit bat", 2, 4);

ROLLBACK;

SELECT *
	FROM Animal
    WHERE CategoryID = 2
    ORDER BY AnimalID;



