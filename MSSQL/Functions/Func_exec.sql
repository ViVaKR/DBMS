use Movie
go

select
	FullName,
	LEFT(FullName, charindex(' ',FullName) -1)
from
	Director

select
	FullName
	-- ,left(FullName, charindex(' ', FullName) -1)
from
	Actor

	select charindex(' ', 'ab c')

select
	Title,
	ReleaseDate,
	dbo.fnLongDate(ReleaseDate)
from
	Film

select
	FullName,
	DoB,
	dbo.fnLongDate(DoB)
from
	Actor

	DECLARE @Path NVARCHAR(max)
set @Path = N'D:\Database\Backup\Movie_full.bak'

restore filelistonly from disk = @Path