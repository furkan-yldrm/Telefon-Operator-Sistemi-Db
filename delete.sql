
--Eski müþteri fiyatý olan paketlerin silinmesi
DELETE FROM tblPaket WHERE EskiMusteriFiyatý IS NOT NULL


--Kurumsal müþterilerin silinmesi 
DELETE FROM tblMusteri WHERE MusteriTip = 2


--Kurumsal müþteri kavramýnýn silinmesi 
DELETE FROM tblMusteriTipi WHERE Tip = 'Kurumsal'


--01.01.2021 gününden önce yapýlan sözleþmelerin silinmesi
DELETE FROM tblSozlesme WHERE BaslamaTrh < '2021-01-01'


--Outlook uzantýlý mail adresi olan müþterilerin silinmesi
DELETE FROM tblMusteri WHERE eMail LIKE '%outlook%'




