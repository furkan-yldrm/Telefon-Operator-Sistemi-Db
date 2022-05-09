
--S�zle�me s�resi 6 ay olan s�zle�melerden de�eri NULL olanlar�n cayma bedelinin 100 TL olarak g�ncellenmesi 
UPDATE tblSozlesme SET  CaymaBedeli = 100.00  WHERE SozlesmeSuresi = 6 AND CaymaBedeli IS NULL


--Eski m��teri fiyat� olan faturas�z paketlerde taahh�t s�resi 12 aydan fazla ise internet ve sms eklemesi
UPDATE tblPaket  SET   ToplamInternet = ToplamInternet + 1,ToplamDakika = ToplamDakika + 300, ToplamSms = ToplamSms + 250   
	WHERE FaturaTip = 2 AND EskiMusteriFiyat� IS NOT NULL AND TaahhutSuresi > 12


--Sistemdeki 6. Sim kart�n sahibinin sim kart�n� de�i�tirmesi 
UPDATE tblSozlesme SET	SimKart = 76  WHERE SimKart = 6 


--Bir ay boyunca toplam konu�ma s�resi 20 saatten fazla olan m��terilere 1000 dakika hediye edilmesi
UPDATE tblDakikaKullanimi SET  ToplamDakika = ToplamDakika + 1000  WHERE KonusmaSuresi > '20:00:00'


--M��terinin E-mail adresini g�ncellemesi 
UPDATE tblMusteri  SET  eMail ='merve.yldrm94@gmail.com'  WHERE eMail = 'mrve.yldrm@outlook.com'




