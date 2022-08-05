##########################################################################################################################################################
##########################################################################################################################################################

##### introduction #######################################################################################################################################

# ggplot  = "grammer of graphics"

# a data frame is a rectangular collection of variables (in columns) and observations (in rows)

# the first argument in ggplot is always the dataset

# complete your graph by adding one or more layers (geom_point)

# the mapping argument is always paired with aes() specifying which variables to map to x and y

##### the layered grammer of graphics ####################################################################################################################

ggplot(data = <DATA>) +
  <GEOM_FUNCTION> (mapping = aes(<MAPPING>),
                   state = <STAT>,
                   position = <POSITION>) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
  
# 7 parameters in this template compose the grammer of graphics

# you could extend the plot by adding one or more additional layers, each with a set of 7 new parameter specifications

##### exercises ##########################################################################################################################################

mpg %>%
  count(class, drv) %>%
  ggplot(aes(x = class, y = drv)) +
  geom_tile(mapping = aes(fill = n))

mpg %>%
  count(class, drv) %>%
  complete(class, drv, fill = list(n = 0)) %>%
  ggplot(aes(x = class, y = drv)) +
  geom_tile(mapping = aes(fill = n))

##### aesthetic mapping ##################################################################################################################################

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

# adding a 3rd variable to ggplot by mapping it in aes(). a 3rd variable on a two-dimensional graph will be an aesthetic added

# scaling: refers to R auto assigning unique level of aesthetic to each unique variable

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# mapping an unordered variable (class) to an ordered aesthetic (size) is not advised, unlike using color, r gives you a warning too

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# again, alpha doesn't work well with discrete variables like this,

# it's like were assigning a level of value to some categories over the other, 

# shape works with 6 or less discrete values, going over 6 won't map the rest

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# to set an aesthetic manually like in this case where r isn't auto assigning color to each discrete value, 

# the color goes outside of the aes() argument

# aes() -> size, shape, color, fill, stroke

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

##### exercises ##########################################################################################################################################

# 1. what's wrong with this code? why are the points not blue?
  
      # you've mapped the color within the aes function, it should be in the geom_point function
      # it's being treated as an aesthetic

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = "blue"))

##########################################################################################################################################################

# 2. which variables in mpg are categorical? which variables are continuous? how can you see this information when you run mpg?

head(mpg) # look at the data types
      
        # manufacturer(cat), model(cat), displ(cont), year(cont), cyl(cont), trans(cat), drv(cat), city(cont), hwy(cont), fl(cat), class(cat)

##########################################################################################################################################################

# 3. map a continuous variable to color, size, and shape. how do these aesthetics behave differently for categorical vs. continuous variables?

ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, colour = class)) +
  geom_point()

        # mapping color to a cont variable makes the color saturation vary based on value

        # mapping color to a cat variable makes the color distinct according to category values

ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()

        # mapping size to cont variables makes the size vary based on value of cont variable

        # mapping size to cat variables is not a good idea, the size shouldn't have any meaning to categories

ggplot(mpg, aes(x = displ, y = hwy, shape = cty)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

        # mapping shape to cont variables doesn't work as it shouldn't

        # mapping shape to cat variables works but can only display a max of 6

##########################################################################################################################################################
  
# 4. what happens when you map the same variable to multiple aesthetics?

ggplot(mpg, aes(x = displ, y = hwy, colour = cty, size = cty)) +
  geom_point()

        # it works but adding a second aesthetic doesn't seem to be intuitive or add meaning

ggplot(mpg, aes(x = displ, y = hwy, colour = class, shape = class)) +
  geom_point()

##########################################################################################################################################################

# 5. what does the stroke aesthetic do> what shapes does it work with?

        # stroke changes the size of the border for shapes, for shapes 21 - 25

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 24, colour = "purple", fill = "yellow", size = 3, stroke = 2)

##########################################################################################################################################################

# 6. what happens if you map an aesthetic to something other than a variable name?

ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()

        # colour equals a logical variable (taking the value of TRUE or FALSE)
        # so TRUE and FALSE are what gets mapped

##### facets #############################################################################################################################################

# facets basically splits your data into subplots, which is useful for categorical variables when you have a handful of them

# the variable you pass to facts should be discrete

# this is an alternative to mapping a 3rd variable in the aes argument

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

# for faceting your plot on two variables rather than one, use facet_grid 

# as you can see this is like adding a second y-axis and second x-axis

# but you can separate the plots based on one variable with a period, similar to facet_wrap

# you should put the variable with more unique levels in the columns 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ class)

# when you use facet_wrap with a continuous variable

# you'll create separate graphs for each observation's value for that continuous variable

# this is not ideal

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ displ, nrow = 2)

# comparing these graphs, we can see the cases where there's no observations with drv = r and a cyl = 4 in the geom_point graph, 

# so in the facet_grid that box is empty showing no observations

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

# choosing where you place the period will change the orientation of the graph for facet_grid

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

##### exercises ##########################################################################################################################################

# 1. what happens if you facet on a continuous variable?

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(. ~ cty)

        # a facet is created for each distinct value

##########################################################################################################################################################

# 2. What do the empty cells in a plot with facet_grid(drv ~ cyl) mean? how do they relate to this plot?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cty)) +
  facet_grid(drv ~ cyl)

        # when there's no observations with a combination of a drv value and cyl value, that cell facet cell will be empty 

##########################################################################################################################################################

# 3. what plots does the following code make? what does . do?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

        # the period ignores that axis so its only faceted on one axis

##########################################################################################################################################################

# 4. take the first faceted plot in this section?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~class, nrow = 2)

# what are the advantages of using facteting instead of the color aesthetic? what are disadvantages?
# how might the balance change if you have a larger dataset?

# Advantages of encoding class with facets instead of color include the ability to encode more distinct categories. 
# For me, it is difficult to distinguish between the colors of "midsize" and "minivan".

# The max number of colors to use when encoding unordered categorical (qualitative) data is nine, and in practice, often much less than that. 
# Displaying observations from different categories on different scales makes it difficult to directly compare values of observations across categories. 
# However, it can make it easier to compare the shape of the relationship between the x and y variables across categories.

# Disadvantages of encoding the class variable with facets instead of the color aesthetic 
# include the difficulty of comparing the values of observations between categories since the observations for each category are on different plots. 
# Using the same x- and y-scales for all facets makes it easier to compare values of observations across categories, 
# but it is still more difficult than if they had been displayed on the same plot. 
# Since encoding class within color also places all points on the same plot,
# it visualizes the unconditional relationship between the x and y variables; 
# with facets, the unconditional relationship is no longer visualized since the points are spread across multiple plots.

# The benefit of encoding a variable with facetting over encoding it with color increase in both the number of points and the number of categories. 
# With a large number of points, there is often overlap. It is difficult to handle overlapping points with different colors color. 
# Jittering will still work with color. 
# But jittering will only work well if there are few points and the classes do not overlap much, 
# otherwise, the colors of areas will no longer be distinct, 
# and it will be hard to pick out the patterns of different categories visually. 
# Transparency (alpha) does not work well with colors 
# since the mixing of overlapping transparent colors will no longer represent the colors of the categories. 
# Binning methods already use color to encode the density of points in the bin, so color cannot be used to encode categories.

# As the number of categories increases, the difference between colors decreases, 
# to the point that the color of categories will no longer be visually distinct.

##########################################################################################################################################################

# 5. read ?facet_wrap. what does nrow do? what does ncol do?
# what other options control the layout of the individual panels?
# why doesn’t facet_grid() have nrow and ncol variables?

        # they determine the number of rows or columns layed out by facet_wrap
      
        # because with facet_grid you have two variables, and you need x-axis and y-axis for their respective values

##########################################################################################################################################################

# 6. when using facet_grid() you should usually put the variable with more unique levels in the columns. why?

        # there will be more space if you lay out the grid horizontally not vertically

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ hwy)

##### geometric objects ##################################################################################################################################

# every geom function in ggplot2 takes a mapping argument however not every aesthetic works with every geom

# geom_smooth() creates a fitted line for to the data, shadow represents the variability on the y-axis at any given point in the x-axis

# adding an additional variable to the aesthetic can be done with linetype = , creating separate lines

# adding color makes the distinction more clear as well

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

# the group aesthetic displays multiple rows of data which can be assigned to categorical variables

# color does the same but adds separate colors, the output will default to showing a legend unless you say otherwise

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), show.legend = FALSE)

# additionally, you can display multiple geoms in the same plot by adding another geom_ function

# pass the mapping to ggplot instead of the geom to make the code more concise

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point()+
  geom_smooth()

# this allows for you to display an aesthetic for only one geom but not the other like here

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))+
  geom_smooth()

# similarly, you can specify different data for each layer, like choosing to display only a subset of the data set for one geom

# to make the graph more readable, we can choose not to display the standard error shadow

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"),se = FALSE)

##### exercises ##########################################################################################################################################

# 1. what geom would you use to draw a line chart? boxplot? histogram? area chart?

          # line chart -> geom_line()
          # box plot -> geom_boxplot()
          # histogram -> geom_histogram()
          # area chart -> geom_area()

##########################################################################################################################################################

# 2. run the code in your head and predict what the output will look like.
# then run the code in r and check your predictions

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

        # the smoother line will have different colors, separate lines for each category in colour

##########################################################################################################################################################

# 3. what does show.legend = FALSE do? what happens if you remove it?

        # specifies if you want the legend to be present
        # if a legend is needed to make sense of the graph, keep it
        # show.legend goes in the geom argument

##########################################################################################################################################################

# 4. what does the se argument to geom_smooth() do?

        # it specifies if you want a standard error shadow around the smoother line
        # the width of the shadow represents the size of the standard error

##########################################################################################################################################################

# 5. will these two graphs look different? why or why not?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

        # they'll look the same because you're mapping the same aesthetics
        # the only difference is mapping them in geom or in ggplot

##########################################################################################################################################################

# 6. recreate the r code for these graphs

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5) +
  geom_smooth(se = FALSE, color = "blue", size = 2)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5) +
  geom_smooth(se = FALSE, color = "blue", size = 2, mapping = aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5, mapping = aes(color = drv)) +
  geom_smooth(se = FALSE, size = 2, mapping = aes(color = drv, group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5, mapping = aes(color = drv)) +
  geom_smooth(se = FALSE, size = 2)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5, mapping = aes(color = drv)) +
  geom_smooth(se = FALSE, size = 2, mapping = aes(linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5, mapping = aes(color = drv))

##### statistical transformations ########################################################################################################################

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# we haven't specified a second variable, but ggplot manages to create a 2D plot, why?

# graphs like scatterplots plot the raw values of your data set

# other plots like bar charts calculate new values to the plot

# they bin your data and then plot bin counts

# the y-axis will default to a count of each distinct value of the x-axis variable

# you get the same results using the stat_count argument instead of geom_bar (geom_bar uses the stat_count function)

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

# every geom has a default stat

# you can override the default stat in favor of an explicit stat

# in this case, we change the stat from count to identity which maps the y-axis values to b instead of count of a

demo <- tribble(~ a, ~ b, "bar_1", 20, "bar_2", 30, "bar_3", 40, "bar_4", 50)

ggplot(data = demo) + 
  geom_bar(mapping = aes(x = a, y = b),stat = "identity")

# smoothers fit a model to your data and plot predictions for your model (geom_smooth)

# boxplots give a more robust summary of the distribution

# to display a barchart of proportions rather than count

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..,group = 1))

# if you don't add the group = 1 then all the values for the categorical variable cut will show up as 100%

# stat_summary() summarizes the y values for each unique x value (categorical)

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median)

# so here, the lines for each category of cut reflect where the min max and median values are

# the default geom for stat_summary is geom_pointrange () and the default stat is identity ()

# specifying stat as "summary" tells it to use mean and sd to calculate the middle and endpoints

ggplot(data = diamonds) + 
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.min = min,
    fun.max = max,
    fun = median)

# he difference between geom_bar and geom_col is the default stat

# geom_bar defaults to stat_count, while geom_col defaults to stat_identity

# meaning geom_col expects the data to contain x and y values to construct the bars

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
  geom_col(mapping = aes(x = cut, y = depth))

# geoms and stats come in pairs and are almost always used in concert, they often share similar names

# stat_smooth is used to calculate a predicted value for y

# displays the confidence interval, min value for y, max value for y, along with the standard error

##### exercises ##########################################################################################################################################

# 1. what is the default geom associated with stat_summary()
# how could you rewrite the previous plot to use that geom_function instead of the stat function

        # geom_pointrange() is associated with stat_summary()
        # the default stat is identity but you can change it to summary

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median)

##########################################################################################################################################################

# 2. how is geom_col() different than geom_bar()
      
        # geom_col()  expects an x variable and v variable - has default stat of stat_identity
        # geom_bar() the y-axis defaults to being the count of distinct categories of the x variable - default stat is stat_count

##########################################################################################################################################################

# 3. most geoms and stats come in pairs that are almost always used in concert
# make a list of all the pairs, what do they have in common?

# geom 	default stat 	shared docs

# geom_abline() 	stat_identity() 	
# geom_area() 	stat_identity() 	
# geom_bar() 	stat_count() 	x
# geom_bin2d() 	stat_bin_2d() 	x
# geom_blank() 	None 	
# geom_boxplot() 	stat_boxplot() 	x
# geom_col() 	stat_identity() 	
# geom_count() 	stat_sum() 	x
# geom_countour_filled() 	stat_countour_filled() 	x
# geom_countour() 	stat_countour() 	x
# geom_crossbar() 	stat_identity() 	
# geom_curve() 	stat_identity() 	
# geom_density_2d_filled() 	stat_density_2d_filled() 	x
# geom_density_2d() 	stat_density_2d() 	x
# geom_density() 	stat_density() 	x
# geom_dotplot() 	stat_bindot() 	x
# geom_errorbar() 	stat_identity() 	
# geom_errorbarh() 	stat_identity() 	
# geom_freqpoly() 	stat_bin() 	x
# geom_function() 	stat_function() 	x
# geom_hex() 	stat_bin_hex() 	x
# geom_histogram() 	stat_bin() 	x
# geom_hline() 	stat_identity() 	
# geom_jitter() 	stat_identity() 	
# geom_label() 	stat_identity() 	
# geom_line() 	stat_identity() 	
# geom_linerange() 	stat_identity() 	
# geom_map() 	stat_identity() 	
# geom_path() 	stat_identity() 	
# geom_point() 	stat_identity() 	
# geom_pointrange() 	stat_identity() 	
# geom_polygon() 	stat_identity() 	
# geom_qq_line() 	stat_qq_line() 	x
# geom_qq() 	stat_qq() 	x
# geom_quantile() 	stat_quantile() 	x
# geom_raster() 	stat_identity() 	
# geom_rect() 	stat_identity() 	
# geom_ribbon() 	stat_identity() 	
# geom_rug() 	stat_identity() 	
# geom_segment() 	stat_identity() 	
# geom_sf_label() 	stat_sf_coordinates() 	x
# geom_sf_text() 	stat_sf_coordinates() 	x
# geom_sf() 	stat_sf() 	x
# geom_smooth() 	stat_smooth() 	x
# geom_spoke() 	stat_identity() 	
# geom_step() 	stat_identity() 	
# geom_text() 	stat_identity() 	
# geom_tile() 	stat_identity() 	
# geom_violin() 	stat_ydensity() 	x
# geom_vline() 	stat_identity() 	

##########################################################################################################################################################

# 4. what variables does stat_smooth() compute? what parameters control its behavior?

        # it computes: y or x, ymin or xmin, ymax or xmax, se

        # parameters: method, se, na.rm, formula

##########################################################################################################################################################

# 5. in our proportion bar chart, we need to set group = 1, why?
# in other words what is the problem with these two graphs

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

        # without group = 1, assumes all groups have equal size x, 
        # the count for proportion will be within group rather than between group

##### position adjustments ###############################################################################################################################

# you can color in a bar chart by specifying the fill aesthetic, which is more useful that the color aesthetic.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

# if you use the fill aesthetic with another variable, the bars will automatically stack,

# so each colored section of a bar represents the combination of cut and clarity

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

# when you use a second variable for fill, stacking is the automatic option specified in your position argument

# however you can change the position argument to identity, dodge, or fill

# fill works like a 100% stacked chart, dodge makes separate charts for each x variable value

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "identity")

# these graphs show how position = "identity" doesn't really work for bar graphs,

# there's overlap for the stacks so the smaller values get cut out of the graph

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity))+
  geom_bar(fill = NA, position = "identity")

# position = "jitter" is extremely helpful for scatterplots

# when there are multiple observations with the same combination of x and y value, they'll look like one observation

# but if you set position to jitter, it'll add a small amount of random noise to the graph 

# this helps spread the points out slightly making them all visible

# the result is that the graph is less accurate at small scales, but at larger scales the graph reveals more observations

# the benefit of this is the graph shows where a higher concentration of observations are

ggplot(data = mpg) +
  geom_point(mapping = aes (x = cty, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes (x = cty, y = hwy), position = "jitter")

ggplot(data = mpg) +
  geom_jitter(mapping = aes (x = cty, y = hwy))

# you can control the amount of displacement of your points with width and height in the geom_jitter function

ggplot(data = mpg) +
  geom_jitter(mapping = aes (x = cty, y = hwy))

# height and width set to 0, there's no jitter, its just like a geom_point

ggplot(data = mpg) +
  geom_jitter(mapping = aes (x = cty, y = hwy), height = 0, width = 0)

ggplot(data = mpg) +
  geom_jitter(mapping = aes (x = cty, y = hwy), height = .4, width = .4)

# as you can see geom_count and geom_jitter serve similar purposes, to make the density of observations clear but through different means

ggplot(data = mpg, mapping = aes (x = cty, y = hwy, color = class)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes (x = cty, y = hwy, color = class)) +
  geom_count()

# the default position adjustment for geom_boxplot is dodge2

# which will not adjust the location of points vertically but if there's overlap of x values the graph will adjust to separate

# changing the position to "identity" makes it look like shit

ggplot(data = mpg, mapping = aes( x = drv, y = hwy, color = class)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes( x = drv, y = hwy, color = class)) +
  geom_boxplot(position = "identity")

##### exercises ##########################################################################################################################################

# 1. what is the problem with this plot? how could you improve it?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

        # there are multiple observations taking up a point space
        # so this isn't being reflected in the graph
        # use geom_jitter() or add position = "jitter" to geom_point

##########################################################################################################################################################

# 2. what parameters to geom_jitter control the amount of jittering?
    
        # width and height - they control the amount of displacement

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
  
##########################################################################################################################################################

# 3. compare and contrast geom_jitter and geom_count

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

        # they both take into account the density of variables at a position on the graph
        # jitter displaces the position of the values though
        # if you add a third variable to geom_count you may covering some values
        # but if you combine jitter and count geoms it can help

##########################################################################################################################################################

# 4. what's the default position adjustment for geom_boxplot()? create a viz of the mpg dataset to demonstrate.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, group = class)) +
  geom_boxplot()

        # dodge2 position
        # it doesn't adjust the vertical axis but slightly adjusts horizontal axis if there's interferrence
        # if you change position to identity it fucks shit up

ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot(position = "identity")

##### coordinate systems #################################################################################################################################

# probably the most complicated part of ggplot2

# the default coordinate system is the cartesian coordinate system where x and y position act independently to find the location of each point

# coord_flip() switches the x and y axis, especially useful for boxplots when flipping axis makes it more readable, and when the labels get overlapped

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()+
  coord_flip()

# coord_quickmap() sets aspect ratio correctly for maps, connection between bar charts and Coxcomb charts

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group))+
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(long, lat, group = group))+
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

ggplot(nz, aes(long, lat, group = group))+
  geom_polygon(fill = "white", color = "black") +
  coord_map()

# coord_polar() uses polar coordinates

# labs will add a label to the the x axis, y axis, title, subtitle, caption, you can leave one out with NULL

bar <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()

bar + coord_polar()

# using geom_abline and coord_fixed together is important

# the line produced will always be 45 degrees when the coordinates are fixed

# this can be used as a baseline comparison if the data points make a deceiving line

# the x-axis and y-axis will have the same interval space with coord_fixed

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline()

# to create a pie chart you can set your x values to factor(1) to place all the observations on a single bar

# specifying theta = "y" maps the angle of each section to the y values

# so the blue had a count of 25 so it corresponds to angle 0 - 25 

ggplot(data = mpg, mapping = aes(x = factor(1), fill = drv)) +
  geom_bar()

ggplot(data = mpg, mapping = aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")

##### exercises ##########################################################################################################################################

# 1. turn a stacked bar chart into a pie chart using coord_polar()

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar()

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar()

##########################################################################################################################################################

# 2. what does labs do?

        # in labs function they are used to make labels
        # x, y, title, subtitle, caption

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(y = "Highway MPG",
       x = "Class",
       title = "Highway MPG by car class",
       subtitle = "1999-2008",
       caption = "Source: http://fueleconomy.gov")
       
##########################################################################################################################################################

# 3. what's the difference between coord_quickmap() and coord_map()

        # quickmap is quicker
        # they both map based on earth coordinates
        # but coord_map accounts for the curvature of the earth
        
# 4. what does the following plot tell you about the relationship between city and highway mpg?
# why is coord_fixed important? what does geom_abline do?

p <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline()
p + coord_fixed()

        # coord_fixed is important to make y-axis and x-axis uniform space intervals
        # that way we can use our 45 degree line as an accurate reference point
        
