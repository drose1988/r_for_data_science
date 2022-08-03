##########################################################################################################################################################
##########################################################################################################################################################

library(nycflights13)
library(tidyverse)

?flights
View(flights)

##########################################################################################################################################################

# tibbles are data frames but slightly tweaked to work better with tidyverse

# int -> integer
# dbl -> doubles, real numbers
# chr -> character vectors, or strings
# dttm -> date-times
# lgl -> logical (TRUE FALSE)
# fctr -> factors, represents categorical variables with fixed possible values
# date -> date

#### dplyr basics ########################################################################################################################################

# filter, arrange, select, mutate, summarize, group_by(works in conjunction with the other)
# those 6 verbs are the basis of data manipulation

filter(flights, month == 1 , day == 1)
dec25 <- filter (flights, month == 12 , day == 1)

#### comparisons #########################################################################################################################################

# near() is alternative to == to use, computers hold finite precision on arithmatic

sqrt(2)^2 == 2
1/49 * 49 == 1

near(sqrt(2) ^ 2 , 2)
near(1/49 * 49 , 1)

#### logical operators  #################################################################################################################################

# y & !x
# x & x
# x & !y
# x | y
# xor (x, y)


# this works regardless of what the books says
filter(flights , month == 11 | month == 12)

# but this is more intuitive
nov_dec <- filter(flights, month %in% c(11,12))

# same output, nesting a whole argument in a ! can sometimes make code concise
filter(flights , !(arr_delay > 120 | dep_delay > 120))
filter(flights , arr_delay <= 120 , dep_delay <= 120)


# NA is the absense of value, most operations involving an NA will return NA
NA > 5
10 == NA
NA + 10
df <- tibble (x = c(1, NA, 3))

filter(df, x > 1)
filter(df, is.na(x) | x > 1)

#### excersises #########################################################################################################################################

# Find all flights that:

# had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)

# flew to Houston (IAH or HOU)
filter(flights, dest %in% c("IAH" , "HOU"))
filter(flights, dest == "IAH" | dest == "HOU")

# were operated by united, american, delta
flights %>% distinct(carrier)
filter(flights, carrier %in% c("UA","AA","DL"))

# departed in summer (july, august, september)
filter(flights, month %in% c(7,8,9))

# arrived more than two hours late, but didn't leave late
filter(flights, arr_delay >=120, dep_delay <=0)

# were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)

# departed between midnight and 6 am (inclusive)
summary(flights$dep_time)  # check the min and max to see if midnight is referred to as 2400 or 0
filter(flights, between(dep_time,1,600) | dep_time == 2400)
filter(flights, dep_time <= 600 | dep_time == 2400)

# Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous questions?
filter(flights, between(month,7,9))

# How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time)) # all the time and delay variables except the scheduled times, incomplete input of the data

# Why is NA ^ 0 not missing? Why is NA | True not missing? Why is False & NA not missing? Can you figure out the general rule? 
# (NA * 0 is a tricky counterexample)

NA ^ 0        # general rule that anything to the power of 0 will be 1
NA | TRUE     # anything TRUE is TRUE, if the missing values were FALSE then the statement would still be TRUE
NA | FALSE    # NA could be TRUE or FALSE so the logic can't determine the statement to be TRUE or FALSE
TRUE & FALSE
NA & FALSE    # NA could be TRUE or FALSE, either way TRUE & FALSE == FALSE 
NA * 0        # 0 * ∞ and 0 * -∞ are undefined values, so NA could possibly be infinity

#### arrange #################################################################################################################

arrange(flights, year, month, day)

arrange(flights, desc(arr_time))

df <- tibble(x = c(5, 2, NA))

arrange(df, desc(x))
arrange(df, x)

# How could you use arrange() to sort all missing values to the start (hint is.na)
arrange(flights, desc(is.na(air_time)),air_time)

# Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay + arr_delay))
arrange(flights, desc(year + month + day))    # interesting that you can use math operations and sort based on results

# Sort flights to find the fastest flight.
arrange(flights, air_time)

# Which flights traveled the longest? Which traveled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)

#### select  #################################################################################################################

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

rename(flights, tail_num = tailnum)
select(flights, time_hour, air_time, everything())    # to bring a few columns to the front but return everything

# Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, arr_delay from flights
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, 4,6,7,9)

# What happens if you include the name of a variable multiple times in a select() call?
select(flights, air_time, air_time)

# What does the one_of() function do? Why might it be helpful in conjunction with this vector? vars <- c("year","month","day","dep_delay","arr_delay")
vars <- c("year","month","day","dep_delay","arr_delay")
select(flights, one_of(vars))     # if you create a vector with matching column names and ask for one of the columns in vars from flights
select(flights, all_of(vars)) 
select(flights, any_of(vars)) 

# Does the result of running this following code surprise you? How do the select helpers deal with case by default? How can you change the default? select(flights, contains("TIME"))
select(flights, contains("TIME"))     # for some reason the contains function ignores the case, probably to return more making it easier to find columns

#### mutate ##################################################################################################################

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)

mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)   # however you're not creating an object so this won't save your new columns

# transmute mutates the table but only return the columns you've created
transmute(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)

# mutating can include a number of functions and operators
# arithmetic operators (+ - * /)
# modular arithmetic (%/% or %%) -> %/% returns integer division, %% returns remainder

transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)

# logs -> log(), log2(), log10()
# useful for transforming data that ranges across multiple orders of magnitude

# offset -> lead(), lag() 
# allows you to compute running differences, useful in conjunction with group_by

(x <- 1:10)
lag(x)
lead(x)

# cumulative and rolling aggregates -> sum computed over a rolling window

cumsum(x)
cumprod(x)
cummin(x)
cummax(x)
cummean(x)

# logical comparisions -> <,>,<=,>=,!=

# ranking -> start with min and max then move down to other functions if needed

y <- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))
row_number(y)
percent_rank(y)
dense_rank(y)
cume_dist(y)

#### excersises ##############################################################################################################

# Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. 
# Convert them to a more convenient representation of number of minutes since midnight.

flights_times <- mutate(flights,
                        dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                        sched_dep_time_mins = (sched_dep_time %/% 100 * 60 +
                                                 sched_dep_time %% 100) %% 1440)

select(
  flights_times, dep_time, dep_time_mins, sched_dep_time,
  sched_dep_time_mins)

time2mins <- function(x) {(x %/% 100 * 60 + x %% 100) %% 1440}

flight_time <- mutate(flights,
                      dep_time_mins = time2mins(dep_time),
                      sched_dep_time_mins = time2mins(sched_dep_time))

# Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

air_flights <- mutate(flights, air_time2 = arr_time - dep_time) 

select(air_flights, air_time, air_time2)

#### grouped summaries #######################################################################################################

# summarize collapses the data frame into a single row
# most useful paired with group_by
# summarize and group_by is one of the most commonly used pair in work with dplyr

summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)

summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

summarize(group_by(flights, year, month, day), delay = mean(dep_delay, na.rm = TRUE))


# 3 steps are needed to prepare the data
# group flights by destination
# summarize to compute count of flights, distance, average delay
# filter out the noisy data points
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data = delay, mapping  = aes(x = dist, y = delay))+
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# however you can use pipes to condense the code and make the steps more intuitive, easier to interpret
# read as a series of imperative statements
# left to right, top to bottom makes it more digestible
delays <- flights %>%
  group_by(dest) %>%
  summarize(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dest != "HNL")

#### missing values ##########################################################################################################

# na.rm -> remove NA, defaults to FALSE so specify TRUE so NA doesn't impact your aggregations
View(delay)
View(delays)

flights %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

flights %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

#### counts  #################################################################################################################

# when doing aggregation do a count of values and a count of nonmissing values
# count(n()) , sum(!is.na())

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay))

View(delays)

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# this plot compared to the previous demonstrates how sometimes its useful to filter out the smallest number of observations
# you see more of a pattern, the plot is less influenced by the extreme variation of small counts
delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

##############################################################################################################################

# creates a tibble from the Batting table in Lahman package
batting <- as_tibble(Lahman::Batting)

# creates a list of every batter and their career avg and ab
batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

# filter out the batters will 100 or less, and plot ab against ba
batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

#### useful summary functions ################################################################################################

# meaures of location -> here we are combining aggregation with logical subsetting seen in the brackets
# we can see the difference in avg_delay values because we've filtered out arr_delay less than zero in the second one
not_cancelled %>% 
  group_by(year, month, day) %>%
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

# measures of spread -> sd(), IQR(), mad(): median absolute deviation
# why is distance to some destinations more variable than others
not_cancelled %>%
  group_by(dest) %>%
  summarise(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

# measures of rank -> min(), quantile(x,0.25), max()
# when do the first and last flights leave each day
not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(first = min(dep_time), last = max(dep_time))

# measures of position -> first(), last(), nth(x,2)

not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(first_dep = first(dep_time), last_dep = last(dep_time))

# mutate r to give the highest dep_time of each day
# what does the filter do?
what_is_this <- not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

#### count ###################################################################################################################

# n() takes no argument to get the size of the current group
# n_distinct(x) counts distinct values

# which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

# count the total number of miles each plane flew (use weight variable)
not_cancelled %>%
  count(tailnum, wt = distance)

#### counts and proportions of logical values  ###############################################################################
# ex sum(x > 10) or mean(y == 0)
# when using counts with numeric functions, TRUE converts to 1 and FALSE converts to 0
# so sum(x) gives the number of TRUEs in x
# and mean(x) gives the proportion of TRUEs of the total

# How many flights left before 5am for each day?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time < 500))

# what proportion of flights are delayed by more than an hour?
# the hour_perc here represents percent of flights delayed over total flights for each day
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(hour_perc = mean(arr_delay > 60))

#### grouping with multi variables ###########################################################################################

# grouping multiple variables, each summary peels off one level of grouping

# you're starting on a dataset grouped by three columns and moving it back to grouping on one column
daily <- group_by(flights, year, month, day)

(per_day <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum(flights)))

(per_year <- summarise(per_month, flights = sum(flights)))

# the object daily has a group_by in it so specifying ungroup first will change it back to original dataset

daily %>%
  ungroup() %>%
  summarise(flights = n())

#### excersises ##############################################################################################################

# Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:

# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# A flight is always 10 minutes late.
# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# 99% of the time a flight is on time. 1% of the time it’s 2 hours late.

#Which is more important: arrival delay or departure delay?

# look at the summary statistics for arr_delay and dep_delay, graph the distribution of delay time, 
# convert the dep_delay and arr_delay to z-scores and figure out which values are 2 standard deviations away from the median

# Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).

not_cancelled %>%
  group_by(dest) %>%
  summarise(n = n())

not_cancelled %>%
  group_by(tailnum) %>%
  summarise(n = sum(distance))


# Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay)) is slightly suboptimal. Why? Which is the most important column?

# I would think a lack of delay information doesn't necessarily the flight was cancelled, no values for arrival time and departure time are more appropriate

not_cancelled_wrong <- flights %>%
  filter(!is.na(dep_delay) | !is.na(arr_delay))

# Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?

not_cancelled1 <- flights %>%
  filter(!(is.na(dep_delay) & is.na(arr_delay)))

flights %>%
  group_by(year,month,day) %>%
  summarise(pct_cancelled = count(is.na(dep_delay)) / count(dep_delay))

cancelled_counts <- flights %>%
  mutate(cancelled = (is.na(dep_delay) | is.na(arr_delay))) %>%
  group_by(year, month, day) %>%
  summarise(cancelled_num = sum(cancelled), flights_num = n())

ggplot(data = cancelled_counts, mapping = aes(x = flights_num, y = cancelled_num))+
  geom_jitter() +
  geom_smooth(se = FALSE)

cancelled_and_delayed <- flights %>%
  mutate(cancelled = (is.na(dep_delay) | is.na(arr_delay))) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelled_prop = mean(cancelled),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  ungroup()

ggplot(data = cancelled_and_delayed, mapping = aes(x = cancelled_prop, y = avg_arr_delay)) +
  geom_point() +
  geom_smooth()


# Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? 
# Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))


flights %>%
  group_by(carrier) %>%
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  ) %>%
  arrange(desc(avg_dep_delay))

# For each plane, count the number of flights before the first delay of greater than 1 hour.

flights %>%
  group_by(tailnum) %>%
  count(sort = TRUE)

#### grouped mutates (and filters) ###########################################################################################

# grouping is most common with summarise, but it can be used with mutate and filter as well

# finding the worst members in each group
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) <= 5)

# this doesn't create a squashed dataset grouped by dest, it filters the dataset to only show flights to destinations that had more than 365 trips that year
popular_dest <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)

# to see the desinations not included in that group
flights %>%
  group_by(dest) %>%
  filter(n() <= 365)

# filter out arrival delays less than 0, the prop_delay percent values are actually the proportion of delay times over total delay times for each destination
# since you grouped by the dest when making the object, the group by holds
popular_dest %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay) %>%
  arrange(desc(prop_delay))

#### excersises ##############################################################################################################

# 1. Refer back to the table of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

# when you first group the dataset by values in a field, the filter you use applies to each of those fields
# so filtering for the 5 largest values of arr_delay will not return 5 records in total, it'll return 5 records per group

# 2. Which plane (tailnum) has the worst on time record?

# worst arrival delay of each plane

# take flights, filter out the NA for tailnum and arr_time
# the mutate on_time variable tells us either true or false depending on those two conditions
# then group by tailnum
# summarise with mean of on_time which gives you proportion of on time over the total per tailnum 
# filter out cases where a plane flew less than 20 flights
# second filter ranks the on_time percents and gives you the lowest one

flights %>%
  filter(!is.na(tailnum), is.na(arr_time) | !is.na(arr_delay)) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>%
  group_by(tailnum) %>%
  summarise(on_time = mean(on_time), n = n()) %>%
  filter(n >= 20) %>%
  filter(min_rank(on_time) == 1)

flights %>%
  group_by(tailnum) %>%
  filter(rank(desc(arr_delay)) == 1) %>%
  arrange(tailnum)

# 3. What time of day should you fly if you want to avoid delays as much as possible?

flights %>%
  filter(!is.na(hour)) %>%
  group_by(hour) %>%
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(avg_delay)

#4. For each destination, compute the total minutes of delay. 
#   For each flight, compute the proportion of the total delay for its destination.

View(flights %>%
       filter(arr_delay > 0) %>%
       group_by(dest) %>%
       summarise(arr_delay_total = sum(arr_delay),
                 prop_total_delay = arr_delay / arr_delay_total))

#5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, 
#   later flights are delayed to allow earlier flights to leave. 
#   Using lag() explore how the delay of a flight is related to the delay of the immediately preceding flight.


lagged_delays <- flights %>%
  arrange(origin, month, day, dep_time) %>%
  group_by(origin) %>%
  mutate(dep_delay_lag = lag(dep_delay)) %>%
  filter(!is.na(dep_delay), !is.na(dep_delay_lag))

lagged_delays %>%
  group_by(dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 1500, by = 120)) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")

lagged_delays %>%
  group_by(origin, dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  facet_wrap(~ origin, ncol=1) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")



# 6. Look at each destination. Can you find flights that are suspiciously fast? 
#    (i.e. flights that represent a potential data entry error). 
#    Compute the air time of a flight relative to the shortest flight to that destination. 
#    Which flights were most delayed in the air?

View(flights %>%
       group_by(dest) %>%
       summarise(sd_travel_time = sd(air_time, na.rm = TRUE),
                 mean_travel_time = mean(air_time, na.rm = TRUE),
                 min_travel_time = min(air_time, na.rm = TRUE),
                 max_travel_time = max(air_time, na.rm = TRUE)))

View(flights %>%
       filter(!is.na(air_time)) %>%
       group_by(dest) %>%
       mutate(min_air_time = min(air_time), relative = air_time - min(air_time)))

standardized_flights <- flights %>%
  filter(!is.na(air_time)) %>%
  group_by(dest, origin) %>%
  mutate(
    air_time_mean = mean(air_time),
    air_time_sd = sd(air_time),
    n = n()
  ) %>%
  ungroup() %>%
  mutate(air_time_standard = (air_time - air_time_mean) / (air_time_sd + 1))

View(standardized_flights)
