# DBMS

## 정의

- 대용량 <span style="color:red">__데이터베이스__</span>를 관리하고 운영하는 소프트웨어  

## 주요기능

1. 질의 처리 (Query Process)
2. 백업, 복원, 복구
3. 무결성 유지
4. 보안처리 (Security)
   1. 인증처리 (Authentication, 오덴씨케이션)
   2. 권한부여 (Authoorization, 오쏘리제이션)
5. 동시성 제어 (Concurrency Control)


## 데이터베이스 시스템의 장점

1. 중복성 제거 및 최소화
2. 불일치성 제거
3. 데이터 공유
4. 정보의 표준화
5. 보안기능 제공
6. 무결성(Integrity) 유지
7. 데이터 독립성 보장

## 용어

- `스키마` : 데이터베이스의 논리적 구조
- `DBA` (Database Administrator) : 데이터베이스 관리자
- `DDL` (Data Definition Language) : 데이터정의 언어
- `DML` (Data Manipulation Language) : 데이터조작 언어
  - 데이터 삽입, 갱식, 질의(Query Language), 삭제
- `DCL` (Data Control Language) : 데이터제어 언어, 데이터베이스 관리자가 주로 사용하는 언어
  - 사용자 계정관리, 세션관리, 로그인 관리, 서버관리
- `SQL` (Strucutred Query Language)
  - SQL Server : 마이크로소프트 사에서 공급하는 관계형 데이터베이스 관리시스템 (DBMS), Integrated Business Intelligence Tool
  - DB2, Oracle, MySQL, Sybase, Informix
- T-SQL (Transact-SQL)
- 데이터마이닝 : 데이터 가운데 숨겨져 있는 유용한 상관관계를 찾아내어 미래에 실행 가능한 정보를 추출하여 의사결저에 이용하는 과정
  - 분석서비스 (Analysis Service)
- 데이터웨어하우징 : 흩어져 있는 기업 데이터 정보를 최종사용자가 쉽게 접근 활용할 수 있도록 하는 개방형 시스템 기술
  - 통합서비스 (Integration Service            )

## 구분
- Administrator : 데이터베이스 관리자
  - 데이터베이스, 테이블, 뷰, 인덱스, 제약 조건 등의 데이터베이스 스키마를 정의
  - 데이터 저장 구조와 접근 방법을 결정
  - 데이터보안 정책을 결정
  - 무결성 제약조건정의
  - 오류 발생시 데이터베이스 복구
  - 데이터베이스 및 하드웨어를 모니터링 하고 관리
- Designer : 데이터베이스 설계자
- Developer : 응용프로그램 개발자
- End User : 단말 사용자
  - 응용프로그램을 통해 접근하는 사용자와 질의 편집도구를 사용해 접근하는 사용자로 구분할 수 있음

## 종류
> :new_moon: 관계형 (RDBMS) : 테이블로 구성되며 테이블은 행과 열로 이루어져 있음
>> MSSQL (SQL Server): Microsoft  
>> MySQL: Oracle  
>> PostgreSQL: PostgreSQL  
>> Oracle: Oracle  
>> DB2: IBM  
>> Acceess: Microsoft  
>> SQLite: SQLite  

> 계층형
> 망형

### 사용언어
>> SQL (Strucutred Query Language, 구조화된 질의 언어)

### SQL
>> 관계형 데이터베이스에서 사용되는 언어 : 에스큐엘 또는 시퀄로 발음
>> 국제표준화기구에서 표준 SQL 을 정해서 발표함
>> 회사별 특성을 반영하기 위하여 표준을 준수하고 제품 특성을 반영한 SQL을 사용하과 있음
>> 변형된 SQL 명칭 => T-SQL : MSSQL, SQL : MySQL, Oracle : PL/SQL


## 데이터베이스 모델링
- 테이블의 구조를 설계는 개념, 건축물의 설계도와 유사
- Waterfall model 을 주로 사용함

## 데이터

1. 운영 데이터
2. 의사결정 데이터
