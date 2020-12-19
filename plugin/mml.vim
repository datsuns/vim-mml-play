if exists('g:loaded_vim_mml_auto')
  finish
else
  let g:loaded_vim_mml_auto=1
endif

if !exists('g:nsf2wav_command')
  let g:nsf2wav_command='nsf2wav'
endif

command! -nargs=* StartAutoMmlPlay call mml#start(<f-args>)
command! -nargs=? PlayMml call mml#play(<f-args>)
command! StopMml call mml#stop()



