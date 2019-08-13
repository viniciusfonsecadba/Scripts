-- tabelas que não possuem chave primária
select distinct(tb.name) as Table_name, p.rows 
from sys.objects tb join sys.partitions p on p.object_id = tb.object_id 
Where type = 'U' and tb.object_id not in ( select ix.parent_object_id from sys.key_constraints ix where type = 'PK' ) order by p.rows desc
