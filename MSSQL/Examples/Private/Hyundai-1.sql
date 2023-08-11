-- 기본 모형
use Movies
go
-- Declaring a cusor
Declare @Id int
Declare @Name nvarchar(max)
Declare @Date Datetime

Declare Cs Cursor Scroll
	For select FilmID, FilmName, FilmReleaseDate From tblFilm

Open Cs
	
	Fetch next from Cs -- (1) 순방향 1개씩 이동
		into @Id, @Name, @Date
	-- Fetch First From Cs
	-- Fetch Last From Cs -- (3) 역순
	-- Fetch Absolute 10 From Cs -- (4) 처음 부터 10개씩 순방향으로 건너 뛰기
	-- Fetch Absolute -10 From Cs -- (5) 끝에서 부터 10개씩 역방향으로 건너뛰기

	While @@Fetch_Status = 0
		Begin
			-- Call Proc
			Exec spListCharacters @Id, @Name, @Date

			Fetch next from Cs -- (1)
				into @Id, @Name, @Date

		-- Fetch Prior From Cs -- (3)
		-- Fetch Relative 10 From Cs -- (4)
		-- Fetch Relative -10 From Cs -- (5)
		End
Close Cs
Deallocate Cs
go

-- Update 기본 모형
Declare @FilmOscars int
Declare @TotalOscars int

Set @TotalOscars = 0

Declare Cs Cursor  -- Global(Default) or Local, Scroll, Forward_Only, Fast_Forward, Static, KeySet, Dynamic, REad_Only, Scroll_Locks, Optimistic, 
	For Select FilmOscarWins From tblFilm
	For Update Of FilmCumulativeOscars
Open Cs
	Fetch Next From Cs into @FilmOscars

	While @@FETCH_STATUS = 0
	Begin
		Set @TotalOscars += @FilmOscars
		
		Update tblFilm
		Set FilmCumulativeOscars = @TotalOscars
		Where Current of Cs -- 현재 커서 행

		Fetch Next From Cs into @FilmOscars
	End

Close Cs
Deallocate Cs
Go

-- 업체번호 만들기 --
use DMS
go

declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select 업체 from  테이블1
	for update of 번호

open cs

	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin

			update 테이블1 set 번호 =  
			case @Cname
				when N'업체3' then 10003
				when N'업체2' then 10002
				when N'업체1' then 10001
				else 10004
			end
			where current of cs
			
			fetch next from cs into @Cname

		end

close cs
deallocate cs
go

-- 합계 구하기
use Movies
go
	declare @Dollars int
	declare @Sum int = 0
declare cs cursor for
	select FilmStudioID from tblFilm 
open cs
	fetch next from cs into @Dollars

	while @@FETCH_STATUS = 0
	begin
		if @Dollars is null
			set @Dollars = 0;

			set @Sum= @Sum + @Dollars
		
		fetch next from cs into @Dollars
	end

	select cast(@Sum as nchar(20))

close cs
deallocate cs
go

-- 차량작업번호 --
use DMS
go

declare @Cname nvarchar(8)
declare @CarKind nvarchar(255)
declare @CarKindSum nvarchar(max)

declare cs cursor for
	select 임시번호, 차종 from  통합_휠얼라인먼트_스팩
	for update of 차량작업번호

open cs
	fetch next from cs into @Cname, @CarKind
	while @@FETCH_STATUS = 0
		begin
			if @CarKind = '-'	-- 차종 정보가 없을 때
				begin
					set @CarKindSum = @Cname
					update 통합_정비일지 set 차량작업번호 = 
					(select top 1 작업번호 from 시험차량 Where 임시번호 = @CarKindSum order by 작업번호)
					where current of cs
				end
			else
				begin
					set @CarKindSum = @Cname + @CarKind
					update 통합_정비일지 set 차량작업번호 = 
					(select top 1 작업번호 from 시험차량 Where (임시번호 + 차종) = @CarKindSum order by 작업번호)
					where current of cs
				end

			fetch next from cs into @Cname, @CarKind
		end

close cs
deallocate cs
go

 -- 코스번호 --
use DMS
go

declare @Cs nvarchar(50)
declare @Comp int

declare cs cursor for
	select 코스, 업체번호 from  통합_전기차
	for update of 코스번호
open cs
	fetch next from cs into @Cs, @Comp

	while @@FETCH_STATUS = 0
		begin

			update 통합_전기차 set 코스번호 = 
			(select 코스번호 from 코스정의 Where 코스명 = @Cs and 업체 = @Comp)
			where current of cs

			fetch next from cs into @Cs, @Comp
		end
close cs
deallocate cs
go

 -- 작업번호 재설정 --
use DMS
go
declare @TempCarNumber nvarchar(8)
declare @Number int

declare @Num int
	set @Num = 1000000001

declare cs cursor for
	select 임시번호, 작업번호 from 통합_전기차 order by 날짜
	for update of 차량작업번호

open cs 
	fetch next from cs into  @TempCarNumber, @Number

	while @@FETCH_STATUS = 0
		begin
			update 통합_전기차 set 차량작업번호= @Num
			where current of cs

			fetch next from cs into @TempCarNumber, @Number
			set @Num = @Num + 1
		end
close cs
deallocate cs

go

-- 차량작업번호 임시번호 만으로 만들기--
use DMS
go

declare @TempCarNumber nvarchar(8)
declare @CompNumber int
declare @CarKind	nvarchar(20)

declare cs cursor for
	select 임시번호, 업체번호 from  통합_타이어마모
	for update of 차량작업번호
open cs
	fetch next from cs into @TempCarNumber, @CompNumber
	while @@FETCH_STATUS = 0
		begin
				begin
					update 통합_타이어마모 set 차량작업번호 = 
					(select top 1 작업번호 from 시험차량 Where 임시번호 = @TempCarNumber and 업체번호 = @CompNumber  order by 작업번호)
					where current of cs
				end
			fetch next from cs into @TempCarNumber, @CompNumber
		end
close cs
deallocate cs

-- 운전자 번호 ------------------------------------------------
use DMS
go

declare @dv nvarchar(20)
declare @comp int

declare cs cursor for
	select 운전자, 업체번호 from  통합_주행일지
	for update of 운전자번호
open cs
	fetch next from cs into @dv, @comp
	while @@FETCH_STATUS = 0
		begin
				begin
					update 통합_주행일지 set 운전자번호 = 
					(select top 1 운전자번호 from 운전자정보 Where 이름 = @dv and 업체 = @comp)
					where current of cs
				end
			fetch next from cs into @dv, @comp
		end
close cs
deallocate cs
go
-------------------------------------------------------------------




















-- 시각변경 ------------------------------------------------
use DMS
go

begin tran Tran2
begin try
	declare @t1 nvarchar(10)
	declare @t2 nvarchar(50)

	declare cs cursor for
		select 도시각임시 from  통합_주행일지
		for update of 도시각
	open cs
		fetch next from cs into @t1
		while @@FETCH_STATUS = 0
			begin
					begin
						update 통합_주행일지 set 도시각 = (CONVERT(nvarchar, @t1, 108)) where current of cs
						-- update 통합_주행일지 set 도시각임시 = (select REPLACE(@t1, 'ㅣ', '')) where current of cs
					end
				fetch next from cs into @t1
			end
	close cs
	deallocate cs
      COMMIT TRANSACTION [Tran2]
END TRY
BEGIN CATCH
	SELECT
        ERROR_NUMBER() AS N'오류번호',
		ERROR_STATE() AS N'오류상태',
		ERROR_SEVERITY() AS N'오류 심각도',
		ERROR_PROCEDURE() AS N'오류절차',
		ERROR_LINE() AS N'오류발생 줄번호',
        ERROR_MESSAGE() as N'오류발생 내용';
      ROLLBACK TRANSACTION [Tran2]

	  	close cs
	deallocate cs
END CATCH 
go

-- 타입변경 --
use DMS
go

begin tran Tran3
begin try
	declare @t1 nvarchar(10)
	declare @t2 nvarchar(50)

	declare cs cursor for
		select 톨비잔액 from  통합_주행일지
		for update of 톨잔
	open cs
		fetch next from cs into @t1
		while @@FETCH_STATUS = 0
			begin
					begin
						update 통합_주행일지 set 톨잔 = (select cast(round(CONVERT(real, @t1), 0) as int))
						-- update 통합_주행일지 set 트립운 = (select REPLACE(@t1, ',','.'))
						 where current of cs
					end
				fetch next from cs into @t1
			end
	close cs
	deallocate cs
      COMMIT TRANSACTION [Tran3]
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran3]

	  	close cs
	deallocate cs
END CATCH 
--
declare @jno	int
declare @tname	nvarchar(128)

declare cs cursor for
	select 작업번호 from  오일소모
	for update of 오일소모량_리터, 오일소모량_키로그램, 보충량, 드레인량, 재주입량
open cs
	fetch next from cs into @Liter, @kg, @add, @drein, @rein
	while @@FETCH_STATUS = 0
		begin
			EXEC('UPDATE [' + @tname + '] SET item = UPPER(item)');

				update 오일소모 set 오일소모량_리터 = @Liter, 오일소모량_키로그램 = @kg, 보충량 = @drein, 드레인량 = @drein, 재주입량 = @rein
				 where current of cs

			fetch next from cs into @Liter, @kg, @add, @drein, @rein
		end
close cs
deallocate cs

-- 엔진오일 번호 --
use Hyundai
go

declare @num1 int
declare @num2 int

declare cs cursor for
	select 담당자번호, 소속개발팀 from  담당자
	for update of 소속개발팀
open cs
	fetch next from cs into @num1, @num2
	while @@FETCH_STATUS = 0
		begin
				begin
					update 담당자 set 소속개발팀 = 
					(select 팀번호 from 시험차량 Where 담당자번호 = @num1)
					where current of cs
				end
			fetch next from cs into @kind
		end
close cs
deallocate cs


select 담당자번호, 팀번호 from 시험차량 order by 담당자번호 desc

select 담당자번호, 소속개발팀 from 담당자 order by 담당자번호 desc

-- 타이어제품번호 만들기--
use DMS
go

declare @TireMaker int
declare @Spec nvarchar(100)

declare cs cursor for
	select 타이어업체번호, 규격 from  통합_타이어마모
	for update of 타이어제품번호
open cs
	fetch next from cs into @TireMaker, @Spec
	while @@FETCH_STATUS = 0
		begin
				begin
					update 통합_타이어마모 set 타이어제품번호 = 
					(select top 1 작업번호 from 타이어제품정보 Where 업체 = @TireMaker and 규격 = @Spec  order by 작업번호)
					where current of cs
				end
			fetch next from cs into @TireMaker, @Spec
		end
close cs
deallocate cs
go

-- 타이어 업체번호 -----------------------------------------------------------------------
use DMS
go

declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select 타이어업체 from  통합_타이어마모
	for update of 타이어업체번호
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin

			update 통합_타이어마모 set 타이어업체번호 =  
			case @Cname
				when N'세광' then 101
				when N'아폴로' then 102
				when N'정신' then 103
				when N'콘티넨탈' then 104
				when N'피렐리' then 105
				when N'한국' then 106
				when N'굿이어' then 107
				when N'금호' then 108
				when N'넥센' then 109
				when N'미쉐린'then 110
				when N'브릿지스톤' then 111
				when N'APOLLO' then 112
				when N'CEAT' then 113
				when N'MAXXIS' then 114
				when N'MRF' then 115

			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs
go

use DMS
go
------계절구분 번호--
declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select 계절구분 from  통합_타이어마모
	for update of 계절
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin

			update 통합_타이어마모 set 계절 =  
			case @Cname
				when N'썸머' then 0
				when N'올시즌' then 1
			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs
go
----------------------------------------------------------------------
use Hyundai
go

declare @no1 int

declare cs cursor for 
	select 담당자번호 from 담당자
	for update of 소속개발팀
open cs
	fetch next from cs into @no1
		while @@FETCH_STATUS = 0
		begin
				begin
					update 담당자 set 소속개발팀 = (select 팀번호 from 시험차량 Where 담당자번호 = @no1 group by 담당자번호, 팀번호)
					where current of cs
				end
			fetch next from cs into @no1
		end
close cs
deallocate cs
go

select 담당자번호, 팀번호 from 시험차량 group by 담당자번호, 팀번호 order by 담당자번호 desc


select 담당자번호, 소속개발팀 from 담당자 order by 담당자번호 desc


select 팀번호 from 시험차량 group by 담당자번호, 팀번호
