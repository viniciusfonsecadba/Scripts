Explicação: https://viniciusfonsecadba.wordpress.com/2018/12/11/apagando-registros-duplicados-no-sql-server/

-- cria tabela
create table tab_dup (id int, col1 varchar(20), col2 varchar(20))

-- insere registros
insert into tab_dup (id,col1,col2)
values 
(1,'vinicius','fonseca'),
(2,'maria','fonseca'),
(3,'joao','fonseca'),
(4,'jose','fonseca'),
(5,'carlos','fonseca'),
(6,'lunis','fonseca'),
(1,'vinicius','fonseca'),
(1,'vinicius','fonseca'),
(2,'maria','fonseca'),
(5,'carlos','fonseca')

-- identificando registros duplicados 
select id, col1, col2, count(1) quantidade from tab_dup group by id, col1, col2 having count(1) > 1


-- exibindo todas as linhas/registros que estão duplicadas
with cte as 
(select id, col1, col2, row_number() over (partition by id, col1, col2 order by id) linha from tab_dup ) 
select * from cte where linha > 1

-- identificando registros duplicados 
select id, col1, col2, count(1) quantidade from tab_dup group by id, col1, col2 having count(1) > 1


-- exibindo todas as linhas/registros que estão duplicadas
with cte as 
(select id, col1, col2, row_number() over (partition by id, col1, col2 order by id) linha from tab_dup ) 
select * from cte where linha > 1


-- excluindo registros duplicados
with cte as 
(select id, col1, col2, row_number() over (partition by id, col1, col2 order by id) linha from tab_dup ) 
delete from cte where linha > 1


-- Preparando o ambiente - Cria a coluna do tipo datetime
alter table tab_dup add data_atualizacao datetime

-- Atualiza com datas diferentes
while exists (select top 1 * from tab_dup where data_atualizacao is null)
begin

;with cte as 
(select top 1 * from tab_dup where data_atualizacao is null)
update cte set data_atualizacao = dateadd(second, rand() * (-25), getdate() )

end



-- Exibe os registros na tabela com o identificador de cada linha por id,col1 e col2
with cte as 
(select id, col1, col2, data_atualizacao, 
 row_number() over (partition by id, col1, col2 order by data_atualizacao asc) linha 
from tab_dup ) 
select * from cte 



-- apaga os registros mantendo somente o primeiro inserido para cada conjunto de id, col1 e col2
with cte as 
(select id, col1, col2, data_atualizacao, row_number() over (partition by id, col1, col2 order by data_atualizacao asc) linha 
from tab_dup ) 
delete from cte where linha > 1