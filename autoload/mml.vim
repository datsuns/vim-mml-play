" set env:
"   - PPMCK_BASEDIR 
"   - NES_INCLUDE 
" execute:
"   - ${PPMCK_BASEDIR}/bin/ppmckc -i <mml-file-path>
"   - ${PPMCK_BASEDIR}/bin/nesasm -s -raw ppmck.asm
"   - rename ppmck.nes to <mml-file-path>.nsf
"   - delte working files {define.inc, effect.h, <mml-file-name>.h}
function! s:mml_play(f) abort
  let s:dest = tempname() . '.wav'
  "let s:dest = 'tmp.wav'
  let l:cmd = [&shell, &shellcmdflag, '/D', g:mml_ppmck_dir . '/songs', g:mml_nsf2wav_command, a:f, s:dest]
  let l:cmd = [&shell, &shellcmdflag, g:mml_nsf2wav_command, a:f, s:dest]
  echom l:cmd

  if has('nvim')
    let g:mml_play_job = jobstart(cmd, {})
  elseif v:version >= 800
    let g:mml_play_job = job_start(cmd, {
          \ 'err_cb': function('mml#_error_cb'),
          \ 'exit_cb': function('mml#_exit_cb')
          \ })
    if job_status(g:mml_play_job) == 'fail'
      echo 'Starting job failed'
      unlet g:mml_play_job
    endif
  else
    echoerr 'does not support jobs'
  endif
endfunction

function! mml#_error_cb(ch, msg) abort
  echom a:msg
endfunction

function! mml#_exit_cb(job, status) abort
  if exists('g:mml_play_job')
    unlet g:mml_play_job
  endif
  call job_stop(a:job)
endfunction

function! mml#play(...) abort
  if exists('g:mml_play_job')
    echoerr 'process is running.'
    return 0
  endif

  if a:0 >= 1
    let l:fname = a:1
  else
    let l:fname = expand('%:p')
  endif
  echom l:fname
  call s:mml_play(l:fname)
  return
endfunction

