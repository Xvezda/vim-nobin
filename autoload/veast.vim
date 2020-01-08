" Copyright (C) 2020 Xvezda <https://xvezda.com/>
"
" MIT License
"
" Use of this source code is governed by an MIT-style
" license that can be found in the LICENSE file or at
" https://opensource.org/licenses/MIT.
"
" Location:     autoload/veast.vim
" Maintainer:   Xvezda <https://xvezda.com/>


" Source guard
if exists('g:loaded_veast')
  finish
endif
let g:loaded_veast = 1


function! veast#every(...) abort
  for i in range(a:0)
    let expr = a:000[i]
    if type(expr) == type([])
      for subexpr in expr
        if !veast#every(subexpr)
          return 0
        endif
      endfor
    elseif type(expr) == type("")
      if !eval(expr)
        return 0
      endif
    elseif type(expr) == type({})
      throw 'argument `expr` cannot be dictionary type'
    else
      if !expr
        return 0
      endif
    endif
  endfor
  return 1
endfunction


function! veast#some(...) abort
  for i in range(a:0)
    let expr = a:000[i]
    if type(expr) == type([])
      for subexpr in expr
        if veast#some(subexpr)
          return 1
        endif
      endfor
    elseif type(expr) == type("")
      if eval(expr)
        return 1
      endif
    elseif type(expr) == type({})
      throw 'argument `expr` cannot be dictionary type'
    else
      if expr
        return 1
      endif
    endif
  endfor
  return 0
endfunction


function! veast#concat(list, ...) abort
  for i in range(a:0)
    let item = a:000[i]
    if type(item) == type([])
      " Alias
      let items = item
      unlet item

      for item in items
        call veast#concat(a:list, item)
      endfor
    else
      call add(a:list, item)
    endif
  endfor
endfunction


