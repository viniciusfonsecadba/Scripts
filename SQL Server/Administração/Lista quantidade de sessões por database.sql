Às vezes quando precisamos fazer alguma manutenção em um servidor SQL, é necessário verificarmos quais usuários estão conectados ou quais databases estão sendo utilizadas. Uma forma simples e rápida de verificar a utilização do servidor é simplesmente identificar quais databases estão sendo acessadas naquele momento. Assim, apresento duas formas de fazermos tal verificação:

1) Usando sysprocesses (deprecado)
SELECT DB_NAME(p.dbid) db, COUNT(*) quantity
FROM master.dbo.sysprocesses p
WHERE p.spid > 50
group by DB_NAME(p.dbid)
ORDER BY 1

2) Usando DMV
SELECT db_name(l.resource_database_id) db, COUNT(*) quantity
FROM sys.dm_tran_locks l
GROUP BY db_name(l.resource_database_id)
ORDER BY 1