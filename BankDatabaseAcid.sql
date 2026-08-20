-- ============================================================
-- BANK DATABASE – ACID PROPERTIES & ISOLATION
-- ============================================================

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS Bank_ACID_DB;
USE Bank_ACID_DB;


-- ============================================================
-- 2. CREATE TABLES
-- ============================================================

DROP TABLE IF EXISTS Bank_Transaction;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    City VARCHAR(50)
);

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12,2),
    Branch VARCHAR(50),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customer(Customer_ID)
);

CREATE TABLE Bank_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Account_No)
    REFERENCES Account(Account_No)
);


-- ============================================================
-- 3. INSERT CUSTOMER DATA
-- ============================================================

INSERT INTO Customer
(Customer_ID, Customer_Name, Phone, City)
VALUES
(101, 'Ravi Kumar', '9876543210', 'Hyderabad'),
(102, 'Priya Sharma', '9876543211', 'Vijayawada'),
(103, 'Arjun Reddy', '9876543212', 'Bangalore'),
(104, 'Sneha Rao', '9876543213', 'Chennai'),
(105, 'Kiran Kumar', '9876543214', 'Hyderabad');


-- ============================================================
-- 4. INSERT ACCOUNT DATA
-- ============================================================

INSERT INTO Account
(Account_No, Customer_ID, Account_Type, Balance, Branch)
VALUES
(10001, 101, 'Savings', 50000, 'Hyderabad'),
(10002, 102, 'Savings', 75000, 'Vijayawada'),
(10003, 103, 'Current', 120000, 'Bangalore'),
(10004, 104, 'Savings', 45000, 'Chennai'),
(10005, 105, 'Current', 90000, 'Hyderabad');


-- ============================================================
-- 5. INSERT BANK TRANSACTION DATA
-- ============================================================

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 10000),
(10002, 'DEPOSIT', 15000),
(10003, 'WITHDRAW', 20000),
(10004, 'DEPOSIT', 5000),
(10005, 'WITHDRAW', 10000);


-- ============================================================
-- 6. DISPLAY DATA
-- ============================================================

SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;


-- ============================================================
-- PART A – TRANSACTIONS
-- ============================================================


-- ============================================================
-- 7. START A TRANSACTION
-- ============================================================

START TRANSACTION;


-- ============================================================
-- 8. DEPOSIT Rs.5000 INTO ACCOUNT 10001
-- ============================================================

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


-- CHECK BALANCE

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- 9. COMMIT TRANSACTION
-- ============================================================

COMMIT;


-- CHECK AFTER COMMIT

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- PART B – ROLLBACK
-- ============================================================


-- ============================================================
-- 10. START TRANSACTION
-- ============================================================

START TRANSACTION;


-- WITHDRAW Rs.10000

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;


-- CHECK BALANCE

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- 11. ROLLBACK
-- ============================================================

ROLLBACK;


-- CHECK BALANCE AFTER ROLLBACK

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- PART C – SAVEPOINT
-- ============================================================


START TRANSACTION;


-- FIRST UPDATE

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


-- CREATE SAVEPOINT

SAVEPOINT Deposit1;


-- SECOND UPDATE

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;


-- SECOND SAVEPOINT

SAVEPOINT Withdrawal1;


-- THIRD UPDATE

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10003;


-- ROLLBACK ONLY THIRD UPDATE

ROLLBACK TO SAVEPOINT Withdrawal1;


-- COMMIT FIRST AND SECOND UPDATE

COMMIT;


-- CHECK ACCOUNTS

SELECT * FROM Account;


-- ============================================================
-- PART D – BANK TRANSFER
-- ============================================================


-- TRANSFER Rs.10000
-- FROM ACCOUNT 10001 TO ACCOUNT 10002

START TRANSACTION;


-- DEDUCT FROM SENDER

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;


-- ADD TO RECEIVER

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;


-- CHECK BOTH ACCOUNTS

SELECT *
FROM Account
WHERE Account_No IN (10001,10002);


-- COMMIT TRANSFER

COMMIT;


-- FINAL BALANCES

SELECT Account_No, Balance
FROM Account
WHERE Account_No IN (10001,10002);


-- ============================================================
-- PART E – TRANSFER USING ROLLBACK
-- ============================================================


START TRANSACTION;


-- DEDUCT MONEY

UPDATE Account
SET Balance = Balance - 20000
WHERE Account_No = 10001;


-- ADD MONEY

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10002;


-- CANCEL TRANSFER

ROLLBACK;


-- CHECK BALANCES

SELECT *
FROM Account
WHERE Account_No IN (10001,10002);


-- ============================================================
-- PART F – ACID PROPERTY EXAMPLES
-- ============================================================


-- ============================================================
-- ATOMICITY
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;


-- If error occurs:
-- ROLLBACK;


-- ============================================================
-- CONSISTENCY
-- ============================================================

-- TOTAL BEFORE TRANSFER

SELECT SUM(Balance) AS Total_Before
FROM Account;

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;


-- TOTAL AFTER TRANSFER

SELECT SUM(Balance) AS Total_After
FROM Account;


-- ============================================================
-- ISOLATION
-- ============================================================

-- Check current isolation level

SELECT @@SESSION.transaction_isolation;


-- ============================================================
-- DURABILITY
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;


-- CHECK COMMITTED DATA

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- PART G – TRANSACTION ISOLATION LEVELS
-- ============================================================


-- ============================================================
-- 1. READ UNCOMMITTED
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- 2. READ COMMITTED
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- 3. REPEATABLE READ
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- 4. SERIALIZABLE
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- CHECK ISOLATION LEVEL
-- ============================================================

SELECT @@SESSION.transaction_isolation;

SELECT @@GLOBAL.transaction_isolation;


-- ============================================================
-- PART H – DIRTY READ EXPERIMENT
-- ============================================================

-- IMPORTANT:
-- Run SESSION 1 and SESSION 2 in two separate MySQL windows.


-- ============================================================
-- SESSION 1
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10001;

-- DO NOT COMMIT


-- ============================================================
-- SESSION 2
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- SESSION 1
-- ============================================================

ROLLBACK;


-- ============================================================
-- SESSION 2
-- ============================================================

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- PART I – READ COMMITTED EXPERIMENT
-- ============================================================


-- ============================================================
-- SESSION 1
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10001;

-- DO NOT COMMIT


-- ============================================================
-- SESSION 2
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- SESSION 1
-- ============================================================

COMMIT;


-- ============================================================
-- SESSION 2
-- ============================================================

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- PART J – REPEATABLE READ EXPERIMENT
-- ============================================================


-- ============================================================
-- SESSION 1
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- SESSION 2
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- SESSION 1
-- ============================================================

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- PART K – SERIALIZABLE EXPERIMENT
-- ============================================================


-- ============================================================
-- SESSION 1
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- SESSION 2
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


-- SESSION 2 MAY WAIT FOR SESSION 1


-- ============================================================
-- SESSION 1
-- ============================================================

COMMIT;


-- ============================================================
-- SESSION 2
-- ============================================================

COMMIT;


-- ============================================================
-- PART L – TRANSACTION COMMANDS
-- ============================================================

START TRANSACTION;

BEGIN;

COMMIT;

ROLLBACK;

SAVEPOINT Savepoint_Name;

ROLLBACK TO SAVEPOINT Savepoint_Name;

RELEASE SAVEPOINT Savepoint_Name;


-- ============================================================
-- PART M – BANK TRANSACTION EXAMPLES
-- ============================================================


-- ============================================================
-- DEPOSIT TRANSACTION
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- WITHDRAWAL TRANSACTION
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 5000
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- CANCEL WITHDRAWAL
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

ROLLBACK;


-- ============================================================
-- TRANSFER WITH SAVEPOINT
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

SAVEPOINT AfterDebit;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;


-- ============================================================
-- PART N – PRACTICE QUESTIONS
-- ============================================================


-- ============================================================
-- QUESTION 1
-- Deposit Rs.5000 into account 10001 and COMMIT
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- QUESTION 2
-- Withdraw Rs.3000 from account 10002 and COMMIT
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;

COMMIT;

SELECT *
FROM Account
WHERE Account_No = 10002;


-- ============================================================
-- QUESTION 3
-- Withdraw Rs.10000 and ROLLBACK
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

ROLLBACK;

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- QUESTION 4
-- Transfer Rs.15000 from 10001 to 10002
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 15000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 15000
WHERE Account_No = 10002;

COMMIT;

SELECT *
FROM Account
WHERE Account_No IN (10001,10002);


-- ============================================================
-- QUESTION 5
-- Transfer Rs.20000 from 10001 to 10003
-- Using SAVEPOINT after deduction
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 20000
WHERE Account_No = 10001;

SAVEPOINT AfterDeduct;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10003;

COMMIT;

SELECT *
FROM Account
WHERE Account_No IN (10001,10003);


-- ============================================================
-- QUESTION 6
-- Three updates and rollback only third update
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;

SAVEPOINT Update2;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10003;

ROLLBACK TO SAVEPOINT Update2;

COMMIT;

SELECT * FROM Account;


-- ============================================================
-- QUESTION 7
-- Demonstrate ATOMICITY
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;


-- ============================================================
-- QUESTION 8
-- Demonstrate CONSISTENCY
-- ============================================================

SELECT SUM(Balance) AS Total_Before
FROM Account;

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

SELECT SUM(Balance) AS Total_After
FROM Account;


-- ============================================================
-- QUESTION 9
-- Demonstrate DURABILITY
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;

SELECT *
FROM Account
WHERE Account_No = 10001;

-- Reconnect to MySQL and run:
SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- QUESTION 10
-- READ UNCOMMITTED – DIRTY READ
-- ============================================================

-- SESSION 1

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10001;

-- DO NOT COMMIT


-- SESSION 2

SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- SESSION 1

ROLLBACK;


-- ============================================================
-- QUESTION 11
-- READ COMMITTED
-- ============================================================

-- SESSION 1

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10001;

-- DO NOT COMMIT


-- SESSION 2

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- SESSION 1

COMMIT;


-- ============================================================
-- QUESTION 12
-- REPEATABLE READ
-- ============================================================

-- SESSION 1

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;


-- SESSION 2

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;


-- SESSION 1

SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- ============================================================
-- QUESTION 13
-- SERIALIZABLE
-- ============================================================

-- SESSION 1

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;


-- SESSION 2

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


-- SESSION 1

COMMIT;


-- SESSION 2

COMMIT;


-- ============================================================
-- QUESTION 14
-- COMPARE ISOLATION LEVELS
-- ============================================================

SELECT 'READ UNCOMMITTED' AS Isolation_Level;

SELECT 'READ COMMITTED' AS Isolation_Level;

SELECT 'REPEATABLE READ' AS Isolation_Level;

SELECT 'SERIALIZABLE' AS Isolation_Level;


-- ============================================================
-- QUESTION 15
-- ANOMALIES
-- ============================================================

-- READ UNCOMMITTED
-- Dirty Read       : Possible
-- Non-repeatable   : Possible
-- Phantom Read     : Possible

-- READ COMMITTED
-- Dirty Read       : Prevented
-- Non-repeatable   : Possible
-- Phantom Read     : Possible

-- REPEATABLE READ
-- Dirty Read       : Prevented
-- Non-repeatable   : Prevented for consistent reads
-- Phantom Read     : Database-specific/concurrency dependent

-- SERIALIZABLE
-- Dirty Read       : Prevented
-- Non-repeatable   : Prevented
-- Phantom Read     : Prevented


-- ============================================================
-- QUESTION 16
-- RECEIVER ACCOUNT DOES NOT EXIST
-- ============================================================

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 99999;

-- Check whether receiver exists

SELECT *
FROM Account
WHERE Account_No = 99999;

-- If receiver does not exist:

ROLLBACK;

SELECT *
FROM Account
WHERE Account_No = 10001;


-- ============================================================
-- QUESTION 17
-- INSUFFICIENT BALANCE
-- ============================================================

START TRANSACTION;

-- Check balance

SELECT Balance
FROM Account
WHERE Account_No = 10001;

-- Example withdrawal

UPDATE Account
SET Balance = Balance - 1000000
WHERE Account_No = 10001
AND Balance >= 1000000;

-- Check whether update happened

SELECT *
FROM Account
WHERE Account_No = 10001;

-- If insufficient balance, cancel transaction

ROLLBACK;


-- ============================================================
-- QUESTION 18
-- SAVEPOINT
-- ============================================================

START TRANSACTION;

-- Deposit Rs.5000

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

-- Create savepoint

SAVEPOINT Deposit_Savepoint;

-- Withdraw Rs.2000

UPDATE Account
SET Balance = Balance - 2000
WHERE Account_No = 10002;

-- Rollback second operation

ROLLBACK TO SAVEPOINT Deposit_Savepoint;

-- Commit first operation

COMMIT;

SELECT *
FROM Account
WHERE Account_No IN (10001,10002);


-- ============================================================
-- QUESTION 19
-- DISPLAY CURRENT ISOLATION LEVEL
-- ============================================================

SELECT @@SESSION.transaction_isolation;

SELECT @@GLOBAL.transaction_isolation;


-- ============================================================
-- QUESTION 20
-- CHANGE SESSION ISOLATION LEVEL TO SERIALIZABLE
-- ============================================================

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT @@SESSION.transaction_isolation;


-- ============================================================
-- FINAL CHECK
-- ============================================================

SELECT * FROM Customer;

SELECT * FROM Account;

SELECT * FROM Bank_Transaction;

SELECT
    Account_No,
    Customer_ID,
    Account_Type,
    Balance,
    Branch
FROM Account
ORDER BY Account_No;


-- ============================================================
-- END OF BANK DATABASE – ACID PROPERTIES & ISOLATION
-- ============================================================