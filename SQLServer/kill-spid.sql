SELECT text, GETDATE(), *
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle)


kill 125
--125 is my Session-Id


exec sp_who2

kill 7

-- >= 50
SELECT *
FROM sys.dm_exec_sessions
WHERE
    is_user_process = 1

SELECT *
FROM sys.sysprocesses
WHERE
    hostprocess > ''

-- recommand

SELECT conn.session_id, host_name, program_name,
    nt_domain, login_name, connect_time, last_request_end_time
FROM sys.dm_exec_sessions AS sess
    JOIN sys.dm_exec_connections AS conn
    ON sess.session_id = conn.session_id;

KILL 53;
GO
