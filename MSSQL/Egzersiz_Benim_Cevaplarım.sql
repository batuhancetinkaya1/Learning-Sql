/* 
1) Henüz kayýtlý olmayan tüm hemþireleri ve bilgilerini getir
*/
SELECT * FROM Nurse
WHERE Registered = 0

/* 
2) Hemþirelerden baþhemþirenin ismini bulan sqlsorugusu
*/
SELECT Name, Position, EmployeeID FROM Nurse
WHERE Position = 'Head Nurse'

/* 
3)	Her bir bölümün baþýndaki doktorun ismini bulan bir sql sorgusu
*/
SELECT Physician.Name, Physician.SSN FROM Physician
JOIN Department ON Department.Head = Physician.EmployeeID

--BU DEMODEYMÝÞ
SELECT Physician.Name, Physician.SSN 
FROM Physician, Department
WHERE Department.Head = Physician.EmployeeID;

/* 
4)	En az bir doktordan randevu alan hasta sayýsý result tablosuna basan bir sql sorgusu
*/
SELECT COUNT(DISTINCT Appointment.Patient) AS RESULT FROM Appointment

/* 
5)	212 Numaralý odanýn blok ve  kat numarasýný bulan sql sorgusunu yazýnýz
*/
SELECT BlockCode, BlockFloor FROM ROOM
WHERE RoomNumber = 212

/* 
6)	Hastalar için uygun olan odalarýn sayýsýný bulan bir sql sorgusu
*/
SELECT COUNT(*) AS [AVALIABLE ROOM COUNT] FROM ROOM
WHERE Unavailable = 0

/* 
7) Hangi doktorun hangi branþa ait olduðunu bulan bir sql sorgusu yazýnýz
*/
SELECT Physician.Name, Department.Name AS DepartmentName
FROM Physician
JOIN Affiliated_With ON Affiliated_With.Physician = Physician.EmployeeID
JOIN Department ON  Department.DepartmentID = Affiliated_With.Department;

/* 
8) Hangi doktoroun hangi tedavi yöntemleri konusunda eðitim aldýðýný reuslt tablosuna bas
*/
SELECT Physician.Name, Procedures.Name, Procedures.Cost AS [Treatment]
FROM Physician
JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician
JOIN Procedures ON Trained_In.Treatment = Procedures.Code

/* 
9) Uzmanlaþmýþ doktorlarý bulan bir sql sorgusu yazýn
*/
SELECT Physician.Name, Physician.Position  FROM Physician
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician
WHERE Trained_In.Treatment IS NULL

/* 
10) Hastanýn ismini adresi ve muayne olduðu doktoru result tablosuna yazan bir sql sorgusu
*/
SELECT Patient.Name AS [Hasta Adý], Patient.Address, Physician.Name AS [Doktor Adý] 
FROM Patient
JOIN  Physician ON Physician.EmployeeID = Patient.PCP

/* 
11) Doktorlara alýnan randevu tablosundan hastanýn ismini ve hangi doktora randevu aldýðýný result tablosuna basýnýz
*/
SELECT Patient.Name AS [Hasta Adý], Physician.Name AS [Doktor Adý] 
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Patient ON Patient.PCP = Physician.EmployeeID 

/* 
12) Doktor odasý C de kaç farklý hasta bakýldýðýný result tablosuna bastýran bir sql sorgusu
*/
SELECT COUNT(DISTINCT Appointment.Patient) 
AS [C Odasýndaki Hasta Sayýsý]
FROM Appointment
WHERE CAST(Appointment.ExaminationRoom AS VARCHAR(MAX)) = 'C'

/* 
13) Hastanýn ismini ve Muayene Ýçin gitmesi gereken doktor odasýný result tablosuna bastýran bir sql sorgusu
*/
SELECT Patient.Name AS [HASTA ADI], Appointment.ExaminationRoom AS [MUAYENE ODASI] 
FROM Appointment
JOIN Patient ON Appointment.Patient = Patient.SSN

/* 
14) Doktor odasýný ve doktor odasýnda  hazýr bulunmasý gereken hemþireyi basan sql
*/
SELECT ExaminationRoom AS [MUAYENE ODASI], PrepNurse, Nurse.Name
FROM Appointment
JOIN Nurse ON Appointment.PrepNurse = Nurse.EmployeeID
ORDER BY CAST(ExaminationRoom AS VARCHAR(MAX)) ASC

/* 
15) 25 Nisan 2025 saat 10.00.00 da randevusu olan hastanýn doktorunun ismini hemþiresininin ismini ve doktor odasýný result tablosuna
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Nurse.Name [NURSE NAME], ExaminationRoom, Appointment.Start AS [DATE]
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Nurse ON Appointment.PrepNurse = Nurse.EmployeeID
JOIN Patient ON Patient.SSN = Appointment.Patient
WHERE Appointment.Start = '2008-04-25 10:00:00'

/* 
16) Doktor muayenesi sýrasýnda hemþirenin asiste etmesine gerek olmayan hasta ve doktor ismini result tablosuna bastýran
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME] 
FROM Appointment
JOIN Physician ON Physician.EmployeeID = Appointment.Physician
JOIN Patient ON Patient.SSN = Appointment.Patient
WHERE PrepNurse IS NULL

/* 
17) Hastanýn ismini doktorun ismini doktorun verdiði  ilacýn ismini result tablosuna basan sql
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [ÝLAÇ]
FROM Patient 
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication

/* 
18) muayenede doktor tarafýndan tekrar randevu verieln hastanýn ismini doktorun ismini ve doktorun verdiði ilacý result tablosuna basan bir sql
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [ÝLAÇ],  Prescribes.Appointment AS [RANDEVU]
FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication
WHERE Prescribes.Appointment IS NOT NULL

/*
19) Muayenede doktor tarafýndan tekrar randevu verilmeyen hastanýn ismini doktorun ve verdiði ilacý result tablosuna basan
*/
SELECT Patient.Name AS [HASTA ADI], Physician.Name AS [DOCTOR NAME], Medication.Name AS [ÝLAÇ],  Prescribes.Appointment AS [RANDEVU]
FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Physician.EmployeeID = Prescribes.Physician
JOIN Medication ON Medication.Code = Prescribes.Medication
WHERE Prescribes.Appointment IS NULL

/* 
20) Room tablosundaki herbir blok için kaç tane uygun oda olduðunu result tablosuna basan sqwl sorgusunu yazýn
*/
SELECT BlockCode, COUNT(BlockCode) AS [UYGUN ODA SAYISI] FROM Room
WHERE Room.Unavailable = 0
Group BY BlockCode

/* 
21) Herbir kattaki uygun odalarýn sayýsýný Result tablosuna basan sql sorgusu
*/
SELECT BlockFloor, COUNT(BlockFloor) AS [UYGUN ODA SAYISI]
FROM Room
WHERE Room.Unavailable = 0
Group BY BlockFloor

/* 
22) Ayný katta bulunan herbir blocktaki uygun odalarýn sayýsný result tablosuna basn sql
*/
SELECT BlockCode, BlockFloor, COUNT(BlockCode) AS [UYGUN ODA SAYISI] 
FROM Room
WHERE Room.Unavailable = 0
GROUP BY BlockCode, BlockFloor 

/* 
23) Ayný katta bulunan herbir blocktaki uygun olmayan odalarýn sayýsýný Result tablosuna basan sql sorgusunu yazýn
*/
SELECT BlockCode, BlockFloor, COUNT(BlockCode) AS [UYGUN ODA SAYISI] FROM Room
WHERE Room.Unavailable = 1
GROUP BY BlockCode, BlockFloor 

/* 
24) En fazla uygun oda olmayan katý bulan sql sorgusunu yazýn
*/
SELECT TOP 1 BlockFloor, COUNT(*) AS [UYGUN OLMAYAN ODA SAYISI]
FROM Room
WHERE Unavailable = 1
GROUP BY BlockFloor
ORDER BY COUNT(*) DESC;


/* 
25) En fazla uygun oda bulunan katý bulan sql
*/
SELECT TOP 1 BlockFloor, COUNT(*) AS [UYGUN OLAN ODA SAYISI]
FROM Room
WHERE Unavailable = 0
GROUP BY BlockFloor
ORDER BY COUNT(*) DESC;

/* 
26) HaStanýn ismini tedavi gördüðü oda numarasýný block'unu ve hangi katta tedavi gördüðünü result tablosuna bstýran bir sql sorgusu yazýn
*/
SELECT Name AS [Hasta Adý],  Stay.Room AS [Oda Numarasý], Room.BlockCode AS [Odanýn Bulunduðu Blok], Room.BlockFloor AS [Odanýn Bulunduðu Kat] 
FROM Patient
JOIN Stay ON Stay.Patient = Patient.SSN
JOIN Room ON Stay.Room = Room.RoomNumber

/* 
27) Hangi hemþirenin hangi kat ve block ta görevli olduðunu result tablosuna basan bir sql sorgusu
*/
SELECT * FROM Nurse, On_Call
SELECT Nurse.EmployeeID, Nurse.Name, On_Call.BlockCode AS [Odanýn Bulunduðu Blok], On_Call.BlockFloor AS [Odanýn Bulunduðu Kat]
FROM Nurse
JOIN On_Call ON On_Call.Nurse = Nurse.EmployeeID

/* 
28) Patronunuz tedavi olan ve hastanede yatýþ yapan hastalar için kapsamlý bir rapor istedi:
Bu tabloda
-Hastanýn ismi
-Hastayý Tedavi eden doktorun adý
-Tedavi sýrasýnda bulunan hemþirenin ismi
-Hastanýn taburcu olma tarihi
-Hastanýn kaldýðý oda numrasý
-Odanýn bulunduðu kat ve blok
*/
SELECT 
	Patient.Name AS [Hasta Adý], 
	Physician.Name AS [Doktor Adý],
	Nurse.Name AS [Hemþire Adý],
	Stay.StayEnd As [Taburcu Olma Tarihi],
	Stay.Room AS [Kaldýðý Oda],
	Room.BlockCode AS [Blok Numarasý],
	Room.BlockFloor AS [Kat]
FROM 
	Undergoes
JOIN Patient ON Undergoes.Patient = Patient.SSN
JOIN Stay ON Undergoes.Stay = Stay.StayID
JOIN Physician ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Nurse ON Undergoes.AssistingNurse = Nurse.EmployeeID
JOIN Room ON Stay.Room = Room.RoomNumber


/* 
29) Doktorlardan tedavi yapmasýna raðmen o branþla ilgili sertifikasý bulunmayan doktorlarýn ismini result  tablosuna bas
*/
SELECT Name
FROM Physician
JOIN Undergoes ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = Undergoes.Procedures
WHERE Trained_In.Physician IS NULL

/* 
30) Doktorlarýn tedavi yapmasýnna raðmen o branþla ilgili sertifikasý bulunmayan doktorlarýn ismini yaptýðý tedvinin zamanýný ve hangi hastaya uyguladýðýný bulan sql
*/
SELECT Physician.Name AS [Doktor Adý], Patient.Name AS [Hasta Adý]
FROM Physician
JOIN Undergoes ON Undergoes.Physician = Physician.EmployeeID
LEFT JOIN Trained_In ON Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = Undergoes.Procedures
JOIN Patient ON Patient.SSN = Undergoes.Patient
WHERE Trained_In.Physician IS NULL

/* 
31) 122 numaralý odada yatan hstanýn çaðýrabileceði hemþireleri basan sql
*/
SELECT Nurse.Name
FROM On_Call
JOIN Nurse ON Nurse.EmployeeID = On_Call.Nurse
WHERE 
	On_Call.BlockFloor = (SELECT Room.BlockFloor FROM Room WHERE Room.RoomNumber = 112)
	AND 
	On_Call.BlockCode = (SELECT BlockCode FROM Room WHERE Room.RoomNumber = 112)

--ALTERNATÝF ÇÖZÜM
SELECT Name FROM Nurse
WHERE EmployeeID IN
(SELECT On_Call.Nurse FROM On_Call, Room
WHERE On_Call.BlockFloor = Room.BlockFloor
AND On_Call.BlockCode = Room.BlockCode
AND Room.RoomNumber = 112)

/* 
32) Hastaneye ilk sýradan gelen hastayý ilaçla tedavi edilen hastanýn ismini ve doktorun ismini veren sql
*/
SELECT TOP 1 * FROM Patient
JOIN Prescribes ON Prescribes.Patient = Patient.SSN
JOIN Physician ON Patient.PCP = EmployeeID
Order BY Prescribes.Date ASC

/* 
33) Hastaneye yatarak tedavi olmak için ilk sýrada gelen hastadan maliyeti 5000 dolarý geçen tedaviler için hastanýn ismini doktorun ismini ve maliyetini result tablosuna basan sql
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

