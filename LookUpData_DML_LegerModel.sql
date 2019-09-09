# Mandatory Insert for intial data
USE expense_tracker_transaction_ledger;

INSERT INTO TransactionType (Name) VALUES('Savings'),('Loan'),('Lending'),('Salary'),('Budget'),('Debit'),('Credit') ;

INSERT INTO RecurringType (Name) VALUES('Daily'),('Weekly'),('Fortnight'),('Monthly'),('Yearly'),('None');