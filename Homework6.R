library(tidyverse)
library(tidytext)
library(textstem)
library(topicmodels)
library(ggplot2)
library(dplyr)

data = read_csv("RDS-2016-0005/Data/TS3_Raw_tree_data.csv")
#created empty state column
data$State = c()
#split up data by column to create state and city column
data[,c("City", "State")] = str_split_fixed(data$City, ",", n=2) 

state_counts = data %>% group_by(State) %>% summarise(n = n())

#Table shows counts by states
view(state_counts)

#Only NC and SC
NCSC = data %>% filter(State == " NC" | State == " SC")
NCSC_Cities = NCSC %>% group_by(State, City) %>%  summarise(n = n())

#They looked at Charleston and Charlotte

all(str_detect(NCSC$ScientificName, "^[[:alnum:]]+ [[:digit:]]+$"))

NCSC$genus = c()
NCSC$species = c()
#split up data by column to create state and city column
NCSC[,c("genus", "species")] = str_split_fixed(NCSC$ScientificName, " ", n=2) 
By_genus = NCSC %>% group_by(State, genus) %>% summarise(average = mean(`AvgCdia (m)`))
#In both NC and SC, the largest genus was Quercus.

#extra credit

#tree age

age_by_genus = NCSC %>% group_by(genus) %>% summarise(average = mean(Age))
#Yes, Quercus averages older at 35, this oculd explain results from before- in thatt hey would have bigger canopies. 

#Now this shows me my average area by age and genus. 
by_age = NCSC %>% group_by(Age, genus) %>% summarise(average = mean(`AvgCdia (m)`))
#I want a tree that is young but still averages with a large canopy. 

#I looked at this plot to figure out which genus I should recommend. THe one that jumped out at me was the one that was young and peaked at about 25. Ulmus was this genus. It produces a relatively large crown quickly.
ggplot(by_age, aes(x = average, y = Age, color = genus)) +
 geom_line()