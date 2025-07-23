-- =============================================
-- SQL REFERANS NOTLARI — Özet + Çalıştırılabilir Örnekler  (2025‑04‑28)
-- Hazırlayan  : Batuhan Çetinkaya
-- Güncelleyen : ChatGPT  |  Son Günc. : 28‑04‑2025
-- Amacı       : “Aklıma takıldı → CTRL + F”  kılavuzu  ➜  Hızlı hatırlatıcı + deneme alanı
-- Notlar      : * Her başlık iki bölümden oluşur → (1) Kavramsal özet  (2) Çalıştırılabilir örnek
--              * "-- ►"   = Ana konu  /  "-- •"  = Alt ipucu  /  "-- EX:" = Örnek sorgu
--              * Kodlar SQL Server (T‑SQL) içindir; diğer RDBMS’lerde sözdizimi ufak değişebilir.
-- =============================================

/* ╔════════════════════════════════════════════╗
   ║  1. DDL  (Data Definition Language)        ║
   ╠════════════════════════════════════════════╣
   ║  * Veri yapısını oluşturur veya değiştirir.║
   ╚════════════════════════════════════════════╝ */

-- ► Veritabanı ----------------------------------------------------------------
-- • CREATE / DROP   : DB düzeyinde ekleme & silme.
-- • BACKUP / RESTORE:  Günlük yedek senaryosu.
CREATE DATABASE SampleDB;
DROP   DATABASE SampleDB;
GO
BACKUP DATABASE SampleDB 
    TO DISK = 'C:\Backups\SampleDB_FULL_2025-04-28.bak';
/*
RESTORE DATABASE SampleDB 
    FROM DISK = 'C:\Backups\SampleDB_FULL_2025-04-28.bak';
*/

-- ► Tablo ----------------------------------------------------------------------
-- • PRIMARY KEY  : Benzersiz tanımlayıcı.
-- • CHECK / DEFAULT / UNIQUE kısıtlarıyla veri doğruluğu.
CREATE TABLE Personel (
    PersonelID INT          IDENTITY(1,1)      PRIMARY KEY,
    Ad         NVARCHAR(50) NOT NULL,
    Soyad      NVARCHAR(50) NOT NULL,
    Yas        TINYINT      CHECK (Yas>=18),
    Email      NVARCHAR(60) UNIQUE,
    Sehir      VARCHAR(40)  DEFAULT 'Bilinmiyor',
    YoneticiID INT          NULL               -- Self‑JOIN için
);

-- ► Tablo Değişiklikleri -------------------------------------------------------
ALTER TABLE Personel ADD  Telefon NVARCHAR(15);      -- Kolon ekle
ALTER TABLE Personel ALTER COLUMN Yas SMALLINT;      -- Veri tipi değiştir
ALTER TABLE Personel DROP COLUMN  Telefon;           -- Kolon kaldır

-- ► Kimlik Sıfırlama & Manuel Ekleme ------------------------------------------
DBCC CHECKIDENT ('Personel', RESEED, 0);             -- IDENTITY yeniden başlat
SET IDENTITY_INSERT Personel ON;
INSERT INTO Personel(PersonelID,Ad,Soyad,Yas)
VALUES (99,'Manual','Entry',30);
SET IDENTITY_INSERT Personel OFF;

-- ► Diğer DDL Kırıntıları -------------------------------------------------------
-- EX: Kolon adını değiştirmek (SP_RENAME):
-- EXEC sp_rename 'Personel.Soyad', 'SoyIsim', 'COLUMN';
-- EX: Şemanın başka kullanıcıya devri (ALTER AUTHORIZATION)...

/* ╔════════════════════════════════════════════╗
   ║  2. DML  (Data Manipulation Language)      ║
   ╠════════════════════════════════════════════╣
   ║  * Veriyi ekle, güncelle, sil, oku.        ║
   ╚════════════════════════════════════════════╝ */

INSERT INTO Personel (Ad,Soyad,Yas,Email)
VALUES ('Ayşe','Kara',28,'ayse.kara@example.com');

UPDATE Personel
SET    Email = 'ayse.kara@firma.com'
OUTPUT inserted.PersonelID, deleted.Email AS EskiMail, inserted.Email AS YeniMail
WHERE  PersonelID = 1;

DELETE FROM Personel WHERE PersonelID = 1;          -- Tek satır sil
-- TRUNCATE TABLE Personel;   -- Tam temizlik (geri ALINAMAZ)

-- • MERGE : UPSERT örneği -------------------------------------------------------
/*
MERGE INTO Personel AS hedef
USING (SELECT 1 AS PersonelID, 'Ayşe','Kara',28,'ayse@firma.com') AS kaynak
ON  hedef.PersonelID = kaynak.PersonelID
WHEN MATCHED THEN UPDATE SET Email = kaynak.Email
WHEN NOT MATCHED THEN INSERT (Ad,Soyad,Yas,Email) VALUES(kaynak.Ad,kaynak.Soyad,kaynak.Yas,kaynak.Email);
*/

/* ╔════════════════════════════════════════════╗
   ║  3. SORGULAR (SELECT) — Temeller           ║
   ╚════════════════════════════════════════════╝ */

SELECT * FROM Personel;                                       -- Tüm sütunlar
SELECT Ad,Soyad FROM Personel WHERE Sehir='İstanbul';         -- Yalnız belirli sütunlar

-- ► WHERE --------------------------------------------------
SELECT * FROM Personel WHERE Sehir='İzmir' OR Yas<25;         -- Mantıksal bağlaçlar
SELECT * FROM Personel WHERE Sehir IN ('İzmir','Ankara');     -- IN kümesi
SELECT * FROM Personel WHERE Yas BETWEEN 20 AND 30;           -- Aralık

-- • CASE ifadesi (koşullu sütun) ---------------------------
SELECT Ad,
       CASE WHEN Yas<25 THEN 'Genç'
            WHEN Yas BETWEEN 25 AND 40 THEN 'Orta'
            ELSE 'Deneyimli' END AS Kategori
FROM Personel;

-- ► LIKE ---------------------------------------------------
SELECT * FROM Personel WHERE Ad LIKE 'A%';        -- "A" ile başlar
SELECT * FROM Personel WHERE Ad LIKE '%e%';       -- "e" içerir
SELECT * FROM Personel WHERE Ad LIKE '%y';        -- "y" ile biter
SELECT * FROM Personel WHERE Ad LIKE '___e';      -- 4 harf, "e" ile biter
SELECT * FROM Personel WHERE Email LIKE '%\%%' ESCAPE '\';  -- "%" karakteri içerir

-- ► Sıralama & İlk N --------------------------------------
SELECT TOP 10 * FROM Personel ORDER BY Yas DESC;   -- İlk 10 satır
SELECT TOP 5 PERCENT WITH TIES *
FROM Personel ORDER BY Yas DESC;                   -- En üst %5 (+eşitler)

-- ► Gruplama ----------------------------------------------
SELECT DISTINCT Sehir FROM Personel;               -- Tekrarsız
SELECT Sehir, COUNT(*) AS KisiSayisi
FROM   Personel
GROUP  BY Sehir
ORDER  BY KisiSayisi DESC;

/* ╔════════════════════════════════════════════╗
   ║  4. AGREGAT + HAVING                       ║
   ╚════════════════════════════════════════════╝ */

SELECT MIN(Yas)  EnKucuk,
       MAX(Yas)  EnBuyuk,
       AVG(Yas)  Ort,
       SUM(Yas)  Toplam,
       COUNT(*)  KayitSayisi
FROM   Personel;

SELECT Sehir, AVG(Yas) Ortalama
FROM   Personel
GROUP  BY Sehir
HAVING AVG(Yas) > 30;          -- Gruplandiktan sonra filtrele

/* ╔════════════════════════════════════════════╗
   ║  5. YERLEŞİK FONKSİYONLAR                  ║
   ╚════════════════════════════════════════════╝ */

-- ► String
SELECT  UPPER(Ad)               AS BuyukAd,
        LOWER(Soyad)            AS KucukSoyad,
        LEN(Email)              AS Uzunluk,
        CONCAT(Ad,' ',Soyad)    AS TamIsim,
        LEFT(Ad,3)              AS Ilk3,
        RIGHT(Soyad,2)          AS Son2,
        REPLACE(Ad,'ş','s')     AS Seo,
        CHARINDEX('@',Email)    AS AtPos,
        STUFF(Email,1,0,'📧 ')  AS EmojiMail
FROM    Personel;

-- ► Tarih & Benzersiz
SELECT  GETDATE()                      AS Simdi,
        SYSDATETIME()                  AS YüksekHassasiyet,
        EOMONTH(GETDATE())             AS AySonu,
        DATEADD(month,3,GETDATE())     AS UcAySonra,
        NEWID()                        AS RassalGuid,
        DATEDIFF(day,'2000-01-01',GETDATE()) AS GunFarki;

-- ► COALESCE / ISNULL / NULLIF
SELECT  COALESCE(Email,'[boş]')    AS Mail,
        ISNULL(Sehir,'(tanımsız)') AS Sehir,
        NULLIF(Ad,'Adsiz')         AS AdKontrol
FROM    Personel;

/* ╔════════════════════════════════════════════╗
   ║  6. JOIN  (Çoklu Tablo)                    ║
   ╠════════════════════════════════════════════╣
   ║  * Tabloları mantıksal olarak birleştirir.  ║
   ╚════════════════════════════════════════════╝ */

CREATE TABLE Siparis (
    SiparisID  INT IDENTITY PRIMARY KEY,
    PersonelID INT         NOT NULL,
    Tarih      DATE        DEFAULT GETDATE(),
    Tutar      DECIMAL(10,2),
    FOREIGN KEY (PersonelID) REFERENCES Personel(PersonelID)
);

-- ► INNER JOIN: Kesişim -----------------------
SELECT p.Ad,p.Soyad,s.Tutar,s.Tarih
FROM   Personel p
JOIN   Siparis  s ON p.PersonelID = s.PersonelID;

-- ► LEFT JOIN: Tüm personel + varsa sipariş ---
SELECT p.Ad,p.Soyad,s.Tutar
FROM   Personel p
LEFT  JOIN Siparis s ON p.PersonelID = s.PersonelID;

-- ► RIGHT / FULL OUTER örnek ------------------
/*
SELECT *
FROM   Siparis s
RIGHT JOIN Personel p ON p.PersonelID = s.PersonelID;   -- SQL Server’da eşdeğer

SELECT *
FROM   Personel p
FULL  JOIN Siparis s ON p.PersonelID = s.PersonelID;    -- Birleşim (NULL’lar dâhil)
*/

-- ► SELF JOIN (yönetici – çalışan) ------------
SELECT  c.Ad+' '+c.Soyad  AS Calisan,
        y.Ad+' '+y.Soyad  AS Yonetici
FROM    Personel c
LEFT JOIN Personel y ON c.YoneticiID = y.PersonelID;

-- ► CROSS APPLY (fonksiyonlu) -----------------
/*
SELECT p.*, d.Tutar
FROM   Personel p
CROSS APPLY (SELECT TOP 1 Tutar FROM Siparis s WHERE s.PersonelID = p.PersonelID ORDER BY Tarih DESC) d;
*/

/* ╔════════════════════════════════════════════╗
   ║  7. ALT SORGULAR & SET OPERATÖRLERİ        ║
   ╚════════════════════════════════════════════╝ */

-- ► EXISTS (var mı?)
SELECT Ad,Soyad
FROM   Personel p
WHERE  EXISTS (SELECT 1 FROM Siparis s WHERE s.PersonelID = p.PersonelID);

-- ► ANY / ALL (bağıl karşılaştırma)
SELECT *
FROM   Siparis
WHERE  Tutar > ALL (SELECT AVG(Tutar) FROM Siparis);

-- ► UNION / INTERSECT / EXCEPT
SELECT Sehir FROM Personel WHERE Yas>30
UNION
SELECT Sehir FROM Personel WHERE Sehir='İzmir';

-- ► CTE (Common Table Expression) örneği -------
WITH YasRaporu AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY Yas DESC) AS Sira
    FROM Personel)
SELECT * FROM YasRaporu WHERE Sira<=3;

-- ► SELECT INTO + INSERT‑SELECT
SELECT * INTO PersonelBackup2025 FROM Personel;
INSERT INTO PersonelBackup2025(Ad,Soyad,Yas,Email,Sehir)
SELECT Ad,Soyad,Yas,Email,Sehir
FROM   Personel WHERE Sehir='Ankara';

/* ╔════════════════════════════════════════════╗
   ║  8. PROGRAMLAMA BLOKLARI (T‑SQL)           ║
   ╚════════════════════════════════════════════╝ */

DECLARE @Mesaj NVARCHAR(50)='Merhaba SQL!';  PRINT @Mesaj;

-- ► Döngü ------------------------------------
DECLARE @Sayac INT=1;
WHILE @Sayac<=3
BEGIN
    PRINT CONCAT('Tur ',@Sayac);
    SET @Sayac+=1;
END

-- ► IF…ELSE ----------------------------------
IF EXISTS(SELECT 1 FROM Personel WHERE Email IS NULL)
    PRINT 'Eksik e‑posta var';
ELSE
    PRINT 'Tüm e‑postalar dolu';

-- ► TRY…CATCH --------------------------------
BEGIN TRY
    INSERT INTO Personel(PersonelID,Ad,Soyad,Yas) VALUES (1,'Hata','Deneme',15);
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

/* ╔════════════════════════════════════════════╗
   ║  9. SP & FONKSİYONLAR                      ║
   ╚════════════════════════════════════════════╝ */

GO
CREATE OR ALTER PROCEDURE SP_Personel_BySehir @Sehir NVARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Personel WHERE Sehir=@Sehir;
END
GO
EXEC SP_Personel_BySehir 'İstanbul';

GO
CREATE OR ALTER FUNCTION fn_TamIsim (@ID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @S NVARCHAR(100);
    SELECT @S=Ad+' '+Soyad FROM Personel WHERE PersonelID=@ID;
    RETURN ISNULL(@S,'Bulunamadı');
END
GO
SELECT dbo.fn_TamIsim(2);

GO
CREATE OR ALTER FUNCTION fn_Siparisleri (@ID INT)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Siparis WHERE PersonelID=@ID
);
GO
SELECT * FROM fn_Siparisleri(2);

/* ╔════════════════════════════════════════════╗
   ║ 10. GEÇİCİ TABLOLAR / TABLO DEĞİŞKENLERİ   ║
   ╚════════════════════════════════════════════╝ */

-- ► Tablo Değişkeni (scope = batch) ----------
DECLARE @Tmp TABLE(ID INT, Rnd UNIQUEIDENTIFIER DEFAULT NEWID());
INSERT INTO @Tmp(ID) VALUES(1),(2);
SELECT * FROM @Tmp;

-- ► Local & Global Temp Tables ---------------
CREATE TABLE #LocalTmp  (ID INT, Aciklama NVARCHAR(20)); -- Oturum süresince
CREATE TABLE ##GlobalTmp(Tarih DATE, Tutar MONEY);       -- Sunucu süresince

/* ╔════════════════════════════════════════════╗
   ║ 11. VIEW & INDEX                           ║
   ╚════════════════════════════════════════════╝ */

CREATE OR ALTER VIEW vw_Izmir_Personel AS
SELECT * FROM Personel WHERE Sehir='İzmir';
GO
SELECT * FROM vw_Izmir_Personel;

-- ► Index ---------------------------------------------------
CREATE INDEX IX_Personel_Sehir      ON Personel(Sehir);
CREATE INDEX IX_Personel_Sehir18Yas ON Personel(Sehir) WHERE Yas>=18;  -- Filtreli

/* ╔════════════════════════════════════════════╗
   ║ 12. TRANSACTION                            ║
   ╚════════════════════════════════════════════╝ */

SET XACT_ABORT ON;   -- Hata olursa otomatik ROLLBACK
BEGIN TRAN
    UPDATE Personel SET Yas = 'hata' WHERE PersonelID=99;  -- type error
COMMIT;  -- Çalışmaz; otomatik geri alınır

/* EX: El ile kontrol ---------------------------------------
BEGIN TRAN;
    UPDATE Siparis SET Tutar = Tutar*1.10;
IF @@ERROR <> 0
    ROLLBACK TRAN;
ELSE
    COMMIT TRAN;
*/

/* ╔════════════════════════════════════════════╗
   ║ 13. YARDIMCI KOMUTLAR & İPUÇLAR            ║
   ╚════════════════════════════════════════════╝ */

EXEC sp_help               Personel;   -- Tablo şeması
EXEC sp_describe_first_result_set N'SELECT * FROM Personel WHERE 1=0';

-- En iyi uygulamalar:
-- • WHERE’siz UPDATE / DELETE yapma ➜ Yedek almadan üretime dokunma.
-- • SELECT * yerine gerekli sütunları çek ➜ Network + bellek tasarrufu.
-- • Düzenli yedek + kaynak kodu Git repo’su ➜ Felaket kurtarma.
-- • Gereksiz NULL bırakma; CHECK & DEFAULT ile koru ➜ Veri tutarlılığı.
-- • Kimlik sütununa doğrudan değer atamak gerekiyorsa IDENTITY_INSERT kullan.
-- • Performans izle: indeks, execution plan, istatistik (SET STATISTICS IO, TIME ON).
-- • Sorgu parçala / CTE kullan / indeks tavsiye edici DMV’leri incele.
