select serverproperty('machinename') as 'Server Name',
isnull(serverproperty('instancename'),serverproperty('machinename')) as 'Instance Name',
name as 'Login With Password Same As Name'
from master.sys.sql_logins
where pwdcompare(name,password_hash) = 1
order by name
option (maxdop 1) 



SELECT
serverproperty('machinename')as 'Servidor',
isnull(serverproperty('instancename'),serverproperty('machinename')) as 'Instancia',
master.sys.sql_logins.name as 'Login com mesmo passwd',
master.sys.sql_logins.is_disabled,
isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=3 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'sysadmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=2 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'public'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=4 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'Securityadmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=5 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'ServerAdmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=6 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'SetupAdmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=7 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'ProcessAdmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=8 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'DiskAdmin'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=9 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'DBCreater'
,isnull((Select 1 FROM sys.server_role_members RM inner JOIN master.sys.server_principals Role ON RM.role_principal_id = role.principal_id AND principal_id=10 AND rm.member_principal_id=master.sys.sql_logins.principal_id),0) AS 'BulkAdmin'
from master.sys.sql_logins
where pwdcompare(master.sys.sql_logins.name,password_hash)=1
order by name
option (maxdop 1);

GO