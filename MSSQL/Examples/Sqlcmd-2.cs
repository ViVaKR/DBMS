private void button1_Click(object sender, EventArgs e)
{
        Process RunSQLScript = new Process();
        RunSQLScript.StartInfo.FileName = "sqlcmd.exe";
        RunSQLScript.StartInfo.Arguments = "- E -S clovis-003 -i c:\test.sql -o c:\testData.txt";
        RunSQLScript.Start();

}

/* 

! 모든 데이터베이스 목록
select name from sys.databases
sp_databases

! 현재 데이터베이스
select db_name()

! 테이블목록보기
select name from sysobjects Where xtype = 'U'
select * from Information_schema.tables where table_type = 'base table'

! Collation Information
select serverproperty('collation')

! sp_helpsort
>> select serverproperty('edition')

! 변수선언 및 사용예
1> :setvar _name "Movies"
1> use $(_name);
2> go

! 열 넓이 지정
> :setvar SQLCMDMAXVARTYPEWIDTH 30
> :setvar SQLCMDMAXFIXEDTYPEWIDTH 30
> SELECT * from my_table
> go
> 또는
> sqlcmd -S my_server -y 30 -Y 30.

? 열이름 제거하고 구분기호 지정하기
* sqlcmd -E -d Movies -E -h -1 -s "," -W

? 외부 스크립트를 실행하고 파일로 저장하기
sqlcmd -i "D:\Desktop\demo.sql" -o "D:\Temp\Result Actor.bak"

[ 백업 표준 스크립트 ]
! sqlcmd
1> connect bm
2> :setvar db movies
2> :setvar bakfile D:\Temp\mv.bak
2> use movies
3> backup database $(db) to disk = '$(bakfile)';
4 > go

or

다음 코드로 C:\BackupTemplate.sql 을 만듭니다.
USE master;
BACKUP DATABASE[$(db)] TO DISK='$(bakfile)';

! sqlcmd Ex
                
C:\ > sqlcmd
1 > :connect<server>
Sqlcmd: Successfully connected to server <server>.
1> :setvar db msdb
1> :setvar bakfile c:\msdb.bak
1 > :r c:\BackupTemplate.sql
2 > GO

? Sqlcmd
        [-U 로그인 ID]
        [-P 암호]
        [-S 서버]
        [-H 호스트 이름]
        [-E 트러스트된 연결]
        [-N 연결 암호화]
        [-C 서버 인증서 신뢰]
        [-d 데이터베이스 이름 사용]
        [-l 로그인 제한 시간]
        [-t 쿼리 제한 시간]
        [-h 머리글]
        [-s 열 구분 기호]
        [-w 화면 너비]
        [-a 패킷 크기]
        [-e 에코 입력]
        [-I 따옴표 붙은 식별자 사용]
        [-c 명령 끝]
        [-L[c] 서버 목록 표시[정리 출력]]
        [-q "명령줄 쿼리"]
        [-Q "명령줄 쿼리" 후 끝내기]
        [-m 오류 수준]
        [-V 심각도]
        [-W 후행 공백 제거]
        [-u 유니코드 출력]
        [-r[0 | 1] 일반 오류에 대한 메시지]
        [-i 입력 파일]
        [-o 출력 파일]
        [-z 새 암호]
        [-f<codepage> | i:< codepage > [, o:< codepage >]]
        [-Z 새 암호 설정 후 끝내기]
        [-k[1 | 2] 제어 문자 제거[바꾸기]]
        [-y 변수 길이 유형 표시 너비]
        [-Y 고정 길이 유형 표시 너비]
        [-p[1] 통계 인쇄[콜론 형식]]
        [-R 클라이언트 국가별 설정 사용]
        [-K 애플리케이션 의도]
        [-M 다중 서브넷 장애 조치(Failover)]
        [-b 오류 시 일괄 처리 중단]
        [-v 변수 = "값"...][-A 관리자 전용 연결]
        [-X[1] 명령, 시작 스크립트, 환경 변수 비활성화[및 종료]]
        [-x 변수 대체 비활성화]
        [-j 원시 오류 메시지 인쇄]
        [-g 열 암호화 사용]
        [-G 인증에 Azure Active Directory 사용]
        [-? 구문 요약 표시]
 */

//  End Line //
