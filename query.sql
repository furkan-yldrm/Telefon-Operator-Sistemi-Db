 
-- 1 Ocak 1992'ten sonra doðup 109.9TL üzeri fatura ödeyen müþteriler 
SELECT MusteriAd, DogumTarihi, OdenecekTutar
FROM TblMusteri M INNER JOIN tblSozlesme S
	ON M.ID = S.MusteriID INNER JOIN tblFaturaBilgi F
	ON S.FaturaBilgi = F.ID
	WHERE DogumTarihi > '1992-01-01' AND OdenecekTutar > 109.90


--Müþterilerin sözleþme süreleri boyunca ödeyecekleri toplam miktar 
SELECT MusteriAd, OdenecekTutar * SozlesmeSuresi AS ToplamOdeme 
FROM (
	SELECT MusteriAd, OdenecekTutar, SozlesmeSuresi
	FROM tblMusteri M INNER JOIN tblSozlesme S
		ON M.ID = S.MusteriID INNER JOIN tblFaturaBilgi FB
		ON S.FaturaBilgi = FB.ID INNER JOIN tblSozlesmePaketi SP 
		ON S.SozlesmePaketi = SP.ID 
		GROUP BY MusteriAd,OdenecekTutar, SozlesmeSuresi
	 ) A 
ORDER BY ToplamOdeme DESC


--Paketindeki kullanýmlarýndan (Ýnternet, dakika, sms) en az birinin tamamýný kullanmýþ müþteriler
SELECT MusteriAd, KalanByte, KalanDakika, KalanSms 
FROM tblMusteri M INNER JOIN tblSozlesme S
	ON M.ID = S.MusteriID INNER JOIN tblSozlesmePaketi SP
	ON S.SozlesmePaketi = SP.ID INNER JOIN tblInternetKullanimi IK
	ON SP.ID = IK.ID INNER JOIN tblDakikaKullanimi DK
	ON SP.ID = DK.ID INNER JOIN tblSmsKullanimi SK
	ON SP.ID = SK.ID
	WHERE KalanByte = 0 OR KalanDakika = 0 OR KalanSms = 0 


--Son ödeme tarihine göre gün gün toplam alýnacak ödemeler
SELECT SonOdemeTarihi, SUM(OdenecekTutar) FROM tblFaturaBilgi
GROUP BY SonOdemeTarihi 
ORDER BY SonOdemeTarihi


