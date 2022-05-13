--index var
--tblFaturaTipi tablosu içine 1000000 veri ekleyip sorgulama
DECLARE @sayac INT = 1
WHILE @sayac < 1000000
	BEGIN
	INSERT tblFaturaTipi
	SELECT 'Faturalý' + CAST(@sayac AS VARCHAR(20))
	SET @sayac = @sayac + 1
	END
	
SET STATISTICS IO ON 
SET STATISTICS TIME ON

SELECT * FROM tblFaturaTipi

CREATE NONCLUSTERED INDEX idxFaturaTip ON tblFaturaTipi(ID,Tip)
SELECT * FROM tblFaturaTipi WHERE ID > 542

























