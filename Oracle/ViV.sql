-- CREATE USER C##ViV IDENTIFIED BY "B9037!m8947#";
-- GRANT CONNECT, RESOURCE TO C##ViV;
-- GRANT CREATE SESSION TO C##ViV;

-- create table c##viv.memos (
--    id    number(6) primary key,
--    title varchar2(20),
--    memo  varchar2(1000)
-- );

-- 테이블 생성
-- create table c##viv.memos (
--    id    number(6) primary key,
--    title varchar2(20),
--    memo  varchar2(1000)
-- );

-- 시퀀스 생성
-- create sequence c##viv.memos_seq start with 1 increment by 1 nocache nocycle;

-- 트리거 생성
-- create or replace trigger c##viv.bi_memos before
--    insert on c##viv.memos
--    for each row
-- begin
--    :new.id := c##viv.memos_seq.nextval;
-- end;
-- /

alter user c##viv
   quota unlimited on users;

insert into c##viv.memos (
   title,
   memo
) values ( 'Sample Title',
           'This is a sample memo.' );

insert into c##viv.memos (
   title,
   memo
) values ( 'Another Title',
           'This is another sample memo.' );

select *
  from c##viv.memos;

select owner,
       table_name
  from all_tables
 where owner = 'C##VIV';
