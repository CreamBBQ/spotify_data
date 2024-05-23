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
         artists = sapply(artists, process_element), 
         date = fecha_yyyymm)

tracks <- tracks %>% 
  merge(., 
        get_track_audio_features(.[["id"]], authorization = get_spotify_access_token()) %>% 
          select(acousticness, danceability, energy, valence, id)) %>% 
  arrange(., rank)


############################# RECOMENDATIONS ####################################

get_recommendations_all(tracks$id, valence = NULL) %>% 
  select(name, artists, id) %>% 
  mutate(artists = sapply(artists, process_element))

########################################################################################


artist_top <- get_my_top_artists_or_tracks(
  type = "artists",
  limit = 50,
  offset = 0,
  time_range = "short_term",
  authorization = get_spotify_authorization_code(scope = "user-top-read"),
  include_meta_info = FALSE
)


################################################################################
ye <- get_artist_audio_features("kanye west")
ye %>% 
  filter(album_name == "ye") %>% 
  select(artist_name, album_name, album_release_date, track_name, 
         danceability, energy, loudness, speechiness, acousticness, valence)
