WITH
variables AS (
SELECT t0.Patid as Patid, t0.Fst_Dt as Fst_Dt, t0.Loinc_Cd as t0_Loinc_Cd, t0.Rslt_Nbr as Rslt_Nbr

FROM `Optum ZIP5 Laboratory Results` as t0)

SELECT Patid, Fst_Dt, Rslt_Nbr FROM variables
WHERE (t0_Loinc_Cd = '4548-4')
ORDER BY Fst_Dt ASC



WITH
variables AS (
SELECT t0.Patid as Patid, t0.Ahfsclss as t0_Ahfsclss, t0.Copay as t0_Copay, t0.Deduct as t0_Deduct, t0.Dispfee as t0_Dispfee, t0.Fill_Dt as Fill_Dt, t0.Fst_Fill as t0_Fst_Fill, t0.Quantity as t0_Quantity,
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



WITH
variables AS (
SELECT t0.Rslt_Nbr as Rslt_Nbr, t0.Fst_Dt as t0_Fst_Dt, t0.Patid as Patid, t1.Patid as t1_Patid, t1.Fill_Dt as t1_Fill_Dt, t1.dolperunits as dolperunits,
DATE_DIFF(t1.`Fill_Dt`, t0.`Fst_Dt`, day) as tnull_Date_ABS_Diff
FROM `Transform 2 - output` as t0
FULL JOIN `Transform 4 - output` as t1 ON (t0.`Patid` = t1.`Patid`))

SELECT Rslt_Nbr, Patid, dolperunits FROM variables
WHERE (tnull_Date_ABS_Diff IS NOT NULL) or  (tnull_Date_ABS_Diff <= 0)
ORDER BY Patid ASC
