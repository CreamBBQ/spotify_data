rm(list = ls())
library(tidyverse)
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[2])
Sys.setenv(SPOTIFY_CLIENT_SECRET = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[5])

fecha_yyyymm <- "202405"

################################# TOP SONGS ####################################

tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  limit = 10,
  offset = 0,
  time_range = "short_term",
  authorization = get_spotify_authorization_code(scope = "user-top-read"),
  include_meta_info = FALSE
)

process_element <- function(element) {
  names <- element$name
  if(length(names) > 1) {
    paste(names, collapse = " - ")
  } else {
    names
  }
}

tracks <- tracks %>% 
  select(id, name, artists) %>% 
  mutate(rank = seq(1:10), 
         artists = sapply(artists, process_element))

tracks <- tracks %>% 
  merge(., 
        get_track_audio_features(.[["id"]], authorization = get_spotify_access_token()) %>% 
          select(acousticness, danceability, energy, valence, id)) %>% 
  arrange(., rank)

write.csv(tracks, 
          file = paste("C:/Users/guill/Desktop/2024/Second Brain/Métricas/Spotify/Top canciones/", fecha_yyyymm, ".csv", sep = ""), 
          row.names = FALSE)

############################# RECOMENDATIONS ####################################

recommendations <- get_recommendations_all(tracks$id, valence = NULL) %>% 
  select(name, artists, id) %>% 
  mutate(artists = sapply(artists, process_element))

write.csv(recommendations, 
          file = paste("C:/Users/guill/Desktop/2024/Second Brain/Métricas/Spotify/Recomendaciones/", fecha_yyyymm, ".csv", sep = ""), 
          row.names = FALSE)

############################### ARTISTS ########################################


artists <- get_my_top_artists_or_tracks(
  type = "artists",
  limit = 10,
  offset = 0,
  time_range = "short_term",
  authorization = get_spotify_authorization_code(scope = "user-top-read"),
  include_meta_info = FALSE
)

artists <- artists %>% 
  select(id, name, images) %>% 
  mutate(rank = seq(1:10), 
         images = sapply(images, function(x) x[[2]])[1, ])

write.csv(artists, 
          file = paste("C:/Users/guill/Desktop/2024/Second Brain/Métricas/Spotify/Top artistas/", fecha_yyyymm, ".csv", sep = ""), 
          row.names = FALSE)