use Movie
go

-- IF 구문
exec spVariableData @InfoType = 'All' -- All, Award, Financial
exec spVariableData @InfoType = 'Award'
exec spVariableData @InfoType = 'Financial'
exec spVariableData @InfoType = ''

use Movies
go

begin try
begin tran trnAll

-- (3) Output Parameter
begin tran
declare @Names nvarchar(max)
declare @Count int

exec spFilmsInYear 
	@Year = 2000, 
	@FilmList = @Names output, 
	@FilmCount = @Count output
print @Names + char(10) + char(13) + '- Film Count = ' + cast(@Count as nvarchar(max))
select @Count as [Number of Films], @Names as [List of Films]
commit

-- (3-2) Output Parameter
begin tran
declare @Cnt int
exec @Cnt = spGetFilmCount @CountryId = 241
select @Cnt as [필름 수량]

-- (2) 파라미터
exec spFilmCriteria 120, 180, 'star'
	-- OR
exec spFilmCriteria  @Title = 'die', @MinLength = 130
commit tran
-- (1)
exec spFilmList

select * from tblFilm
-- drop proc spFilmCriteria
-- drop proc spFilmList
commit tran
end try
begin catch
	select
		ERROR_MESSAGE() as '오류내용'
	rollback trnAll
end catch

-- End Line --
