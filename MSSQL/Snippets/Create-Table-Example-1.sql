
USE PlayGround;
GO

IF OBJECT_ID(N'Customer', 'U') IS NULL
BEGIN
	create table dbo.Customer
	(
		Id INT PRIMARY KEY IDENTITY(1,1),
		FullName NVARCHAR(50) NOT NULL
	);
END
ELSE
BEGIN
	PRINT '== 이미 있는 테이블입니다. =='
END
GO
-- Enc Line --
