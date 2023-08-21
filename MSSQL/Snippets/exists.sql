

USE [ViVa]  
GO


SELECT * FROM 주행일지
WHERE EXISTS (SELECT * 
FROM 시험차량 WHERE 주행일지.차량작업번호 = 시험차량.작업번호)