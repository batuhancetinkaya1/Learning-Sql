/* 
1) Hen�z kay�tl� olmayan t�m hem�ireleri ve bilgilerini getir
*/
SELECT * FROM Nurse
WHERE Registered = 0

/* 
2) Hem�irelerden ba�hem�irenin ismini bulan sqlsorugusu
*/
SELECT Name, Position, EmployeeID FROM Nurse
WHERE Position = 'Head Nurse'

/* 
3)	Her bir b�l�m�n ba��ndaki doktorun ismini bulan bir sql sorgusu
*/
SELECT Physician.Name, Physician.SSN FROM Physician
JOIN Department ON Department.Head = Physician.EmployeeID

--BU DEMODEYM��
SELECT Physician.Name, Physician.SSN 
FROM Physician, Department
WHERE Department.Head = Physician.EmployeeID;

/* 
4)	En az bir doktordan randevu alan hasta say�s� result tablosuna basan bir sql sorgusu
*/
SELECT COUNT(DISTINCT Appointment.Patient) AS RESULT FROM Appointment

/* 
5)	212 Numaral� odan�n blok ve  kat numaras�n� bulan sql sorgusunu yaz�n�z
*/
SELECT BlockCode, BlockFloor FROM ROOM
WHERE RoomNumber = 212

/* 
6)	Hastalar i�in uygun olan odalar�n say�s�n� bulan bir sql sorgusu
*/
SELECT COUNT(*) AS [AVALIABLE ROOM COUNT] FROM ROOM
WHERE Unavailable = 0

/* 
7) Hangi doktorun hangi bran�a ait oldu�unu bulan bir sql sorgusu yaz�n�z
*/
SELECT Physician.Name, Department.Name AS DepartmentName
FROM Physician
JOIN Affiliated_With ON Affiliated_With.Physician = Physician.EmployeeID
JOIN Department ON  Department.DepartmentID = Affiliated_With.Department;

/* 
8) Hangi doktoroun hangi tedavi y�ntemleri konusunda e�itim ald���n� reuslt tablosuna bas
*/
SELECT Physician.Name, Procedures.Name, Procedures.Cost AS [Treatment]
FROM Physician
JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician
JOIN Procedures ON Trained_In.Treatment = Procedures.Code

/* 
9) Uzmanla�m�� doktorlar� bulan bir sql sorgusu yaz�n
*/
SELECT Physician.Name, Physician.Position  FROM Physician
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician
WHERE Trained_In.Treatment IS NULL

/* 
10) Hastan�n ismini adresi ve muayne oldu�u doktoru result tablosuna yazan bir sql sorgusu
*/
SELECT Patient.Name AS [Hasta Ad�], Patient.Address, Physician.Name AS [Doktor Ad�] 
FROM Patient
JOIN  Physician ON Physician.EmployeeID = Patient.PCP

/* 
11) Doktorlara al�nan randevu tablosundan hastan�n ismini ve hangi doktora randevu ald���n� result tablosuna bas�n�z
*/
SELECT Patient.Name AS [Hasta Ad�], Physician.Name AS [Doktor Ad�] 
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Patient ON Patient.PCP = Physician.EmployeeID 

/* 
12) Doktor odas� C de ka� farkl� hasta bak�ld���n� result tablosuna bast�ran bir sql sorgusu
*/
SELECT COUNT(DISTINCT Appointment.Patient) 
AS [C Odas�ndaki Hasta Say�s�]
FROM Appointment
WHERE CAST(Appointment.ExaminationRoom AS VARCHAR(MAX)) = 'C'

/* 
13) Hastan�n ismini ve Muayene ��in gitmesi gereken doktor odas�n� result tablosuna bast�ran bir sql sorgusu
*/
SELECT Patient.Name AS [HASTA ADI], Appointment.ExaminationRoom AS [MUAYENE ODASI] 
FROM Appointment
JOIN Patient ON Appointment.Patient = Patient.SSN

/* 
14) Doktor odas�n� ve doktor odas�nda  haz�r bulunmas� gereken hem�ireyi basan sql
*/
SELECT ExaminationRoom AS [MUAYENE ODASI], PrepNurse, Nurse.Name
FROM Appointment
JOIN Nurse ON Appointment.PrepNurse = Nurse.EmployeeID
ORDER BY CAST(ExaminationRoom AS VARCHAR(MAX)) ASC

/* 
15) 25 Nisan 2025 saat 10.00.00 da randevusu olan hastan�n doktorunun ismini hem�iresininin ismini ve doktor odas�n� result tablosuna
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Nurse.Name [NURSE NAME], ExaminationRoom, Appointment.Start AS [DATE]
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Nurse ON Appointment.PrepNurse = Nurse.EmployeeID
JOIN Patient ON Patient.SSN = Appointment.Patient
WHERE Appointment.Start = '2008-04-25 10:00:00'

/* 
16) Doktor muayenesi s�ras�nda hem�irenin asiste etmesine gerek olmayan hasta ve doktor ismini result tablosuna bast�ran
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME] 
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Patient ON Patient.SSN = Appointment.Patient
WHERE PrepNurse IS NULL

/* 
17) Hastan�n ismini doktorun ismini doktorun verdi�i  ilac�n ismini result tablosuna basan sql
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [�LA�]
FROM Patient 
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication

/* 
18) muayenede doktor taraf�ndan tekrar randevu verieln hastan�n ismini doktorun ismini ve doktorun verdi�i ilac� result tablosuna basan bir sql
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [�LA�],  Prescribes.Appointment AS [RANDEVU]
FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication
WHERE Prescribes.Appointment IS NOT NULL

/*
19) Muayenede doktor taraf�ndan tekrar randevu verilmeyen hastan�n ismini doktorun ve verdi�i ilac� result tablosuna basan
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [�LA�],  Prescribes.Appointment AS [RANDEVU]
FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication
WHERE Prescribes.Appointment IS NULL

/* 
20) Room tablosundaki herbir blok i�in ka� tane uygun oda oldu�unu result tablosuna basan sqwl sorgusunu yaz�n
*/
SELECT BlockCode, COUNT(BlockCode) AS [UYGUN ODA SAYISI] FROM Room
WHERE Room.Unavailable = 0
Group BY BlockCode

/* 
21) Herbir kattaki uygun odalar�n say�s�n� Result tablosuna basan sql sorgusu
*/
SELECT BlockFloor, COUNT(BlockFloor) AS [UYGUN ODA SAYISI]
FROM Room
WHERE Room.Unavailable = 0
Group BY BlockFloor

/* 
22) Ayn� katta bulunan herbir blocktaki uygun odalar�n say�sn� result tablosuna basn sql
*/
SELECT BlockCode, BlockFloor, COUNT(BlockCode) AS [UYGUN ODA SAYISI] 
FROM Room
WHERE Room.Unavailable = 0
GROUP BY BlockCode, BlockFloor 

/* 
23) Ayn� katta bulunan herbir blocktaki uygun olmayan odalar�n say�s�n� Result tablosuna basan sql sorgusunu yaz�n
*/
SELECT BlockCode, BlockFloor, COUNT(BlockCode) AS [UYGUN ODA SAYISI] FROM Room
WHERE Room.Unavailable = 1
GROUP BY BlockCode, BlockFloor 

/* 
24) En fazla uygun oda olmayan kat� bulan sql sorgusunu yaz�n
*/
SELECT TOP 1 BlockFloor, COUNT(*) AS [UYGUN OLMAYAN ODA SAYISI]
FROM Room
WHERE Unavailable = 1
GROUP BY BlockFloor
ORDER BY COUNT(*) DESC;


/* 
25) En fazla uygun oda bulunan kat� bulan sql
*/
SELECT TOP 1 BlockFloor, COUNT(*) AS [UYGUN OLAN ODA SAYISI]
FROM Room
WHERE Unavailable = 0
GROUP BY BlockFloor
ORDER BY COUNT(*) DESC;

/* 
26) HaStan�n ismini tedavi g�rd��� oda numaras�n� block'unu ve hangi katta tedavi g�rd���n� result tablosuna bst�ran bir sql sorgusu yaz�n
*/
SELECT Name AS [Hasta Ad�],  Stay.Room AS [Oda Numaras�], Room.BlockCode AS [Odan�n Bulundu�u Blok], Room.BlockFloor AS [Odan�n Bulundu�u Kat] 
FROM Patient
JOIN Stay ON Stay.Patient = Patient.SSN
JOIN Room ON Stay.Room = Room.RoomNumber

/* 
27) Hangi hem�irenin hangi kat ve block ta g�revli oldu�unu result tablosuna basan bir sql sorgusu
*/
SELECT * FROM Nurse, On_Call
SELECT Nurse.EmployeeID, Nurse.Name, On_Call.BlockCode AS [Odan�n Bulundu�u Blok], On_Call.BlockFloor AS [Odan�n Bulundu�u Kat]
FROM Nurse
JOIN On_Call ON On_Call.Nurse = Nurse.EmployeeID

/* 
28) Patronunuz tedavi olan ve hastanede yat�� yapan hastalar i�in kapsaml� bir rapor istedi:
Bu tabloda
-Hastan�n ismi
-Hastay� Tedavi eden doktorun ad�
-Tedavi s�ras�nda bulunan hem�irenin ismi
-Hastan�n taburcu olma tarihi
-Hastan�n kald��� oda numras�
-Odan�n bulundu�u kat ve blok
*/
SELECT 
	Patient.Name AS [Hasta Ad�], 
	Physician.Name AS [Doktor Ad�],
	Nurse.Name AS [Hem�ire Ad�],
	Stay.StayEnd As [Taburcu Olma Tarihi],
	Stay.Room AS [Kald��� Oda],
	Room.BlockCode AS [Blok Numaras�],
	Room.BlockFloor AS [Kat]
FROM 
	Undergoes
JOIN Patient ON Undergoes.Patient = Patient.SSN
JOIN Stay ON Undergoes.Stay = Stay.StayID
JOIN Physician ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Nurse ON Undergoes.AssistingNurse = Nurse.EmployeeID
JOIN Room ON Stay.Room = Room.RoomNumber


/* 
29) Doktorlardan tedavi yapmas�na ra�men o bran�la ilgili sertifikas� bulunmayan doktorlar�n ismini result  tablosuna bas
*/
SELECT Name
FROM Physician
JOIN Undergoes ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = Undergoes.Procedures
WHERE Trained_In.Physician IS NULL

/* 
30) Doktorlar�n tedavi yapmas�nna ra�men o bran�la ilgili sertifikas� bulunmayan doktorlar�n ismini yapt��� tedvinin zaman�n� ve hangi hastaya uygulad���n� bulan sql
*/
SELECT Physician.Name AS [Doktor Ad�], Patient.Name AS [Hasta Ad�]
FROM Physician
JOIN Undergoes ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = Undergoes.Procedures
JOIN Patient ON Patient.SSN = Undergoes.Patient
WHERE Trained_In.Physician IS NULL

/* 
31) 122 numaral� odada yatan hstan�n �a��rabilece�i hem�ireleri basan sql
*/
SELECT Nurse.Name
FROM On_Call
JOIN Nurse ON Nurse.EmployeeID = On_Call.Nurse
WHERE 
	On_Call.BlockFloor = (SELECT Room.BlockFloor FROM Room WHERE Room.RoomNumber = 112)
	AND 
	On_Call.BlockCode = (SELECT BlockCode FROM Room WHERE Room.RoomNumber = 112)

--ALTERNAT�F ��Z�M
SELECT Name FROM Nurse
WHERE EmployeeID IN
(SELECT On_Call.Nurse FROM On_Call, Room
WHERE On_Call.BlockFloor = Room.BlockFloor
AND On_Call.BlockCode = Room.BlockCode
AND Room.RoomNumber = 112)

/* 
32) Hastaneye ilk s�radan gelen hastay� ila�la tedavi edilen hastan�n ismini ve doktorun ismini veren sql
*/
SELECT TOP 1 * FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Patient.PCP = EmployeeID
Order BY Prescribes.Date ASC

/* 
33) Hastaneye yatarak tedavi olmak i�in ilk s�rada gelen hastadan maliyeti 5000 dolar� ge�en tedaviler i�in hastan�n ismini doktorun ismini ve maliyetini result tablosuna basan sql
*/
SELECT 
    Patient.Name AS HastaAdi,
    Physician.Name AS DoktorAdi,
    Procedures.Cost AS Maliyet
FROM Undergoes
JOIN Patient ON Patient.SSN = Undergoes.Patient
JOIN Physician ON Physician.EmployeeID = Undergoes.Physician
JOIN Procedures ON Procedures.Code = Undergoes.Procedures
WHERE 
    Undergoes.Patient = (
        SELECT TOP 1 Patient 
        FROM Undergoes
        ORDER BY DateUndergoes ASC
    )
	AND 
	Procedures.Cost > 5000;

