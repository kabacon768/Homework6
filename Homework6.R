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