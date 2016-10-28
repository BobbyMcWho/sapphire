#Sapphire
Sapphire is/will be a general purpose "modularised" bot for discord, built with Ruby and using https://github.com/meew0/discordrb

##Info
Version = 0.3

Ruby version 2.2+ required

Audio playback works on multiple servers, but all modules affect all servers (can't have the language module loaded on just one server)

##Install/Guide
```
gem install bundler
bundler
```
Lots of audio stuff is needed for this, depends on your linux system and repo's
(No help from me for windows/mac users, sorry)
```
libsodium (python3-nacl and libsodium-dev worked for me)
libopus (libopusfile0 and libopus0 and libopusfile-dev worked for me)
ffmpeg
```
Install https://github.com/rg3/youtube-dl
```
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```
Yes, I am aware there are a few gems but I found working directly with it was so much easier


##Misc
MIT License 2016 Jos Spencer
