DECLARE @tabela TABLE
(
    IdNota INT,
    Valor DECIMAL(18, 2),
    Data DATETIME
);

INSERT INTO @tabela
(
    IdNota,
    Valor,
    Data
)
VALUES
(1, 10, GETDATE()),
(2, 20, GETDATE()),
(5, 30, GETDATE()),
(6, 40, GETDATE()),
(7, 50, GETDATE()),
(10, 60, GETDATE()),
(11, 70, GETDATE()),
(12, 70, GETDATE());



DECLARE @MenorValor INT = ( SELECT MIN(t.IdNota) FROM @tabela AS t );
DECLARE @MaiorValor INT = ( SELECT MAX(t.IdNota) FROM @tabela AS t);


WITH Intervalo
AS (SELECT @MenorValor AS Numero
    UNION ALL
    SELECT Intervalo.Numero + 1
    FROM Intervalo
    WHERE Intervalo.Numero < @MaiorValor
   )
SELECT I.Numero,
       TaNota.*,
	   NotasPuladas = IIF(TaNota.IdNota IS NULL,I.Numero,NULL)
FROM Intervalo I
    LEFT JOIN @tabela AS TaNota ON I.Numero = TaNota.IdNota
OPTION (MAXRECURSION 0);