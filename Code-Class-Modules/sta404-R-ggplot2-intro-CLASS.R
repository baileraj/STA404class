# sta404-R-ggplot2-intro-CLASS-questions-23jan2021.R
# Directory:  C:/Users/John Bailer/Documents/Classes/STA404class
#             (also on RStudio Server and MacBook)
# Author: J. Bailer
#
# Revised: 01 Feb 2021

# can see working directory - if start as a new project, then all saved there
getwd()

# save work in class subdirectory
# setwd("/Users/baileraj/Desktop/Classes/sta404-fall-2020") # on Mac
# setwd("/home/baileraj/sta404-fall-2020") # on server

# load packages that we will use for initial exploration

library("tidyverse")   # includes ggplot2, dplyr and other tools
library("gapminder")   # dataset with country, may need to install this if it is not available

# getting help 
#==========================================================================

help( package = "tidyverse")
?tidyverse
tidyverse_packages(include_self = TRUE)   # list all of the packages in the tidyverse

?gapminder

browseVignettes(package="dplyr")  # will work on a local installation of RStudio

# exploring a data set ===================================================================

gapminder   # typing name displays contents of object

names(gapminder)    # list names of variables

str(gapminder)      # characteristics and structure of object.  
                    # For data frames, variable names, type, ...

glimpse(gapminder)  # alternative to "str" for tibble

View(gapminder)     # open a tab displaying the gapminder data set

# summary of data set 
#=====================================================================

summary(gapminder)  # what is produced?

# has life expectancy improved between 1952 and 2007?

ggplot() + 
  geom_point(data=gapminder, aes(x=year,y=lifeExp))     # scatterplot
# or ...
ggplot(data=gapminder) +
  geom_point(aes(x=year,y=lifeExp))
# or ...
ggplot(data=gapminder, aes(x=year,y=lifeExp)) +
  geom_point()

# jittering to deal with overplotting
ggplot() + 
  geom_jitter(data=gapminder, aes(x=year,y=lifeExp))    

# distribution changes
ggplot() + 
  geom_boxplot(data=gapminder, aes(x=as.factor(year),y=lifeExp))  


# .............  start of class question ..............
#
# Questions ...
#
ggplot() + 
  geom_boxplot(data=gapminder, 
               aes(x=country,y=lifeExp),color="blue") +
  coord_flip()

# order country by median life expectancy 
# REFS
#    fct_order  <-- Chang Section 15.9 (reorder factor levels)
#    coord_flip <-- Chang Section  8.1 (change axes)
#    filter     <-- Chang Section 15.7 (subset data)
#    xlab, ylab <-- Chang Section 8.10 (axis labels) 

ggplot() + 
  geom_boxplot(data=gapminder, 
               aes(x=fct_reorder(.f=country,
                                 .x=lifeExp,
                                 .fun=median),
                   y=lifeExp)) +
  coord_flip()   # Chang Section 8.1

# restrict to Africa ...
gapminder %>% 
  filter(continent=="Africa") %>% 
  ggplot() + 
  geom_boxplot(aes(x=fct_reorder(.f=country,
                                 .x=lifeExp,
                                 .fun=median),
                   y=lifeExp)) +
  coord_flip()

# ... and then clean up axis labels
gapminder %>% 
  filter(continent=="Africa") %>% 
  ggplot() + 
  geom_boxplot(aes(x=fct_reorder(.f=country,
                                 .x=lifeExp,
                                 .fun=median),
                   y=lifeExp)) +
  ylab("Average Life Expectancy") +
  xlab("Country") +
  coord_flip()

# ... what happens if we select a single year?
gapminder %>% 
  filter(continent=="Africa") %>% 
  filter(year == 2007) %>% 
  ggplot() + 
  geom_boxplot(aes(x=fct_reorder(.f=country,
                                 .x=lifeExp,
                                 .fun=median),
                   y=lifeExp)) +
  ylab("Average Life Expectancy") +
  xlab("Country") +
  coord_flip()

# simpler to code when ordering by other variable as  
gapminder %>% 
  filter(continent=="Africa") %>% 
  filter(year == 2007) %>% 
  ggplot() + 
  geom_boxplot(aes(x=fct_reorder(country,lifeExp),
                   y=lifeExp)) +
  ylab("Average Life Expectancy") +
  xlab("Country") +
  coord_flip()

# .............  end of class question ..............

# distribution changes

# combining layers
ggplot(data=gapminder, aes(x=as.factor(year),y=lifeExp)) + 
  geom_boxplot() +
  geom_jitter(alpha=.2)


ggplot(data=gapminder, 
       aes(x=year,y=lifeExp)) + 
  geom_boxplot() +
  geom_jitter(alpha=.2)

ggplot(data=gapminder, 
       aes(x=as.factor(year),y=lifeExp)) + 
  geom_point()

gapBad <- gapminder %>%
  filter(year != 1957)

ggplot(data=gapBad, 
       aes(x=as.factor(year),y=lifeExp)) + 
  geom_point()

ggplot(data=gapBad, 
       aes(x=year,y=lifeExp)) + 
  geom_point()

# what question do you want to answer for these data?

gapminder %>% 
  arrange(lifeExp) %>% 
  head()

gapminder %>% 
  arrange(lifeExp) %>% 
  tail()

# for those who have used Base R before...
gapminder[gapminder$lifeExp==min(gapminder$lifeExp),]
# or
with(gapminder, gapminder[lifeExp==min(lifeExp),])

# QUESTION:  what is easier to read?

# What is being missed in this display?

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year,y=lifeExp))     
# line graph - what happened here?

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, group=country))

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country, color=country))   
# what happens here?
  
  ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country, color=country)) +
  guides(color="none")


# highlighting countries 
# ================================================================================

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, group=country), color="lightgrey") +
  guides(color="none")

# create dataframe with Rwanda and Japan
#   What is a data frame?
#   What does it mean to pipe commands?
#        Reading " %>% " as " and then "

rwanda_japan <- gapminder %>% 
  filter(country %in% c("Rwanda", "Japan"))

rwanda_japan

ggplot() + 
  geom_line(data=gapminder,
            aes(x=year, y=lifeExp,
                group=country),
            color="grey") +
  geom_line(data=rwanda_japan, 
            aes(year,lifeExp, color=country), 
            size=1.1) +
  theme_minimal()

# cleaning up annotations .....................

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country), 
            color="grey") +
  geom_line(data=rwanda_japan, 
            aes(year,lifeExp, 
                color=country), lwd=1.1) +
  guides(color="none") +
  labs(x="Year", y="Life Expectancy", 
       caption="Source: J. Bryan (2017). gapminder: Data from Gapminder. R package version 
0.3.0.") +
  annotate("text", x=1985, y=80, label="Japan") +
  annotate("text", x=1985, y=30, label="Rwanda") +
  theme_minimal()

# expanding the scale to remove blank space ......
#    at left and bottom of scale
# 
# Added:  01 Feb 2021

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country), 
            color="grey") +
  geom_line(data=rwanda_japan, 
            aes(year,lifeExp, 
                color=country), lwd=1.1) +
  guides(color="none") +
  labs(x="Year", y="Life Expectancy", 
       caption="Source: J. Bryan (2017). gapminder: Data from Gapminder. R package version 0.3.0.") +
  annotate("text", x=1985, y=80, label="Japan") +
  annotate("text", x=1985, y=30, label="Rwanda") +
  scale_x_continuous(limits = c(1952,2007), 
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(20,90),
                     breaks = seq(20, 80, by=20),
                     expand = c(0, 0) ) +  
  theme_minimal() 

#
# controlling color 
#   using scale_color_manual
# modifying x and y scales
#   using scale_x_continuous (_y_)
#
# changing text appearance - Chang 9.2
#   including position of text 
#      hjust = 0 (left justify) to 1 (right justify)
#


ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country), 
            color="grey") +
  geom_line(data=rwanda_japan, 
            aes(year,lifeExp, 
                color=country), lwd=1.1) +
  guides(color="none") +
  labs(x="", y="Life Expectancy", 
       caption="Source: J. Bryan (2017). gapminder: Data from Gapminder. R package version 0.3.0.") +
  annotate("text", x=1985, y=80, 
           label="Japan",
           color = "blue",
           hjust = 0 ) +
  annotate("text", x=1990, y=30, 
           label="Rwanda",
           color = "darkgreen",
           hjust = 1) +
  scale_x_continuous(limits = c(1952,2007), 
                     expand = c(0, 0) ) +
  scale_y_continuous(limits = c(20,85),
                     breaks = seq(20, 80, by=20),
                     expand = c(0, 0) ) +  
  scale_color_manual(
    values = c("blue","darkgreen")
  ) +
  theme_minimal() +
  theme(plot.caption = 
          element_text(size=8) )



# saving this for use in a presentation

myplot <- ggplot() + 
  geom_line(data=gapminder, aes(x=year, y=lifeExp, group=country), color="lightgrey") +
  geom_line(data=rwanda_japan, aes(year,lifeExp, color=country), lwd=1.1) +
  guides(color="none") +
  labs(x="Year", y="Life Expectancy", 
       caption="Source: J. Bryan (2017). gapminder: Data from Gapminder. R package version 
0.3.0.") +
  annotate("text", x=1985, y=80, label="Japan") +
  annotate("text", x=1985, y=30, label="Rwanda") +
  theme_minimal()

ggsave("gapminder-plot.pdf", 
       device="pdf", width=4.5, height=3, units="in")



myplot2 <- ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, 
                group=country), 
            color="grey") +
  geom_line(data=rwanda_japan, 
            aes(year,lifeExp, 
                color=country), lwd=1.1) +
  guides(color="none") +
  labs(x="", y="Life Expectancy", 
       caption="Source: J. Bryan (2017). gapminder: Data from Gapminder. R package version 0.3.0.") +
  annotate("text", x=1985, y=80, 
           label="Japan",
           color = "blue",
           hjust = 0 ) +
  annotate("text", x=1990, y=30, 
           label="Rwanda",
           color = "darkgreen",
           hjust = 1) +
  scale_x_continuous(limits = c(1952,2007), 
                     expand = c(0, 0) ) +
  scale_y_continuous(limits = c(20,85),
                     breaks = seq(20, 80, by=20),
                     expand = c(0, 0) ) +  
  scale_color_manual(
    values = c("blue","darkgreen")
  ) +
  theme_minimal() +
  theme(plot.caption = 
          element_text(size=8) )

ggsave("gapminder-plot2.pdf", 
       device="pdf", width=4.5, height=4, units="in")


# saved on server, would need to export to your computer

# future investigations - faceting ==========================================

ggplot() + 
  geom_line(data=gapminder, 
            aes(x=year, y=lifeExp, group=country, color=country)) +
  facet_grid(. ~ continent ) +
  guides(color="none")


# homework ==================================================================

gapminder2007 <- gapminder %>% 
  filter(year==2007)

