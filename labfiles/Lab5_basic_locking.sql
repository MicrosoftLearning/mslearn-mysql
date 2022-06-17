
/*********************************************************************************
Basic locking
	Demonstrate effect of locking between two users

	Preparation
		Open a second instance of MySQL Workbench and connect to your server
			We'll call them Instance A and B
		Open this same script in Instance B
        
*********************************************************************************/

-- 1. RUN THIS IN INSTANCE A

USE ZooDb;
SELECT DATABASE();
CALL RepopulateAnimals();

-- Start a transaction and keep it open
START TRANSACTION;

UPDATE Animal
	SET Name = 'Percy Penguin'
    WHERE AnimalID = 14;


-- 2. RUN THIS IN INSTANCE B

USE ZooDb;
SELECT DATABASE();

-- Cannot see Percy Penguin because Instance A's transaction has not been committed yet.
SELECT *
	FROM Animal
    WHERE CategoryID = 6
    ORDER BY AnimalID;

-- Increase lock timeout, otherwise it may timeout during the exercise
SET @@innodb_lock_wait_timeout = 300;

-- Updating the same animal gets blocked because the transaction in
-- instance A has locked the row. So, this UPDATE statement  waits
-- until Instance A's transaction has committed
-- Note: This is single UPDATE statement, so we'll run it as an autocommit
-- transaction for simplicity. We don't need START TRANSACTION and COMMIT.
UPDATE Animal
	SET Name = 'Percival Penguin'
    WHERE AnimalID = 14;


-- 3. RUN THIS IN INSTANCE A
-- There should be two transactions. The transaction for Instance B is
-- waiting for the transaction for Instance A to complete.
SELECT *
	FROM information_schema.innodb_trx;

-- Commit the transaction in Instance A to allow the transaction in Instance B to proceed
COMMIT;

-- There should be no transactions now
SELECT *
	FROM information_schema.innodb_trx;

-- We should see the change made by Instance B "Percival Penguin"
SELECT *
	FROM Animal
    WHERE CategoryID = 6
    ORDER BY AnimalID;


/*********************************************************************************
Read-only transactions and transaction isolation levels
		Demonstrates use of read-only transaction
        Also demonstrates different transaction isolation levels
        
        Run this section twice with different transaction isolation levels:
			REPEATABLE READ -- this is the default for MySQL
            READ COMMITTED
            
*********************************************************************************/

-- 10. RUN THIS IN INSTANCE A

USE ZooDb;
SELECT DATABASE();

CALL RepopulateAnimals();

-- The first time you run this section, leave the transaction isolation level
-- at the default, REPEATABLE READ. The second time you run this section
-- uncomment the SET TRANSACTION ISOLATION LEVEL statement and change the
-- transaction isolation level to READ COMMITTED. (Note: This applies only to
-- the next START TRANSACTION statement, without GLOBAL or SESSION keywords.)

-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION READ ONLY;

-- Enclosure 1 has camels, rabbits, and goats
SELECT *
	FROM Animal
    WHERE EnclosureID = 1
    ORDER BY AnimalID;


-- 11. RUN THIS IN INSTANCE B
USE ZooDb;
SELECT DATABASE();

-- Move the camels into enclosure 2. This is not blocked by the read only transaction in Instance A.
-- For simplicity, this is an autocommit transaction.
UPDATE Animal
	SET EnclosureID = 2
    WHERE CategoryID = 4;

-- The change is visible in Instance B. Camels are no longer in Enclosure 1.
SELECT *
	FROM Animal
    WHERE EnclosureID = 1
    ORDER BY AnimalID;


-- 12. RUN THIS IN INSTANCE A
-- We are running this within the transaction and the result will be different
-- according to the transaction isolation level. With REPEATABLE READ, the changes
-- made in Instance B are not visible. With READ COMMITTED, the changes made in
-- Instance B are visible.
SELECT *
	FROM Animal
    WHERE EnclosureID = 1
    ORDER BY AnimalID;

-- Finish the transaction
COMMIT;

-- Verify that the camels are now in enclosure 2 together with the badgers.
-- Outside of the transaction, the changes made in Instance B are
-- visible, regardless of isolation level.
SELECT *
	FROM Animal
    WHERE EnclosureID IN (1, 2)
    ORDER BY EnclosureID, AnimalID;