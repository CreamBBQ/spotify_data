rm(list = ls())
library(tidyverse)
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[2])
Sys.setenv(SPOTIFY_CLIENT_SECRET = 
             readLines("C:/Users/guill/Documents/projects/credentials/spotify.txt")[5])
access_token <- get_spotify_access_token()

ye <- get_artist_audio_features("kanye west")

deva <- get_artist_audio_features("DEVA")

ye %>% 
  filter(album_name == "ye") %>% 
  select(artist_name, album_name, album_release_date, track_name, 
         danceability, energy, loudness, speechiness, acousticness, valence)

ye %>% 
  arrange(valence) %>% 
  select(artist_name, album_name, album_release_date, track_name, 
         danceability, energy, loudness, speechiness, acousticness, valence) %>% 
  head(10)
  
bmth <- get_artist_audio_features("Bring Me The Horizon") 
bmth %>% arrange(-danceability) %>% 
  filter(album_name == "amo") %>% 
  select(artist_name, album_name, track_name, danceability, valence) %>% 
  head(20)


ysy <- get_artist_audio_features("YSY A") 
ysy %>% arrange(-valence) %>% 
  select(artist_name, album_name, track_name, danceability, valence) %>% 
  head(20)


################################################################################
