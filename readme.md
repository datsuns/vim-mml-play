# Play MML file

## setup

1. environment
   1. refer to https://github.com/datsuns/go-mml
   1. `Plug datsuns/vim-mml-play, { 'for': 'mml' }`
1. config
   * g:mml#ppmck_location
      * path to root directory of ppmck. (see. http://ppmck.web.fc2.com/ppmck.html)
   * g:mml#nsf2wav_command 
      * path to nsf2wav command. (see. https://github.com/datsuns/nsf2wav)

## usage

* open mml file
* `:PlayMml` to play mml file
* `:StopMml` to stop playing
* `PlayMmlAuto` start auto playing when file saved.