CREATE TABLE #Usage(
	[Schema_Name] sysname,
	[Table_Name] sysname, 
	[Index_Name] sysname,
	[Partition] int, 
	[Index_ID] int,
	[Index_Type] varchar(20),
	[Percent_Update] decimal(5,2),
	[Percent_Scan] decimal(5,2)
);

INSERT INTO #Usage
SELECT schema_name(o.schema_id) as [Schema_Name], 
o.name AS [Table_Name], isnull(x.name,'') AS [Index_Name],
i.[partition_number],
i.[Index_ID], x.type_desc AS [Index_Type],
i.[leaf_update_count] * 100.0 / (i.[range_scan_count] + i.[leaf_insert_count]+ 
i.[leaf_delete_count] + i.[leaf_update_count]+ i.[leaf_page_merge_count] + [i].[singleton_lookup_count]) AS [Percent_Update],
i.[range_scan_count] * 100.0 /
(i.[range_scan_count] + i.[leaf_insert_count]
+ i.[leaf_delete_count] + i.[leaf_update_count]
+ i.[leaf_page_merge_count] + i.[singleton_lookup_count]) AS [Percent_Scan]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i
JOIN sys.objects o ON o.object_id = i.object_id
JOIN sys.indexes x ON x.object_id = i.object_id AND x.index_id = i.index_id
WHERE (i.[range_scan_count] + i.[leaf_insert_count] + i.[leaf_delete_count] + [leaf_update_count] + i.[leaf_page_merge_count] + 
i.[singleton_lookup_count]) != 0
AND objectproperty(i.[object_id],'IsUserTable') = 1;

select * from #Usage