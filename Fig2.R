library(metafor)

par(font=1)
forest(c(1.0486, 1.00, 1.05, 1.04, 1.02, 1.06),
       ci.lb=c(1.0239, 0.89, 1.004, 1.01, 0.92, 1.03),
       ci.ub=c(1.0739, 1.13, 1.10, 1.08, 1.12, 1.09),
       xlim=c(.75,1.25),
       ylim=c(-1,11),
       rows=c(7,5,4,3,1,0),
       slab=c(" ","  Children"  ,"  Adults <65" ,"  Older adults","  Type 1","  Type 2"),
       xlab="Hazard Ratio of primary outcome (95% CI)",
       refline=1)
par(font=2)
text(.75,c(7,6,2),pos=4,c("Overall", "By age", "By diabetes type"))

par(font=1)
forest(c(0.01, -0.01, 0.01, 0.01, 0.04, 0.00),
       ci.lb=c(-0.05, -0.05, -0.07, -0.07, -0.15, -0.06),
       ci.ub=c(0.07, 0.03, 0.09, 0.09, 0.23, 0.06),
       xlim=c(-.5, .5),
       ylim=c(-1,11),
       rows=c(7,5,4,3,1,0),
       slab=c(" ","  Children"  ,"  Adults <65" ,"  Older adults","  Type 1","  Type 2"),
       xlab="Percentage point change in hemoglobin A1c (95% CI)",
       refline=0)
par(font=2)
text(-0.5,c(7,6,2),pos=4,c("Overall", "By age", "By diabetes type"))

par(font=1)
forest(c(1.01, 1.28, 1.00, 1.01, 1.04, 1.02),
       ci.lb=c(0.98, 0.78, 0.94, 0.98, 0.92, 0.99),
       ci.ub=c(1.04, 1.78, 1.07, 1.04, 1.17, 1.05),
       xlim=c(0.3,2.2),
       ylim=c(-1,11),
       rows=c(7,5,4,3,1,0),
       slab=c(" ","  Children"  ,"  Adults <65" ,"  Older adults","  Type 1","  Type 2"),
       xlab="Hazard ratio of microvascular disease (95% CI)",
       refline=1)
par(font=2)
text(.3,c(7,6,2),pos=4,c("Overall", "By age", "By diabetes type"))


