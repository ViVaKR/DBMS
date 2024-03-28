--* Pivot Table examples *-- 
use Movies
go

select * from
(select
	YEAR(f.FilmReleaseDate) as [FilmYear],
	DATENAME(MM, FilmReleaseDate) as [FilmMonth],
	c.CountryName,
	f.FilmID
from
	tblCountry as c inner join
	tblFilm as f
	on c.CountryID = f.FilmCountryID
) as BaseData
pivot 
(
	count(FilmID)
	for CountryName
	in 
	(	[China]
		,[France]
		,[Korea]
		,[New Zealand]
		,[United Kingdom]
		,[United States]
		,[Germany]
		,[Russia]
	)
) as PivotTable
order by FilmYear desc

go

-- 괄호 서식 만들기
select
	',' + QUOTENAME(CountryName)
from
	tblCountry

select
	QUOTENAME(CountryName, '()')
from
	tblCountry

select
	QUOTENAME(CountryName, '''')
from
	tblCountry

-- Dynamic Pivot Table, 동적인 피벗테이블 만들기
declare @CountryNames nvarchar(max) = ''
declare @SQL nvarchar(max) = ''

select @CountryNames += QUOTENAME(CountryName) + ', ' from tblCountry
set @CountryNames = LEFT(@CountryNames, len(@CountryNames)-1) -- 왼쪽 한 글자 지우기

set @SQL = 
'select * from
(select
	YEAR(f.FilmReleaseDate) as [FilmYear],
	DATENAME(MM, FilmReleaseDate) as [FilmMonth],
	c.CountryName,
	f.FilmID
from
	tblCountry as c inner join
	tblFilm as f
	on c.CountryID = f.FilmCountryID
) as BaseData
pivot 
(
	count(FilmID)
	for CountryName
	in (' + @CountryNames + ')
) as PivotTable
order by FilmYear desc'

exec sp_executesql @SQL

-- End Line --
