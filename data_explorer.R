rm(list = ls())
library(tidyverse)
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[2])
Sys.setenv(SPOTIFY_CLIENT_SECRET = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[5])

tracks <- get_my_top_artists_or_tracks(
  type = "tracks",
  limit = 50,
  offset = 0,
  time_range = "short_term",
  authorization = get_spotify_authorization_code(scope = "user-top-read"),
  include_meta_info = FALSE
)

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
