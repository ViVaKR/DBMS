# MSSQL

## Install **_sqlcmd_** for macos (2023-03-24)  
1. $ brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release  
2. $ brew update  
3. $ HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18  
4. $ sqlcmd -S [server,port] -U [username] -P [password] -C  
5. (if macos ssl error) -> $ ln -s /usr/local/Cellar/openssl@1.1/1.1.1t /usr/local/opt/openssl  

## SQL
```sql
    -- 데이터베이스 연결
    EXEC sp_attach_db @dbname = N'데이터베이스',   
    @filename1 = N'$PATH:\데이터베이스_Data.mdf',   
    @filename2 = N'$PATH:\데이터베이스_log.ldf';

    -- 데이터베이스 분리
    EXEC sp_detach_db '데이터베이스', 'true';
```
