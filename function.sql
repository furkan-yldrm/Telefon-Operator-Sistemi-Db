IF OBJECT_ID('Hesapla') IS NOT NULL
BEGIN 
	DROP FUNCTION Hesapla
END
GO
--M��terilerin ka� y�ld�r kay�tl� oldu�unu hesaplayan fonksiyon
CREATE FUNCTION Hesapla(@id INT)
RETURNS INT
BEGIN 
DECLARE @gecenYil as INT
		SELECT @gecenYil =DATEDIFF(YEAR,Kay�tTarihi,GETDATE()) from tblMusteri where ID = @id
		RETURN @gecenYil;
END
GO


SELECT MusteriAd,
CONVERT(VARCHAR(11),KayitTarihi,103) AS KayitTarihi,
dbo.Hesapla(M.ID) AS Ge�irdigiYil
FROM tblMusteri M