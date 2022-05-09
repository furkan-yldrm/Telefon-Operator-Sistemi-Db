
--Eski m��teri fiyat� olan paketlerin silinmesi
DELETE FROM tblPaket WHERE EskiMusteriFiyat� IS NOT NULL


--Kurumsal m��terilerin silinmesi 
DELETE FROM tblMusteri WHERE MusteriTip = 2


--Kurumsal m��teri kavram�n�n silinmesi 
DELETE FROM tblMusteriTipi WHERE Tip = 'Kurumsal'


--01.01.2021 g�n�nden �nce yap�lan s�zle�melerin silinmesi
DELETE FROM tblSozlesme WHERE BaslamaTrh < '2021-01-01'


--Outlook uzant�l� mail adresi olan m��terilerin silinmesi
DELETE FROM tblMusteri WHERE eMail LIKE '%outlook%'




