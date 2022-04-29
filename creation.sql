CREATE DATABASE TelefonOperator
		ON PRIMARY	(
						NAME = 'TelefonOperatordb',
						FILENAME = 'C:\DATABASE\TelefonOperator_db.mdf',
						SIZE = 5MB,
						MAXSIZE = 100MB,
						FILEGROWTH = 5MB
					)
		LOG ON		(
						NAME = 'TelefonOperatordb_log',
						FILENAME = 'C:\DATABASE\TelefonOperator_log.ldf',
						SIZE  = 2MB,
						MAXSIZE = 5MB,
						FILEGROWTH = 1MB
					)
GO

USE TelefonOperator


--Bu tabloda m��teri tipleri tutulur (Bireysel veya kurumsal)
CREATE TABLE tblMusteriTipi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Tip CHAR(8) NOT NULL
)
GO


--Telefon numaralar�n� tutar.
CREATE TABLE tblTelNo
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	TelNo CHAR(11) CONSTRAINT telFormat CHECK (TelNo LIKE '[0][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')--TelNo 11 haneden olu�ur ve 0'la ba�lar.
)
GO


--M��teri bilgilerinin bulundu�u tablo
CREATE TABLE tblMusteri
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	MusteriAd VARCHAR(70)NOT NULL,
	DogumTarihi DATE,--Kurumsal m��terilerin girmesi zorunlu de�ildir.
	Yas AS DATEDIFF(yy,DogumTarihi,GETDATE()),
	eMail VARCHAR(40) CONSTRAINT mailUnq UNIQUE
					  CONSTRAINT mailnotNull NOT NULL
					  CONSTRAINT mailCheck CHECK (eMail LIKE '%@%.com'),
	Parola VARCHAR(10) NOT NULL,
	Kay�tTarihi DATE NOT NULL,
	MusteriTip INT FOREIGN KEY REFERENCES tblMusteriTipi (ID) NOT NULL,
	TelefonNo INT FOREIGN KEY REFERENCES tblTelNo (ID) NOT NULL
)
GO


--Paketin ve s�zle�menin tipinin tutar (Fatural�,faturas�z)
CREATE TABLE tblFaturaTipi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Tip VARCHAR(20) NOT NULL	
)
GO


--Sim kart bilgilerini i�erir.
CREATE TABLE tblSimKart
(
	Barkod INT IDENTITY(1,1) PRIMARY KEY,
	PinKodu CHAR(4)	CONSTRAINT pinnotNull NOT NULL,
	PukKodu CHAR(4) NOT NULL				
)
GO
ALTER TABLE tblSimKart WITH NOCHECK ADD CONSTRAINT PinKontrol CHECK (PinKodu LIKE '[0-9][0-9][0-9][0-9]') 
--Pin kodu 4 rakamdan olu�mak zorunda


--Fatura bilgilerinin tutuldu�u tablo
CREATE TABLE tblFaturaBilgi
(
	ID INT IDENTITY (1,1) PRIMARY KEY,
	KesilmeTrh DATE NOT NULL,
	SonOdemeTarihi AS DATEADD(day,15,KesilmeTrh), --Fatura 15 g�n i�inde �denmelidir.
	OdenecekTutar FLOAT NOT NULL
)
GO


--Paket bilgilerinin tutuldu�u tablo.
CREATE TABLE tblPaket 
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Aciklama VARCHAR(120) NOT NULL,
	ToplamInternet INT NOT NULL, --Gigabyte cinsinden 
	ToplamDakika INT NOT NULL, --Dakika cinsinden 
	ToplamSms INT NOT NULL,
	StandartFiyat FLOAT NOT NULL, 
	EskiMusteriFiyat� FLOAT, --Baz� paketlerin fiyat� standartt�r.
	TaahhutSuresi INT, --Taahh�t� olmayan paketler de vard�r.
	FaturaTip INT FOREIGN KEY REFERENCES tblFaturaTipi(ID) NOT NULL
)
GO


--Ne kadar internet kullan�ld���n� g�steren tablo.
CREATE TABLE tblInternetKullanimi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	GecirilenSure TIME NOT NULL, -- Ayl�k toplam
	ToplamMegabyte DECIMAL(5,3) NOT NULL,
	KullanilanMegabyte DECIMAL(5,3) NOT NULL, --Megabyte cinsinden
	KalanByte AS (ToplamMegabyte - KullanilanMegabyte)
)
GO


--Ne kadar dakika kulan�ld���n� g�steren tablo.
CREATE TABLE tblDakikaKullanimi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	KonusmaSuresi TIME NOT NULL, --Ayl�k toplam
	ToplamDakika INT NOT NULL,
	HarcananDakika INT NOT NULL,
	KalanDakika AS (ToplamDakika - HarcananDakika)
)
GO


--Ne kadar sms kullan�ld���n� g�steren tablo.
CREATE TABLE tblSmsKullanimi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	ToplamSms INT NOT NULL,
	GonderilenSmsSayisi INT NOT NULL, -- 1 ayda g�nderilen toplam sms 
	KalanSms AS (ToplamSms - GonderilenSmsSayisi)
)
GO


--Paket ve s�zle�melerin ba�land��� tablo.
CREATE TABLE tblSozlesmePaketi
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	PaketBilgileri INT FOREIGN KEY REFERENCES tblPaket(ID)
	ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	InternetKullanim INT FOREIGN KEY REFERENCES tblInternetKullanimi(ID) NOT NULL,
	DakikaKullanim INT FOREIGN KEY REFERENCES tblDakikaKullanimi(ID) NOT NULL,
	SmsKullanim INT FOREIGN KEY REFERENCES tblSmsKullanimi(ID) NOT NULL
)
GO


--S�zle�me bilgilerinin tutuldu�u tablo.
CREATE TABLE tblSozlesme
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	MusteriID INT FOREIGN KEY REFERENCES tblMusteri(ID)
	ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	BaslamaTrh DATE NOT NULL,
	SozlesmeSuresi INT NOT NULL, --Ay cinsinden
	BitisTarihi AS DATEADD(month,SozlesmeSuresi,BaslamaTrh),
	CaymaBedeli FLOAT,  --Baz� s�zle�melerde cayma bedeli bulunmayabilir.
	SozlesmePaketi INT FOREIGN KEY REFERENCES tblSozlesmePaketi(ID)
	ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	FaturTipi INT FOREIGN KEY REFERENCES tblFaturaTipi(ID) NOT NULL,
	FaturaBilgi INT FOREIGN KEY REFERENCES tblFaturaBilgi(ID) NOT NULL,
	SimKart INT FOREIGN KEY REFERENCES tblSimKart(Barkod) NOT NULL
)
GO