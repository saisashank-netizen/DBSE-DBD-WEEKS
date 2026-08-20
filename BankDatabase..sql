

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;




DROP TABLE IF EXISTS Bank_Transaction;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
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

CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Loan_Type VARCHAR(30),
    Loan_Amount DECIMAL(12,2),
    Interest_Rate DECIMAL(5,2),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
);


-

INSERT INTO Customer
(Customer_ID, Customer_Name, Phone, Email, City)
VALUES
(101, 'Ravi Kumar', '9876543210', 'ravi@gmail.com', 'Hyderabad'),
(102, 'Priya Sharma', '9876543211', 'priya@gmail.com', 'Vijayawada'),
(103, 'Arjun Reddy', '9876543212', 'arjun@gmail.com', 'Bangalore'),
(104, 'Sneha Rao', '9876543213', 'sneha@gmail.com', 'Chennai'),
(105, 'Kiran Kumar', '9876543214', 'kiran@gmail.com', 'Hyderabad'),
(106, 'Anil Kumar', '9876543215', 'anil@gmail.com', 'Delhi'),
(107, 'Meena Reddy', '9876543216', 'meena@gmail.com', 'Mumbai'),
(108, 'Rahul Sharma', '9876543217', 'rahul@gmail.com', 'Pune'),
(109, 'Lakshmi Devi', '9876543218', 'lakshmi@gmail.com', 'Hyderabad'),
(110, 'Suresh Babu', '9876543219', 'suresh@gmail.com', 'Vijayawada');



INSERT INTO Account
(Account_No, Customer_ID, Account_Type, Balance, Branch)
VALUES
(10001, 101, 'Savings', 50000, 'Hyderabad'),
(10002, 102, 'Savings', 75000, 'Vijayawada'),
(10003, 103, 'Current', 120000, 'Bangalore'),
(10004, 104, 'Savings', 45000, 'Chennai'),
(10005, 105, 'Current', 90000, 'Hyderabad'),
(10006, 106, 'Savings', 65000, 'Delhi'),
(10007, 107, 'Current', 150000, 'Mumbai'),
(10008, 108, 'Savings', 35000, 'Pune'),
(10009, 109, 'Savings', 85000, 'Hyderabad'),
(10010, 110, 'Current', 110000, 'Vijayawada');




INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 10000),
(10001, 'WITHDRAW', 5000),
(10002, 'DEPOSIT', 15000),
(10003, 'WITHDRAW', 20000),
(10004, 'DEPOSIT', 5000),
(10005, 'WITHDRAW', 10000),
(10006, 'DEPOSIT', 12000),
(10007, 'DEPOSIT', 25000),
(10008, 'WITHDRAW', 5000),
(10009, 'DEPOSIT', 20000),
(10010, 'WITHDRAW', 15000);




INSERT INTO Loan
(Loan_ID, Customer_ID, Loan_Type, Loan_Amount, Interest_Rate)
VALUES
(501, 101, 'Home Loan', 5000000, 7.5),
(502, 102, 'Education Loan', 1000000, 6.5),
(503, 103, 'Car Loan', 800000, 8.2),
(504, 104, 'Personal Loan', 500000, 10.5),
(505, 105, 'Home Loan', 4000000, 7.2),
(506, 106, 'Car Loan', 900000, 8.5),
(507, 107, 'Business Loan', 3000000, 9.0),
(508, 109, 'Personal Loan', 600000, 10.0);




SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Loan;




DROP VIEW IF EXISTS Customer_View;
CREATE VIEW Customer_View AS
SELECT *
FROM Customer;

SELECT * FROM Customer_View;


DROP VIEW IF EXISTS Customer_Basic_View;
CREATE VIEW Customer_Basic_View AS
SELECT Customer_ID, Customer_Name, City
FROM Customer;

SELECT * FROM Customer_Basic_View;


DROP VIEW IF EXISTS Account_View;
CREATE VIEW Account_View AS
SELECT Account_No, Account_Type, Balance, Branch
FROM Account;

SELECT * FROM Account_View;


DROP VIEW IF EXISTS Savings_Account_View;
CREATE VIEW Savings_Account_View AS
SELECT *
FROM Account
WHERE Account_Type = 'Savings';

SELECT * FROM Savings_Account_View;


DROP VIEW IF EXISTS Current_Account_View;
CREATE VIEW Current_Account_View AS
SELECT *
FROM Account
WHERE Account_Type = 'Current';

SELECT * FROM Current_Account_View;




DROP VIEW IF EXISTS High_Balance_View;
CREATE VIEW High_Balance_View AS
SELECT Account_No, Customer_ID, Account_Type, Balance
FROM Account
WHERE Balance > 100000;

SELECT * FROM High_Balance_View;


DROP VIEW IF EXISTS Hyderabad_Account_View;
CREATE VIEW Hyderabad_Account_View AS
SELECT *
FROM Account
WHERE Branch = 'Hyderabad';

SELECT * FROM Hyderabad_Account_View;


DROP VIEW IF EXISTS Low_Balance_View;
CREATE VIEW Low_Balance_View AS
SELECT Account_No, Customer_ID, Balance
FROM Account
WHERE Balance < 50000;

SELECT * FROM Low_Balance_View;




DROP VIEW IF EXISTS Customer_Account_View;
CREATE VIEW Customer_Account_View AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    A.Account_No,
    A.Account_Type,
    A.Balance,
    A.Branch
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID;

SELECT * FROM Customer_Account_View;


DROP VIEW IF EXISTS Hyderabad_Customer_Accounts;
CREATE VIEW Hyderabad_Customer_Accounts AS
SELECT
    C.Customer_Name,
    C.City,
    A.Account_No,
    A.Account_Type,
    A.Balance
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID
WHERE A.Branch = 'Hyderabad';

SELECT * FROM Hyderabad_Customer_Accounts;


DROP VIEW IF EXISTS Customer_Loan_View;
CREATE VIEW Customer_Loan_View AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    L.Loan_ID,
    L.Loan_Type,
    L.Loan_Amount,
    L.Interest_Rate
FROM Customer C
JOIN Loan L
ON C.Customer_ID = L.Customer_ID;

SELECT * FROM Customer_Loan_View;


DROP VIEW IF EXISTS Customer_Banking_View;
CREATE VIEW Customer_Banking_View AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    A.Account_No,
    A.Account_Type,
    A.Balance,
    A.Branch,
    L.Loan_Type,
    L.Loan_Amount
FROM Customer C
LEFT JOIN Account A
ON C.Customer_ID = A.Customer_ID
LEFT JOIN Loan L
ON C.Customer_ID = L.Customer_ID;

SELECT * FROM Customer_Banking_View;



DROP VIEW IF EXISTS Total_Bank_Balance;
CREATE VIEW Total_Bank_Balance AS
SELECT SUM(Balance) AS Total_Balance
FROM Account;

SELECT * FROM Total_Bank_Balance;


DROP VIEW IF EXISTS Average_Account_Balance;
CREATE VIEW Average_Account_Balance AS
SELECT AVG(Balance) AS Average_Balance
FROM Account;

SELECT * FROM Average_Account_Balance;


DROP VIEW IF EXISTS Maximum_Balance_View;
CREATE VIEW Maximum_Balance_View AS
SELECT MAX(Balance) AS Maximum_Balance
FROM Account;

SELECT * FROM Maximum_Balance_View;


DROP VIEW IF EXISTS Minimum_Balance_View;
CREATE VIEW Minimum_Balance_View AS
SELECT MIN(Balance) AS Minimum_Balance
FROM Account;

SELECT * FROM Minimum_Balance_View;


DROP VIEW IF EXISTS Account_Count_View;
CREATE VIEW Account_Count_View AS
SELECT COUNT(*) AS Total_Accounts
FROM Account;

SELECT * FROM Account_Count_View;



DROP VIEW IF EXISTS Branch_Account_Count;
CREATE VIEW Branch_Account_Count AS
SELECT Branch, COUNT(*) AS Number_of_Accounts
FROM Account
GROUP BY Branch;

SELECT * FROM Branch_Account_Count;


DROP VIEW IF EXISTS Branch_Total_Balance;
CREATE VIEW Branch_Total_Balance AS
SELECT Branch, SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Branch;

SELECT * FROM Branch_Total_Balance;


DROP VIEW IF EXISTS Account_Type_Count;
CREATE VIEW Account_Type_Count AS
SELECT Account_Type, COUNT(*) AS Number_of_Accounts
FROM Account
GROUP BY Account_Type;

SELECT * FROM Account_Type_Count;


DROP VIEW IF EXISTS Account_Type_Balance;
CREATE VIEW Account_Type_Balance AS
SELECT Account_Type, SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Account_Type;

SELECT * FROM Account_Type_Balance;




DROP VIEW IF EXISTS Multiple_Account_Branches;
CREATE VIEW Multiple_Account_Branches AS
SELECT Branch, COUNT(*) AS Number_of_Accounts
FROM Account
GROUP BY Branch
HAVING COUNT(*) > 1;

SELECT * FROM Multiple_Account_Branches;


DROP VIEW IF EXISTS Rich_Branches;
CREATE VIEW Rich_Branches AS
SELECT Branch, SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Branch
HAVING SUM(Balance) > 100000;

SELECT * FROM Rich_Branches;




DROP VIEW IF EXISTS Deposit_Transaction_View;
CREATE VIEW Deposit_Transaction_View AS
SELECT *
FROM Bank_Transaction
WHERE Transaction_Type = 'DEPOSIT';

SELECT * FROM Deposit_Transaction_View;


DROP VIEW IF EXISTS Withdrawal_Transaction_View;
CREATE VIEW Withdrawal_Transaction_View AS
SELECT *
FROM Bank_Transaction
WHERE Transaction_Type = 'WITHDRAW';

SELECT * FROM Withdrawal_Transaction_View;


DROP VIEW IF EXISTS Customer_Transaction_View;
CREATE VIEW Customer_Transaction_View AS
SELECT
    C.Customer_Name,
    A.Account_No,
    A.Account_Type,
    T.Transaction_ID,
    T.Transaction_Type,
    T.Amount,
    T.Transaction_Date
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID
JOIN Bank_Transaction T
ON A.Account_No = T.Account_No;

SELECT * FROM Customer_Transaction_View;


DROP VIEW IF EXISTS High_Value_Transaction_View;
CREATE VIEW High_Value_Transaction_View AS
SELECT *
FROM Bank_Transaction
WHERE Amount > 10000;

SELECT * FROM High_Value_Transaction_View;




DROP VIEW IF EXISTS Balance_Ranking_View;
CREATE VIEW Balance_Ranking_View AS
SELECT
    Account_No,
    Customer_ID,
    Account_Type,
    Balance
FROM Account
ORDER BY Balance DESC;

SELECT * FROM Balance_Ranking_View;


DROP VIEW IF EXISTS Customer_Name_View;
CREATE VIEW Customer_Name_View AS
SELECT Customer_ID, Customer_Name, City
FROM Customer
ORDER BY Customer_Name;

SELECT * FROM Customer_Name_View;




DROP VIEW IF EXISTS Loan_Interest_View;
CREATE VIEW Loan_Interest_View AS
SELECT
    Loan_ID,
    Customer_ID,
    Loan_Type,
    Loan_Amount,
    Interest_Rate,
    (Loan_Amount * Interest_Rate / 100) AS Annual_Interest
FROM Loan;

SELECT * FROM Loan_Interest_View;


DROP VIEW IF EXISTS Loan_Total_Amount_View;
CREATE VIEW Loan_Total_Amount_View AS
SELECT
    Loan_ID,
    Customer_ID,
    Loan_Type,
    Loan_Amount,
    Interest_Rate,
    (Loan_Amount * Interest_Rate / 100) AS Annual_Interest,
    Loan_Amount +
    (Loan_Amount * Interest_Rate / 100) AS Total_Amount
FROM Loan;

SELECT * FROM Loan_Total_Amount_View;



SELECT *
FROM High_Balance_View
WHERE Balance > 120000;

SELECT *
FROM Savings_Account_View
WHERE Balance > 60000;

SELECT *
FROM Hyderabad_Account_View
WHERE Balance > 50000;

SELECT *
FROM Customer_Basic_View
WHERE City = 'Hyderabad';

SELECT *
FROM Customer_Account_View
ORDER BY Balance DESC;

SELECT *
FROM Customer_Loan_View
WHERE Loan_Amount > 1000000;



UPDATE Account_View
SET Balance = 60000
WHERE Account_No = 10001;

SELECT *
FROM Account
WHERE Account_No = 10001;



DROP VIEW IF EXISTS Simple_Account_View;

CREATE VIEW Simple_Account_View AS
SELECT
    Account_No,
    Customer_ID,
    Account_Type,
    Balance,
    Branch
FROM Account;

INSERT INTO Simple_Account_View
VALUES
(10011, 101, 'Savings', 55000, 'Hyderabad');

SELECT * FROM Account;



DELETE FROM Simple_Account_View
WHERE Account_No = 10011;

SELECT * FROM Account;




SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';

SHOW CREATE VIEW Customer_Account_View;

DESCRIBE Customer_Account_View;





-- QUESTION 1
-- Customer_ID, Customer_Name, Account_No,
-- Account_Type, Balance for all customers

DROP VIEW IF EXISTS Q1_Customer_Account;
CREATE VIEW Q1_Customer_Account AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    A.Account_No,
    A.Account_Type,
    A.Balance
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID;

SELECT * FROM Q1_Customer_Account;


-- QUESTION 2
-- Savings accounts having balance > 50000

DROP VIEW IF EXISTS Q2_Savings_Above_50000;
CREATE VIEW Q2_Savings_Above_50000 AS
SELECT *
FROM Account
WHERE Account_Type = 'Savings'
AND Balance > 50000;

SELECT * FROM Q2_Savings_Above_50000;


-- QUESTION 3
-- Current accounts from Hyderabad

DROP VIEW IF EXISTS Q3_Hyderabad_Current;
CREATE VIEW Q3_Hyderabad_Current AS
SELECT *
FROM Account
WHERE Account_Type = 'Current'
AND Branch = 'Hyderabad';

SELECT * FROM Q3_Hyderabad_Current;


-- QUESTION 4
-- Top balance accounts

DROP VIEW IF EXISTS Q4_Top_Balance;
CREATE VIEW Q4_Top_Balance AS
SELECT
    Account_No,
    Customer_ID,
    Account_Type,
    Balance
FROM Account
ORDER BY Balance DESC;

SELECT * FROM Q4_Top_Balance;


-- QUESTION 5
-- Customers who have taken loans

DROP VIEW IF EXISTS Q5_Customer_Loans;
CREATE VIEW Q5_Customer_Loans AS
SELECT
    C.Customer_Name,
    C.City,
    L.Loan_Type,
    L.Loan_Amount
FROM Customer C
JOIN Loan L
ON C.Customer_ID = L.Customer_ID;

SELECT * FROM Q5_Customer_Loans;


-- QUESTION 6
-- Customers whose loan amount > 1000000

DROP VIEW IF EXISTS Q6_Large_Loans;
CREATE VIEW Q6_Large_Loans AS
SELECT
    C.Customer_Name,
    C.City,
    L.Loan_Type,
    L.Loan_Amount
FROM Customer C
JOIN Loan L
ON C.Customer_ID = L.Customer_ID
WHERE L.Loan_Amount > 1000000;

SELECT * FROM Q6_Large_Loans;


-- QUESTION 7
-- Total balance for every branch

DROP VIEW IF EXISTS Q7_Branch_Total;
CREATE VIEW Q7_Branch_Total AS
SELECT
    Branch,
    SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Branch;

SELECT * FROM Q7_Branch_Total;


-- QUESTION 8
-- Average balance for each account type

DROP VIEW IF EXISTS Q8_Average_Account_Type;
CREATE VIEW Q8_Average_Account_Type AS
SELECT
    Account_Type,
    AVG(Balance) AS Average_Balance
FROM Account
GROUP BY Account_Type;

SELECT * FROM Q8_Average_Account_Type;


-- QUESTION 9
-- Number of customers in each city

DROP VIEW IF EXISTS Q9_City_Customers;
CREATE VIEW Q9_City_Customers AS
SELECT
    City,
    COUNT(*) AS Number_of_Customers
FROM Customer
GROUP BY City;

SELECT * FROM Q9_City_Customers;


-- QUESTION 10
-- Branches having total balance > 200000

DROP VIEW IF EXISTS Q10_Rich_Branches;
CREATE VIEW Q10_Rich_Branches AS
SELECT
    Branch,
    SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Branch
HAVING SUM(Balance) > 200000;

SELECT * FROM Q10_Rich_Branches;


-- QUESTION 11
-- All deposit transactions

DROP VIEW IF EXISTS Q11_Deposits;
CREATE VIEW Q11_Deposits AS
SELECT
    Transaction_ID,
    Account_No,
    Amount,
    Transaction_Date
FROM Bank_Transaction
WHERE Transaction_Type = 'DEPOSIT';

SELECT * FROM Q11_Deposits;


-- QUESTION 12
-- Withdrawals greater than 10000

DROP VIEW IF EXISTS Q12_Large_Withdrawals;
CREATE VIEW Q12_Large_Withdrawals AS
SELECT
    Transaction_ID,
    Account_No,
    Amount,
    Transaction_Date
FROM Bank_Transaction
WHERE Transaction_Type = 'WITHDRAW'
AND Amount > 10000;

SELECT * FROM Q12_Large_Withdrawals;


-- QUESTION 13
-- Customer + Account + Transaction

DROP VIEW IF EXISTS Q13_Customer_Transaction;
CREATE VIEW Q13_Customer_Transaction AS
SELECT
    C.Customer_Name,
    A.Account_No,
    A.Account_Type,
    T.Transaction_Type,
    T.Amount,
    T.Transaction_Date
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID
JOIN Bank_Transaction T
ON A.Account_No = T.Account_No;

SELECT * FROM Q13_Customer_Transaction;


-- QUESTION 14
-- Customer + Account + Loan

DROP VIEW IF EXISTS Q14_Customer_Account_Loan;
CREATE VIEW Q14_Customer_Account_Loan AS
SELECT
    C.Customer_Name,
    A.Account_No,
    A.Account_Type,
    A.Balance,
    L.Loan_Type,
    L.Loan_Amount
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID
JOIN Loan L
ON C.Customer_ID = L.Customer_ID;

SELECT * FROM Q14_Customer_Account_Loan;


-- QUESTION 15
-- Annual loan interest

DROP VIEW IF EXISTS Q15_Annual_Interest;
CREATE VIEW Q15_Annual_Interest AS
SELECT
    Loan_ID,
    Customer_ID,
    Loan_Type,
    Loan_Amount,
    Interest_Rate,
    (Loan_Amount * Interest_Rate / 100) AS Annual_Interest
FROM Loan;

SELECT * FROM Q15_Annual_Interest;


-- QUESTION 16
-- Loan amount, interest, annual interest and total amount

DROP VIEW IF EXISTS Q16_Loan_Total;
CREATE VIEW Q16_Loan_Total AS
SELECT
    Loan_ID,
    Customer_ID,
    Loan_Amount,
    Interest_Rate,
    (Loan_Amount * Interest_Rate / 100) AS Annual_Interest,
    Loan_Amount +
    (Loan_Amount * Interest_Rate / 100) AS Total_Amount
FROM Loan;

SELECT * FROM Q16_Loan_Total;


-- QUESTION 17
-- Branches having more than two accounts

DROP VIEW IF EXISTS Q17_Branches_More_Than_Two;
CREATE VIEW Q17_Branches_More_Than_Two AS
SELECT
    Branch,
    COUNT(*) AS Number_of_Accounts
FROM Account
GROUP BY Branch
HAVING COUNT(*) > 2;

SELECT * FROM Q17_Branches_More_Than_Two;


-- QUESTION 18
-- Account types whose total balance > 200000

DROP VIEW IF EXISTS Q18_Account_Type_Balance;
CREATE VIEW Q18_Account_Type_Balance AS
SELECT
    Account_Type,
    SUM(Balance) AS Total_Balance
FROM Account
GROUP BY Account_Type
HAVING SUM(Balance) > 200000;

SELECT * FROM Q18_Account_Type_Balance;


-- QUESTION 19
-- Customers with account balance between 50000 and 100000

DROP VIEW IF EXISTS Q19_Balance_Range;
CREATE VIEW Q19_Balance_Range AS
SELECT
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    A.Account_No,
    A.Account_Type,
    A.Balance
FROM Customer C
JOIN Account A
ON C.Customer_ID = A.Customer_ID
WHERE A.Balance BETWEEN 50000 AND 100000;

SELECT * FROM Q19_Balance_Range;


-- QUESTION 20
-- Highest balance account in each branch

DROP VIEW IF EXISTS Q20_Highest_Branch_Balance;
CREATE VIEW Q20_Highest_Branch_Balance AS
SELECT
    A.Branch,
    A.Account_No,
    A.Customer_ID,
    A.Account_Type,
    A.Balance
FROM Account A
WHERE A.Balance = (
    SELECT MAX(B.Balance)
    FROM Account B
    WHERE B.Branch = A.Branch
);

SELECT * FROM Q20_Highest_Branch_Balance;


-- ============================================================
-- FINAL CHECK – DISPLAY IMPORTANT VIEWS
-- ============================================================

SELECT * FROM Customer_View;
SELECT * FROM Account_View;
SELECT * FROM Savings_Account_View;
SELECT * FROM High_Balance_View;
SELECT * FROM Customer_Account_View;
SELECT * FROM Customer_Loan_View;
SELECT * FROM Customer_Transaction_View;
SELECT * FROM Branch_Account_Count;
SELECT * FROM Branch_Total_Balance;
SELECT * FROM Account_Type_Balance;
SELECT * FROM Deposit_Transaction_View;
SELECT * FROM Withdrawal_Transaction_View;
SELECT * FROM Loan_Interest_View;
SELECT * FROM High_Value_Transaction_View;
SELECT * FROM Customer_Banking_View;

-- ============================================================
-- END OF BANK DATABASE – SQL VIEWS
-- ============================================================