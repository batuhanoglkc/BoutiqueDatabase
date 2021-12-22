-- ALAN 1
-- BU ALANDA; tablo oluþturma , insert ve update iþlemleri , key ve constraint tanýmlama vb. iþlemler yapýlmýþtýr.

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
SET Description = 'Atkýlar,Bereler,Eldivenler,Þallar'
WHERE CategoryID = 6

SELECT *
FROM [dbo].[Category]

INSERT INTO Supplier
VALUES('Tarýk Jeans','Antalya','tarikjeans@gmail.com',NULL)

INSERT INTO Supplier
VALUES('Fatih Gömlek','Antalya',NULL,'05312504466')

INSERT INTO Supplier
VALUES('Kasha','Ýstanbul','kashabusiness@gmail.com','08504447484')

INSERT INTO Supplier(SupplierName,City)
VALUES('Bosco Giyim','Bursa')

SELECT *
FROM Supplier

SELECT CategoryID,CategoryName,G.Name
FROM Category AS C
INNER JOIN Gender AS G ON C.GenderID = G.GenderID

INSERT INTO [dbo].[Product]
VALUES('Lacoste Pembe Gömlek',40,NULL,2,'Pembe',2)

INSERT INTO [dbo].[Product]
VALUES('Gant Lacivert Keten Gömlek',45,NULL,2,'Lacivert',4)

INSERT INTO [dbo].[Product]
VALUES('Gri Örgü Bere',5,NULL,4,'Gri',6)

ALTER TABLE [dbo].[Supplier]
ADD CONSTRAINT DF_Telephone DEFAULT NULL FOR [Telephone]

ALTER TABLE [dbo].[Category]
ADD CONSTRAINT UK_CategoryIDGenderID UNIQUE (CategoryID,GenderID)

INSERT INTO [dbo].[Employee]
VALUES('Alican','Yýlmaz','1990-10-08','2021-12-21')

INSERT INTO [dbo].[Employee]
VALUES ('Buse','Kabak','1997-03-14','2021-10-08')

INSERT INTO [dbo].[Employee]
VALUES ('Selin','Yýlmaz','1993-07-17','2020-07-20')

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
-- BU ALANDA; proje kapsamýnda yapýlacak ek tablo oluþturma , view oluþturma , sorgular
-- stored procedure , trigger vb. bulunmaktadýr.

-- Daha sonra üzerinde sorgu çalýþtýrmak için geçici bir tablo oluþturuyorum
SELECT P.ProductID,P.ProductName,P.Color,P.Price,C.CategoryName,G.Name,S.SupplierName,S.City
INTO A1 -- Ürün Detay Tablosu 
FROM [dbo].[Product] AS P
INNER JOIN [dbo].[Category] AS C ON P.CategoryID = C.CategoryID
INNER JOIN [dbo].[Gender] AS G ON C.GenderID = G.GenderID
INNER JOIN [dbo].[Supplier] AS S ON P.SupplierID = S.SupplierID

-- Daha sonra bu tablo üzerinde sorgularýn daha hýzlý çalýþmasý için birkaç index tanýmlýyorum
CREATE NONCLUSTERED INDEX IX_Color ON [dbo].[A1] (Color)
CREATE NONCLUSTERED INDEX IX_Name ON [dbo].[A1] (Name)
CREATE CLUSTERED INDEX IX_ProductID ON [dbo].[A1] (ProductID)

-- Sorgu: Fiyatý 40 Dolar'dan fazla olan ürünler 
SELECT *
FROM [dbo].[A1]
WHERE Price > 40

-- Sorgu: Kadýn Reyonunda veya Gömlek Kategorisindeki Ürünlerin Fiyatlarý
SELECT A1.Price
FROM [dbo].[A1] 
WHERE A1.Name = 'Kadýn' OR A1.CategoryName = 'Gömlek'

-- Sorgu: Antalya þehrindeki tedarikçilerden kýrmýzý veya siyah ürün saðlayan tedarikçilerin isimleri
SELECT A1.SupplierName
FROM [dbo].[A1]
WHERE A1.Color IN ('Kýrmýzý','Siyah') AND A1.City = 'Antalya'

-- Sorgu: Reyon baþýna ürünlerin ortalama fiyatlarý 
SELECT Name,AVG(Price)
FROM [dbo].[A1]
GROUP BY Name


-- Satýþ detaylarýyla alakalý bir toplu tablo oluþturuyorum
SELECT SD.SalesID,(E.FirstName+E.LastName) AS Employee,SD.ProductID,P.ProductName,SD.Price,SD.Quantity,(SD.Price*SD.Quantity) AS Amount
INTO A2 -- Satýþ Detay Tablosu
FROM SalesDetail AS SD
INNER JOIN Sales AS S ON SD.SalesID = S.SalesID
INNER JOIN Employee AS E ON S.EmployeeID = E.EmployeeID
INNER JOIN Product AS P ON SD.ProductID = P.ProductID

-- A2 adlý tablodan üzerinde sorgu çalýþtýrmak için bir view oluþturuyorum.
CREATE VIEW V1 -- Satýþ Toplamý & Çalýþan Kýrýlýmý 
AS
SELECT A2.Employee,A2.Amount
FROM [dbo].[A2]

SELECT *
FROM [dbo].[V1]

-- Sorgu: Hiç satýlmayan ürünler
SELECT *
FROM [dbo].[Product] AS P
LEFT JOIN [dbo].[SalesDetail] AS SD ON P.ProductID = SD.ProductID
LEFT JOIN [dbo].[Sales] AS S ON SD.SalesID = S.SalesID
WHERE S.SalesID IS NULL

-- Sorgu: Çalýþan baþýna yapýlan toplam satýþ tutarý
SELECT V1.Employee,SUM(V1.Amount) AS TotalSalesAmount
FROM [dbo].[V1]
GROUP BY V1.Employee
ORDER BY TotalSalesAmount DESC;

-- Sorgu: Ürün baþýna yapýlan satýþ adedi ve toplam kazanç
SELECT ProductID,ProductName,SUM(Quantity) AS Adet ,SUM(Amount) AS ToplamKazanc
FROM [dbo].[A2]
GROUP BY ProductID,ProductName
ORDER BY ToplamKazanc DESC

-- Bonus Sorgu: Antalya þehri dýþýndan tedarik edilen ürünleri satan çalýþanlar ***
SELECT DISTINCT(E.FirstName+' '+E.LastName)
FROM [dbo].[Employee] AS E
INNER JOIN [dbo].[Sales] AS S ON E.EmployeeID = S.EmployeeID
INNER JOIN [dbo].[SalesDetail] AS SD ON SD.SalesID = S.SalesID
INNER JOIN [dbo].[Product] AS P ON P.ProductID = SD.ProductID
INNER JOIN [dbo].[Supplier] AS SP ON P.SupplierID = SP.SupplierID
WHERE SP.City != 'Antalya'

-- Bu sorguyu daha rahat çalýþtýrabileceðimiz 5 tablonun birleþimi olan bir view oluþturalým
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

-- Procedure Tanýmlamalarý

-- Delete / parametre olarak EmployeeID alýr.
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
			PRINT('Veritabanýndan calisan silinemez...')
			PRINT('CalisanGuncelle komutu ile calisani inaktif hale getirebilirsiniz.')
			ROLLBACK TRANSACTION
			END

EXEC [dbo].[Employee_CalisanSil] 1

SELECT *
FROM Employee

-- Update / parametre olarak EmployeeID ve isActive için boolean deðeri alýr.
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


-- Insert / 5 parametre olarak eklenecek çalýþanýn bilgilerini alýr.
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

-- Trigger Tanýmlama

-- Gender silinmesini engelleyen bir trigger tanýmlýyorum.

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
            ('Veritabanýndan Gender silinemez...!', -- Message
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

-- "Boutique" Sample Database created by Batuhan Oðlakçýoðlu
