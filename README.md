# Project
Project for INFO201-SP19 Group 26


### Authors
- Khoa Luong
- Matthew McNeil
- Saatvik Arya
- Sherry Wenyi Zhang


# [Final Report Link Here](https://khoa-nguyen-luong.shinyapps.io/project/) 


### Project Description
- Our group uses the Washington State's dataset for occupation by region (2018)
from [database](data.wa.gov) provided by **U.S. Bureau of Labor Statistics**.
Our group is working with data that estimates occupational employment and wages in Washington State in 2018. The data records the occupation title along with the mean hourly and yearly wages, as well as 25th, 50th and 75th percentile hourly wages. The data was collected from a survey of 4,800 state employers, collecting information on over 800 occupations with a total sample size of 29,300 employees.

- The data includes employment and wage figures for different regions as well as Washington as a whole. We hope visualizing this data will provide current and graduating college students with valuable information on prospective fields of employment while also providing insight into the diverse economy of Washington State.

- Through our project, we want the audience to gain **insight** into
  1. Which area in Washington has the highest average hourly income?
  2. Which occupations have the highest average hourly incomes?
  3. Which occupation is most popular in each region?
  4. Which area(s) have the most variability in hourly incomes?
  5. Do metropolitan areas have higher wages than non-metropolitan areas?


### Technical Analysis
**Data**
The data we used from the [Washington government](data.wa.gov) can be accessed as a `.json` file that is publicly available. It is also available through a `R` package called `RSocrata`. We also conducted conversions for the
dataset to be in `.csv` files that are acceptable by `R`.


**Data Wrangling**


**Libraries**
We used libraries like `dplyr` and `tidyr` to reshape the datasets. In order to
create visualization, we used `usmap`, `ggplot2` and `plotly`to better combine with
`Shiny`.


**Challenges**
We had difficulty labelling the map with county names. We found a package that allowed us
to solve this issue.
