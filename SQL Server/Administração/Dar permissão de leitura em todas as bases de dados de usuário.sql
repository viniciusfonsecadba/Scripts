USE [master]
GO
CREATE LOGIN [NOMEDOLOGIN] WITH PASSWORD=N'SENHA', DEFAULT_DATABASE=[banco_default], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO

DECLARE @usuario SYSNAME
        , @login SYSNAME;

SELECT @usuario = 'NOMEDOLOGIN',
       @login = 'NOMEDOLOGIN'

SELECT ' USE ' + QUOTENAME(NAME) + '; CREATE USER ' + QUOTENAME(@usuario) + ' FOR LOGIN ' + QUOTENAME(@login) + ' WITH DEFAULT_SCHEMA=[dbo];     EXEC sys.sp_addrolemember  ''db_datareader'',''' + @usuario+ ''';'
FROM   sys.databases
WHERE  database_id > 4
       AND state_desc = 'ONLINE'