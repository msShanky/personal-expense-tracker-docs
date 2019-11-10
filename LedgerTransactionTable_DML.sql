Use expense_tracker_transaction_ledger;
-- Adding New User
INSERT INTO user (Email,UserName,Password,FirstName,LastName) 
VALUES('shankaranarayanan.m.s@gmail.com', 'shankyms', 'SHANKAR@0503','Shankara', 'Narayanan');

INSERT INTO transactiontype (Name) VALUES('Savings'),('Loan'),('Lending'),('Salary'),('Budget'),('Debit'),('Credit') ;

-- How would we trigger the transaction based on the string values ??
-- we could use a function to generate the next occuring date during the db insert
INSERT INTO recurringtype (Name) VALUES('Daily'),('Weekly'),('Fortnight'),('Monthly'),('Yearly'),('None');

-- Creating a new Budget
INSERT INTO budget (TargetAmount,Description,StartDate,EndDate,UserId) 
VALUES
(150000, 'Traveling to hong kong', '2019-09-09 00:00:00', '2020-09-09 00:00:00',1);

-- Creating a new Category Transaction

INSERT INTO categorytransaction (Name, UserId) VALUES ('uncatagorised', 1),('Food', 1),('Travel',1);

-- Creating a new Lending

INSERT INTO lending (LendingAmount, Date, NameOfLendee, ExpectedReturnDate, ReturnTypeId, PredictedReturnDate, IsCompleted, UserId) 
VALUES 
(8000, '2019-09-09', 'Hari Prasath', '2019-10-09', 6, '2019-10-09', false, 1);

-- Creating a new Loan

INSERT INTO loan (Name,Description, Tenure, InterestAmount, Emi, EmiDate, BankName, StartDate, EndDate, UserId) 
VALUES
('Jumbo Loan', 'Loan for pre closing the Morgage on House', 36, 16.5, 22500, '2019-10-07',  'HDFC', '2019-10-09', '2021-03-02', 1);

-- Creating a New Payment Method

INSERT INTO paymentmethod (Name, UserId) VALUES ('Cash', 1),('Debit Card',1), ('Credit Card', 1), ('UPI',1), ('Net Banking',1);

-- Creating a New Payslip

INSERT INTO payslip (Date, UserId) VALUES ('2019-08-09', 1), ('2019-09-09', 1);

-- Creating a new Payslip Variable

INSERT INTO payslipvariable (Name, UserId, IsDeduction) VALUES ('HRA', 1, FALSE),('Bonus', 1, FALSE),('PF', 1, TRUE);

-- Creating a new Salary Report

INSERT INTO payslipvariablemapping (PayslipId, PayslipVariableId, Amount, UserId) 
VALUES 
(1, 1, 25000, 1),
(1, 2, 3500, 1),
(1, 3, 3000, 1),
(2, 1, 26000, 1),
(2, 2, 0, 1),  
(2, 3, 3000, 1);

-- Creating a new Savings  

INSERT INTO savings (Amount, UserId) VALUES (20000, 1);

-- Create A new Transaction
-- One transaction for Loan, Lending, Budget, Savings, Expense, 
INSERT INTO transaction (Amount, Description, Date, UserId, CategoryTransactionId, PaymentMethodId, RecurringTypeId)
VALUES 
(1500, 'surplus after this months expenses', '2019-09-09', 1, 1, 1, 6), -- Savings
(20500, 'Loan Repyment September', '2019-09-09', 1, 1, 1, 6), -- Loan
(8000, 'Lending money to a friend', '2019-09-09', 1, 1, 1, 6), -- Lending
(15000, 'Money setting aside for the hong kong trip sep', '2019-09-09', 1, 1, 1, 6), -- Budget
(230, 'food @sunday', '2019-09-08', 1, 1, 1, 6), -- Expense
(25500, 'Salary sep', '2019-08-08', 1, 1, 1, 6), -- Salary
(25500, 'Salary AUG', '2019-08-08', 1, 1, 1, 6); -- Salary


-- MAPPING THE TRANSACTION TO THE LEDGER

-- Missing The createdAt updatedAt fields in Ledger

INSERT INTO ledger (TransactionTypeId, TransactionId, Credit, UserId, BudgetId, LoanId, LendingId, PayslipId, SavingsId) 
VALUES 
(1, 1, TRUE, 1, NULL, NULL, NULL, NULL, 1), -- Savings
(2, 2, FALSE, 1, NULL, 1, NULL, NULL, NULL), -- Loan
(3, 3, FALSE, 1, NULL, NULL, 1, NULL, NULL), -- Lending
(5, 4, FALSE, 1, 1, NULL, NULL, NULL, NULL), -- Budget
(6, 5, FALSE, 1, NULL, NULL, NULL, NULL, NULL), -- Expense
(4, 6, TRUE, 1, NULL, NULL, NULL, 2, NULL); -- Salary


