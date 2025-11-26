-- ===========================================================
-- 설정값
-- ===========================================================
declare @DBName   nvarchar(128) = N'Buddham_Main';
declare @LoginName nvarchar(128) = N'Buddham_Main';
declare @Password  nvarchar(128) = N'비밀번호...';

print N'설정값 확인: DB = [' + @DBName + N'], Login = [' + @LoginName + N']';

-- ===========================================================
-- 1. 데이터베이스 생성
-- ===========================================================
if DB_ID(@DBName) is null
begin
    print N'Creating Database ' + @DBName + N'...';
    EXEC('CREATE DATABASE [' + @DBName + N'] COLLATE Korean_Wansung_CI_AS');
end
else
begin
    print N'Database ' + @DBName + N' already exists.';
end

-- ===========================================================
-- 2. Database 설정
-- ===========================================================
EXEC('ALTER DATABASE [' + @DBName + '] SET RECOVERY FULL;');
EXEC('ALTER DATABASE [' + @DBName + '] SET AUTO_CLOSE OFF;');
EXEC('ALTER DATABASE [' + @DBName + '] SET AUTO_SHRINK OFF;');
EXEC('ALTER DATABASE [' + @DBName + '] SET READ_COMMITTED_SNAPSHOT ON;');

-- Query Store (2016 이상)
EXEC('ALTER DATABASE [' + @DBName + '] SET QUERY_STORE = ON;');

-- 파일 성장 설정
EXEC('ALTER DATABASE [' + @DBName + '] MODIFY FILE (NAME = ''' + @DBName + ''', SIZE = 256MB, FILEGROWTH = 64MB)');
EXEC('ALTER DATABASE [' + @DBName + '] MODIFY FILE (NAME = ''' + @DBName + '_log'', SIZE = 256MB, FILEGROWTH = 64MB)');

-- ANSI 옵션
EXEC('ALTER DATABASE [' + @DBName + '] SET ANSI_NULLS ON;');
EXEC('ALTER DATABASE [' + @DBName + '] SET ANSI_PADDING ON;');
EXEC('ALTER DATABASE [' + @DBName + '] SET ANSI_WARNINGS ON;');
EXEC('ALTER DATABASE [' + @DBName + '] SET QUOTED_IDENTIFIER ON;');
EXEC('ALTER DATABASE [' + @DBName + '] SET CONCAT_NULL_YIELDS_NULL ON;');

-- 소유자 변경
EXEC('ALTER AUTHORIZATION ON DATABASE::[' + @DBName + '] TO sa');

-- ===========================================================
-- 3. 로그인 생성
-- ===========================================================
if not exists (select 1
from sys.server_principals
where name = @LoginName)
begin
    print N'Creating LOGIN [' + @LoginName + N']...';
    EXEC('CREATE LOGIN [' + @LoginName + N']
          WITH PASSWORD = ''' + @Password + N''',
               DEFAULT_DATABASE = [' + @DBName + N'],
               DEFAULT_LANGUAGE = Korean,
               CHECK_POLICY = OFF,
               CHECK_EXPIRATION = OFF');
end
else
begin
    print N'Login [' + @LoginName + N'] already exists.';
end

-- ===========================================================
-- 4. 데이터베이스 사용자 생성 및 db_owner 권한 부여
-- ===========================================================
declare @sql nvarchar(MAX);

set @sql = '
USE [' + @DBName + '];

-- 사용자 생성
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''' + @LoginName + ''')
BEGIN
    PRINT N''Creating USER [' + @LoginName + ']...'';
    CREATE USER [' + @LoginName + '] FOR LOGIN [' + @LoginName + '];
END

ALTER USER [' + @LoginName + '] WITH DEFAULT_SCHEMA = dbo;

-- db_owner 권한 부여
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
        JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
        JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
    WHERE r.name = ''db_owner'' AND m.name = ''' + @LoginName + '''
)
BEGIN
    PRINT N''Adding [' + @LoginName + '] to db_owner role...'';
    ALTER ROLE db_owner ADD MEMBER [' + @LoginName + '];
END
ELSE
BEGIN
    PRINT N''[' + @LoginName + '] is already db_owner.'';
END
';

EXEC(@sql);

print N'===== ' + @DBName + N' Database + Login/User Setup Complete!! =====';
