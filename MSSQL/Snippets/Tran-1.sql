-- Basic Transaction
Begin Tran
-- 시작

-- Add new records
insert into tblFilm
	(FilmName, FilmReleaseDate)
Values
	('Iron Man 3', '2013-04-25')

Select *
from tblFilm
Where FilmName = 'Iron Man 3'

RollBack Tran
-- 취소

Select *
from tblFilm
Where FilmName = 'Iron Man 3'

Commit Tran
--커밋

-- Naming Transactions
Begin Tran AddIronMan3

Insert into tblFilm
	(FilmName, FilmReleaseDate)
Values
	('Iron Man 3', '2013-04-25')

Commit Tran AddIronMan3

-- IF Conditonally Committing or Rolling Back --
Declare @IronMen int

Begin Tran AddIronMan3

Insert into tblFilm
	(FilmName, FilmReleaseDate)
Values
	('Iron Man 3', '2013-04-25')

select @IronMen = COUNT(*)
From tblFilm
Where FilmName = 'Iron Man 3'

if @IronMen > 1 
	Begin
	Rollback Tran AddIronMan3
	Print 'Iron Man 3 was already there'
	select *
	From tblFilm
	Where FilmName = 'Iron Man 3'
End
Else
	Begin
	Commit Tran AddIronMan3
	Print 'Iron Man 3 added to database'
	select *
	From tblFilm
	Where FilmName = 'Iron Man 3'
End
go

-- Using Error Handling : Try ~ Catch
Begin Try
	Begin Tran AddIM
	Insert Into tblFilm
	(FilmName, FilmReleaseDate)
Values
	('Iron Man 3', '2013-04-25')

	Update tblFilm
	Set FilmDirectorID = 4
	Where FilmName = 'Iron Man 3'

	Commit Tran AddIM
End Try
Begin Catch
	Rollback Tran AddIM
	select
	ERROR_NUMBER() as 오류번호,
	ERROR_STATE() as 오류상태,
	ERROR_SEVERITY() as 오류심각도,
	ERROR_LINE() as 오류라인번호,
	ERROR_MESSAGE() as 오류내용
End Catch

Select *
From tblFilm
Where FilmName = 'Iron Man 3'

-- Nested Transactions Basics

Begin Tran Tran1

Print @@Trancount

-- Begin Tran
Save Tran SavePoint

Print @@Trancount

Rollback Tran SavePoint
-- Commit Tran Tran2

Print @@Trancount
Commit Tran Tran1
-- Rollback Tran Tran1

-- End Line --
