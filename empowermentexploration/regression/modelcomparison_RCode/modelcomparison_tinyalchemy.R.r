library(lmerTest)
library(ggplot2)

rm(list=ls())

ta<-read.csv('..\\..\\..\\empowermentexploration\\data\\regression\\20211011-1425-tinyalchemy-valuedifferences-human-1.csv')

tadf<-data.frame(trial=scale(ta$trial),
                  id=paste(ta$id), 
                  cbu=scale(ta$delta_cbu),
                  emp=scale(ta$delta_emp),
                  bin=scale(ta$delta_bin),
                  cbv=scale(ta$delta_cbv),
                  decision=ta$decision)

tadf_fullregression<-glmer(decision~-1+cbu+emp+trial+trial*cbu+trial*emp+(1|id), family='binomial', data=tadf, nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
#tadf_fullregression<-glmer(decision~-1+cbu+emp+(1|id), family='binomial', data=tadf, nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))

tadf_fullregression_summary<-summary(tadf_fullregression)
tadf_fullregression_summary
tadf_fullregression_m<-tadf_fullregression_summary$coefficients[1:2,1]
tadf_fullregression_se<-tadf_fullregression_summary$coefficients[1:2,2]

dataforplot_tadf_fullregression<-data.frame(mu=tadf_fullregression_m, ci=1.96*tadf_fullregression_se, 
               model=rep(c('Uncertainty', 'Empowerment')))


#limits with 95% CIs
limits <- aes(ymax = mu + ci, ymin= mu - ci)

#plot
plot_tadf_fullregression <- ggplot(dataforplot_tadf_fullregression, aes(x=model, y=mu)) + 
  #bars
  geom_bar(position="dodge", stat="identity", width=0.6)+
  #error bars
  geom_errorbar(limits, position="dodge", width=0.25)+
  #points
  geom_point(size=3)+
  #color
  #scale_fill_manual(values = c(cbPalette))+
  #theme
  theme_minimal() +
  #limits
  #scale_y_continuous(limits = c(0,100), expand = c(0, 0)) +
  #labs
  xlab("Model")+
  ylab(expression(beta))+
  #title
  ggtitle("")+
  #adjust text size
  theme(text = element_text(size=21,  family="sans"))+
  #no legend
  theme(legend.position = "none")

plot_tadf_fullregression


# 
# 
# ## BOTTOM UP ANALYSIS
# # get model with single models as fixed effect
# me <- glmer(decision ~ -1 + emp + trial + trial*emp + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(me)
# 
# mv <- glmer(decision ~ -1 + cbv + trial + trial*cbv + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(mv)
# 
# mb <- glmer(decision ~ -1 + bin + trial + trial*bin + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(mb)
# 
# mu <- glmer(decision ~ -1 + cbu + trial + trial*cbu + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(mu)
# 
# # get model with empowerment and binary as fixed effect
# meb <- glmer(decision ~ -1 + emp + bin + trial + trial*emp + trial*bin + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(meb)
# 
# # get model with empowerment and CBU as fixed effect
# meu <- glmer(decision ~ -1 + emp + cbu + trial + trial*emp + trial*cbu + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(meu)
# 
# # get model with binary and CBU as fixed effect
# mub <- glmer(decision ~ -1 + bin + cbu + trial + trial*bin + trial*cbu + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(mub)
# 
# # get model with empowerment and binary and CBU as fixed effect
# meub <- glmer(decision ~ -1 + emp + bin + cbu + trial + trial*emp + trial*bin + trial*cbu + (1 | id), data=tadf, family="binomial", nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
# summary(meub)
# 
# # compare models
# anova(me, meb)
# anova(mb, meb)
# anova(me, meu)
# anova(mu, meu)
# anova(mb, mub)
# anova(mu, mub)
# anova(mub, meub)
# anova(meu, meub)
# anova(meb, meub)
# 
# emponbin <- lmer(emp ~ -1 + bin + (1|id), data = tadf)
# summary(emponbin)
# 


#comparison of empowerment and uncertainty

emp_df <- subset(tadf, select=c("emp","decision", "id", "trial"))
emp_df$empmodel <- 1
names(emp_df)[names(emp_df) == "emp"] <-"modelestimate"

cbu_df <- subset(tadf, select=c("cbu","decision", "id", "trial"))
cbu_df$empmodel <- 0
names(cbu_df)[names(cbu_df) == "cbu"] <-"modelestimate"

concatenated_df<-rbind(emp_df,cbu_df)
concatenated_df_fullregression<-glmer(decision~-1+modelestimate+modelestimate*empmodel+trial+trial*modelestimate+(1|id), family='binomial', data=concatenated_df, nAGQ=0, control=glmerControl(optimizer = "nloptwrap"))
summary(concatenated_df_fullregression)

