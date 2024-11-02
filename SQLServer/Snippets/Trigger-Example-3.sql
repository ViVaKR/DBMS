-- DML, DDL, Logon
-- 1. DML : Insert, Update, Delete
Use Movies
go

Alter Trigger trgActorChanged
On tblActor
After Insert, Update, Delete
as
Begin

	Print 'Data was changed in the Actor table'

End

go

use Movies
go

-- 실행
Use Movies
go

Begin Try

Begin Tran InsertActor
set nocount on

	insert into tblActor
	(ActorID, ActorName)
values
	(999, 'Test Actor')

	update tblActor
	Set ActorDOB = GETDATE()
	where ActorID = 999

	Commit Tran InsertActor
End Try

Begin Catch
	Select
	Error_Message() As ErrorMessage

	Rollback Tran InsertActor
End Catch
go

-- trgActorChanged
select *
from tblActor
where ActorID = 999

Delete From tblActor Where ActorID = 999

-- RaisError 
USE [Movies]
GO

ALTER Trigger [dbo].[trgActorInserted]
on [dbo].[tblActor]
instead of insert
as
begin
	raiserror ('No more actors can be inserted', 16, 1)
end

-- End Line --
