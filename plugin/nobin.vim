" Copyright (C) 2020 Xvezda <https://xvezda.com/>
"
" MIT License
"
" Use of this source code is governed by an MIT-style
" license that can be found in the LICENSE file or at
" https://opensource.org/licenses/MIT.
"
" Location:     plugin/nobin.vim
" Maintainer:   Xvezda <https://xvezda.com/>


" Source guard
if exists('g:loaded_nobin')
  finish
endif
let g:loaded_nobin = 1


function! s:every(...)
  let flag = 1
  for i in range(a:0)
    let expr = a:000[i]
    if type(expr) == type([])
      for subexpr in expr
        if !s:every(subexpr)
          let flag = 0
          break
        endif
      endfor
    elseif type(expr) == type("")
      if !eval(expr)
        let flag = 0
        break
      endif
    endif
  endfor
  return flag
endfunction


function! s:some(...)
  let flag = 0
  for i in range(a:0)
    let expr = a:000[i]
    if type(expr) == type([])
      for subexpr in expr
        if s:some(subexpr)
          let flag = 1
          break
        endif
      endfor
    elseif type(expr) == type("")
      if eval(expr)
        let flag = 1
        break
      endif
    endif
  endfor
  return flag
endfunction


function! s:silent_edit(filepath) abort
  execute 'silent! :e ' . a:filepath
endfunction


function! nobin#find_source()
  " Only if filetype is empty
  if empty(&ft)
    " Prevent double execution
    if exists('b:inited_nobin')
      return
    endif
    let b:inited_nobin = 1
    " Get fullpath of opened file
    let b:filepath = expand('%:p')
    " Get only filename from the path
    let b:filename = fnamemodify(b:filepath, ':t')
    " Pass if file not opened or not executable
    if empty(b:filepath) || !executable(b:filepath)
      return
    endif
    " On windows, executable should contains `exe` or no extension
    if has('win32') || has('win32unix') || executable('wslpath')
      if matchend(b:filename, '\.exe') == -1 && match(b:filename, '\.') != -1
        return
      endif
    endif
    " Get all filenames, which has extension
    let b:filelist = map(glob(b:filepath . '.*', 1, 1),
          \ 'fnamemodify(v:val, ":t")')

    " If there is no file with extension, then finish
    if empty(b:filelist)
      return
    endif
    let b:target_file = b:filelist[0]
    let b:target_filepath = glob(fnamemodify(b:filepath, ':h')
          \ . '/' . b:target_file)

    if !exists('g:nobin_always_yes')
      " Keep variables to restore
      let orig_shortmess = &shortmess
      set shortmess=a
      let orig_cmdheight = &cmdheight
      let &cmdheight = 2

      echo "Seems like you accidentally opened executable rather than "
            \ . "source code."
      echo "Would you like to open following file instead?"
      echo '"' . b:target_file . '" [Y/n]: '

      " Restore
      let &shortmess = orig_shortmess
      let &cmdheight = orig_cmdheight

      " Get input from user
      let select = nr2char(getchar())
      if select ==? 'Y'
        call s:silent_edit(b:target_filepath)
      endif

      " Tiny hack to clean command line
      echo ''
      redraw!
    else
      call s:silent_edit(b:target_filepath)
    endif

  endif
endfunction

call nobin#find_source()


augroup nobin_init
  autocmd!
  autocmd BufEnter * call nobin#find_source() | execute "filetype detect"
augroup END


" vim:set sts=2
