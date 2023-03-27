-- 테이블 생성
CREATE TABLE MEMBER (
    ID VARCHAR2(50),
    PWD NVARCHAR2(50),
    NAME NVARCHAR2(50), -- 한글이 들어감으로 NVARCHAR2
 -- GENDER CHAR(2 CHAR), -- CHAR 문자수 옵션의 한글 2자 : 6바이트
    GENDER NCHAR(2), -- 한글 고정 문자열에 권장 -> 한글 2자 : 4바이트
    AGE NUMBER(3), -- 자릿수 지정
    BIRTHDAY CHAR(10), -- 2000-01-23 : NCHAR 불필요
    PHONE CHAR(13), -- 010-1234-5678 : NCHAR 불필요
    REGDATE DATE
);

-- (vscode) CTRL + E, Tables -> Relational Tables

-- 환경설정 보기
-- NLS_CHARACTERSET -> AL32UTF16
-- NLS_CAARACTERSET -> ALUTF8
SELECT
    *
FROM
    NLS_DATABASE_PARAMETERS;

DROP TABLE MEMBER;

INSERT INTO MEMBER (
    GENDER
) VALUES(
    '남성'
);

SELECT
    LENGTHB(GENDER)
FROM
    MEMBER;

SELECT
    *
FROM
    MEMBER;
