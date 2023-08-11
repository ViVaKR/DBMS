
--* SQL Admin Send Mail Settings *--

--! (1)
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

--! (2)
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

--* ( bm@live.co.kr ) *--

-- (1) Create Profile : e.g. `Viv`
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = "Viv",
    @description = 'MSSQL SMTP'
GO

-- (2) Create Principal : `Viv`
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'Viv',
    @principal_name = 'public',
    @is_default = 1;
Go

-- (3) Create a Database Mail Account : e.g. `vivakr@outlook.com`
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'ViVaKR',  
    @description = 'Mail account for SQL Server',  
    @email_address = 'vivakr@outlook.com',  
    @replyto_address = 'vivakr@outlook.com',  
    @display_name = 'vivakr@outlook.com',  
    @mailserver_name = 'smtp.office365.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'vivakr@outlook.com',
    @password = '앱용 비밀번호' ; 
GO

--* Send Mail Test : `vivakr@outlook.com`
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'Viv',  
    @recipients = 'kimburmjun@gmail.com',  
    @subject = 'SQL Server Management Status Messages',
    @body = 'MSSQL 에서 서버관련 메시지를 보내드립니다.안녕하세요 반갑습니다.. vivakr',  
	@from_address = 'vivakr@outlook.com',
	@reply_to = 'vivakr@outlook.com'
GO

-- (3) Create a Database Mail Account : e.g. `kimburmjun@gmail.com`
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'KimBurmJun Gmail',  
    @description = 'KimBurmJun Mail account for Admin',  
    @email_address = 'kimburmjun@gmail.com',  
    @replyto_address = 'kimburmjun@gmail.com',  
    @display_name = 'KimBurmJun Gmail',  
    @mailserver_name = 'smtp.gmail.com',
    @port = 465,
    @enable_ssl = 1,
    @username = 'kimburmjun@gmail.com',
    @password = '비밀번호' ; 
GO

--* Create Profile Account : vivakr@outlook.com
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Viv',
    @account_name = 'KimBurmJun Gmail',
    @sequence_number = 2; -- 우선순위
GO

--* Update Mail Account (2. kimburmjun@gmail.com)
EXEC msdb.dbo.sysmail_update_account_sp
    @account_id = 13,
    @account_name = 'KimBurmJun Gmail',
    @description = 'kimburmjun@gmail.com Mail account for Admin',
    @email_address = 'kimburmjun@gmail.com',
    @display_name = 'KimBurmJun Gamil',
    @replyto_address = 'kimburmjun@gmail.com',
    @mailserver_name = 'smtp.gmail.com',
    @mailserver_type = 'SMTP',
    @port = 465,
    @timeout = 60,
    @username = 'kimburmjun@gmail.com',
    @password = '<비밀번호>',
    @use_default_credentials = 0,
    @enable_ssl = 1;
GO

EXECUTE msdb.dbo.sysmail_update_profileaccount_sp
    @profile_name = 'Viv',
    @account_name = 'KimBurmJun Gmail',
    @sequence_number = 1;
GO

--* Update Mail Account e.g. vivakr@outlook.com
EXEC msdb.dbo.sysmail_update_account_sp
    @account_id = 1,
    @account_name = 'ViVaKR Outlook',
    @description = 'vivakr@outlook.com Mail account for Admin',
    @email_address = 'vivakr@outlook.com',
    @display_name = 'ViVaKR Outlook',
    @replyto_address = 'vivakr@outlook.com',
    @mailserver_name = 'smtp.office365.com',
    @mailserver_type = 'SMTP',
    @port = 587,
    @timeout = 60,
    @username = 'vivakr@outlook.com',
    @password = '<앱용 비밀번호>',
    @use_default_credentials = 0,
    @enable_ssl = 1;
GO

--* Add New Profile Account : ViVaKR Outlook
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Viv',
    @account_name = 'ViVaKR Outlook',
    @sequence_number = 1;
GO

--* Update Profile Account : e.g. `ViVaKR Outlook`
EXECUTE msdb.dbo.sysmail_update_profileaccount_sp
    @profile_name = 'Viv',
    @account_name = 'ViVaKR Outlook',
    @sequence_number = 2;
GO

--* Update Mail Account : e.g. `naver.com`
EXEC msdb.dbo.sysmail_update_account_sp
    @account_id = 4,
    @account_name = 'ViVaBM Naver',
    @description = 'vivabm@naver.com Mail account for Admin',
    @email_address = 'vivabm@naver.com',
    @display_name = 'ViVaBM Naver',
    @replyto_address = 'vivabm@naver.com',
    @mailserver_name = 'smtp.naver.com',
    @mailserver_type = 'SMTP',
    @port = 587,
    @timeout = 60,
    @username = 'vivabm',
    @password = '네이버메일 비밀번호',
    @use_default_credentials = 0,
    @enable_ssl = 1;
GO

--* Get Mail Profile List (전체 계정 목록 보기)
EXEC msdb.dbo.sysmail_help_profile_sp;
GO

--* Get Mail Account By Name (계정 정보, 이름으로)
EXEC msdb.dbo.sysmail_help_profile_sp @profile_name = 'Viv'
GO

--* Get Mail Account By ID (계정 정보, 아이디로)
EXEC msdb.dbo.sysmail_help_account_sp @account_id = 1;
GO

--* Get All ProfileAccounts (프로파일 + 계정)
EXEC msdb.dbo.sysmail_help_profileaccount_sp;
GO

--* Get All Mail Accounts (모든 계정)
EXEC msdb.dbo.sysmail_help_account_sp;
GO

--* 삭제전 계정 확인
EXEC msdb.dbo.sysmail_help_account_sp  @account_id = 13;
GO

--* Delete Mail Account (삭제)
EXEC msdb.dbo.sysmail_delete_account_sp @account_id = 13;
GO

--* Delete Mail Profile
EXEC msdb.dbo.sysmail_delete_profile_sp @profile_id = 4
GO

--? View Send Mail Log
SELECT er.log_id AS [LogID],
    er.event_type AS [EventType],
    er.log_date AS [LogDate],
    er.description AS [Description],
    er.process_id AS [ProcessID],
    er.mailitem_id AS [MailItemID],
    er.account_id AS [AccountID],
    er.last_mod_date AS [LastModifiedDate],
    er.last_mod_user AS [LastModifiedUser]
FROM msdb.dbo.sysmail_event_log er
ORDER BY [LogDate] DESC

--? Delete All Send Mail Log
DELETE FROM msdb.dbo.sysmail_event_log

-- End Log
