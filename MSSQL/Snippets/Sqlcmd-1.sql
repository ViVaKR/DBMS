--* SqlCmd sqllocaldb 연결
-- (1) sqlcmd -S "(localdb)\mssqllocalDB" -d "C:\abc\db\TestDB.MDF"

--? 날자별 백업 
declare @dir nvarchar(100)
set @dir=N'D:\backup\database\DB-'+convert(nvarchar(20), getDate(), 112) +N'.bak'
BACKUP DATABASE dzicube TO DISK = @dir
GO

--? SQLCMD 로그인 옵션
--* `E` 트러스트(trustered) 연결, 기본값이며 –E 생략 시 트러스트된 연결 옵션 사용
--* `S` 서버지정
--* `U` 사용자 로그인 ID
--* `P` 사용자 로그인 PWD
--* `H` 워크스테이션 이름. 각 서버의 이름을 지정하여 접속 가능
--* `d` 데이터베이스 지정

--! 팁
--* sqlcmd -E -O "output할 파일의 절대경로" -Q "실행할 쿼리" -f 65001 -h-1 -W

--? `o` : output할 파일명 (가급적 절대경로)
--? `Q` : 실행할 쿼리 (SP도 가능함)
--? `f` 65001 : 이것이 파일로 output하면서 ANSI를 utf-8로 변환해주는 옵션이다.
--? `h-1` : sqlcmd로 쿼리 결과를 파일로 뽑아낼 경우 상단에 ----------------- 가 붙는다. 이걸 제거해주는 역할
--? `W` : sqlcmd로 쿼리 결과를 파일로 뽑는 경우 어마어마하게 공백이 추가되어 쓸데 없이 byte수가 늘어난다. 공백을 제거해주는 역할을 한다.

--! select db-name()

--(1) sqlprod1 = principle
--(2) sqlprod2 = mirror
--(3) tbssql - witness

-- End Line --
