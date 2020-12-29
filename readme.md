# Play MML file

## setup

1. environment
   1. refer to https://github.com/datsuns/go-mml
   1. `Plug datsuns/vim-mml-play, { 'for': 'mml' }`
1. config
   * g:mml#ppmck_location
      * [MUST] path to root directory of ppmck. (see. http://ppmck.web.fc2.com/ppmck.html)
   * g:mml#lame_command
      * [optional] path to lame command.
      * play sound by mp3 format if this command specified

## usage

* open mml file
* `:PlayMml` to play mml file
* `:StopMml` to stop playing
* `PlayMmlAuto` start auto playing when file saved.
