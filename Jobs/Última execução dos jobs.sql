SELECT
		j.name
		, (CASE h.run_status
			WHEN 0 THEN 'Falha'
			WHEN 1 THEN 'Sucesso'
			WHEN 2 THEN 'Repetir'
			WHEN 3 THEN 'Cancelado'
			WHEN 4 THEN 'Em Progresso'
		END) [status]
		, h.message
		, h.run_date
		, h.run_time
	FROM msdb.dbo.sysjobs j
	CROSS APPLY
	(	SELECT TOP 1 h.run_date, h.run_time, h.run_status, h.message
		from msdb.dbo.sysjobhistory h
		WHERE h.step_id = 0
		AND h.job_id = j.job_id 
		ORDER BY h.instance_id DESC
	) h
	ORDER BY name;