------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: A1c vs insulin price
-- Last updated: Thu Apr 04 2019 23:04:59 GMT+0000 (Coordinated Universal Time)
-- Generated at: Thu Apr 04 2019 23:16:56 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 9
-- Description: Member
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Zipcode_5 as Zipcode_5, t0.Patid as Patid, t0.Gdr_Cd as Gdr_Cd, t0.Yrdob as Yrdob, t0.Eligeff as Eligeff, t0.Eligend as Eligend,
2017 - t0.`Yrdob` as age,
CASE WHEN (t0.`Gdr_Cd` = 'F')
THEN 1
ELSE 0 END as sex,
SUBSTR(t0.`Zipcode_5`, 0, 5) as zip,
DATE_DIFF(t0.`Eligend`, t0.`Eligeff`, day) as enrollduration
FROM `Optum ZIP5 Member` as t0)

SELECT Zipcode_5, Patid, Gdr_Cd, Yrdob, Eligeff, Eligend, age, sex, zip, enrollduration FROM variables
WHERE (age < 65)

------------------------------------------------------------------
-- Transform: Transform 2
-- Description: Lab
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Rslt_Nbr as Rslt_Nbr, t0.Loinc_Cd as t0_Loinc_Cd, t0.Fst_Dt as Fst_Dt, t0.Patid as Patid

FROM `Optum ZIP5 Laboratory Results` as t0)

SELECT Rslt_Nbr, Fst_Dt, Patid FROM variables
WHERE (t0_Loinc_Cd = '4548-4')
ORDER BY Fst_Dt ASC

------------------------------------------------------------------
-- Transform: Transform 4
-- Description: Pharmacy
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Ahfsclss as t0_Ahfsclss, t0.Deduct as t0_Deduct, t0.Copay as t0_Copay, t0.Patid as Patid, t0.Quantity as t0_Quantity, t0.Fill_Dt as Fill_Dt, t0.Dispfee as t0_Dispfee,
t0.`Copay` + t0.`Deduct` as oopcpre,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` as oopc,
t0.`Quantity` * 100 as quantity100,
CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as quantity100fixed,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` / CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as dolperunits
FROM `Optum ZIP5 Rx Pharmacy` as t0)

SELECT Patid, Fill_Dt, oopcpre, oopc, quantity100, quantity100fixed, dolperunits FROM variables
WHERE (t0_Ahfsclss = '682008')
ORDER BY Fill_Dt ASC

------------------------------------------------------------------
-- Transform: Transform 5
-- Description: Lab + Pharmacy
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Patid as Patid, t0.Fst_Dt as Fst_Dt, t0.Rslt_Nbr as Rslt_Nbr, t1.dolperunits as dolperunits, t1.Fill_Dt as Fill_Dt, t1.Patid as t1_Patid,
DATE_DIFF(t0.`Fst_Dt`, t1.`Fill_Dt`, day) as tnull_Date_ABS_Diff,
EXTRACT(MONTH FROM t0.`Fst_Dt`) as month,
EXTRACT(YEAR FROM t0.`Fst_Dt`) as year
FROM `Transform 2 - output` as t0
FULL JOIN `Transform 4 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT Patid, Fst_Dt, Rslt_Nbr, dolperunits, Fill_Dt, month, year FROM variables
WHERE (tnull_Date_ABS_Diff IS NOT NULL) and  (tnull_Date_ABS_Diff >= 0)
ORDER BY Patid ASC

------------------------------------------------------------------
-- Transform: Transform 12
-- Description: Lab + Pharmacy + Member
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.zip as zip, t0.sex as sex, t0.age as age, t0.Eligeff as t0_Eligeff, t0.Patid as t0_Patid, t1.year as year, t1.month as month, t1.Fill_Dt as t1_Fill_Dt, t1.dolperunits as dolperunits, t1.Rslt_Nbr as Rslt_Nbr, t1.Fst_Dt as t1_Fst_Dt, t1.Patid as Patid,
DATE_DIFF(t1.`Fill_Dt`, t0.`Eligeff`, day) as time1,
DATE_DIFF(t1.`Fst_Dt`, t0.`Eligeff`, day) as time2
FROM `Transform 9 - output` as t0
FULL JOIN `Transform 5 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT zip, sex, age, year, month, dolperunits, Rslt_Nbr, Patid, time1, time2 FROM variables
ORDER BY Patid ASC
                                           
                                           
                                           
                                           
                                           
------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Event vs insulin price
-- Last updated: Thu Apr 04 2019 22:58:28 GMT+0000 (Coordinated Universal Time)
-- Generated at: Thu Apr 04 2019 23:15:41 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 9
-- Description: Member
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Zipcode_5 as Zipcode_5, t0.Patid as Patid, t0.Gdr_Cd as Gdr_Cd, t0.Yrdob as Yrdob, t0.Eligeff as Eligeff, t0.Eligend as Eligend,
2017 - t0.`Yrdob` as age,
CASE WHEN (t0.`Gdr_Cd` = 'F')
THEN 1
ELSE 0 END as sex,
SUBSTR(t0.`Zipcode_5`, 0, 5) as zip,
DATE_DIFF(t0.`Eligend`, t0.`Eligeff`, day) as enrollduration
FROM `Optum ZIP5 Member` as t0)

SELECT Zipcode_5, Patid, Gdr_Cd, Yrdob, Eligeff, Eligend, age, sex, zip, enrollduration FROM variables
WHERE (age < 65)

------------------------------------------------------------------
-- Transform: Transform 6
-- Description: Event
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Std_Cost_Yr as Std_Cost_Yr, t0.Std_Cost as Std_Cost, t0.Drg as Drg, t0.Patid as Patid, t0.Fst_Dt as Fst_Dt,
CASE WHEN (t0.`Std_Cost` IS NOT NULL)
THEN 1
ELSE 0 END as event
FROM `Optum ZIP5 Medical Claims` as t0)

SELECT Std_Cost_Yr, Std_Cost, Drg, Patid, Fst_Dt, event FROM variables
WHERE (Drg >= '637') and  (Drg <= '639')
ORDER BY Fst_Dt ASC

------------------------------------------------------------------
-- Transform: Transform 4
-- Description: Pharmacy
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Ahfsclss as t0_Ahfsclss, t0.Deduct as t0_Deduct, t0.Copay as t0_Copay, t0.Patid as Patid, t0.Quantity as t0_Quantity, t0.Fill_Dt as Fill_Dt, t0.Dispfee as t0_Dispfee,
t0.`Copay` + t0.`Deduct` as oopcpre,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` as oopc,
t0.`Quantity` * 100 as quantity100,
CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as quantity100fixed,
t0.`Copay` + t0.`Deduct` + t0.`Dispfee` / CASE WHEN (t0.`Quantity` * 100 =  0.0)
THEN NULL
ELSE t0.`Quantity` * 100 END as dolperunits
FROM `Optum ZIP5 Rx Pharmacy` as t0)

SELECT Patid, Fill_Dt, oopcpre, oopc, quantity100, quantity100fixed, dolperunits FROM variables
WHERE (t0_Ahfsclss = '682008')
ORDER BY Fill_Dt ASC

------------------------------------------------------------------
-- Transform: Transform 8
-- Description: Event + Pharmacy
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.event as t0_event, t0.Fst_Dt as Fst_Dt, t0.Patid as t0_Patid, t1.dolperunits as dolperunits, t1.Fill_Dt as Fill_Dt, t1.Patid as Patid,
CASE WHEN (t0.`event` = 1)
THEN 1
ELSE 0 END as eventfixed,
DATE_DIFF(t0.`Fst_Dt`, t1.`Fill_Dt`, day) as tnull_Date_ABS_Diff,
EXTRACT(MONTH FROM t0.`Fst_Dt`) as month,
EXTRACT(YEAR FROM t0.`Fst_Dt`) as year
FROM `Transform 6 - output` as t0
FULL JOIN `Transform 4 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT Fst_Dt, dolperunits, Fill_Dt, Patid, eventfixed, month, year FROM variables
WHERE (tnull_Date_ABS_Diff IS NOT NULL) or  (tnull_Date_ABS_Diff >= 0)

------------------------------------------------------------------
-- Transform: Transform 11
-- Description: Event + Pharmacy + Member
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.zip as zip, t0.sex as sex, t0.age as age, t0.Eligeff as t0_Eligeff, t0.Patid as t0_Patid, t1.year as year, t1.month as month, t1.eventfixed as eventfixed, t1.Patid as Patid, t1.Fill_Dt as t1_Fill_Dt, t1.dolperunits as dolperunits, t1.Fst_Dt as t1_Fst_Dt,
DATE_DIFF(t1.`Fill_Dt`, t0.`Eligeff`, day) as time1,
DATE_DIFF(t1.`Fst_Dt`, t0.`Eligeff`, day) as time2
FROM `Transform 9 - output` as t0
FULL JOIN `Transform 8 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT zip, sex, age, year, month, eventfixed, Patid, dolperunits, time1, time2 FROM variables
ORDER BY t0_Patid ASC                                           
