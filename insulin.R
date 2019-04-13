rm(list=ls())
library(tidyverse)
library(survival)
library(readr)
library(broom)
library(knitr)

iseq <- read_csv("~/Transform_15_output.csv")
iev <- read_csv("~/Transform_18_output.csv", 
                col_types = cols(zip = col_double()))

temp <- subset(iev, select=c(zip:event)) # baseline data
temp = temp %>%
  group_by(Patid) %>%
  summarise(zip = max(zip),
            sex = max(sex),
            age = min(age),
            time = max(time),
            event = max(event),
            timeenr = max(timeenr)) 

temp2 = temp %>%
  select(Patid)
temp3 = iseq %>%
  inner_join(temp2, by="Patid") %>%
  mutate(dolperunits = dolperunits*1.07*(Std_Cost_Yr==2013)+
           dolperunits*1.08*(Std_Cost_Yr!=2013),
         year = lubridate::year(Fill_Dt), 
         month = lubridate::month(Fill_Dt)) %>%
  mutate_at(scale, .vars = "dolperunits")

iev2 <- tmerge(temp, temp, id=Patid, endpt = event(time, event))
iev2 <- tmerge(iev2, temp3, id=Patid, dolperunits = tdc(time, dolperunits),
               month = tdc(time, month),
               year = tdc(time, year))

fit1 = coxph(Surv(tstart, tstop, endpt==1) ~ age+sex+zip+timeenr+dolperunits+cluster(Patid), data=iev2)
summary(fit1)

