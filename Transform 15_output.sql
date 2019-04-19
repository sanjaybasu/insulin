------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Transform 15 - output
-- Last updated: Thu Apr 18 2019 21:55:50 GMT+0000 (Coordinated Universal Time)
-- Generated at: Fri Apr 19 2019 23:08:56 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 9
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Patid as Patid, t0.Yrdob as Yrdob, t0.Zipcode_5 as Zipcode_5, t0.Eligend as Eligend, t0.Eligeff as Eligeff, t0.Gdr_Cd as Gdr_Cd,
2017 - t0.`Yrdob` as age,
CASE WHEN (t0.`Gdr_Cd` = 'F')
THEN 1
ELSE 0 END as sex,
SUBSTR(t0.`Zipcode_5`, 0, 5) as zip,
DATE_DIFF(t0.`Eligend`, t0.`Eligeff`, day) as enrollduration
FROM `Optum ZIP5 Member` as t0)

SELECT Patid, Yrdob, Zipcode_5, Eligend, Eligeff, Gdr_Cd, age, sex, zip, enrollduration FROM variables
WHERE (age < 2017)

------------------------------------------------------------------
-- Transform: Transform 4
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Patid as Patid, t0.Gnrc_Nm as Gnrc_Nm, t0.Quantity as Quantity, t0.Strength as Strength, t0.Fill_Dt as Fill_Dt, t0.Dispfee as Dispfee, t0.Ahfsclss as t0_Ahfsclss, t0.Std_Cost_Yr as Std_Cost_Yr, t0.Deduct as Deduct, t0.Copay as Copay,
t0.`Copay` + t0.`Deduct` as tnull_oopcpre,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` as oopc,
CASE WHEN (t0.`Strength` = '100/ML (3)')
THEN 300
ELSE 100 END as tnull_unitsperquant,
t0.`Quantity` * CASE WHEN (t0.`Strength` = '100/ML (3)')
THEN 300
ELSE 100 END as tnull_units,
CASE WHEN (t0.`Quantity` * CASE WHEN (t0.`Strength` = '100/ML (3)')
THEN 300
ELSE 100 END =  0.0)
THEN NULL
ELSE t0.`Quantity` * CASE WHEN (t0.`Strength` = '100/ML (3)')
THEN 300
ELSE 100 END END as unitsfixed,
0 as event
FROM `Optum ZIP5 Rx Pharmacy` as t0)

SELECT Patid, Gnrc_Nm, Quantity, Strength, Fill_Dt, Dispfee, Std_Cost_Yr, Deduct, Copay, oopc, unitsfixed, event FROM variables
WHERE (t0_Ahfsclss = '682008') or  (Gnrc_Nm LIKE r'''%INSULIN%''')

------------------------------------------------------------------
-- Transform: Transform 15
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Eligeff as t0_Eligeff, t0.Patid as Patid, t1.Std_Cost_Yr as Std_Cost_Yr, t1.Patid as t1_Patid, t1.event as event, t1.Copay as Copay, t1.Deduct as Deduct, t1.Gnrc_Nm as Gnrc_Nm, t1.Quantity as Quantity, t1.Fill_Dt as Fill_Dt, t1.Strength as Strength, t1.unitsfixed as unitsfixed, t1.oopc as oopc, t1.Dispfee as Dispfee,
DATE_DIFF(t1.`Fill_Dt`, t0.`Eligeff`, day) as time
FROM `Transform 9 - output` as t0
RIGHT JOIN `Transform 4 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT Patid, Std_Cost_Yr, event, Copay, Deduct, Gnrc_Nm, Quantity, Fill_Dt, Strength, unitsfixed, oopc, Dispfee, time FROM variables
WHERE (time >= 0)
ORDER BY Patid ASC