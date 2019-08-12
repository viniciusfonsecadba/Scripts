-- Altere a variável @target_dir com o diretório no servidor de destino onde os backups estarão disponíveis
DECLARE @target_dir varchar(1000) = 'D:\Migracao\'
-- Altere a variável @database_name para o nome do seu banco de dados, caso não queira limitar para um banco, altere para null
DECLARE @database_name varchar(100) = 'Nome_do_banco'


if object_id('tempdb..#tmp') is not null
	drop table #tmp

create table #tmp (database_name varchar(1000) null, backup_finish_date datetime, media_set_id int, backup_size bigint, recovery_model varchar(40) null, type char(1), physical_device_name varchar(1000) null, script varchar(4000) null)

;with backups as (
	select row_number () over (partition by database_name order by backup_start_date desc) linha, database_name, backup_finish_date, msdb..backupset.media_set_id, backup_size, recovery_model, type , bf.physical_device_name, reverse(SUBSTRING(REVERSE(bf.physical_device_name),0,CHARINDEX('\',REVERSE(bf.physical_device_name)))) as arquivo
	from msdb..backupset 
	inner join msdb..backupmediafamily bf on msdb..backupset.media_set_id = bf.media_set_id 
	where backup_start_date >= dateadd(dd,-15,getdate()) and type = 'D'
	and (database_name = @database_name or @database_name is null) )

insert into #tmp
select database_name, backup_finish_date, media_set_id, backup_size, recovery_model, type , physical_device_name, 
'restore database ' + database_name +  ' from disk = ''' + @target_dir + arquivo + ''' with norecovery' as script
from backups 
where linha = 1 and backups.database_name = @database_name
union  
select bs.database_name, bs.backup_finish_date, bs.media_set_id, bs.backup_size, bs.recovery_model, bs.type, bf.physical_device_name, 
'restore log ' + bs.database_name +  ' from disk = ''' + @target_dir + reverse(SUBSTRING(REVERSE(bf.physical_device_name),0,CHARINDEX('\',REVERSE(bf.physical_device_name)))) + ''' with norecovery'
from backups b
inner join msdb..backupset bs on bs.database_name = b.database_name and bs.backup_start_date >= b.backup_finish_date
inner join msdb..backupmediafamily bf on bs.media_set_id = bf.media_set_id 
where linha = 1 
order by database_name, backup_finish_date

if @database_name is not null
insert into #tmp (database_name, backup_finish_date, script )
values (@database_name ,  getdate(), 'restore database ' + @database_name + ' with recovery')

select * from #tmp order by backup_finish_date
