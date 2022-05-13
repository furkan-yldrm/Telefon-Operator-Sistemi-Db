
IF OBJECT_ID('viewOrnek') IS NOT NULL
BEGIN 
	DROP VIEW viewOrnek
	
END
GO

--Müþterilerin 1 yýl boyunca ödeyeceði toplam miktarý hesaplayan view,
--Kayýt tarihleri Türkçe formatta,
--5 yýl ve üzeri süredir kayýtlýysa elit müþteri
CREATE VIEW viewOrnek 
AS
SELECT MusteriAd AS AdSoyad,
FORMAT (KayÝtTarihi, 'dd MMMMM yyyy','tr-tr') AS KayitTarihi,
dbo.Hesapla(M.ID) AS GecirdigiYil, 
CASE  WHEN  DATEDIFF(YEAR,KayÝtTarihi,GETDATE()) >= 5 THEN 'Elit Müþteri' 
	  ELSE 'Elit Deðil' END  AS MusteriDurumu,
SUM(OdenecekTutar*SozlesmeSuresi) AS ToplamTutar
FROM tblMusteri M INNER JOIN tblSozlesme S
ON M.ID = S.MusteriID INNER JOIN tblFaturaBilgi F
ON S.FaturaBilgi = F.ID
GROUP BY MusteriAd, KayitTarihi, dbo.Hesapla(M.ID)
GO

SELECT * FROM dbo.viewOrnek 
--Elit müþterilerin kiþisel bilgilerini, paket bilgilerini ve toplam ödemesini içeren sorgu
SELECT AdSoyad,
	       Yas,
		 eMail,
		 TelNo,
  MusteriDurumu,
Aciklama AS KullandigiPaketBilgisi,
ToplamTutar AS SozlesmeBoyuncaToplamOdeyecegiTutar

FROM dbo.viewOrnek O INNER JOIN tblMusteri M 
	ON O.AdSoyad = M.MusteriAd INNER JOIN tblSozlesme S 
	ON M.ID = S.MusteriID INNER JOIN tblTelNo N
	ON M.TelefonNo = N.ID INNER JOIN tblSozlesmePaketi SP
	ON S.SozlesmePaketi = SP.ID INNER JOIN tblPaket P
	ON SP.PaketBilgileri = P.ID
WHERE MusteriDurumu = 'Elit Müþteri'


