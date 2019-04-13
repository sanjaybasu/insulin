------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Clinical and economic consequences of insulin cost
-- Table: A1c vs insulin price
-- Last updated: Thu Apr 04 2019 23:04:59 GMT+0000 (Coordinated Universal Time)
-- Generated at: Thu Apr 04 2019 23:16:56 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------

------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Transform 15 - output
-- Last updated: Sat Apr 13 2019 16:46:31 GMT+0000 (Coordinated Universal Time)
-- Generated at: Sat Apr 13 2019 19:05:02 GMT+0000 (Coordinated Universal Time)
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
SELECT t0.Patid as Patid, t0.Gnrc_Nm as t0_Gnrc_Nm, t0.Quantity as t0_Quantity, t0.Fill_Dt as Fill_Dt, t0.Dispfee as t0_Dispfee, t0.Ahfsclss as t0_Ahfsclss, t0.Std_Cost_Yr as Std_Cost_Yr, t0.Deduct as t0_Deduct, t0.Copay as t0_Copay,
t0.`Copay` + t0.`Deduct` as oopcpre,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` as oopc,
t0.`Quantity` * 100 as quantity100,
CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as quantity100fixed,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` / CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as dolperunits,
0 as event
FROM `Optum ZIP5 Rx Pharmacy` as t0)

SELECT Patid, Fill_Dt, Std_Cost_Yr, oopcpre, oopc, quantity100, quantity100fixed, dolperunits, event FROM variables
WHERE (t0_Ahfsclss = '682008') or  (t0_Gnrc_Nm LIKE r'''%INSULIN%''')
ORDER BY Patid ASC

------------------------------------------------------------------
-- Transform: Transform 15
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Eligeff as t0_Eligeff, t0.Patid as Patid, t1.event as event, t1.dolperunits as dolperunits, t1.Std_Cost_Yr as Std_Cost_Yr, t1.Fill_Dt as Fill_Dt, t1.Patid as t1_Patid,
DATE_DIFF(t1.`Fill_Dt`, t0.`Eligeff`, day) as time
FROM `Transform 9 - output` as t0
RIGHT JOIN `Transform 4 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT Patid, event, dolperunits, Std_Cost_Yr, Fill_Dt, time FROM variables
WHERE (time >= 0)
ORDER BY Patid ASC
                                            
                                            
                                            
------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Transform 18 - output
-- Last updated: Sat Apr 13 2019 17:55:34 GMT+0000 (Coordinated Universal Time)
-- Generated at: Sat Apr 13 2019 19:05:47 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 6
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Drg as Drg, t0.Fst_Dt as Fst_Dt, t0.Std_Cost as Std_Cost, t0.Std_Cost_Yr as Std_Cost_Yr, t0.Diag1 as Diag1, t0.Pos as t0_Pos, t0.Patid as Patid,
1 as event,
CASE WHEN (t0.`Diag1` LIKE r'''250_1''') or  (t0.`Diag1` LIKE r'''250_3''') or  (t0.`Diag1` LIKE r'''E10%''')
THEN 1
ELSE 2 END as type
FROM `Optum ZIP5 Medical Claims` as t0)

SELECT Drg, Fst_Dt, Std_Cost, Std_Cost_Yr, Diag1, Patid, event, type FROM variables
WHERE (Drg >= '637') and  (Drg <= '639') and  (COALESCE(Diag1 != '\'E089\'', true)) and  (COALESCE(Diag1 != '\'E099', true)) and  (COALESCE(Diag1 != '\'E109\'', true)) and  (COALESCE(Diag1 != '\'E119', true)) and  (COALESCE(Diag1 != '\'E139\'', true)) and  (t0_Pos >= '20') and  (t0_Pos <= '23') and  (COALESCE(Diag1 != '25000', true)) and  (COALESCE(Diag1 != '25001', true)) and  (COALESCE(Diag1 != '25002', true)) and  (COALESCE(Diag1 != '25003', true))
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
-- Transform: Transform 18
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.type as type, t0.event as t0_event, t0.Patid as t0_Patid, t0.Diag1 as Diag1, t0.Fst_Dt as t0_Fst_Dt, t1.zip as zip, t1.sex as sex, t1.age as age, t1.Eligeff as t1_Eligeff, t1.Eligend as t1_Eligend, t1.Patid as Patid,
DATE_DIFF(t0.`Fst_Dt`, t1.`Eligeff`, day) as tnull_timepre,
DATE_DIFF(t1.`Eligend`, t1.`Eligeff`, day) as timeenr,
CASE WHEN (t0.`event` = 1)
THEN DATE_DIFF(t0.`Fst_Dt`, t1.`Eligeff`, day)
ELSE DATE_DIFF(t1.`Eligend`, t1.`Eligeff`, day) END as time,
CASE WHEN (t0.`event` = 1)
THEN 1
ELSE 0 END as event
FROM `Transform 6 - output` as t0
FULL JOIN `Transform 9 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT DISTINCT type, Diag1, zip, sex, age, Patid, timeenr, time, event FROM variables
WHERE (time > 0)
ORDER BY Patid ASC                                            
                                            
