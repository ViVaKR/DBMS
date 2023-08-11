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

select * from 통합_브레이크패드_신 where 업체번호 is null
select * from 통합_브레이크패드_신 where len(업체번호) <> 5

go

select * from 통합_주행일지 where 운전자 is null
select COUNT(*) from 통합_배기계리크

select * from 통합_중량하이트

select * from 브레이크패드
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
-- ==========================================================================================
go

update 통합_주행일지 Set 차종 = N'TQ-PE2' where 임시번호 = '4081' 
 and 차량작업번호 is null and 업체 = N'세광'

select 업체, 차량작업번호, 차종, 임시번호 from 통합_주행일지 where 임시번호 = '4081' 

select 차종, 임시번호, 업체 from 통합_주행일지 where 차량작업번호 is null group by 차종, 임시번호, 업체  order by 임시번호

go
---------------------------------------------------------------------------------------
update 통합_오일소모 set 비중 = 0 where 비중 is null
select * from 통합_오일소모 where 비중 is null

select 오일종류 from 통합_오일소모 group by 오일종류
select * from 엔진오일

update 통합_오일소모 set 오일번호= 1002 where 오일번호 is null
select * from 통합_오일소모

-- 테이블 복사
select * into 복사_문제점 from 통합_문제점
select * from 복사_문제점

-- 데이터 복사 --------------------------------------------
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
----------------------------------------------------------
 go

 select * from 타이어제품정보 order by 작업번호 desc

 go

 declare @Tmp nvarchar(8)
 set @Tmp = '4104'
 update 통합_브레이크패드 set 차종 = 'LF' where 임시번호 = @Tmp

 select * from 통합_브레이크패드 where 임시번호 = @Tmp

 select * from 통합_브레이크패드 where 임시번호 = '4104'

 select * from 통합_브레이크패드 where 차량작업번호 is null

  select * from 통합_브레이크패드 where len(차량작업번호) <> 10

 select * from 통합_에이밍

 update 통합_에이밍 set 구분 = '-' where 구분 is null
 select * from 통합_에이밍 where 구분 is null

 select * from 통합_전기차충전

 select * from 전기차충전

 select * from 코스정의



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

-------------------------------------------------------------------
go

select * from 코스정의

select * from 통합_주행일지
--declare @t nvarchar(20)
-- set @t = N'가상코스'
--update 통합_주행일지 set 주행코스 = @t where 주행코스 = '가상코스'

declare @t nvarchar(20)
 set @t = N'가상코스'
update 통합_주행일지 set 주행코스 = N'무상(정비)' Where 주행코스 =N' 무상(정비)'
select 주행코스 from 통합_주행일지 where 코스번호 is null group by 주행코스
-- ===============================================================================================

-- select * into 복사_전기차충전 from 통합_전기차충전

select * from 복사_전기차충전 order by 코스명

select 시간대 from 통합_전기차충전 group by 시간대

go

update 통합_전기차충전 set 시간대 = '2' where 시간대 = N'오후'

select * from 통합_전기차충전 order by 날짜

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

go

select * from 통합_휠얼라인먼트_스팩

select * from 통합_전기차충전 where 코스번호 is null
-- ===============================================================================================

select * from 통합_주행일지

-- 차량작업번호 임시번호 만으로 만들기------------------------------------------------
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
-- ==========================================================================================
select * from 통합_브레이크패드_신 where 차량작업번호 is null

select * from 통합_점화플러그 where 임시번호 = '4491'
select * from 시험차량 where 임시번호 = '4491'

update 통합_중량하이트 set 점검오도 = 0 where 점검오도 is null

select * from 통합_중량하이트 where 업체 not in (10002, 10003)

select 임시번호 from 통합_정비일지 where 차량작업번호 is null group by 임시번호 order by 임시번호

select 차종, 임시번호, 업체번호 from 통합_휠얼라인먼트_측정 where 차량작업번호 is null group by 차종, 임시번호, 업체번호 order by 임시번호

go

update 통합_주행일지
	set 차량작업번호 = 1000001090 
	where 임시번호 = '9275' 
	and 업체번호 = 10002
	and 차량작업번호 is null
	-- and 차종 = N'VG' 

go

select 차종, 임시번호, 업체번호
	from 통합_주행일지
	where 차량작업번호 is null 
	group by 차종, 임시번호, 업체번호 
	order by 임시번호

select * from 통합_주행일지 order by 작업번호 desc

select 운전자, count(운전자) from 통합_주행일지 group by 운전자
select * from 운전자정보

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
-- ==========================================================================================
update 통합_주행일지 set 운전자 = N'김기성' where 운전자 = N' 김기성'

select 업체, 주행코스 from 통합_주행일지 where 코스번호 is null group by 주행코스, 업체

select * from 통합_주행일지 order by 작업번호 desc


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
-- ========================================================================================
update 통합_주행일지 set 도착오도 = '0' where 도착오도 = '0km'

select 도시각임시 from 통합_주행일지 where 작업

update 통합_주행일지 set 외기온 = 0 where 외기온 is null

select 작업번호, 도착오도 from 통합_주행일지
where 
	CASE WHEN IsNumeric(도착오도) = 1 
	THEN CASE WHEN CAST(도착오도 AS FLOAT) <> CAST(CAST(도착오도 AS FLOAT) AS INT) 
	THEN 1 END ELSE 1 END = 1


update 통합_주행일지 set 외기온 = '' WHERE 외기온 IS NOT NULL AND ISNUMERIC(외기온) = 0

SELECT 날씨 FROM 통합_주행일지 WHERE 날씨 IS NOT NULL AND ISNUMERIC(날씨) = 0 group by 날씨

update 통합_주행일지 set 날씨 = 4 where 날씨 = N'눈'
select 날씨 from 통합_주행일지 group by 날씨

update 통합_주행일지 set 적재조건 = '0' where 적재조건 = ''
select 적재조건 from 통합_주행일지 group by 적재조건 order by 적재조건

update 통합_주행일지 set 적재조건 = '0' where 적재조건 = ''

update 통합_주행일지 set 위장막 = '2' where 위장막 = N'유'
select  위장막 from 통합_주행일지 group by 위장막 order by 위장막


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
-- ===========================================================================

update 통합_주행일지 set 위장막 = 0 where 위장막 is null

select 위장막 from 통합_주행일지 group by 위장막


--
go
update 통합_주행일지
set 통합_주행일지.톨비지불방식 = B.톨비
from 통합_주행일지 as A,
(select 작업번호, 톨비 from 통합_주행일지 where 톨비 = N'히이패스') as B
where A.작업번호 = B.작업번호
go
--select 운전조건 from 백업_주행일지 where 각부작동 is null group by 운전조건

--update 백업_주행일지 set 운전조건 = N'4' where 운전조건 = N'스포츠'

---- Select 문으로 업데이트 하기
--update 통합_주행일지 
--set 통합_주행일지.운전조건 = B.운전조건
--from 통합_주행일지 as A, 
-- (select 작업번호, 운전조건 from 백업_주행일지  where 각부작동 is null) as B
-- Where A.작업번호 = B.작업번호

--냉각수량
--양호
--L 미만
--측정불가
--F
--L
--F 초과
--중간


-- select 
--  운전조건
-- from 통합_주행일지
-- Where 각부작동 is null
-- group by 운전조건

select 작업번호, 톨비지불방식, 톨비 from 통합_주행일지 where 톨비 = N'히이패스'
insert into 주행일지 select * from 통합_주행일지

select * from 통합_중량하이트 order by 작업번호 desc

select * from  복사_중량하이트


insert into 중량하이트 select * from 통합_중량하이트


select * from 중량하이트

select * from 점화플러그

select * from 통합_점화플러그



update 통합_휠얼라인먼트_스팩 set 임시번호 = 6372, 차량작업번호 = 1000000686 where 차량작업번호 is null and 임시번호 = '6372(RB)'

update 통합_휠얼라인먼트_스팩 set 보고서용 = 0 

select * from 통합_휠얼라인먼트_스팩 where 차량작업번호 = 1000000808

select * from 휠얼라인먼트_측정 where 차량작업번호 = 1000000808


-- 오일소모 수정하기 ---------------------------------------------------------------------
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

				--update 오일소모 set 오일소모량_리터 = @Liter, 오일소모량_키로그램 = @kg, 보충량 = @drein, 드레인량 = @drein, 재주입량 = @rein
				-- where current of cs

			fetch next from cs into @Liter, @kg, @add, @drein, @rein
		end
close cs
deallocate cs
-- ==========================================================================================


update 오일소모 set 오일종류 = N'양산용5W-30 A5', 비고 = 비고 + N'-' where 오일종류 = N'(양산용5W-30 A5)'

select 오일종류 from 오일소모 group by 오일종류 order by 오일종류

select * from 오일소모 where 오일종류 = N'0W20'

select count(*) from 임시_오일소모_2 where 오일소모량_리터 is not null

select count(*) from 통합_임시 where 오일소모량_리터 is not null

go
insert into 오일소모 select * from 임시_오일소모_2
select * from 오일소모
go

update 임시_오일소모_2 set 오일번호 = 1
select * from 임시_오일소모_2

insert into 엔진오일 Values('-','-', '-','-')

truncate table 엔진오일
go
dbcc checkident(N'엔진오일', reseed, 0)
go

delete from 엔진오일 where 오일번호 = 1003
select * from 엔진오일

update 오일소모 set 오일종류 = '양산용5W-30 A5' where 오일종류 = N'(양산용5W-30 A5)'


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
-- ==========================================================================================

select a.오일번호, a.오일종류, b.오일번호, b.오일이름 from 오일소모 a inner join 엔진오일 b on a.오일번호 = b.오일번호 where a.오일번호 <> b.오일번호

select 오일번호, count(오일번호) from 오일소모 group by 오일번호 order by 오일번호

update 오일소모 set 오일종류 = N'양산용5W-30 A5' where 오일종류 = '???5W-30 A5'

select 오일종류 from 오일소모 group by 오일종류 Order by 오일종류

update 오일소모 set 업체 = 10002 where 작업번호 = 1000005972
select * from 오일소모 where 작업번호 = 1000005972

select * from 중량하이트 order by 작업번호 desc


select 작업번호, 임시번호, 외기온, 도착시각 from 주행일지 where 업체 = 10002 order by 작업번호 desc

select 위장막 from 주행일지 group by 위장막


-- 타이어제품번호 만들기------------------------------------------------
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
------계절구분 번호-------------------------------
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
