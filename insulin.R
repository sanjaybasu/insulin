library(plm)
library(knitr)
library(tidyverse)
library(broom)
library(data.table)

lab = read_csv("zip5_lr.csv")
rx = read_csv("zip5_r.csv")
mbr <- read_csv("zip5_mbr.csv",
                col_types = cols(Aso = col_skip(), Bus = col_skip(),
                                 Cdhp = col_skip(), Eligeff = col_skip(),
                                 Eligend = col_skip(), Extract_Ym = col_skip(),
                                 Group_Nbr = col_skip(), Health_Exch = col_skip(),
                                 Product = col_skip(), Version = col_skip()))
m <- read_csv("zip5_m.csv",
              col_types = cols(Admit_Chan = col_skip(),
                               Admit_Type = col_skip(), Bill_Prov = col_skip(),
                               Charge = col_skip(), Clmid = col_skip(),
                               Clmseq = col_skip(), Cob = col_skip(),
                               Conf_Id = col_skip(), Diag10 = col_skip(),
                               Diag11 = col_skip(), Diag12 = col_skip(),
                               Diag13 = col_skip(), Diag14 = col_skip(),
                               Diag15 = col_skip(), Diag16 = col_skip(),
                               Diag17 = col_skip(), Diag18 = col_skip(),
                               Diag19 = col_skip(), Diag2 = col_skip(),
                               Diag20 = col_skip(), Diag21 = col_skip(),
                               Diag22 = col_skip(), Diag23 = col_skip(),
                               Diag24 = col_skip(), Diag25 = col_skip(),
                               Diag3 = col_skip(), Diag4 = col_skip(),
                               Diag5 = col_skip(), Diag6 = col_skip(),
                               Diag7 = col_skip(), Diag8 = col_skip(),
                               Diag9 = col_skip(), Dstatus = col_skip(),
                               Enctr = col_skip(), Extract_Ym = col_skip(),
                               Hccc = col_skip(), Icd_Flag = col_skip(),
                               Loc_Cd = col_skip(), Lst_Dt = col_skip(),
                               Ndc = col_skip(), Paid_Dt = col_skip(),
                               Paid_Status = col_skip(), Pat_Planid = col_skip(),
                               Poa = col_skip(), Proc1 = col_skip(),
                               Proc10 = col_skip(), Proc11 = col_skip(),
                               Proc12 = col_skip(), Proc13 = col_skip(),
                               Proc14 = col_skip(), Proc15 = col_skip(),
                               Proc16 = col_skip(), Proc17 = col_skip(),
                               Proc18 = col_skip(), Proc19 = col_skip(),
                               Proc2 = col_skip(), Proc20 = col_skip(),
                               Proc21 = col_skip(), Proc22 = col_skip(),
                               Proc23 = col_skip(), Proc24 = col_skip(),
                               Proc25 = col_skip(), Proc3 = col_skip(),
                               Proc4 = col_skip(), Proc5 = col_skip(),
                               Proc6 = col_skip(), Proc7 = col_skip(),
                               Proc8 = col_skip(), Proc9 = col_skip(),
                               Proc_Cd = col_skip(), Procmod = col_skip(),
                               Prov = col_skip(), Prov_Par = col_skip(),
                               Provcat = col_skip(), Refer_Prov = col_skip(),
                               Rvnu_Cd = col_skip(), Service_Prov = col_skip(),
                               Tos_Cd = col_skip(), Units = col_skip(),
                               Version = col_skip()))



labt = lab %>%
  filter(Loinc_Cd == '4548-4') %>%
  select(Patid, Fst_Dt, Loinc_Cd, Rslt_Nbr, Rslt_Txt, Tst_Desc) %>%
  mutate(Fst_Dt = lubridate::mdy(Fst_Dt))
rxt = rx %>%
  filter(Ahfsclss == '682008') %>%
  select(Patid, Brnd_Nm, Charge, Copay, Days_Sup, Deduct, Dispfee, Fill_Dt, Fst_Fill, Gnrc_Nm, Ndc, Quantity, Rfl_Nbr, Specclss, Std_Cost, Std_Cost_Yr, Strength) %>%
  mutate(Fill_Dt = lubridate::mdy(Fill_Dt))
rm(lab,rx)



labt = data.table(labt)
rxt = data.table(rxt)
dm = labt %>%
  full_join(rxt, by = c("Patid" = "Patid")) %>%
  mutate(Date_ABS_Diff = as.numeric((Fill_Dt - Fst_Dt)*((Fill_Dt-Fst_Dt)>=0)+
                                      0*((Fill_Dt-Fst_Dt)<0))) %>%
  filter(as.numeric(Date_ABS_Diff)!='NA' & as.numeric(Date_ABS_Diff)!=0) %>%
  arrange(Patid, Date_ABS_Diff) %>%
  select(Patid, Fst_Dt, Date_ABS_Diff, Copay, Deduct, Dispfee, Quantity, Charge, Rslt_Nbr) %>%
  group_by(Patid, Fst_Dt) %>%
  summarise_all(mean) %>%
  ungroup() %>%
  filter(Rslt_Nbr>0, Quantity>0) %>%
  mutate(oopc = Copay+Deduct+Dispfee,
         dolperunits = oopc/(Quantity*100),
         totdolperunits = (Charge+oopc)/(Quantity*100),
         hgba1c = Rslt_Nbr) %>%
  full_join(mbr, by=c("Patid"="Patid")) %>%
  mutate(age = as.numeric(2017-Yrdob),
         sex = as.numeric(Gdr_Cd=="F"),
         zip = as.numeric(substr(Zipcode_5,1,5)),
         yr = as.numeric(substr(Fst_Dt,1,4))) %>%
  select(Patid,Fst_Dt,age,sex,zip,yr,hgba1c,dolperunits,totdolperunits) %>%
  filter(is.na(Fst_Dt)==F) %>%
  group_by(Patid, Fst_Dt) %>%
  summarise_all(mean) %>%
  ungroup()

dm$nhgba1c = dm$hgba1c-mean(na.omit(dm$hgba1c))/(2*sd(na.omit(dm$hgba1c)))
dm$ndolperunits = dm$dolperunits-mean(na.omit(dm$dolperunits))/(2*sd(na.omit(dm$dolperunits)))

panel <- pdata.frame(dm, index=c("Patid", "Fst_Dt"))


kable(tidy(plm(hgba1c~age+sex+zip+yr+dolperunits-1, data=panel, model="fd")), digits=3)
kable(tidy(plm(nhgba1c~age+sex+zip+yr+ndolperunits-1, data=panel, model="fd")), digits=3)

mt = m %>%
  select(Patid, Drg, Diag1, Fst_Dt, Pos, Copay, Deduct, Coins, Std_Cost) %>%
  filter((Diag1=='E1010') |
            (Diag1=='E1011') |
            (Diag1=='E10618') |
            (Diag1=='E10620') |
            (Diag1=='E10621') |
            (Diag1=='E10622') |
            (Diag1=='E10628') |
            (Diag1=='E10630') |
            (Diag1=='E10638') |
            (Diag1=='E10641') |
            (Diag1=='E10649') |
            (Diag1=='E1065') |
            (Diag1=='E1069') |
            (Diag1=='E108') |
            (Diag1=='E109') |
            (Diag1=='E1100') |
            (Diag1=='E1101') |
            (Diag1=='E11618') |
            (Diag1=='E11620') |
            (Diag1=='E11621') |
            (Diag1=='E11622') |
            (Diag1=='E11628') |
            (Diag1=='E11630') |
            (Diag1=='E11638') |
            (Diag1=='E11641') |
            (Diag1=='E11649') |
            (Diag1=='E1165') |
            (Diag1=='E1169') |
            (Diag1=='E118') |
            (Diag1=='E119') |
            (Diag1=='E1300') |
            (Diag1=='E1301') |
            (Diag1=='E1310') |
            (Diag1=='E1311') |
            (Diag1=='E13618') |
            (Diag1=='E13620') |
            (Diag1=='E13621') |
            (Diag1=='E13622') |
            (Diag1=='E13628') |
            (Diag1=='E13630') |
            (Diag1=='E13638') |
            (Diag1=='E13641') |
            (Diag1=='E13649') |
            (Diag1=='E1365') |
            (Diag1=='E1369') |
            (Diag1=='E138') |
            (Diag1=='E139') |
            (Diag1=='E10311') |
            (Diag1=='E10319') |
            (Diag1=='E10321') |
            (Diag1=='E10329') |
            (Diag1=='E10331') |
            (Diag1=='E10339') |
            (Diag1=='E10341') |
            (Diag1=='E10349') |
            (Diag1=='E10351') |
            (Diag1=='E10359') |
            (Diag1=='E1036') |
            (Diag1=='E1039') |
            (Diag1=='E11311') |
            (Diag1=='E11319') |
            (Diag1=='E11321') |
            (Diag1=='E11329') |
            (Diag1=='E11331') |
            (Diag1=='E11339') |
            (Diag1=='E11341') |
            (Diag1=='E11349') |
            (Diag1=='E11351') |
            (Diag1=='E11359') |
            (Diag1=='E1136') |
            (Diag1=='E1139') |
            (Diag1=='E13311') |
            (Diag1=='E13319') |
            (Diag1=='E13321') |
            (Diag1=='E13329') |
            (Diag1=='E13331') |
            (Diag1=='E13339') |
            (Diag1=='E13341') |
            (Diag1=='E13349') |
            (Diag1=='E13351') |
            (Diag1=='E13359') |
            (Diag1=='E1336') |
            (Diag1=='E1339') |
            (Diag1=='E1040') |
            (Diag1=='E1041') |
            (Diag1=='E1042') |
            (Diag1=='E1043') |
            (Diag1=='E1044') |
            (Diag1=='E1049') |
            (Diag1=='E10610') |
            (Diag1=='E1140') |
            (Diag1=='E1141') |
            (Diag1=='E1142') |
            (Diag1=='E1143') |
            (Diag1=='E1144') |
            (Diag1=='E1149') |
            (Diag1=='E11610') |
            (Diag1=='E1340') |
            (Diag1=='E1341') |
            (Diag1=='E1342') |
            (Diag1=='E1343') |
            (Diag1=='E1344') |
            (Diag1=='E1349') |
            (Diag1=='E13610')) %>%
  filter(Drg>=637 & Drg<=639) %>%
  filter((Pos>16 & Pos<24) | (Pos>40 & Pos<51) | (Pos==71)) %>% 
  mutate(event = 1,
         Fst_Dt = lubridate::mdy(Fst_Dt))

evt= dm %>%
  full_join(mt, by=c("Patid" = "Patid")) %>%
  mutate(event = replace_na(event,0))


kable(tidy(plm(hgba1c~age+sex+zip+yr+dolperunits-1, data=panel, model="fd")), digits=3)
kable(tidy(glm(event~ndolperunits+age+sex+zip+yr, data=evt, family = binomial())), digits=3)
table(evt$event)


