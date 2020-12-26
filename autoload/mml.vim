function! s:mml_play(f) abort
  let cmd = [&shell, &shellcmdflag, "go-mml", "-m", g:mml#ppmck_location, "-n", g:mml#nsf2wav_command, "-f", a:f]
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
  "while ch_status(a:channel, {'part': 'err'}) == 'buffered'
  "  echom ch_read(a:channel)
  "endwhile
  "while ch_status(a:channel, {'part': 'out'}) == 'buffered'
  "  echom ch_read(a:channel)
  "endwhile
endfunc

function! mml#_error_cb(ch, msg) abort
  echom '--ERROR--'
  echom a:msg
endfunction

function! mml#_exit_cb(job, status) abort
  "echom '--EXIT--'
  if exists('g:mml_play_job')
    unlet g:mml_play_job
  endif
  call job_stop(a:job)
endfunction

function! mml#play(...) abort
  if exists('g:mml_play_job')
     call job_stop(g:mml_play_job)
     while exists('g:mml_play_job')
        sleep 100m
     endwhile
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

function! mml#start() abort
  autocmd! BufWritePost *.mml silent! call mml#play(expand('%:p'))
endfunction

function! mml#stop() abort
  if exists('g:mml_play_job')
     call job_stop(g:mml_play_job)
     while exists('g:mml_play_job')
        sleep 100m
     endwhile
  endif
endfunction
