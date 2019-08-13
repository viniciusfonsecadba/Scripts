Explicação: https://viniciusfonsecadba.wordpress.com/2019/03/04/usando-try-catch-e-raiserror-x-throw/


use salesdb
go
-- create table cliente (id int identity(1,1), nome varchar(100), sobrenome varchar(100), cpf varchar(10) primary key)
BEGIN TRY
BEGIN TRANSACTION
INSERT INTO cliente (nome, sobrenome, cpf) VALUES ('Vinicius', 'Castro Fonseca', '0000000000'); 
INSERT INTO cliente (nome, sobrenome, cpf) VALUES ('Maria', 'Teresa Adão','0000000001'); 
INSERT INTO cliente (nome, sobrenome, cpf) VALUES ('Benício', 'Adão Fonseca', '0000000000'); 
END TRY
BEGIN CATCH
IF(@@TRANCOUNT > 0)
ROLLBACK TRANSACtION;

SELECT 'Se houver erro e instruções begin tran, o rollback será feito acima na transação';

SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage; 
END CATCH

IF(@@TRANCOUNT > 0)
COMMIT TRANSACTION;
-- @@TRANCOUNT - Retorna o número de instruções BEGIN TRANSACTION que ocorreram na conexão atual.
select * from cliente