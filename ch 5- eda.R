##########################################################################################################################################################
##########################################################################################################################################################

##### introduction #######################################################################################################################################

# exploratory data analysis (EDA) is an iterative cycle
          # 1. generate questions about the data
          # 2. search for answers through visualizing, transforming, modeling
          # 3. refine your questions or generate new questions based on the results
# EDA is not a formal process, more of a state of mind, creative process
# start by freely investigating the data and gradually hone in on fewer productive areas
# quality of your data should be investigated, does the data meet your expectations?
# cleaning and exploring have an interractive relationship

##### questions ##########################################################################################################################################

# got of EDA is develop an understanding of your data
# answering questions you generate will help you achieve this
# asking quality questions will help generate a quantity of questions
# questions lead to more questions
# drill down on most interesting parts of your data
# no rule for what questions you should be asking
# but two questions you should always be asking are
        # what type of variation occurs within my variables (single variable)
        # what type of covariation occurs between my variables (multiple variables)

##### variation ##########################################################################################################################################

# variation is the tendency of values of a variable to change measurement to measurement
# values of a measurement will have a small amount of error varying from one observation to the next
# each variable has its own pattern of variation
# best way to explore this is through visualization with histograms or barcharts
# categorical variables can vary in terms of different subjects, or different times measured

##### visualizing distributions ##########################################################################################################################

# categorical and continuous variables have different methods for visualizing distribution
# for categorical use a bar chart
# for continuous use a histogram

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# manually count rather than graph

diamonds %>%
  count(cut)

# continuous variables can take on an infitite set of ordered values

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

# manually compute this distribution with cut_width

diamonds %>%
  count(cut_width(carat, 0.1))

# histograms will divide the x-axis into equally spaced bins, the height represents the number of observations for each bin
# set the bin size with the width argument 
# good idea to use a variety of binwidths to explore your data, it can help reveal patterns in the data
# you can zoom into your histogram by filtering values on the x-axis and choosing a smaller binwidth

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(data = smaller) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)

# if you want to overlay multiple histograms in the same graph, its wiser to use a frequency plot (geom_freqpoly)
# easier to understanding overlapping lines than bars
# in this case we see 5 distributions on 1 graph, distributions seperated by cut type
# specifying binwidth still applies with frequency plot

ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = carat, colour = cut), binwidth = 0.1)

##### typical values #####################################################################################################################################

# for histograms and bar charts, tall bars show common values of a variable, short bars show less common values
# look for which values are most common vs most rare, does it match your expectation
# look for unusual patterns and attempt to explain them

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# the cluster of similar values here suggests a subgroup exists, explore the subgroup
# how are the observations within a cluster similar?
# how are observations in separate clusters different?
# could the appearance of a cluster be misleading?
# explain and describe the cluster

# in this histogram we can see two seperate clusters

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

##### unusual values #####################################################################################################################################

# outliers could be due to data entry errors or could actually suggest something important
# some effort may be needed to detect the outliers on a histogram
# simply zoom in on the y-axis so the small values don't appear invisible
# coord_cartesian can zoom into ranges of x or y with xlim or ylim , enter the range like a vector
# ggplot function also has xlim and ylim but it throws away outside values rather than zooming

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) # fyi "y" here is a named variable

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

diamonds %>%
  count(cut_width(y,0.5))

# based on the zoomed histogram we can see the unusual values (around 0, around 30, around 60)
# so we can filter our data based on this

unusual <- diamonds %>%
  filter(y > 3 | y < 20) %>%
  arrange(y)

# analyze these outlier values
# can a diamond have a width of 0mm? Does a width of 60mm seem plausible for diamond?
# repeat the analysis without the outliers and see the effect
# if you can't figure out why they're there and removing them has minimal effect on the results, its like okay to replace with NA values
# however if removing outliers has a substantial effect on results, further investigation is needed, or at least disclose that you removed them

##### exercises ##########################################################################################################################################




#### missing values  #####################################################################################################################################

# you decide what to do with unusual values in your dataset
# either remove the entire record with an usual value (not recommended)
# or replace the unusual value with NA and keep record (recommended)
# just because one measurement is invalid doesn't mean the whole record is invalid
# use mutate and ifelse to replace values
# so you can use mutate not just to create a column, but alter an existing column

diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()

# ggplot will not include NA in your plot, but it will display a warning
# get rid of the warning by removing the NA values with na.rm = TRUE

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

# sometimes you'll want to explore the differences between observations with a missing values and observations with recorded values
# do this by adding a variable specifying TRUE/FALSE

flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
    geom_freqpoly(mapping  = aes(color = cancelled), binwidth = 1/4)

# we mutated the existing sched_dep_time variable, why?
# this is what the graph looks like before mutating the variable to have 6 decimal places
# the added precision makes each value more rare so graph lines come out more

flights %>%
  mutate(cancelled = is.na(dep_time)) %>%
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(mapping  = aes(color = cancelled), binwidth = 1/4)

##### exercises ##########################################################################################################################################


##### covariation ########################################################################################################################################

# covariance is the tendency for two or more variables to vary together in a related way
# visualizing the relationship is best way to understand covariance of multiple variables

##### a categorical and a continuous variable ############################################################################################################

# use geom_freqpoly
# the default setting of geom_freqpoly is not useful to compare one variable to another
# because height is given as a count
# its hard to detect differences between categories if the count heights vary so much

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

# replace count with density, which is like a standardized count
# y-axis values represents the percent of the category's total that each category value is

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

# use a boxplot
# boxplots give you good understanding of the spread of the distribution of values, and if theres a skew
# both whiskers extend past the box 1.5 times the length of the IQR
# all observations outside the whiskers are outliers

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# some categorical variables have an intrinsic order (like cut), some don't
# you'll likely want to reorder the variables if they are ordered with reorder_function

# the x-axis categorical variables here are unordered

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

# we can order the class variables based on their hwy median value

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class,hwy, FUN = median), y = hwy))

# or flip the graph 90 degrees if we prefer

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class,hwy, FUN = median), y = hwy)) +
  coord_flip()

##### two categorical variables ##########################################################################################################################

# visualizing the relationship between two categorical variables 
# a count of the observations for each possible combination is required

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>%
  count(color, cut)

# covariation will appear as a strong correlation between specific x values and specific y values

# with geom_tile, specify that the heat density for each tile depends on n

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

##### two continuous variables ###########################################################################################################################

# scatterplots are standard for two continuous variables

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

# with so many observations showing up on the scatterplot it becomes less insightful
# some areas are overplotted leading to dense black chunks
# fix the problem with the alpha aesthetic (outside of the aes argument)


ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 1/100)

# bin2d and hex will bin on two dimensions, the plane is divided into 2D bins (y bins and x bins)

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

# another solution is grouping continuous variable values into bins so they act like categorical variables
# we can bin carat into ranges of 0.1

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

# so geom_boxplot takes one variable which we chose as carat
# but since its continuous we're using cut_width to group the values into bins
# this graph doesn't tell you anything about the number of observations per bin
# it does tell you the range of values of price for every binned carat

# to visualize the number of data points per bin too, use varwidth = TRUE

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = TRUE)

# or use cut_number
# the difference between cut_number and cut_width is that
# with cut_width, you create bins based on x values specifying the range of each bin
# cut_number will bin the values to get the same number of data points in each bin
# so you can see the bin furthest to the right is way bigger
# because there's way observations with higher carats, data is very right skewed

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

##### patterns and models ################################################################################################################################

# a relationship that exists between two variables will appear as a pattern in the data
# when a pattern is spotted ask yourself
      # is this possibly due to random chance?
      # can you describe the pattern?
      # how strong is the relationship?
      # are other variables potentially affecting it?
      # does the relationship change if you look at a specific subgroup?

# if you think of variance as the phenomenon that creates uncertainty
# then covariance is the phenomenon that reduces uncertainty
# covariance allows you to use the value of one variable to make a prediction about the value of another variable
# if there is a causal relationship, we can that the value of one variable controls the value of another variable
# modeling extracts patterns from the data
# this modeling code fits a model that predicts price from carat
# the residuals computed will give us a view of the price of a diamond once the effect of carat is removed

library(modelr)


mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))



