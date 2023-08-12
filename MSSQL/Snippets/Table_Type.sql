CREATE TYPE MyTableType AS TABLE (ID INT, Description VARCHAR(256))
go

DECLARE @Table1 MyTableType
DECLARE @Table2 MyTableType
DECLARE @Table3 MyTableType

select * from @Table1
select * from @Table2
select * from @Table3