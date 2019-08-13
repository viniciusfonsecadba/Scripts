select *, [DirtyPageCount] * 8 / 1024 as [DirtyPageMB], [CleanPageCount] * 8 /1024 as [CleanPageMB]
from 
	(select (case when [database_id] = 32767
			then N'Resoruce Database'
			else DB_name([database_id]) end ) as [Database_name],
			sum(case when (is_modified = 1) 
				then 1 else 0 end) as [dirtyPageCount],
			sum(case when (is_modified = 1) 
				then 0 else 1 end) as [CleanPageCount]
		from sys.dm_os_buffer_descriptors
	group by database_id) as Buffers
order by database_name