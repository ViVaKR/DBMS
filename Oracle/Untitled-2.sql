insert into c##viv.memos (
   title,
   memo
) values ( 'Memo 1',
           'This is the first memo' );

-- SELECT TABLESPACE_NAME
--   FROM DBA_TABLESPACES
--  WHERE TABLESPACE_NAME = 'USERS';


--  SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS CURRENT_CONTAINER
-- FROM DUAL;


-- alter session set container = freepdb1;


-- CONN C##ViV;


create table demo (
   id    number primary key,
   title varchar2(100)
);

insert into demo (
   id,
   title
) values ( 1,
           'Title 1' );


select *
  from demo;
