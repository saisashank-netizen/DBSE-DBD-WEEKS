CREATE DATABASE bank;
use bank;
CREATE TABLE bank (
txn_id INT PRIMARY KEY,
customer_name VARCHAR(50),
branch_name VARCHAR(50),
transaction_type VARCHAR(20),
amout DECIMAL(10,2),
transaction_date DATE
);
describe bank;
ALTER TABLE bank_transactions
ADD account_no VARCHAR(20);
ALTER TABLE bank_transactions
MODIFY customer_name VARCHAR(100);