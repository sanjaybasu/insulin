library(vioplot)
library(tidyverse)

iseq <- read_csv("~/Transform_15_output.csv")
iev <- read_csv("~/Transform_26_output.csv", 
                col_types = cols(zip = col_double()))

ins = iseq %>%
  filter(!str_detect(Gnrc_Nm,"PUMP"),!str_detect(Gnrc_Nm,"SYRINGE"),!str_detect(Gnrc_Nm,"NEEDLE"),!str_detect(Gnrc_Nm,"DEVICE"),!str_detect(Gnrc_Nm,"ADMIN")) %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013)) %>%
  group_by(lubridate::year(Fill_Dt)) %>%
  summarise(dolper1000units = mean(na.omit(dolper1000units))) 
ins2 = iseq %>%
  filter(!str_detect(Gnrc_Nm,"PUMP"),!str_detect(Gnrc_Nm,"SYRINGE"),!str_detect(Gnrc_Nm,"NEEDLE"),!str_detect(Gnrc_Nm,"DEVICE"),!str_detect(Gnrc_Nm,"ADMIN")) %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013)) %>%
  group_by(Gnrc_Nm,lubridate::year(Fill_Dt)) %>%
  tally()
ins3 = iseq %>%
  filter(!str_detect(Gnrc_Nm,"PUMP"),!str_detect(Gnrc_Nm,"SYRINGE"),!str_detect(Gnrc_Nm,"NEEDLE"),!str_detect(Gnrc_Nm,"DEVICE"),!str_detect(Gnrc_Nm,"ADMIN")) %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013)) %>%
  group_by(Gnrc_Nm,lubridate::year(Fill_Dt)) %>%
  summarise(dolper1000units = mean(na.omit(dolper1000units)))
write_csv(ins2,"ins2.csv")
write_csv(ins3,"ins3.csv")

ins4 = iseq %>%
  filter(!str_detect(Gnrc_Nm,"PUMP"),!str_detect(Gnrc_Nm,"SYRINGE"),!str_detect(Gnrc_Nm,"NEEDLE"),!str_detect(Gnrc_Nm,"DEVICE"),!str_detect(Gnrc_Nm,"ADMIN")) %>%
  mutate(dolper1000units = (oopc/unitsfixed)*1000,
         dolper1000units = dolper1000units*1.07*(Std_Cost_Yr==2013)+
           dolper1000units*1.08*(Std_Cost_Yr!=2013)) %>%
  group_by(lubridate::year(Fill_Dt)) 
vioplot((ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2003]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2004]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2005]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2006]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2007]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2008]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2009]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2010]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2011]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2012]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2013]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2014]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2015]),
        (ins4$dolper1000units[ins4$`lubridate::year(Fill_Dt)`==2016]),
        names = c("2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016"),
        col="dodgerblue")
title(ylab = "$US/1000 units",xlab = "Year")
