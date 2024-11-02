use Movies
go

-- Create Temp Table (#)
Create Table #TempFilms
(
	Title nvarchar(max),
	REleaseDate Datetime
)

Insert into #TempFilms
select
	FilmName,
	FilmReleaseDate
from
	tblFilm
where 
	FilmName like '%star%'

select *
from #TempFilms

-- Create Gobal Temp Table (##)
Create Table ##TempFilms
(
	Title nvarchar(max),
	ReleaseDate Datetime
)

Insert into ##TempFilms
select
	FilmName,
	FilmReleaseDate
from
	tblFilm
where 
	FilmName like '%star%'

select *
from ##TempFilms

-- Drop
drop table #TempFilms
drop table ##TempFilms

Create Table #TempFilms
(
	Title nvarchar(max),
	Release datetime
)


go
-- Stored Prcedure
alter proc spInsertIntoTemp(@Text as nvarchar(max))
as
begin
	insert into #TempFilms
	select
		FilmName,
		FilmReleaseDate
	From
		tblFilm
	Where FilmName like	'%' + @Text + '%'

end
go

alter proc spSelectFromTemp
as
begin
	select
		*
	from
		#TempFilms
	order by 
		Release desc

end
go
exec spInsertIntoTemp 'star'
exec spSelectFromTemp
go
