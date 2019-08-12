
USE master
go

IF EXISTS(select 1 from tempdb..sysobjects where name like '#Tamanhos%')
DROP TABLE #Tamanhos;
GO

CREATE TABLE #Tamanhos
(	Banco VARCHAR(50),
TamanhoData Float,
TamanhoLog Float,
Usado Float,
Livre Float
);
GO

EXEC sp_MSforeachdb 'USE ?
DECLARE @DbSize FLOAT =
(SELECT SUM(CAST(df.size as float)) FROM sys.database_files AS df WHERE df.type in ( 0, 2, 4 ) );
DECLARE @LogSize FLOAT =
(SELECT SUM(CAST(df.size as float)) FROM sys.database_files AS df WHERE df.type in (1, 3));
DECLARE @SpaceUsed FLOAT;
SELECT @SpaceUsed = SUM(a.total_pages)
FROM sys.allocation_units AS a
INNER JOIN sys.partitions AS p
ON (a.type = 2 AND p.partition_id = a.container_id) OR (a.type IN (1,3) AND p.hobt_id = a.container_id)
DECLARE @SpaceFree FLOAT = @DbSize - @SpaceUsed;
SELECT @DbSize = (@DbSize*8)/1024.00;
SELECT @LogSize = (@LogSize*8)/1024.00;
SELECT @SpaceUsed = (@SpaceUsed*8)/1024.00;
SELECT @SpaceFree = (@SpaceFree*8)/1024.00;
INSERT INTO #Tamanhos
SELECT DB_NAME() Banco, @DbSize TamanhoData, @LogSize TamanhoLog, @SpaceUsed Usado, @SpaceFree Livre';

GO

select * from #Tamanhos order by Banco
GO