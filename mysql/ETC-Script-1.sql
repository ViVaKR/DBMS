use employees;
use students;
use test;
use world;
use Samp;
use sys;

-- # 테이블 내용 삭제
truncate table Sample;
-- # 데이터 가져오기 (윈도우)
LOAD DATA local infile 'D:\\Temp_D\\MySqlLoadData.CSV'
    into table Sample
    columns terminated by ',';
select * from Sample;

-- # 쿼리로 부터 테이블 만들기
create table Smp as select * from Sample;

-- # Alter Table (테이블 변경)
alter table Samp add City varchar(20);
alter table Samp rename Samp;
alter table Samp modify column CNo int primary key ;
alter table Samp Drop COLUMN City;
alter table Samp Add Eno int;
ALTER TABLE Samp ADD CONSTRAINT pk_Samp_Div
    FOREIGN KEY(Eno)
    REFERENCES employees(emp_no)
    on update cascade
on  delete set null ;

-- # 시스템 명령어
show table status;

# 제공 함수 모음 ==========================================
select * from emp_view;
select COUNT(*) from emp_view where Salary >= 1000000;
select max(Salary) as '최고 급여' from emp_view;
select min(Salary) from emp_view;
select Format(sum(Salary),'ko-KR') from emp_view;
select avg(Salary) as Average from emp_view;
select truncate(avg(Salary), 1) from emp_view; # 잘라내기
select abs(-234);
select power(2, 8);
select round(3.1473423, 2);
# 금액 포맷
select FORMAT(Salary, 'ko-KR') as formate from emp_view;
# 테이블 데이터 지우기
# 테이블 내용 싹 지우기
truncate table tablename;

select
  Gender,
  Round(avg(Salary), 0) as Average
from emp
group by Gender;
select 5 div 2;
select 5 mod 2;
# 소수점을 시간으로 표현하기 (1.5 시간을 1시간 30분으로)
select
  (3.25 div 1)       as Time,
  (3.25 * 60 mod 60) as Second;
select ceil(35.40);
select floor(35.40);
select exp(5);
select log(2);
select log10(2);
select pow(2.718, 5);
select greatest(5, 3, 1, 77, 9, 11, 3, 89);
select least(5, 3, 1, -77, 9, 11, 3, 89);
select radians(180);
select sqrt(225.6548);
select truncate(225.6548, 2);
select rand();
# String Funciton
select concat('Hello', ' World');
select upper(concat(first_name, ' ', last_name)) as Name
from employees;
select lower('Hey There');
select trim('       Hi every one      ');
select substr('I need a break', 3, length('I need a break'));
select right('I need a break', 5);
select left('I need a break', 5);
select length('I need a break');
select char_length('Hello world');
select insert('Hello world', 7, 2, 'my');
select repeat('Hi ', 5);
select replace('Good Morning', 'Morning', 'Night');
select reverse('장길산');
select strcmp('Day', 'Night');
select strcmp('Night', 'Day');
select strcmp('Hello', 'world');

--* DateTime Function
select adddate('1989-11-20', interval 25 day);
select subdate(now(), interval 1 day);
select adddate('2010-12-23', interval 30 month);
select subdate('2011-09-21', interval 25 month);
select adddate('2011-11-10', interval 12 year);
select subdate(now(), interval 10 year);
select curtime();
select current_time();
select dayname('2007-07-14'); # 일자로 부터 요일 추출
select
  birth_date,
  dayname(birth_date)
from employees;
select now();
select date(now());
select makedate(2003, 231); # 날짜 만들기
select makedate(2005, 12);
select monthname('2017-07-14'); # 월 이름 가져오기
select timediff('2009-05-18 15.45.57.000000', '2009-05-18 13:40:50.000000');
select datediff(now(), '1964-10-11 20:08:27') / 365; # 나이 구하기
select time_to_sec('24:00:00'); # 시간을 초로 표시
select unix_timestamp();

--* 뷰 만들기
CREATE view emp_view as
  select
    e.emp_no                                       as No,
    concat(e.first_name, concat(' ', e.last_name)) as Name,
    e.gender                                       as Gender,
    sum(s.salary)                                  as Salary
  from employees e
    join salaries s
      on e.emp_no = s.emp_no
  group by e.emp_no;


--* 이중 조인
select
  e.emp_no      as No,
  e.first_name  as First_Name,
  e.last_name   as Last_Name,
  e.gender      as Gender,
  sum(s.salary) as Salary
from (employees as e
  join dept_emp as d on e.emp_no = d.emp_no) join salaries as s on e.emp_no = s.emp_no
group by e.emp_no, e.first_name, e.last_name, e.gender
having sum(s.salary) < 50000
order by Salary desc;

select
  e.emp_no,
  e.first_name,
  e.last_name,
  e.gender,
  sum(s.salary) as Salary
from (employees as e
  join dept_emp as d on e.emp_no = d.emp_no) join salaries as s on e.emp_no = s.emp_no
group by e.emp_no, e.first_name, e.last_name, e.gender
having Salary is null
limit 100;

# 기본 조인
select
  e.emp_no,
  sum(s.salary) as Salary
from employees e
  join salaries s on e.emp_no = s.emp_no
group by e.emp_no;

# 서브 쿼리 (Sub Query)
select * from emp_view where Salary= (select max(Salary) from emp_view);

--* 내보내기 및 가져오기
SELECT * INTO OUTFILE '/tmp/test.dump'
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
FROM test_table;
# 위 구문은 test_table에서 날짜가 2014-09-15인 데이터를 "/tmp/test.dump"에 저장하는 쿼리입니다. FIELDS TERMINATED BY '\t' 는 각 필드를 탭으로 구분한다는 의미이며 OPTIONALLY ENCLOSED BY '"' 는 각 필드를 "로 감싼다는 의미입니다.

--* 텍스트 파일에서 데이터 가져오기 (리눅스)
LOAD DATA INFILE '/tmp/test.dump'
INTO table Sample
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"';
# 텍스트 파일에서 데이터 가져오기 (윈도우)
LOAD DATA LOCAL INFILE 'D:\\Temp_D\\MySqlLoadData.CSV' INTO TABLE Sample
  FIELDS TERMINATED BY ',';

# 테이블 내보내기 (보안 설정 문제가 있음)
select * into outfile 'D:\Temp_D\Employees.dump'
FIELDS terminated by ',' optionally enclosed by '"'
from employees;

# 테이블 덤프 하기 (일반적인 방법)
  # -> mysqldump -u root -p dbname tablename > filename
# 덤프 파일로 복구하기
  #-> mysql -u root -p < dumpFileName;
# 데이터 베이스 스키마만 백업 받기
 #-> mysqldump -u root -p -d employees > employees_schm.sql

show variables like 'secure_file_priv';

# 기본 명령어
Create database sampdb;
use sampdb;
select database();

desc Samp;

-- 사용자 만들기
create user 'samadm'@'%'
  identified by 'B9037!m8947#';
grant all on sampdb.* to 'samadm'@'%';

-- 학생 테이블
CREATE TABLE student
(
  name       VARCHAR(20)     NOT NULL,
  sex        ENUM ('F', 'M') NOT NULL,
  student_id INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (student_id)
);

--# 수강 테이블
CREATE TABLE absence
(
  student_id INT UNSIGNED NOT NULL,
  date       DATE         NOT NULL,
  PRIMARY KEY (student_id, date),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
);

CREATE TABLE grade_event
(
  date     DATE            NOT NULL,
  category ENUM ('T', 'Q') NOT NULL,
  event_id INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (event_id)
);

CREATE TABLE member
(
  member_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (member_id),
  last_name  VARCHAR(20)  NOT NULL,
  first_name VARCHAR(20)  NOT NULL,
  suffix     VARCHAR(5)   NULL,
  expiration DATE         NULL,
  email      VARCHAR(100) NULL,
  street     VARCHAR(50)  NULL,
  city       VARCHAR(50)  NULL,
  state      VARCHAR(2)   NULL,
  zip        VARCHAR(10)  NULL,
  phone      VARCHAR(20)  NULL,
  interests  VARCHAR(255) NULL
);

CREATE TABLE president
(
  last_name  VARCHAR(15) NOT NULL,
  first_name VARCHAR(15) NOT NULL,
  suffix     VARCHAR(5)  NULL,
  city       VARCHAR(20) NOT NULL,
  state      VARCHAR(2)  NOT NULL,
  birth      DATE        NOT NULL,
  death      DATE        NULL
);

CREATE TABLE score
(
  student_id INT UNSIGNED NOT NULL,
  event_id   INT UNSIGNED NOT NULL,
  score      INT          NOT NULL,
  PRIMARY KEY (event_id, student_id),
  INDEX (student_id),
  FOREIGN KEY (event_id) REFERENCES grade_event (event_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
);

select timestamp (now());
































