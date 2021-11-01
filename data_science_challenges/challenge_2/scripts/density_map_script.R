microplastic_density_map <- ggplot(
  # define main data source
  data = microplastics_reduced,
  inherit.aes = FALSE,
  aes(
    x = dec_long_retrieve,
    y = dec_lat_retrieve,
    size = sum_micro_m3
  )
) +
  # first: draw the relief
  geom_raster(
    data = relief,
    inherit.aes = FALSE,
    mapping = aes(
      x = x,
      y = y,
      alpha = 1
    )
  ) +
  # remove legend   
  guide = none + 
    # use the Viridis color scale
    scale_fill_viridis(
      # make fill a bit brighter
      alpha = 0.8, 
      # truncate color scale
      begin = 0.1, 
      end = 0.9,    
      # generate plot-computed discrete scale
      discrete = T, 
      # dark is highest concentration, yellow is lowest
      direction = -1, 
      # set color map option to "plasma"
      option = "C",
      guide_legend(
        title.position = "top",
        keyheight = unit(5, units = "mm"),
        # display highest microplastic density on top
        reverse = FALSE 
      )) +
    # add titles
    labs(x = NULL,
         y = NULL,
         title = "Microplastic Distribution in Scottish Seas",
         subtitle = "Yearly Microplastic Distribution in Scottish Seas, 20__") +
    # add theme
    map_theme()
  