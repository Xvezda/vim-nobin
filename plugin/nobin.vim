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

" Include veast library
runtime! autoload/veast.vim


" Settings
if !exists('g:nobin_well_known_files')
  let g:nobin_well_known_files = ['\.exe$', '\.o$']
else
  if type(g:nobin_well_known_files) == type("")
    let g:nobin_well_known_files = add([], g:nobin_well_known_files)
  elseif type(g:nobin_well_known_files) != type([])
    throw '`g:nobin_well_known_files` must be type of `string` or `list`'
  endif
endif
let g:nobin_well_known_files = map(g:nobin_well_known_files,
      \ '"\\m\\C" . v:val')

" Helpers {{{1
function! s:getch() abort
  return nr2char(getchar())
endfunction


function! s:match_bool(haystack, needle) abort
  if match(a:haystack, a:needle) != -1
    return 1
  endif
  return 0
endfunction
" 1}}}

function! s:echo_multiline(...) abort
  " Keep variables to restore
  let orig_shortmess = &shortmess
  set shortmess=a
  let orig_cmdheight = &cmdheight
  let &cmdheight = 2

  for i in range(a:0)
    echo a:000[i]
  endfor

  " Restore
  let &shortmess = orig_shortmess
  let &cmdheight = orig_cmdheight
endfunction


function! s:silent_edit(filepath) abort
  execute 'silent! :e ' . a:filepath
endfunction


function! nobin#find_source() abort
  " Only if filetype is empty
  if empty(&ft)
    " Prevent double execution
    if exists('b:inited_nobin')
      return
    endif
    let b:inited_nobin = 1
    " Get fullpath of opened file
    let filepath = expand('%:p')
    " Get only filename from the path
    let filename = fnamemodify(filepath, ':t')
    " Pass if file not opened or not executable and not in well known list
    if empty(filepath)
          \ || (!executable(filepath)
              \ && !veast#some(map(g:nobin_well_known_files,
                                \ 's:match_bool(filename, v:val)')))
      return
    endif

    " On windows, executable should contains `exe` or no extension
    if has('win32') || has('win32unix') || executable('wslpath')
      if matchend(filename, '\.exe') == -1 && match(filename, '\.') != -1
        return
      endif
    endif

    " All possible filenames
    let fname_comb = [filename]
    " Cutoff extension
    let tmp_filename = filename
    while 1
      let tmp_filename = strpart(tmp_filename, 0, strridx(tmp_filename, '.'))
      call add(fname_comb, tmp_filename)
      if !s:match_bool(tmp_filename, '\.')
        call add(fname_comb, tmp_filename)
        break
      endif
    endwhile

    let filelist = []
    " Get all filenames, which has extension
    for fname in fname_comb
      call extend(filelist,
            \ map(glob(fnamemodify(filepath, ':h') . '/' . fname . '.*', 0, 1),
            \ 'fnamemodify(v:val, ":t")'))
    endfor

    " If there is no file with extension, then finish
    if empty(filelist)
      return
    endif

    let target_file = filelist[0]
    if filename ==? target_file
      return
    endif

    let target_filepath = glob(fnamemodify(filepath, ':h')
          \ . '/' . target_file)

    if !exists('g:nobin_always_yes')
      " Get input from user
      let select = confirm("Seems like you accidentally opened "
            \ . "executable rather than source code.\n"
            \ . "Would you like to open following file instead?\n"
            \ .'"' . target_file . '"', "&Yes\n&No", 2)
      if select == 1
        call s:silent_edit(target_filepath)
      endif

      " Tiny hack to clean command line
      echo ''
      redraw!
    else
      call s:silent_edit(target_filepath)
    endif

  endif
endfunction

call nobin#find_source()


augroup nobin_init
  autocmd!
  autocmd BufEnter * call nobin#find_source() | execute "filetype detect"
augroup END


" vim:set sts=2
