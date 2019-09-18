install.packages('shinyHeatmaply')
library(shiny)
library(heatmaply)
# If you didn't get shinyHeatmaply yet, you can run it through github:
# runGitHub("yonicd/shinyHeatmaply",subdir = 'inst/shinyapp')
# or just use your locally installed package:
library(shinyHeatmaply)

#single data.frame
data(mtcars)
launch_heatmaply(mtcars)

#list
data(iris)
launch_heatmaply(list('Example1'=mtcars,'Example2'=iris))

runApp(system.file("shinyapp", package = "shinyHeatmaply"))