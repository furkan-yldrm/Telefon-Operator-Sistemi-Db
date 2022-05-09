
--Sözleþme süresi 6 ay olan sözleþmelerden deðeri NULL olanlarýn cayma bedelinin 100 TL olarak güncellenmesi 
UPDATE tblSozlesme SET  CaymaBedeli = 100.00  WHERE SozlesmeSuresi = 6 AND CaymaBedeli IS NULL


--Eski müþteri fiyatý olan faturasýz paketlerde taahhüt süresi 12 aydan fazla ise internet ve sms eklemesi
UPDATE tblPaket  SET   ToplamInternet = ToplamInternet + 1,ToplamDakika = ToplamDakika + 300, ToplamSms = ToplamSms + 250   
	WHERE FaturaTip = 2 AND EskiMusteriFiyatý IS NOT NULL AND TaahhutSuresi > 12


--Sistemdeki 6. Sim kartýn sahibinin sim kartýný deðiþtirmesi 
UPDATE tblSozlesme SET	SimKart = 76  WHERE SimKart = 6 


--Bir ay boyunca toplam konuþma süresi 20 saatten fazla olan müþterilere 1000 dakika hediye edilmesi
UPDATE tblDakikaKullanimi SET  ToplamDakika = ToplamDakika + 1000  WHERE KonusmaSuresi > '20:00:00'


--Müþterinin E-mail adresini güncellemesi 
UPDATE tblMusteri  SET  eMail ='merve.yldrm94@gmail.com'  WHERE eMail = 'mrve.yldrm@outlook.com'




