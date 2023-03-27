# 데이터 타입

#### Oracle Built-in Data Types  
+ `Character Type`  : 'Hello', 'A', '148'  
    + CHAR(size) : `고정길이 검색 속도가 빠름`  
    + VARCHAR2(size) : `구분자를 통한 가변길이 검색 속도가 느림`   
    + NCHAR(size) : `기본적으로 바이트 사이즈이므로 3바이트 할당, CHAR 문자수 옵션 가능`
    + NVARCHAR2(size)  `가변길이`
      + size : 1byte, (N) 2 ~ 3bytes  
        + UTF8 : 3배 길이
        + AL16UTF16 : 2배 길이
          + MAX SIZE : MAX_STRING_SIZE =
            + EXTENDED : `32767`  
            + STANDARD : `4000`
    + LONG  : 테이블 당 하나, 가변길이 문자열 2Gb - 1 or 2^31-1 Bytes, 현재는 사용되지 않음
    + CLOB  : 대용량 텍스트 데이터 최대 4Gb
    + NCLOB : 대용량 텍스트 유니코드 데이터 타입 최대 4Gb
+ `Numberic`  : 정수 및 실수 숫자형
  + NUMBER(4) : 최대 4자로 이루어진 숫자
  + NUMBER(6,2) : 소수점 2자리에서 반올림, 최대 6자리 숫자
  + NUMBER(6,-2) : 소수점 -2자리에서 반올림, 최대 6자리 숫자
  + NUMBER : NUMBER(38, *)
  + NUMBER(*, 5) : NUMBER(38, 5)
+ `Date`  : 기준일 4712 
+ `TimeStamp` : NLS_TIMESTAMP_FORMAT 값 사용
  + WITH TIME ZONE : NLS_TIMESTAMP_TZ_FORMAT 값 사용
  + WITH LOCAT TIME ZONE : NLS_TIMESTAMP_TZ_FORMAT 값 사용
  
---
#### ANSI, DB2, and SQL/DS Data Types
#### User-Defined Types
#### Oracle-Supplied Types
#### Data Type Comparison Rules
#### Data Conversion
---
# Oracle Image PULL
1. $ docker pull gvenzl/oracle-xe
2. docker run -d -p 59573:1521 -e ORACLE_PASSWORD='비밀번호' --name viv-oracle -v /Users/vivabm/Database/Oracle-Data:/opt/oracle/oradata gvenzl/oracle-xe

--
## PDB(가상데이터베이스) 확인
```sql
    select name from v$pdbs;
    select instance_name, version, status from v$instance; -- 인스턴스 확인  
    
    SELECT owner, table_name FROM dba_tables;  
    SELECT owner, table_name FROM all_tables;  
    select table_name from user_tables;  
```

### Developer Tools Connection Test
> 서비스 이름 찾기 : CLI 접속 후 'CDB'  
```
    select value from v$parameter where name like '%service_name%';  
    --result -> **XE**  
```
> SID : Instance 의 유니크한 이름, 보다 큰 작업 가능, SYSDBA, 완전한 Admin
> Service Name : 데이터베이스에 원격으로 접속 할 때 사용  
> CDB -> Root (CDB$ROOT)  
> Seed (PDB$Seed) : 원형, Create Pluggable Database 

```sql
CREATE
    PLUGGABLE DATABASE hrpdb
    ADMIN USER dba1
    IDENTIFIED BY password
```
---

> Pluggable Database, 가상데이터베이스 -> 'XEPDB1'    
>> Seed PDB Pluggable Database 생성 후 서버 접속 ##  
>> -> ViV-XEPDB-1, 서비스이름 -> XEPDB1  
---

## 원격접속 설정  
> 기본값 : localhost 접속만 하도록 되어있으므로  
> 그것을 -> false 로 설정하여 원격접속을 허용 설정함  
```sql
    EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE)  
    -- result -> PL/SQL procedure successfully completed.
```
---

## Admin Accounts  
> + Sys : An account used to perform database administration tasks.  
> + SYSDBA : 자원 관리계정  
> + System  
>> A default generic database administrator account for Oracle databases.  
>> For production systems, Oracle recommends creating individual database  
>> administrator  account and not using the generic SYSTEM account  
>> for database administration operations.  
---
> Default Sample Schema User Accounts  
>> BI (Business Intelligence)  
>> HR (Human REsources)  
>> OE (Order Entry)  
>> PM (Product Media)  
>> IX (Information Exchange)  
>> SH (Sales)  

---
### DBA 테이블스페이스 생성 : Developer Tool
> DBA    
> 저장영역 -> 테이블스페이스  
>> VIV_TABLESPACE, VIV_DATAFILE, 영구, 500 + 500 + 1G  
>> VIV_LOGSPACE, VIV_LOGFILE,  임시, 500 + 500 + 1G  

> 테이블스페이스에 대한 사용자 생성
>> 대문자로 생성
>> 테이블과 로그 스페이스를 할당함
---

## Clear Screen : ALT + CMD + L

### CLI
```sql
    select name from v$databases;
    shutdown imediately;
    startup;
    
    select table_name from user_tables;
    select * from tab;
```

