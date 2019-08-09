 select GETDATE() , db_name(), ix.name, ix.type_desc, vw.user_seeks, vw.last_user_seek, vw.user_scans, vw.last_user_scan, vw.user_lookups, vw.user_updates as 'Total_User_Escrita',(vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Total_User_Leitura',vw.user_updates - (vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Dif_Read_Write',
ix.allow_row_locks, vwx.row_lock_count, row_lock_wait_count, row_lock_wait_in_ms,ix.allow_page_locks, vwx.page_lock_count, page_lock_wait_count, page_lock_wait_in_ms,ix.fill_factor, ix.is_padded
from sys.dm_db_index_usage_stats vw
join sys.indexes ix on ix.index_id = vw.index_id and ix.object_id = vw.object_id
join sys.dm_db_index_operational_stats(db_id(), null, NULL, NULL) vwx on vwx.index_id = ix.index_id and ix.object_id = vwx.object_id
where vw.database_id = db_id() 
and object_name(ix.object_id) = 'SE1010' 
order by user_seeks