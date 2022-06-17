-- Lab5_Script3
-- Version 1.0.1  08-May-2022


/*********************************************************************************
Deadlock
	Demonstrate a deadlock between two users

	Preparation
		Open a second instance of MySQL Workbench and connect to your server
			We'll call them Instance A and B
		Open this same script in Instance B
        
*********************************************************************************/

-- RUN THIS IN INSTANCE A and B
-- Use the ZooDb database and then verify that we're using it
USE ZooDb;
SELECT DATABASE();

-- Avoid locks timing out during the lab exercise
SET @@innodb_lock_wait_timeout = 120;


-- RUN THIS IN INSTANCE A
-- Repopulate Animal table, so we start with clean data
CALL RepopulateAnimals();

-- Deadlock detection is enabled by default
SELECT @@innodb_deadlock_detect;

START TRANSACTION;

UPDATE Animal
	SET Name = 'Griselda the Goat'
    WHERE AnimalID = 26;
    
    
-- RUN THIS IN INSTANCE B
START TRANSACTION;
    
-- We do the two updates in the reverse order to Instance A. This is a
-- common way to create a deadlock situation.
UPDATE Animal
	SET Name = 'Goat George'
    WHERE AnimalID = 27;
    
UPDATE Animal
	SET Name = 'Goat Griselda'
    WHERE AnimalID = 26;

COMMIT;
    
-- RUN THIS IN INSTANCE A
-- The server automatically detects that a deadlock has occurred and
-- rolls back one of the two transactions.
UPDATE Animal
	SET Name = 'George the Goat'
    WHERE AnimalID = 27;
    
COMMIT;

-- Display the animals. Which transaction has completed?
SELECT *
	FROM Animal
    WHERE CategoryID = 8
    ORDER BY AnimalID;
    
