let s:script_location = fnamemodify( expand('<sfile>:p'), ':h')
" set env:
"   - PPMCK_BASEDIR 
"   - NES_INCLUDE 
" execute:
"   - ${PPMCK_BASEDIR}/bin/ppmckc -i <mml-file-path>
"   - ${PPMCK_BASEDIR}/bin/nesasm -s -raw ppmck.asm
"   - rename ppmck.nes to <mml-file-path>.nsf
"   - delte working files {define.inc, effect.h, <mml-file-name>.h}
function! s:mml_play(f) abort
  let tool_path = s:script_location . '/../tool/mknsf.bat'
  let s:mck_basedir = expand('$HOME/tools/nsf/ppmck09a/mck')
  let s:nsf2wav = expand('$HOME/tools/nsf/nsf2wav/nsf2wav')
  let $PPMCK_BASEDIR = s:mck_basedir
  let $NES_INCLUDE   = $PPMCK_BASEDIR . '/nes_include'
  let work_path = fnamemodify(a:f, ':h')
  let mml_name = fnamemodify(a:f, ':t:r')
  let l:cmd = [&shell, &shellcmdflag, tool_path, work_path, mml_name, s:nsf2wav]

  if has('nvim')
    let g:mml_play_job = jobstart(cmd, {})
  elseif v:version >= 800
    let g:mml_play_job = job_start(cmd, {
          \ 'close_cb': function('mml#_close_cb'),
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

func! mml#_close_cb(channel)
  "echom '--CLOSE--'
  "while ch_status(a:channel, {'part': 'out'}) == 'buffered'
  "  echomsg ch_read(a:channel)
  "endwhile
endfunc

function! mml#_error_cb(ch, msg) abort
  echom '--ERROR--'
  echom a:msg
endfunction

function! mml#_exit_cb(job, status) abort
  echom '--EXIT--'
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

