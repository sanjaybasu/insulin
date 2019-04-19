------------------------------------------------------------------
------------------------------------------------------------------
-- Project: Improving Incorporation of Social Determinants of Health into Risk
-- Table: Transform 34 - output
-- Last updated: Tue Apr 16 2019 21:45:01 GMT+0000 (Coordinated Universal Time)
-- Generated at: Fri Apr 19 2019 23:09:27 GMT+0000 (Coordinated Universal Time)
------------------------------------------------------------------
------------------------------------------------------------------



------------------------------------------------------------------
-- Transform: Transform 2
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Patid as Patid, t0.Loinc_Cd as t0_Loinc_Cd, t0.Rslt_Nbr as Rslt_Nbr, t0.Fst_Dt as Fst_Dt

FROM `Optum ZIP5 Laboratory Results` as t0)

SELECT Patid, Rslt_Nbr, Fst_Dt FROM variables
WHERE (t0_Loinc_Cd = '4548-4')
ORDER BY Fst_Dt ASC

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
-- Transform: Transform 34
-- Description: None provided
------------------------------------------------------------------
WITH
variables AS (
SELECT t0.Fst_Dt as Fst_Dt, t0.Rslt_Nbr as Rslt_Nbr, t0.Patid as t0_Patid, t1.enrollduration as enrollduration, t1.zip as zip, t1.sex as sex, t1.age as age, t1.Eligeff as t1_Eligeff, t1.Patid as Patid,
DATE_DIFF(t0.`Fst_Dt`, t1.`Eligeff`, day) as time
FROM `Transform 2 - output` as t0
FULL JOIN `Transform 9 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT DISTINCT Fst_Dt, Rslt_Nbr, enrollduration, zip, sex, age, Patid, time FROM variables
WHERE (time > 0)
ORDER BY Patid ASC