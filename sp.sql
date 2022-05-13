--Müþterilerin birbirlerine paketlerinde olan sms'lerden göndermesi
IF OBJECT_ID('spOrnek') IS NOT NULL
	BEGIN 
		DROP PROCEDURE spOrnek
	END
GO


CREATE PROCEDURE spOrnek(@gonderenID INT, @aliciID INT, @miktar INT)
AS
DECLARE @tranCounter INT = @@TRANCOUNT

IF @tranCounter > 0 
		SAVE TRANSACTION kontrolNoktasi

		BEGIN TRANSACTION
BEGIN TRY
DECLARE @toplam INT
	SELECT @toplam = ToplamSms FROM tblSmsKullanimi WHERE ID = @gonderenID 
IF @miktar > @toplam
	BEGIN 
		ROLLBACK TRANSACTION
	END
ELSE
	BEGIN
UPDATE tblSmsKullanimi SET ToplamSms = ToplamSms - @miktar 
	FROM tblMusteri M INNER JOIN tblSozlesme S 
		ON M.ID = S.MusteriID INNER JOIN tblSozlesmePaketi SP 
			ON S.SozlesmePaketi = SP.ID INNER JOIN tblSmsKullanimi SK
				ON SP.SmsKullanim = SK.ID 
	WHERE M.ID = @gonderenID

UPDATE tblSmsKullanimi SET ToplamSms = ToplamSms + @miktar 
	FROM tblMusteri M INNER JOIN tblSozlesme S 
		ON M.ID = S.MusteriID INNER JOIN tblSozlesmePaketi SP 
			ON S.SozlesmePaketi = SP.ID INNER JOIN tblSmsKullanimi SK
				ON SP.SmsKullanim = SK.ID 
	WHERE M.ID= @aliciID
	
	COMMIT
	END

END TRY

BEGIN CATCH
		IF @tranCounter = 0 OR XACT_STATE() = -1
			ROLLBACK TRANSACTION 
		ELSE
			BEGIN 
				ROLLBACK TRANSACTION kayitNoktasi
				COMMIT
			END
END CATCH
GO

SELECT * FROM tblSmsKullanimi
--1 id nolu müþterinin 2 id nolu müþteriye 500 sms göndermesi 
EXEC spOrnek  1,2,500
GO
--6 id nolu müþterinin 7 id nolu müþteriye 1000 sms göndermesi
--iþlem gerçekleþmez çünkü müþterinin yeterli sms'i yok
EXEC spOrnek 6,7,1000
GO
