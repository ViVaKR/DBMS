-- 업체번호 -----------------------------------------------------------------------
use DMS
go

declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select 업체 from  통합_타이어마모
	for update of 업체번호
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin
			update 통합_타이어마모 set 업체번호 =  
			case @Cname
				when N'세광' then 10003
				when N'오토' then 10002
				when N'현대' then 10001
				else 10004
			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs

go

-- 차량작업번호 ---------------------------------------------------------------------
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

GO

update 통합_주행일지 Set 차종 = N'TQ-PE2' where 임시번호 = '4081' 
 and 차량작업번호 is null and 업체 = N'세광'

select 업체, 차량작업번호, 차종, 임시번호 from 통합_주행일지 where 임시번호 = '4081' 

select 차종, 임시번호, 업체 from 통합_주행일지 where 차량작업번호 is null group by 차종, 임시번호, 업체  order by 임시번호

GO

update 통합_오일소모 set 비중 = 0 where 비중 is null
select * from 통합_오일소모 where 비중 is null

select 오일종류 from 통합_오일소모 group by 오일종류
select * from 엔진오일

update 통합_오일소모 set 오일번호= 1002 where 오일번호 is null
select * from 통합_오일소모

-- 테이블 복사
select * into 복사_문제점 from 통합_문제점
select * from 복사_문제점

-- 데이터 복사 
BEGIN TRANSACTION [Tran1]

  BEGIN TRY

      INSERT INTO 타이어점검
	  SELECT * 
	  FROM 통합_타이어점검

      COMMIT TRANSACTION [Tran1]

  END TRY

  BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran1]

  END CATCH 

GO

-- 코스번호 ---------------------------------------------------------------------
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

GO

-- 작업번호 재설정 ---------------------------------------------------------------------
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

GO

-- 차량작업번호 임시번호 만으로 만들기
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

GO

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

GO

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
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran2]

	  	close cs
	deallocate cs
END CATCH 

GO

-- 타입변경 ------------------------------------------------
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

GO

update 통합_주행일지
set 통합_주행일지.톨비지불방식 = B.톨비
from 통합_주행일지 as A,
(select 작업번호, 톨비 from 통합_주행일지 where 톨비 = N'히이패스') as B
where A.작업번호 = B.작업번호

GO

-- Select 문으로 업데이트 하기

update 통합_주행일지 
set 통합_주행일지.운전조건 = B.운전조건
from 통합_주행일지 as A, 
(select 작업번호, 운전조건 from 백업_주행일지  where 각부작동 is null) as B
Where A.작업번호 = B.작업번호

GO

-- 오일소모 수정하기
use DMS
go

--declare @Liter	int
--declare @kg		int
--declare @add	int
--declare	@drein	int
--declare	@rein	int

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
			fetch next from cs into @Liter, @kg, @add, @drein, @rein
		end
close cs
deallocate cs

GO

truncate table 엔진오일
go
dbcc checkident(N'엔진오일', reseed, 0)
go

-- 엔진오일 번호 ------------------------------------------------
use DMS
go

declare @kind nvarchar(100)

declare cs cursor for
	select 오일종류 from  오일소모
	for update of 오일번호
open cs
	fetch next from cs into @kind
	while @@FETCH_STATUS = 0
		begin
				begin
					update 오일소모 set 오일번호 = 
					(select 오일번호 from 엔진오일 Where 오일이름 = @kind)
					where current of cs
				end
			fetch next from cs into @kind
		end
close cs
deallocate cs

GO

-- 타이어제품번호 만들기
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
-- ==========================================================================================

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

------계절구분 번호
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

-- End Line --
