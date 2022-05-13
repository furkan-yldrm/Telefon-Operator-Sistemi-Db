
IF OBJECT_ID('viewOrnek') IS NOT NULL
BEGIN 
	DROP VIEW viewOrnek
	
END
GO

--M��terilerin 1 y�l boyunca �deyece�i toplam miktar� hesaplayan view,
--Kay�t tarihleri T�rk�e formatta,
--5 y�l ve �zeri s�redir kay�tl�ysa elit m��teri
CREATE VIEW viewOrnek 
AS
SELECT MusteriAd AS AdSoyad,
FORMAT (Kay�tTarihi, 'dd MMMMM yyyy','tr-tr') AS KayitTarihi,
dbo.Hesapla(M.ID) AS GecirdigiYil, 
CASE  WHEN  DATEDIFF(YEAR,Kay�tTarihi,GETDATE()) >= 5 THEN 'Elit M��teri' 
	  ELSE 'Elit De�il' END  AS MusteriDurumu,
SUM(OdenecekTutar*SozlesmeSuresi) AS ToplamTutar
FROM tblMusteri M INNER JOIN tblSozlesme S
ON M.ID = S.MusteriID INNER JOIN tblFaturaBilgi F
ON S.FaturaBilgi = F.ID
GROUP BY MusteriAd, KayitTarihi, dbo.Hesapla(M.ID)
GO

SELECT * FROM dbo.viewOrnek 
--Elit m��terilerin ki�isel bilgilerini, paket bilgilerini ve toplam �demesini i�eren sorgu
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
WHERE MusteriDurumu = 'Elit M��teri'


