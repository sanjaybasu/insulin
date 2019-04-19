------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Transform 32 - output
-- Last updated: Tue Apr 16 2019 22:48:02 GMT+0000 (Coordinated Universal Time)
-- Generated at: Fri Apr 19 2019 23:09:20 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 30
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Drg as Drg, t0.Fst_Dt as Fst_Dt, t0.Std_Cost as Std_Cost, t0.Std_Cost_Yr as Std_Cost_Yr, t0.Diag1 as Diag1, t0.Patid as Patid,
1 as event,
CASE WHEN (t0.`Diag1` LIKE r'''250_1''') or  (t0.`Diag1` LIKE r'''250_3''') or  (t0.`Diag1` LIKE r'''E10%''')
THEN 1
ELSE 2 END as type
FROM `Optum ZIP5 Medical Claims` as t0)

SELECT Drg, Fst_Dt, Std_Cost, Std_Cost_Yr, Diag1, Patid, event, type FROM variables
WHERE (Diag1 LIKE r'''2504_''') or  (Diag1 LIKE r'''2505_''') or  (Diag1 LIKE r'''2506_''') or  (Diag1 LIKE r'''E112_''') or  (Diag1 LIKE r'''E132_''') or  (Diag1 LIKE r'''E102_''') or  (Diag1 LIKE r'''E113_''') or  (Diag1 LIKE r'''E103_''') or  (Diag1 LIKE r'''E114_''') or  (Diag1 LIKE r'''E104_''') or  (Diag1 LIKE r'''E11610''') or  (Diag1 LIKE r'''E134_''')
ORDER BY Patid ASC

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
-- Transform: Transform 32
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.type as type, t0.event as t0_event, t0.Patid as t0_Patid, t0.Diag1 as Diag1, t0.Std_Cost as Std_Cost, t0.Fst_Dt as t0_Fst_Dt, t1.zip as zip, t1.sex as sex, t1.age as age, t1.Eligeff as t1_Eligeff, t1.Eligend as t1_Eligend, t1.Patid as Patid,
DATE_DIFF(t0.`Fst_Dt`, t1.`Eligeff`, day) as tnull_timepre,
DATE_DIFF(t1.`Eligend`, t1.`Eligeff`, day) as timeenr,
CASE WHEN (t0.`event` = 1)
THEN DATE_DIFF(t0.`Fst_Dt`, t1.`Eligeff`, day)
ELSE DATE_DIFF(t1.`Eligend`, t1.`Eligeff`, day) END as time,
CASE WHEN (t0.`event` = 1)
THEN 1
ELSE 0 END as event
FROM `Transform 30 - output` as t0
FULL JOIN `Transform 9 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT DISTINCT type, Diag1, Std_Cost, zip, sex, age, Patid, timeenr, time, event FROM variables
WHERE (time > 0)
ORDER BY Patid ASC