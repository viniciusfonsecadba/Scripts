--Determine os nomes de arquivo lógicos do banco de dados tempdb e o seu local atual no disco.
SELECT name, physical_name AS CurrentLocation
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO
--Altere o local de cada arquivo usando ALTER DATABASE.
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, FILENAME = 'E:\SQLData\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, FILENAME = 'F:\SQLLog\templog.ldf');
GO
--Reinicie a instância do SQL Server.

--Verifique a alteração do arquivo.
SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');

--Exclua os arquivos tempdb.mdf e templog.ldf do local original.

