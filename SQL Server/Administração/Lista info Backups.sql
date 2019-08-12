
select 
    s.backup_set_id 
    , s.media_set_id 
    , s.database_name 
    , s.server_name 
    , s.name 
    , s.recovery_model 
    , s.backup_start_date 
    ,REVERSE (SUBSTRING (REVERSE (CONVERT (VARCHAR (15), CONVERT (MONEY, DATEDIFF (DAY, s.backup_start_date, GETDATE ())), 1)), 4, 15)) AS days_ago 
    ,REVERSE (SUBSTRING (REVERSE (CONVERT (VARCHAR (15), CONVERT (MONEY, ROUND (s.backup_size/1048576.0, 0)), 1)), 4, 15)) AS backup_size_mb 
    , s.type 
    ,(CASE 
        WHEN s.type = 'D' THEN 'Database' 
        WHEN s.type = 'F' THEN 'File Or Filegroup' 
        WHEN s.type = 'G' THEN 'Differential File' 
        WHEN s.type = 'I' THEN 'Differential Database' 
        WHEN s.type = 'L' THEN 'Log' 
        WHEN s.type = 'P' THEN 'Partial' 
        WHEN s.type = 'Q' THEN 'Differential Partial' 
        ELSE 'N/A' 
        END) AS backup_type 
    , f.physical_device_name 
from msdb.dbo.backupset s 
JOIN msdb.dbo.backupmediafamily f ON s.media_set_id = f.media_set_id 
WHERE s.backup_set_id = 
(    SELECT TOP 1 a.backup_set_id 
    FROM msdb.dbo.backupset a 
    WHERE a.database_name = s.database_name 
    ORDER BY a.backup_set_id DESC    ) 
ORDER BY s.database_name 