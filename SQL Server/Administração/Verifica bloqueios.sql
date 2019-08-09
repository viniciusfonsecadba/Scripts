

   declare @comando varchar(700)

   --BLOQUEADOS
   set @comando = 'select ' + '''' + 'bloqueado' + '''' + ' processo, spid, banco = left(db_name(dbid), 20), blocked, equipamento = left(hostname, 20), '
   set @comando = @comando + 'programa = left(program_name, 20), tempo_de_espera = convert(int, waittime/1000), '
   set @comando = @comando + 'open_tran, status from master.dbo.sysprocesses '
   set @comando = @comando + 'where blocked > 0  and blocked <> spid union '   
   --BLOQUEADORES
   set @comando = @comando + 'select ' + '''' + 'bloqueante' + '''' + ' processo, spid, banco = left(db_name(dbid),20) , blocked, equipamento = left(hostname, 20), '
   set @comando = @comando + 'programa = left(program_name, 20), tempo_de_espera = convert(int, waittime/1000), '
   set @comando = @comando + 'open_tran, status from master.dbo.sysprocesses '
   set @comando = @comando + 'where blocked = 0 and blocked <> spid and spid in (select blocked from master.dbo.sysprocesses where blocked > 0) '
   set @comando = @comando + ' order by processo desc'

   exec(@comando)






with rec as (
   Select     sp1.spid      , sp1.blocked      , db_name(sp1.dbid) as [Database]      , sp1.Open_tran as 'Transacoes Abertas'      , 
   sp1.Hostname as 'Estacao Trabalho'      , sp1.lastwaittype,  sp1.nt_username as 'Usuario Windows'      , sp1.loginame as 'Usuário SQL'      , 
   sp1.program_name as Aplicacao      , sp1.login_time as Hora_Login      , sp1.waittime as 'Tempo de Duração'      , 
   sp1.waittime / 1000 as 'segundos'      , sp1.status as 'Status'      , sp1.cmd as 'Comando SQL'   , 
   (select CAST([TEXT] AS VARCHAR(8000)) from ::fn_get_sql(sp1.sql_handle)) as query_completa  , getdate() coleta 
   From SYS.sysProcesses sp1  
   where  1=1 -- and sp1.STATUS in('suspended')   
    and sp1.blocked > 0
  -- and  sp1.cmd = 'AWAITING COMMAND'  -- and (select CAST([TEXT] AS VARCHAR(8000)) from ::fn_get_sql(sp1.sql_handle)) like '%update%'  
   union all
   
   Select    sp2.spid      , sp2.blocked      , db_name(sp2.dbid) as [Database]      , sp2.Open_tran as 'Transacoes Abertas'      , 
   sp2.Hostname as 'Estacao Trabalho'      , sp2.lastwaittype,  sp2.nt_username as 'Usuario Windows'      , sp2.loginame as 'Usuário SQL'      , 
   sp2.program_name as Aplicacao      , sp2.login_time as Hora_Login      , sp2.waittime as 'Tempo de Duração'      , 
   sp2.waittime / 1000 as 'segundos'      , sp2.status as 'Status'      , sp2.cmd as 'Comando SQL'   , 
   (select CAST([TEXT] AS VARCHAR(8000)) from ::fn_get_sql(sp2.sql_handle)) as query_completa  , getdate() coleta 
   From SYS.sysProcesses sp2
   inner join rec on rec.blocked = sp2.spid
   where  1=1   

)
select * from rec
where blocked in (0,200)
order by [Tempo de Duração] desc
OPTION (MAXRECURSION 1000)

 
