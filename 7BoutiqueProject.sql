-- ALAN 1
-- BU ALANDA; tablo olu�turma , insert ve update i�lemleri , key ve constraint tan�mlama vb. i�lemler yap�lm��t�r.

CREATE TABLE Supplier (
	SupplierID integer,
	Name nvarchar(30),
	City nvarchar(30)
)

ALTER TABLE [dbo].[Product]
ADD CONSTRAINT FK_ProductSupplier
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID);

ALTER TABLE [dbo].[Supplier]
ADD Email nvarchar(50)

CREATE TABLE Category (
	CategoryID integer NOT NULL PRIMARY KEY,
	CategoryName nvarchar(30)  NOT NULL,
	Description text
)

ALTER TABLE [dbo].[Product]
ADD CategoryID integer NOT NULL

ALTER TABLE [dbo].[Product]
ADD CONSTRAINT FK_ProductCategory
FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID);

CREATE TABLE Employee(
	EmployeeID smallint NOT NULL PRIMARY KEY,
	FirstName nvarchar(30) NOT NULL,
	LastName nvarchar(30) NOT NULL,
	BirthDate date,
	HireDate date
)

CREATE TABLE Sales(
	SalesID int NOT NULL PRIMARY KEY,
	EmployeeID smallint NOT NULL FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
	OrderDate date,
)

CREATE TABLE SalesDetail(
	SalesID int NOT NULL FOREIGN KEY (SalesID) REFERENCES Sales(SalesID),
	ProductID int NOT NULL FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
	Price money NOT NULL,
	Quantity smallint NOT NULL,
	)

ALTER TABLE [dbo].[Supplier]
ADD Telephone nvarchar(15)

ALTER TABLE [dbo].[SalesDetail]
ADD CONSTRAINT FK_SalesDetail_Sales
FOREIGN KEY (SalesID) REFERENCES [dbo].[Sales](SalesID)

ALTER TABLE [dbo].[SalesDetail]
ADD CONSTRAINT FK_SalesDetail_Product
FOREIGN KEY (ProductID) REFERENCES [dbo].[Product](ProductID)

ALTER TABLE [dbo].[Product]
ADD GenderID smallint NOT NULL FOREIGN KEY (GenderID) REFERENCES [dbo].[Gender](GenderID)

CREATE TABLE Gender(
	GenderID smallint,
	Name nvarchar(10)
	)

ALTER TABLE [dbo].[Category]
ADD GenderID smallint NOT NULL FOREIGN KEY (GenderID) REFERENCES [dbo].[Gender](GenderID)

ALTER TABLE [dbo].[Product]
ADD CONSTRAINT CK_Price CHECK (Price>=0)

ALTER TABLE [dbo].[Product]
ADD CONSTRAINT UK_ProductName UNIQUE (ProductName)

ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT DF_OrderDate DEFAULT getdate() FOR [OrderDate]

ALTER TABLE [dbo].[SalesDetail]
ADD CONSTRAINT CK_SalesDetail_Price CHECK (Price>=0)

ALTER TABLE [dbo].[SalesDetail]
ADD CONSTRAINT CK_SalesDetail_Quantity CHECK (Quantity > 0)

ALTER TABLE [dbo].[Product]
ADD CategoryID int NOT NULL FOREIGN KEY (CategoryID) REFERENCES [dbo].[Category](CategoryID)

ALTER TABLE [dbo].[Employee]
ADD CONSTRAINT CK_HireDate CHECK (HireDate > BirthDate)

INSERT INTO Gender
VALUES ('Unisex');

SELECT *
FROM [dbo].[Gender]

ALTER TABLE [dbo].[Category]
ADD CONSTRAINT CK_GenderID CHECK ((GenderID) IN (1,2,3))

INSERT INTO Category
VALUES('Kazak',NULL,1)

INSERT INTO Category
VALUES('Aksesuar',NULL,3)

UPDATE Category
SET Description = 'Atk�lar,Bereler,Eldivenler,�allar'
WHERE CategoryID = 6

SELECT *
FROM [dbo].[Category]

INSERT INTO Supplier
VALUES('Tar�k Jeans','Antalya','tarikjeans@gmail.com',NULL)

INSERT INTO Supplier
VALUES('Fatih G�mlek','Antalya',NULL,'05312504466')

INSERT INTO Supplier
VALUES('Kasha','�stanbul','kashabusiness@gmail.com','08504447484')

INSERT INTO Supplier(SupplierName,City)
VALUES('Bosco Giyim','Bursa')

SELECT *
FROM Supplier

SELECT CategoryID,CategoryName,G.Name
FROM Category AS C
INNER JOIN Gender AS G ON C.GenderID = G.GenderID

INSERT INTO [dbo].[Product]
VALUES('Lacoste Pembe G�mlek',40,NULL,2,'Pembe',2)

INSERT INTO [dbo].[Product]
VALUES('Gant Lacivert Keten G�mlek',45,NULL,2,'Lacivert',4)

INSERT INTO [dbo].[Product]
VALUES('Gri �rg� Bere',5,NULL,4,'Gri',6)

ALTER TABLE [dbo].[Supplier]
ADD CONSTRAINT DF_Telephone DEFAULT NULL FOR [Telephone]

ALTER TABLE [dbo].[Category]
ADD CONSTRAINT UK_CategoryIDGenderID UNIQUE (CategoryID,GenderID)

INSERT INTO [dbo].[Employee]
VALUES('Alican','Y�lmaz','1990-10-08','2021-12-21')

INSERT INTO [dbo].[Employee]
VALUES ('Buse','Kabak','1997-03-14','2021-10-08')

INSERT INTO [dbo].[Employee]
VALUES ('Selin','Y�lmaz','1993-07-17','2020-07-20')

ALTER TABLE [dbo].[Employee]
ADD CONSTRAINT CK_BirthDate CHECK ([BirthDate]>='1930-01-01')

SELECT *
FROM [dbo].[Employee]

INSERT INTO [dbo].[Sales]
VALUES (5,DEFAULT)

SELECT *
FROM Sales

INSERT INTO [dbo].[SalesDetail]
VALUES(6,7,45,1)

-- ALAN 2
-- BU ALANDA; proje kapsam�nda yap�lacak ek tablo olu�turma , view olu�turma , sorgular
-- stored procedure , trigger vb. bulunmaktad�r.

-- Daha sonra �zerinde sorgu �al��t�rmak i�in ge�ici bir tablo olu�turuyorum
SELECT P.ProductID,P.ProductName,P.Color,P.Price,C.CategoryName,G.Name,S.SupplierName,S.City
INTO A1 -- �r�n Detay Tablosu 
FROM [dbo].[Product] AS P
INNER JOIN [dbo].[Category] AS C ON P.CategoryID = C.CategoryID
INNER JOIN [dbo].[Gender] AS G ON C.GenderID = G.GenderID
INNER JOIN [dbo].[Supplier] AS S ON P.SupplierID = S.SupplierID

-- Daha sonra bu tablo �zerinde sorgular�n daha h�zl� �al��mas� i�in birka� index tan�ml�yorum
CREATE NONCLUSTERED INDEX IX_Color ON [dbo].[A1] (Color)
CREATE NONCLUSTERED INDEX IX_Name ON [dbo].[A1] (Name)
CREATE CLUSTERED INDEX IX_ProductID ON [dbo].[A1] (ProductID)

-- Sorgu: Fiyat� 40 Dolar'dan fazla olan �r�nler 
SELECT *
FROM [dbo].[A1]
WHERE Price > 40

-- Sorgu: Kad�n Reyonunda veya G�mlek Kategorisindeki �r�nlerin Fiyatlar�
SELECT A1.Price
FROM [dbo].[A1] 
WHERE A1.Name = 'Kad�n' OR A1.CategoryName = 'G�mlek'

-- Sorgu: Antalya �ehrindeki tedarik�ilerden k�rm�z� veya siyah �r�n sa�layan tedarik�ilerin isimleri
SELECT A1.SupplierName
FROM [dbo].[A1]
WHERE A1.Color IN ('K�rm�z�','Siyah') AND A1.City = 'Antalya'

-- Sorgu: Reyon ba��na �r�nlerin ortalama fiyatlar� 
SELECT Name,AVG(Price)
FROM [dbo].[A1]
GROUP BY Name


-- Sat�� detaylar�yla alakal� bir toplu tablo olu�turuyorum
SELECT SD.SalesID,(E.FirstName+E.LastName) AS Employee,SD.ProductID,P.ProductName,SD.Price,SD.Quantity,(SD.Price*SD.Quantity) AS Amount
INTO A2 -- Sat�� Detay Tablosu
FROM SalesDetail AS SD
INNER JOIN Sales AS S ON SD.SalesID = S.SalesID
INNER JOIN Employee AS E ON S.EmployeeID = E.EmployeeID
INNER JOIN Product AS P ON SD.ProductID = P.ProductID

-- A2 adl� tablodan �zerinde sorgu �al��t�rmak i�in bir view olu�turuyorum.
CREATE VIEW V1 -- Sat�� Toplam� & �al��an K�r�l�m� 
AS
SELECT A2.Employee,A2.Amount
FROM [dbo].[A2]

SELECT *
FROM [dbo].[V1]

-- Sorgu: Hi� sat�lmayan �r�nler
SELECT *
FROM [dbo].[Product] AS P
LEFT JOIN [dbo].[SalesDetail] AS SD ON P.ProductID = SD.ProductID
LEFT JOIN [dbo].[Sales] AS S ON SD.SalesID = S.SalesID
WHERE S.SalesID IS NULL

-- Sorgu: �al��an ba��na yap�lan toplam sat�� tutar�
SELECT V1.Employee,SUM(V1.Amount) AS TotalSalesAmount
FROM [dbo].[V1]
GROUP BY V1.Employee
ORDER BY TotalSalesAmount DESC;

-- Sorgu: �r�n ba��na yap�lan sat�� adedi ve toplam kazan�
SELECT ProductID,ProductName,SUM(Quantity) AS Adet ,SUM(Amount) AS ToplamKazanc
FROM [dbo].[A2]
GROUP BY ProductID,ProductName
ORDER BY ToplamKazanc DESC

-- Bonus Sorgu: Antalya �ehri d���ndan tedarik edilen �r�nleri satan �al��anlar ***
SELECT DISTINCT(E.FirstName+' '+E.LastName)
FROM [dbo].[Employee] AS E
INNER JOIN [dbo].[Sales] AS S ON E.EmployeeID = S.EmployeeID
INNER JOIN [dbo].[SalesDetail] AS SD ON SD.SalesID = S.SalesID
INNER JOIN [dbo].[Product] AS P ON P.ProductID = SD.ProductID
INNER JOIN [dbo].[Supplier] AS SP ON P.SupplierID = SP.SupplierID
WHERE SP.City != 'Antalya'

-- Bu sorguyu daha rahat �al��t�rabilece�imiz 5 tablonun birle�imi olan bir view olu�tural�m
CREATE VIEW V2
AS
SELECT E.EmployeeID,(E.FirstName+' '+E.LastName) AS Employee,S.SalesID,SD.ProductID,P.ProductName,SD.Price,SD.Quantity,SP.SupplierName,SP.City
FROM [dbo].[Employee] AS E
INNER JOIN [dbo].[Sales] AS S ON E.EmployeeID = S.EmployeeID
INNER JOIN [dbo].[SalesDetail] AS SD ON SD.SalesID = S.SalesID
INNER JOIN [dbo].[Product] AS P ON P.ProductID = SD.ProductID
INNER JOIN [dbo].[Supplier] AS SP ON P.SupplierID = SP.SupplierID

SELECT *
FROM [dbo].[V2]

SELECT DISTINCT Employee
FROM [dbo].[V2]
WHERE City != 'Antalya'

-- Procedure Tan�mlamalar�

-- Delete / parametre olarak EmployeeID al�r.
ALTER PROCEDURE Employee_CalisanSil (@CalisanID smallint)
AS
BEGIN TRANSACTION
	/*
	DECLARE @A INT;
		BEGIN
		DELETE 
		FROM [dbo].[Employee]
		WHERE EmployeeID = @CalisanID

		SET @A = @@ROWCOUNT
		IF @A > 0
			BEGIN
			PRINT('Calisan Silinemez...')
			PRINT('CalisanGuncelle komutu ile calisani inaktif hale getirebilirsiniz.')
			ROLLBACK TRANSACTION
			END
		ELSE
		*/
			BEGIN
			PRINT('Veritaban�ndan calisan silinemez...')
			PRINT('CalisanGuncelle komutu ile calisani inaktif hale getirebilirsiniz.')
			ROLLBACK TRANSACTION
			END

EXEC [dbo].[Employee_CalisanSil] 1

SELECT *
FROM Employee

-- Update / parametre olarak EmployeeID ve isActive i�in boolean de�eri al�r.
CREATE PROCEDURE Employee_CalisanGuncelle (@CalisanID smallint,@Durum bit)
AS
BEGIN TRANSACTION 
	DECLARE @A INT;
	BEGIN
		UPDATE [dbo].[Employee]
		SET isActive = @Durum
		WHERE EmployeeID = @CalisanID
		SET @A = @@ROWCOUNT

		IF @A > 0
			BEGIN
				PRINT('Calisanin aktiflik durumu guncellendi.')
				COMMIT TRANSACTION
			END
		ELSE
			BEGIN
			PRINT('Boyle bir calisan yok...')
			ROLLBACK TRANSACTION
			END
	END

EXEC [dbo].[Employee_CalisanGuncelle] 5,False

SELECT *
FROM Employee

EXEC [dbo].[Employee_CalisanGuncelle] 5,True


-- Insert / 5 parametre olarak eklenecek �al��an�n bilgilerini al�r.
CREATE PROCEDURE Employee_CalisanEkle (
@FirstName nvarchar(30),
@LastName nvarchar(30),
@BirthDate date,
@HireDate date,
@isActive bit
)
AS
BEGIN TRANSACTION 
	DECLARE @B INT;
		BEGIN
		INSERT INTO [dbo].[Employee](FirstName,LastName,BirthDate,HireDate,isActive)
		VALUES(@FirstName,@LastName,@BirthDate,@HireDate,@isActive)
		SET @B = @@ROWCOUNT

		IF @B > 0
			BEGIN
				PRINT('Yeni calisan eklendi...')
				COMMIT TRANSACTION
			END
		ELSE
			BEGIN
				PRINT('Calisan eklenemedi...')
				ROLLBACK TRANSACTION
			END
		END

EXEC [dbo].[Employee_CalisanEkle] 'Gamze','Demir','1988-01-30','2021-12-22',1

SELECT *
FROM Employee

EXEC [dbo].[Employee_CalisanEkle] 'Ahmet','Arslan','1998-02-14','2021-12-22',0

-- Trigger Tan�mlama

-- Gender silinmesini engelleyen bir trigger tan�ml�yorum.

ALTER TRIGGER TR1 ON [dbo].[Gender]
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            ('Veritaban�ndan Gender silinemez...!', -- Message
            10, -- Severity.
            1); -- State.

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
END;

DELETE
FROM Gender
WHERE GenderID = 1

SELECT *
FROM Gender

-- "Boutique" Sample Database created by Batuhan O�lak��o�lu
