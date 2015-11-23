USE AdventureWorks2012;
GO
WITH OrderProduce AS
(
SELECT SOH.SalesOrderId,SOH.OrderDate, SOH.Freight,SOD.ProductID
FROM Sales.SalesOrderHeader AS SOH
 JOIN
Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID =SOD.SalesOrderID
)
SELECT SalesOrderID, Freight,ProductID,
LAG(Freight) OVER (PARTITION BY SalesOrderID ORDER BY ProductID) AS LastOrder,
SUM(Freight) OVER (PARTITION BY SalesOrderID ) AS OrderSum
INTO MyOrder
FROM OrderProduce;
GO
CREATE TABLE Mybook(
BookID int IDENTITY(1,1)Constraint book_ch CHECK(BookID >0),
Writer nvarchar(50) Constraint writer_def DEFAULT(' '),
BookName Nvarchar(50) Constraint name_def DEFAULT(' '),
ReadDate datetime2,
constraint PK_BookID PRIMARY KEY( BookID,Writer)  
)
GO
IF OBJECT_ID('BookView','V') IS NOT NULL
DROP VIEW BookView
GO
CREATE View dbo.BookView
WITH SCHEMABINDING
AS
SELECT BookID,Writer
From dbo.Mybook
WHERE Writer='Shakespeare'
With Check OPtion
GO

WITH XMLNAMESPACES('TK461-CustomersOrders' AS Bo)
SELECT [Bo:MyBook].BookId AS [bo:bookid],
[Bo:MyBook].BookName AS [co:bookname],
FROM dbo.MyBook AS [Bo:MyBook]
WHERE Writer='Shakespeare'
ORDER BY [Bo:MyBook].BookId
FOR XML AUTO, ELEMENTS, ROOT('Book');
GO
SELECT Mybook.BookID AS [@bookid],
Mybook.BookName AS [bookname]
FROM dbo.MyBook AS MyBook
WHERE Writer='Shakespeare'
ORDER BY MyBook.BookId
FOR XML PATH ('MyBook'), ROOT('MyBooks');
GO
SELECT SOH.SalesOrderId,SOH.OrderDate, SOH.Freight,SOD.ProductID
INTO dbo.OrderProduce
FROM Sales.SalesOrderHeader AS SOH
 JOIN
Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID =SOD.SalesOrderID
GO
IF OBJECT_ID (N'dbo.OrderTotalsByYear', N'IF') IS NOT NULL
DROP FUNCTION dbo.OrderTotalsByYear;
GO
CREATE FUNCTION dbo.OrderTotalsByYear()
RETURNS TABLE
AS
RETURN
SELECT OP.SalesOrderID,OP.OrderDate,Year(OP.OrderDate)AS orderyear
FROM OrderProduce AS OP
GO
BEGIN TRAN
BEGIN TRY
	SELECT 1;
	SELECT 1/0;
	COMMIT TRAN
END TRY
BEGIN CATCH
	THROW;
	ROLLBACK TRAN;
END CATCH
GO
