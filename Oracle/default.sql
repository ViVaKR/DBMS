-- CREATE USER C##ViV IDENTIFIED BY "B9037!m8947#";
-- GRANT CONNECT, RESOURCE TO C##ViV;
-- GRANT CREATE SESSION TO C##ViV;

create table c##viv.employee (
   employee_id number(6) primary key,
   first_name  varchar2(20),
   last_name   varchar2(20)
);
