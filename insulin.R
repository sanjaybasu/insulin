rm(list=ls())
library(tidyverse)
library(survival)
library(readr)
library(plm)
library(knitr)
library(broom)
library(riskRegression)

iseq <- read_csv("~/Transform_15_output.csv")
iev <- read_csv("~/Transform_26_output.csv", 
                col_types = cols(zip = col_double()))

temp <- subset(iev, select=c(type, zip:event)) # baseline data
temp = temp %>%
  group_by(Patid) %>%
  summarise(type = max(type),
            zip = max(zip),
            sex = max(sex),
            age = min(age),
            time = max(time),
            event = max(event),
            timeenr = max(timeenr)) 

temp2 = temp %>%
  select(Patid)
temp3 = iseq %>%
  inner_join(temp2, by="Patid") %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013),
         year = lubridate::year(Fill_Dt), 
         month = lubridate::month(Fill_Dt)) %>%
  mutate_at(scale, .vars = "dolper1000units")

iev2 <- tmerge(temp, temp, id=Patid, endpt = event(time, event))
iev2 <- tmerge(iev2, temp3, id=Patid, dolper1000units = tdc(time, dolper1000units),
               year = tdc(time, year))
fit1_unadj = coxph(Surv(tstart, tstop, endpt==1) ~ dolper1000units+cluster(Patid), data=iev2, x = T)
summary(fit1_unadj)

fit1 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, x = T)
summary(fit1)

fit1_s1 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, subset=(age<18))
summary(fit1_s1)

fit1_s2 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, subset=((age>=18) & (age<65)))
summary(fit1_s2)

fit1_s3 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, subset=(age>=65))
summary(fit1_s3)

fit1_s4 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, subset=(type==1))
summary(fit1_s4)

fit1_s5 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iev2, subset=(type==2))
summary(fit1_s5)




iem <- read_csv("~/Transform_32_output.csv", 
                col_types = cols(zip = col_double()))

temp <- subset(iem, select=c(type, zip:event)) # baseline data
temp = temp %>%
  group_by(Patid) %>%
  summarise(type = max(type),
            zip = max(zip),
            sex = max(sex),
            age = min(age),
            time = max(time),
            event = max(event),
            timeenr = max(timeenr)) 

temp2 = temp %>%
  select(Patid)
temp3 = iseq %>%
  inner_join(temp2, by="Patid") %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013),
         year = lubridate::year(Fill_Dt), 
         month = lubridate::month(Fill_Dt)) %>%
  mutate_at(scale, .vars = "dolper1000units")

iem2 <- tmerge(temp, temp, id=Patid, endpt = event(time, event))
iem2 <- tmerge(iem2, temp3, id=Patid, dolper1000units = tdc(time, dolper1000units),
               year = tdc(time, year))

fit2_unadj = coxph(Surv(tstart, tstop, endpt==1) ~ dolper1000units+cluster(Patid), data=iem2)
summary(fit2_unadj)

fit2 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2)
summary(fit2)

fit2_s1 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2, subset=(age<18))
summary(fit2_s1)

fit2_s2 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2, subset=((age>=18) & (age<65)))
summary(fit2_s2)

fit2_s3 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2, subset=(age>=65))
summary(fit2_s3)

fit2_s4 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2, subset=(type==1))
summary(fit2_s4)

fit2_s5 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+year+dolper1000units+cluster(Patid), data=iem2, subset=(type==2))
summary(fit2_s5)



hba1c <- read_csv("~/Transform_34_output.csv")
data1c = hba1c %>%
  full_join(temp, by="Patid") %>%
  inner_join(iseq, by="Patid") %>%
  mutate(a1c = Rslt_Nbr*(Rslt_Nbr>0),
         days = lubridate::day(Fst_Dt)-lubridate::day(Fill_Dt),
         dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013),
         year = lubridate::year(Fst_Dt)) %>%
  filter(days>0) %>%
  mutate_at(scale, .vars = "dolper1000units") %>%
  group_by(Patid, Fst_Dt) %>%
  slice(which.min(days)) %>%
  ungroup() %>%
  unique()

summary(data1c$a1c)

panel <- pdata.frame(data1c, index=c("Patid", "Fst_Dt"))
kable(tidy(plm(a1c~dolper1000units-1, data=panel, model="between")), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between")), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between", subset=(age.x<18))), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between", subset=((age.x>=18) & (age.x<65)))), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between", subset=(age.x>=65))), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between", subset=(type==1))), digits=3)
kable(tidy(plm(a1c~age.x + sex.x + zip.x + timeenr+dolper1000units-1, data=panel, model="between", subset=(type==2))), digits=3)

