##########################################################################################################################################################
##########################################################################################################################################################

##### introduction #######################################################################################################################################

# tibbles are different than R's traditional data frames
# they are still data frames, just slightly tweaked

vignette(tibble)
package?tibble

##### creating tibbles ###################################################################################################################################

# standard in data science functions in R to produce tibbles
# syntax universal within the tidyverse

# coerce a data frame into a tibble

as_tibble(iris)

# create a new tibble from individual vectors
# it automatically recycles a input value as well

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y)

# tibbles will never change the variable type, never change the names of variables, never creates a row name
# R requires a valid name for a column, but if you want to refer to these columns use a backtick

tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number")

# another way to create a tibble is with tribble, transposes the data
# the commented part can make it easier to view

tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5)

##### tibbles vs data.frame #############################################################################################################################

# printing and subsetting are the main differences between tibbles and data frames

# printing

# tibbles print the first 10 records and every column that can fit on the screen

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# you can print the data frame and control the number of rows and width of the display
# width = Inf will display all columns

nycflights13::flights %>%
  print(n = 10, width = Inf)

# R's built in viewer is View()

# subsetting

# pull out a single variable using $ or [[.[[

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# all these work the same

df$x
df[["x"]]
df[[1]]

# you can extract a single column with a pipe but you need a placeholder "."

df %>% .$x

##### interacting with older code #######################################################################################################################

# tibbles are more strict, they never do partial matching

# as.data.fram() will turn a tibble back to a data.frame

as.data.frame(df)

class(as.data.frame(df))
class(df)

##### exercises #########################################################################################################################################

# 1. how can you tell if an object is a tibble? try printing mtcars which is a regular data frame

            print(mtcars)
            print(as_tibble(mtcars))

            # printing as a tibble gives more information about the data

# 2. compare and contrast the following operations on a data.frame and equivalent tibble. what is the difference? 
#    why might the default data frame behaviors cause you frustration?

            df <- data.frame(abc = 1, xyz = "a")
            tb <- tibble(abc = 1, xyz = "a")      # tibble shows the data type and greys out the row number
        
            df$x      # this returns xyz back, which isn't good, we'd rather minimize room for error
            tb$x      # doesn't run, tibbles are more strict
        
            df[, "xyz"]     # returns the character value in quotes
            tb[, "xyz"]     # returns just the value but tibble printout shows the data type
        
            df[, c("abc", "xyz")]     # works
            tb[, c("abc", "xyz")]     # works
        
# 3. if you have the name of a variable stored in an object (var <- "mpg"), how can you extract the reference variable from a tibble?
        
            # You can use the double bracket, like df[[var]]. You cannot use the dollar sign, because df$var would look for a column named var.
        
            mpg[[var]]
        
# 4. Practice reffering to nonsyntactic names in the following data frame by:
        
            annoying <- tibble(
              `1` = 1:10,
              `2` = `1` * 2 + rnorm(length(`1`))
            )
        
        # extracting the variable called 1
        
            annoying$`1`
        
        # plotting a scatterplot of 1 versus 2
            
            ggplot(annoying, aes(`1`,`2`)) +
              geom_point()
        
        # creating a new column called 3 which is 2 divided by 1
            
            annoying <- annoying %>%
              mutate(`3` = `2` / `1`)
              
        
        # renaming the columns to one, two, and three
            
            annoying <- annoying %>%
              rename("one" = `1`,
                     "two" = `2`,
                     "three" = `3`)
            
# 5. what does tibble::enframe() do? when might you use it?
            
            ?tibble::enframe
            enframe(1:5)
            enframe(c(a = 5, b = 7))
            enframe(list(one = 1, two = 2:3, three = 4:6))
            
            # enframe makes it so you don't have to write a character vector out in quotes when you are creating a tibble
            
# 6. what option controls how many additional column names are printed at the footer of a tibble?
            
            # the n_extra argument
