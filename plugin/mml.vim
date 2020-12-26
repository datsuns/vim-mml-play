if exists('g:loaded_vim_mml_auto')
  finish
else
  let g:loaded_vim_mml_auto=1
endif

if !exists('g:mml#nsf2wav_command')
  let g:mml#nsf2wav_command='nsf2wav'
endif

if !exists('g:mml#ppmck_location')
  let g:mml#ppmck_location=''
endif

command! PlayMmlAuto call mml#start()
command! -nargs=? PlayMml call mml#play(<f-args>)
command! StopMml call mml#stop()


