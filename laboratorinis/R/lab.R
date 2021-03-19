library(tidyverse)

# duomenu skaitymas
data0<-read_csv("data/lab_sodra.csv")

# atfiltravimas pagal ekonomines veiklos koda
data<-data0 %>% filter(ecoActCode==479100)

# 1
summary(data$avgWage)
# pirmojo grafiko kodas
ggplot(data, aes(x=avgWage))+
        geom_histogram(fill="darkslategrey", alpha=0.8, col="black")+
        labs(title = "Average wage of employees (economic activity code: 479100)",
             x="Average Wage, euros", y="Count") + theme_bw()


dev.copy(png, file="img/plot1.png", width=780)
dev.off()

# 2
# menesio isskyrimas is datos kintamojo
data <- data %>% mutate(month_value=as.integer(substr(month, 5 ,7)))
# top 5 imoniu atrinkimas pagal avgWage
topcompanies<-data %>% 
        group_by(name) %>% 
        slice_max(avgWage, n=1) %>% 
        ungroup() %>%
        top_n(avgWage, n=5) %>% 
        select(name)

# top 5 imoniu duomenu atrinkimas 
top5 <- data %>% filter(name %in% topcompanies$name)

# antrojo grafiko kodas
ggplot(top5, aes(x=month_value, y=avgWage, col=name))+
        geom_line()+
        geom_point()+
        scale_x_continuous(breaks=1:12,limits=c(1,12))+
        theme_bw()+
        labs(title= "Average wage of employees by month",
             x="Month", y="Average Wage")

dev.copy(png, file="img/plot2.png", width=780)
dev.off()

# 3
# treciojo grafiko kodas
top5 %>%  group_by(name) %>% top_n(numInsured,n=1) %>% distinct(name,numInsured) %>%
        ggplot(aes(x = (reorder(name,-numInsured)), y = numInsured, fill=name))+
        geom_col()+
        labs(title= "# of employees insured",
             x="Company", y="# of emplyees") +
        theme_bw()+
        scale_x_discrete(guide = guide_axis(n.dodge = 2))

dev.copy(png, file="img/plot3.png", width=780)
dev.off()




