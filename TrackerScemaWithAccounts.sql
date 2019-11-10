-- DROP DATABASE IF EXISTS expense_tracker_accounts;
-- CREATE DATABASE expense_tracker_accounts;
USE expense_tracker_accounts;

-- DROP TABLE IF EXISTS Ledger;
DROP TABLE IF EXISTS `Transaction`;
DROP TABLE IF EXISTS TransactionCategory;
DROP TABLE IF EXISTS PaymentMethod;
DROP TABLE IF EXISTS PayslipVariableMapping;
DROP TABLE IF EXISTS Payslip;
DROP TABLE IF EXISTS PayslipVariable;
DROP TABLE IF EXISTS Lending;
DROP TABLE IF EXISTS LendingReturnType;
DROP TABLE IF EXISTS Savings;
DROP TABLE IF EXISTS TransactionType;
DROP TABLE IF EXISTS Budget;
DROP TABLE IF EXISTS RecurringType;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Goal;
DROP TABLE IF EXISTS `Account`;
DROP TABLE IF EXISTS `User`;



# User Details Can be extended when supportinng social connect
CREATE TABLE `User` (
    UserId INT NOT NULL AUTO_INCREMENT,
    Email VARCHAR(100) NOT NULL,
    UserName VARCHAR(50) NOT NULL,
    Avatar TEXT,
    `Password` VARCHAR(255) NOT NULL,
    AccessToken VARCHAR(255) DEFAULT '',
    RefreshToken VARCHAR(255) DEFAULT '',
    FirstName VARCHAR(150) NOT NULL,
    LastName VARCHAR(150) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `Active` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (UserId)
);

CREATE TABLE RecurringType (
    RecurringTypeId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (RecurringTypeId)
);

CREATE TABLE `Account` (
    AccountId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(100),
    UserId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_Account_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (AccountId)
);

# Budget is for declaring a limit for the amount of transaction allowed for the specific time period
CREATE TABLE Budget (
    BudgetId INT NOT NULL AUTO_INCREMENT,
    AllocatedAmount FLOAT NOT NULL,
    Description VARCHAR(255) NULL DEFAULT '',
    TimePeriodId INT NOT NULL,
    AccountId  INT NOT NULL,
    Active BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    CONSTRAINT `FK_Budget_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Budget_RecurringType` FOREIGN KEY (TimePeriodId)
        REFERENCES RecurringType (RecurringTypeId),
    CONSTRAINT `FK_Budget_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (BudgetId)
);

-- TODO : add a new table for maintaining financial goal 

CREATE TABLE Goal (
    GoalId INT NOT NULL AUTO_INCREMENT,
    StartDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndDate DATETIME NOT NULL,
    Description VARCHAR(200) NOT NULL,
    TargetAmount DOUBLE NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    CONSTRAINT `FK_Goal_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (GoalId)
);

CREATE TABLE LoanType (
    LoanTypeId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    PRIMARY KEY (LoanTypeId)
);

# Loan is for tracking all the loan related details including the emi amount and the remaining amount with a countdown time to the end of the loan
CREATE TABLE Loan (
    LoanId INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    Description VARCHAR(255),
    Tenure INT NOT NULL,
    InterestAmount FLOAT NOT NULL,
    InterestType VARCHAR(150),
    LoanTypeId INT NOT NULL,
    Emi FLOAT NOT NULL,
    EmiDate DATETIME,
    BankName VARCHAR(100) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    AccountId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    CONSTRAINT `FK_Loan_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Loan_LoanType` FOREIGN KEY (LoanTypeId)
        REFERENCES LoanType (LoanTypeId),
    CONSTRAINT `FK_Loan_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (LoanId)
);

# Savings is for tracking the saved amount when a user manually pushes the amount to savings account 

CREATE TABLE Savings (
    SavingsId INT NOT NULL AUTO_INCREMENT,
    Amount FLOAT NOT NULL,
    AccountId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    CONSTRAINT `FK_Savings_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Savings_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (SavingsId)
);

# Lending is 

CREATE TABLE Lending (
    LendingId INT NOT NULL AUTO_INCREMENT,
    LendingAmount FLOAT NOT NULL,
    `Date` DATETIME NOT NULL,
    NameOfLendee VARCHAR(150) NOT NULL,
    ExpectedReturnDate DATETIME NOT NULL,
    ReturnTypeId INT NOT NULL,
    PredictedReturnDate DATETIME,
    IsCompleted BOOLEAN DEFAULT FALSE,
    AccountId INT NOT NULL,
    UserId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_Lending_User` FOREIGN KEY (UserId)
        REFERENCES `User` (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Lending_RecurringType` FOREIGN KEY (ReturnTypeId)
        REFERENCES RecurringType (RecurringTypeId)
        ON UPDATE CASCADE,
    CONSTRAINT `FK_Lending_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (LendingId)
);

CREATE TABLE PayslipVariable (
    PayslipVariableId INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(150) NOT NULL,
    UserId INT NOT NULL,
    IsDeduction BOOLEAN DEFAULT FALSE,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_SalaryVariable_User` FOREIGN KEY (UserId)
        REFERENCES `User` (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (PayslipVariableId)
);

CREATE TABLE Payslip (
    PayslipId INT NOT NULL AUTO_INCREMENT,
    `Date` DATETIME NOT NULL,
    UserId INT NOT NULL,
    AccountId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_Payslip_User` FOREIGN KEY (UserId)
        REFERENCES `User` (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Payslip_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (PayslipId)
);

CREATE TABLE PayslipVariableMapping (
    PayslipVariableMappingId INT NOT NULL AUTO_INCREMENT,
    PayslipId INT NOT NULL,
    PayslipVariableId INT NOT NULL,
    Amount FLOAT NOT NULL,
    UserId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_PayslipVariableMapping_User` FOREIGN KEY (UserId)
        REFERENCES `User` (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `UK_Unique_PayslipId_PayslipVariableId` UNIQUE (PayslipId , PayslipVariableId),
    PRIMARY KEY (PayslipVariableMappingId)
);

CREATE TABLE PaymentMethod (
    PaymentMethodId INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    AccountId INT NOT NULL,
    CONSTRAINT `FK_PaymentMethod_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_PaymentMethod_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (PaymentMethodId)
);

# Transaction Category 
CREATE TABLE TransactionCategory (
    TransactionCategoryId INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UserId INT NOT NULL,
    AccountId INT NOT NULL,
    CONSTRAINT `FK_TransactionCategory_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_TransactionCategory_Account` FOREIGN KEY (AccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (TransactionCategoryId)
);

-- CREATE DEFAULT VALUES WHEN CREATING THE DATABASE FOR => TransactionType

CREATE TABLE TransactionType (
    TransactionTypeId INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(150) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (TransactionTypeId)
);

CREATE TABLE `Transaction` (
    TransactionId INT NOT NULL AUTO_INCREMENT,
    Amount FLOAT NOT NULL,
    `Description` VARCHAR(150) NOT NULL,
    `Date` DATETIME NOT NULL,
    UserId INT NOT NULL,
    TransactionCategoryId INT NULL,    
    PaymentMethodId INT NOT NULL,
    RecurringTypeId INT NOT NULL,
    CreditAccountId INT NOT NULL,
    DebitAccountId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `FK_Transaction_User` FOREIGN KEY (UserId)
        REFERENCES User (UserId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_Transaction_TransactionCategory` FOREIGN KEY (TransactionCategoryId)
        REFERENCES TransactionCategory (TransactionCategoryId)
        ON UPDATE CASCADE,
    CONSTRAINT `FK_Transaction_PaymentMethod` FOREIGN KEY (PaymentMethodId)
        REFERENCES PaymentMethod (PaymentMethodId)
        ON UPDATE CASCADE,
    CONSTRAINT `FK_Transaction_Account_Credit` FOREIGN KEY (CreditAccountId)
        REFERENCES `Account` (AccountId),
    CONSTRAINT `FK_Transaction_Account_Debit` FOREIGN KEY (DebitAccountId)
        REFERENCES `Account` (AccountId),
    PRIMARY KEY (TransactionId)
);
