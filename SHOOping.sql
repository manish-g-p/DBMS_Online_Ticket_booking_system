CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    CustomerType VARCHAR(50),
    AccountType VARCHAR(50),
    Address VARCHAR(255)
);

CREATE TABLE ACCOUNT (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountNumber VARCHAR(50),
    Balance DECIMAL(10, 2),
    AccountStatus VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY,
    CustomerID INT,
    AccountID INT,
    PaymentAmount DECIMAL(10, 2),
    PaymentType VARCHAR(50),
    PaymentDate date,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES ACCOUNT(AccountID)
);

CREATE TABLE CART (
    CartID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES PRODUCTS(ProductID)
);





CREATE TABLE PRODUCTS (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    ProductDescription TEXT,
    Price DECIMAL(10, 2),
    CategoryID INT,
    BrandID INT,
    FOREIGN KEY (CategoryID) REFERENCES CATEGORY(CategoryID),
    FOREIGN KEY (BrandID) REFERENCES BRAND(BrandID)
);

CREATE TABLE BRAND (
    BrandID INT PRIMARY KEY,
    BrandName VARCHAR(255),
    BrandDescription TEXT
);

CREATE TABLE CATEGORY (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    CategoryDescription TEXT
);
insert into CUSTOMER values(11,'Karthik','convinence shoppers','savings','Banglore')
insert into CUSTOMER values(12,'Manish Gp','brand advocates','business','shimogga')
insert into CUSTOMER values(13,'shushanth','loyal customers','savings','Banglore')
insert into CUSTOMER values(14,'shravya','convinence shoppers','business','chennai')
insert into CUSTOMER values(15,'adithri','disengaged customes','savings','palakkad')
insert into CUSTOMER values(16,'Nandhu','disengaged customes','savings','shimogga')
insert into CUSTOMER values(17,'Adarsh','disengaged customes','savings','Manglore')

insert into ACCOUNT values(101,11,'abc123','12.08','active')
insert into ACCOUNT values(202,12,'abc234','13.09','inactive')
insert into ACCOUNT values(303,13,'baf356','14.07','active')
insert into ACCOUNT values(404,14,'nht456','15.76','inactive')
insert into ACCOUNT values(505,15,'hty678','16.87','active')

insert into PAYMENT values(23,11,101,20.00,'offline','2004-03-28')
insert into PAYMENT values(24,12,202,30.00,'online','2004-04-28')
insert into PAYMENT values(25,13,303,40.00,'online','2005-07-12')
insert into PAYMENT values(26,14,404,50.00,'online','2006-03-28')
insert into PAYMENT values(27,15,505,60.00,'offline','2004-04-15')

insert into PRODUCTS values(111,'phone','very good phone',99.00,147,789)
insert into PRODUCTS values(222,'textile','very good',22.00,258,456)
insert into PRODUCTS values(333,'watch','budget friendly',45.00,369,123)
insert into PRODUCTS values(444,'wallets','branded',32.00,741,987)
insert into PRODUCTS values(555,'groceries','beast quolity',11.00,852,654)

insert into BRAND values(789,'zara','textile brand')
insert into BRAND values(456,'tommy hilfiger','textile brand')
insert into BRAND values(123,'vanhussein','textile brand')
insert into BRAND values(987,'allen soly','textile brand')
insert into BRAND values(654,'netply','textile brand')

insert into CATEGORY values(147,'electronics','good category')
insert into CATEGORY values(258,'fashion','good category')
insert into CATEGORY values(369,'footwear','good category')
insert into CATEGORY values(741,'health','good category')
insert into CATEGORY values(852,'beauty','good category')

CREATE TRIGGER Update_Account_Status
ON PAYMENT
AFTER INSERT
AS
BEGIN
    DECLARE @AccountID INT
    DECLARE @PaymentAmount DECIMAL(10, 2)
    
    -- Get the AccountID and PaymentAmount from the inserted rows
    SELECT @AccountID = AccountID, @PaymentAmount = PaymentAmount
    FROM inserted
    
    -- Check if the payment amount exceeds the threshold
    IF @PaymentAmount > 50.00
    BEGIN
        -- Update the account status to 'inactive'
        UPDATE ACCOUNT
        SET AccountStatus = 'inactive'
        WHERE AccountID = @AccountID
    END
END;

insert into PAYMENT(PaymentID,CustomerID,AccountID,PaymentAmount,PaymentType,PaymentDate)values
(28,15,505,80.00,'offline','2024-04-03');

select * from ACCOUNT where AccountID=505;
--1)average quantity of products in cart 
SELECT AVG(Quantity) AS AvgQuantity 
FROM CART
 --2)total number of products in "electronics" category 
 SELECT COUNT(*) AS ElectronicsProducts 
FROM PRODUCTS 
WHERE CategoryID = (
    SELECT CategoryID 
    FROM CATEGORY 
    WHERE CategoryName = 'electronics'
);

--3)- brand names and their product descriptions 
SELECT BrandName, ProductDescription 
FROM (
    SELECT B.BrandName, P.ProductDescription 
    FROM BRAND B 
    JOIN PRODUCTS P ON B.BrandID = P.BrandID
) AS BrandProductInfo;
 
 --4)customers who made payments after April 1, 2004, along with their account details
SELECT * 
FROM CUSTOMER 
WHERE CustomerID IN (
    SELECT DISTINCT P.CustomerID 
    FROM PAYMENT P 
    JOIN ACCOUNT A ON P.AccountID = A.AccountID 
    WHERE PaymentDate > '2004-04-01'
);

--5)The total amount paid by each customer and compare it with the average payment amount
SELECT CustomerID, TotalPayment,
    CASE
        WHEN TotalPayment > AvgPayment THEN 'Above Average'
        WHEN TotalPayment = AvgPayment THEN 'Equal to Average'
        ELSE 'Below Average'
    END AS PaymentComparison
FROM (
    SELECT CustomerID, SUM(PaymentAmount) AS TotalPayment 
    FROM PAYMENT 
    GROUP BY CustomerID
) AS CustomerTotalPayments,
(
    SELECT AVG(PaymentAmount) AS AvgPayment 
    FROM PAYMENT
) AS AvgPaymentInfo;

--6)customers who made payments after April 1, 2004, along with their account details
SELECT * 
FROM CUSTOMER 
WHERE CustomerID IN (
    SELECT DISTINCT P.CustomerID 
    FROM PAYMENT P 
    JOIN ACCOUNT A ON P.AccountID = A.AccountID 
    WHERE PaymentDate > '2004-04-01'
);

--7)-products with prices greater than the average price of products in the "electronics" category
SELECT * 
FROM PRODUCTS 
WHERE Price > (
    SELECT AVG(Price) 
    FROM PRODUCTS 
    WHERE CategoryID = (
        SELECT CategoryID 
        FROM CATEGORY 
        WHERE CategoryName = 'electronics'
))

--8)- customers who have made payments offline and have active accounts
SELECT * 
FROM CUSTOMER 
WHERE CustomerID IN (
    SELECT DISTINCT P.CustomerID 
    FROM PAYMENT P 
    JOIN ACCOUNT A ON P.AccountID = A.AccountID 
    WHERE PaymentType = 'offline' 
    AND AccountStatus = 'active'
);

--1. Trigger: Update ACCOUNT.Balance after a PAYMENT
CREATE TRIGGER trg_UpdateBalanceAfterPayment
ON PAYMENT
AFTER INSERT
AS
BEGIN
    UPDATE A
    SET A.Balance = A.Balance - I.PaymentAmount
    FROM ACCOUNT A
    INNER JOIN INSERTED I ON A.AccountID = I.AccountID;
END;

--2)Stored Procedure: View Customer Cart
CREATE PROCEDURE ViewCart
    @CustomerID INT
AS
BEGIN
    SELECT 
        C.CartID,
        P.ProductName,
        C.Quantity,
        C.TotalAmount
    FROM CART C
    JOIN PRODUCTS P ON C.ProductID = P.ProductID
    WHERE C.CustomerID = @CustomerID;
END;
EXEC ViewCart @CustomerID =11;

--Stored Procedure: Get Account Balance
CREATE PROCEDURE GetAccountBalance
    @AccountID INT
AS
BEGIN
    SELECT Balance FROM ACCOUNT WHERE AccountID = @AccountID;
END;
exec GetAccountBalance @AccountID=101;

--Stored Procedure: Add Item to Cart

CREATE PROCEDURE AddToCart
    @CartID INT,
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    DECLARE @Price DECIMAL(10, 2);

    SELECT @Price = Price FROM PRODUCTS WHERE ProductID = @ProductID;

    IF @Price IS NULL
    BEGIN
        RAISERROR('Invalid ProductID.', 16, 1);
        RETURN;
    END

    INSERT INTO CART (CartID, CustomerID, ProductID, Quantity, TotalAmount)
    VALUES (@CartID, @CustomerID, @ProductID, @Quantity, @Price * @Quantity);
END;
EXEC AddToCart @CartID = 11, @CustomerID =12, @ProductID = 111, @Quantity = 2;
select * from cart

--Trigger: Prevent inserting a PAYMENT if ACCOUNT.Balance is too low
CREATE TRIGGER trg_PreventOverpayment
ON PAYMENT
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN ACCOUNT A ON I.AccountID = A.AccountID
        WHERE I.PaymentAmount > A.Balance
    )
    BEGIN
        RAISERROR('Insufficient balance for this payment.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If balance is sufficient, insert the payment
    INSERT INTO PAYMENT (PaymentID, CustomerID, AccountID, PaymentAmount, PaymentType)
    SELECT PaymentID, CustomerID, AccountID, PaymentAmount, PaymentType
    FROM INSERTED;
END;

INSERT INTO PAYMENT (PaymentID, CustomerID, AccountID, PaymentAmount, PaymentType)
VALUES (101, 13, 101, 1000.00, 'Credit Card');
