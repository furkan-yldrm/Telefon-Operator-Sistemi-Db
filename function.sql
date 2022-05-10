IF OBJECT_ID('Hesapla') IS NOT NULL
BEGIN 
	DROP FUNCTION Hesapla
END
GO
--Müþterilerin kaç yýldýr kayýtlý olduðunu hesaplayan fonksiyon
CREATE FUNCTION Hesapla(@id INT)
RETURNS INT
BEGIN 
DECLARE @gecenYil as INT
		SELECT @gecenYil =DATEDIFF(YEAR,KayÝtTarihi,GETDATE()) from tblMusteri where ID = @id
		RETURN @gecenYil;
END
GO


SELECT MusteriAd,
CONVERT(VARCHAR(11),KayitTarihi,103) AS KayitTarihi,
dbo.Hesapla(M.ID) AS GeçirdigiYil
FROM tblMusteri M