# This file contains all the plotting functions developed for the Flomvarsling shiny app

#' Function for single station and single model plots. Used in the server module "forecast_plot_mod"
#' @param dat 
#' @importFrom plotly ggplotly
#' @import ggplot2
#' @return
#' @export
#'
#' @examples In "forecast_plot_mod"
#' output$plot <- renderPlotly(forecast_plot(subset_OBS(), subset2plot())
forecast_plot <- function(OBS, dat) {
  
  dat$time <- as.Date(dat$time)


  d <- ggplot() + scale_colour_manual(
    values = c("Obs" = "black", 
               "HBV.UM.sim" = "cyan3", "HBV.UM.korr" = "cyan4", "Lo50" = "cyan", "Lo90" = "cyan", "Hi50" = "cyan", "Hi90" = "cyan",
               "HBV.UM.Snow" = "cyan4",
               "HBV.P.sim" = "blue3", "HBV.P.korr" = "blue4", "P.m50" = "blue", "P.p50" = "blue",
               "HBV.P.Snow" = "blue4",
               "DDD.sim" = "orange",
               "ODM.sim" = "red",
               "DDD.Snow" = "purple4", "DDD.GW" = "sienna", "DDD.Soil" = "green",
               "mean" = "yellow", "5Y" = "orange", "50Y" = "red",
               "HBV.UM.sim.med.obsMet" = "cyan3",
               "Temp" = "red", "Precip" = "gray75"
               
    )) 
  
  d <- d + scale_linetype_manual( 
    values = c("Obs" = "solid", 
               "HBV.UM.sim" = "F1", "HBV.UM.korr" = "solid", "Lo50" = "dashed", "Lo90" = "dotted",  "Hi50" = "dashed",  "Hi90" = "dotted",
               "HBV.UM.Snow" = "twodash",
               "HBV.P.sim" = "twodash", "HBV.P.korr" = "solid", "P.m50" = "dashed", "P.p50" = "dashed",
               "HBV.P.Snow" = "dotted",
               "DDD.sim" = "solid",
               "DDD.Snow" = "solid", "DDD.GW" = "solid", "DDD.Soil" = "solid",
               "ODM.sim" = "solid",
               "mean" = "dotdash", "5Y" = "dotdash", "50Y" = "dotdash",
               "HBV.UM.sim.med.obsMet" = "dotted",
               "Temp" = "solid", "Precip" = "solid"
               
    ))
  # d <- d + scale_shape_manual(
  #   values = c("Obs" = 46,
  #              "HBV.UM.sim" = 46, "HBV.UM.korr" = 46, "Lo50" = 46, "Lo90" = 46,  "Hi50" = 46,  "Hi90" = 46,
  #              "HBV.UM.Snow" = 1,
  #              "HBV.P.sim" = 46, "HBV.P.korr" = 46, "P.m50" = 46, "P.p50" = 46,
  #              "HBV.P.Snow" = 2,
  #              "DDD.sim" = 46,
  #              "DDD.Snow" = 3, "DDD.GW" = 46, "DDD.Soil" = 46,
  #              "mean" = 46, "5Y" = 46, "50Y" = 46,
  #              "HBV.UM.sim.med.obsMet" = 46,
  #              "Temp" = 46, "Precip" = 46
  #              
  # ))
  
  # levels(as.factor(dat$Type)) <- c("Input (mm or degree celcius)", "Runoff (m3/s)", "State (m)")
  
  precip_subset <- subset(dat, Variable == "Precip")
  
  d <- d +
    geom_bar(data = precip_subset, aes(x = time, y = Values, col = Variable, linetype = Variable), stat="identity", width = 0.4, fill = "gray75") +
    geom_line(data = subset(dat, Variable != "Precip"), aes(x = time, y = Values, col = Variable, linetype = Variable)) +
    
    geom_line(data = OBS, aes(x = time, y = Values, col = Variable, linetype = Variable)) +
    
    facet_grid(Type ~ ., scales = "free_y") +
    
    theme_bw() +
    scale_x_date(date_breaks = "2 day", date_labels = "%m %d")

  return(ggplotly(d))
}

#' Function for multistation and multimodel plots. Used in the server module "multimod_forecast_plot_mod"
#' @param dat_1 
#' @param dat_2 
#' @param dat_3 
#' @param dat_4 
#' @param return_levels 
#' @param gg_plot 
#' @importFrom plotly ggplotly
#' @import ggplot2
#' @return
#' @export
#'
#' @examples In multimod_forecast_plot_mod
#' output$plot <- renderPlotly(multimod_forecast_plot(subset2plot_OBS(), subset2plot_m1(), subset2plot_m2(), 
#' subset2plot_m3(), subset2plot_m4(), subset2plot_rl()))
multimod_forecast_plot <- function(obs_data = NULL, dat_1 = NULL, dat_2 = NULL, dat_3 = NULL, dat_4 = NULL, dat_5 = NULL, return_levels = NULL, gg_plot = FALSE) {
  
  ## NOTE: ODM will have the same line as DDD with the following code
  d <- ggplot() + scale_colour_manual(
    values = c("Obs" = "black", 
               "HBV.UM.sim" = "cyan3", "HBV.UM.korr" = "cyan4", "Lo50" = "cyan", "Lo90" = "cyan", "Hi50" = "cyan", "Hi90" = "cyan",
               "HBV.UM.Snow" = "cyan4",
               "HBV.P.sim" = "blue3", "HBV.P.korr" = "blue4", "P.m50" = "blue", "P.p50" = "blue",
               "HBV.P.Snow" = "blue4",
               "DDD.sim" = "orange",
               "ODM.sim" = "red",
               "DDD.Snow" = "purple4", "DDD.GW" = "sienna", "DDD.Soil" = "green",
               "mean" = "yellow", "5Y" = "orange", "50Y" = "red",
               "HBV.UM.sim.med.obsMet" = "cyan3",
               "Temp" = "red", "Precip" = "gray75")) 
  
  d <- d + scale_linetype_manual( 
    values = c("Obs" = "solid", 
               "HBV.UM.sim" = "F1", "HBV.UM.korr" = "solid", "Lo50" = "dashed", "Lo90" = "dotted",  "Hi50" = "dashed",  "Hi90" = "dotted",
               "HBV.UM.Snow" = "twodash",
               "HBV.P.sim" = "twodash", "HBV.P.korr" = "solid", "P.m50" = "dashed", "P.p50" = "dashed",
               "HBV.P.Snow" = "dotted",
               "DDD.sim" = "solid",
               "ODM.sim" = "solid",
               "DDD.Snow" = "solid", "DDD.GW" = "solid", "DDD.Soil" = "solid",
               "mean" = "dotdash", "5Y" = "dotdash", "50Y" = "dotdash",
               "HBV.UM.sim.med.obsMet" = "dotted",
               "Temp" = "solid", "Precip" = "solid"))
  
    
  p <- 0
  # We check every that each dataset is not an empty data frame.
  if (is.null(obs_data) == FALSE && is.data.frame(obs_data) && nrow(obs_data) > 0) {
    obs_data$time <- as.Date(obs_data$time)
    d <- d + geom_line(data = obs_data, aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  # Model 2 before to have light blue second
  if (is.null(dat_2) == FALSE && is.data.frame(dat_2) && nrow(dat_2) > 0) {
    dat_2$time <- as.Date(dat_2$time)
    d <- d + geom_line(data = dat_2, aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  if (is.null(dat_1) == FALSE && is.data.frame(dat_1) && nrow(dat_1) > 0) {
    dat_1$time <- as.Date(dat_1$time)
    
    precip_subset <- subset(dat_1, Variable == "Precip")
   if (is.data.frame(precip_subset) && nrow(precip_subset) > 0) { 
    d <- d + geom_bar(data = precip_subset, aes(x = time, y = Values, col = Variable, linetype = Variable), stat="identity", width = 0.4, fill = "gray75")
   }
    d <- d + geom_line(data = subset(dat_1, Variable != "Precip"), aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  if (is.null(dat_3) == FALSE && is.data.frame(dat_3) && nrow(dat_3) > 0) {
    dat_3$time <- as.Date(dat_3$time)
    d <- d + geom_line(data = dat_3, aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  if (is.null(dat_4) == FALSE && is.data.frame(dat_4) && nrow(dat_4) > 0) {
    dat_4$time <- as.Date(dat_4$time)
    d <- d + geom_line(data = dat_4, aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  if (is.null(dat_5) == FALSE && is.data.frame(dat_5) && nrow(dat_5) > 0) {
    dat_5$time <- as.Date(dat_5$time)
    d <- d + geom_line(data = dat_5, aes(x = time, y = Values, col = Variable, linetype = Variable))
    p <- 1
  }
  
  if (is.null(return_levels) == FALSE && is.data.frame(return_levels) && nrow(return_levels) > 0) {
    print("return_levels")
        print(return_levels)
    d <- d + 
      geom_hline(data = return_levels, aes(yintercept = Values, col = Variable, linetype = Variable))
    p <- 1
  }

## This below was to highlight the difference between past and forecast
#   today <- Sys.Date()
#   today <- which(dat_1$time == today)
#   print("today")
#   print(today)
#   d <- d + geom_vline(xintercept = today, linetype="dashed", 
#                       color = "blue", size=1)
  if (p == 1) {
    d <- d +
      facet_grid(nbname ~ . , scales = "free") +
      theme_bw() + 
      scale_x_date(date_breaks = "2 day", date_labels = "%m %d") +
      theme(axis.title.x = element_blank()) +   # Remove x-axis label
      ylab("Runoff (m3/s)")                       # Set y-axis label
    ## This below was to try to fix the ylabel cosmetic problem. Did not work
      # theme(axis.text.x = element_text(angle = 90, size = 12) ) # plot.margin = unit(c(10,0,0,0),"mm")
      # theme(plot.margin=unit(c(0,0,0,0),"mm")) 
      
  }

## This below was to try to fix the ylabel cosmetic problem. Did not work
  # l <- plotly_build(d)  # %>%  layout(margin = list(l=100)) 
  # l$layout$margin$l <- l$layout$margin$l + 100
  
  if (gg_plot == TRUE) {
    return(d)
  } else {
    return(ggplotly(d))  
  }
}

