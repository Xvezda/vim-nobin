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
" Last Change:	2020 Jan 11


" Source guard
if exists('g:loaded_veast')
  finish
endif
let g:loaded_veast = 1


function! s:is_list(expr) abort
  return type(a:expr) == type([])
endfunction


function! s:is_dict(expr) abort
  return type(a:expr) == type({})
endfunction


function! s:is_str(expr) abort
  return type(a:expr) == type("")
endfunction


function! s:is_func(expr) abort
  return type(a:expr) == type(function("tr"))
endfunction


function! s:iter(expr) abort
  if s:is_list(a:expr)
    return a:expr
  elseif s:is_dict(a:expr)
    return values(a:expr)
  elseif s:is_str(a:expr)
    return split(a:expr, '\zs')
  endif
  throw 'argument `expr` is not iterable type'
endfunction


function! veast#every(...) abort
  for i in range(a:0)
    let expr = a:000[i]
    if s:is_list(expr)
      for subexpr in expr
        if !veast#every(subexpr)
          return 0
        endif
      endfor
    elseif s:is_str(expr)
      if !eval(expr)
        return 0
      endif
    elseif s:is_dict(expr)
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
    if s:is_list(expr)
      for subexpr in expr
        if veast#some(subexpr)
          return 1
        endif
      endfor
    elseif s:is_str(expr)
      if eval(expr)
        return 1
      endif
    elseif s:is_dict(expr)
      throw 'argument `expr` cannot be dictionary type'
    else
      if expr
        return 1
      endif
    endif
  endfor
  return 0
endfunction


function! veast#each(iter, expr) abort
  let ret = []

  for val in s:iter(a:iter)
    call add(ret, eval(a:expr))
  endfor

  return ret
endfunction


function! veast#chunk(arr, ...) abort
  let ret = []
  " a:0 -> Number of va_args
  if a:0 == 1
    let size = a:000[0]  " a:000 -> va_args only"
  else
    let size = 1
  endif

  let tmp = []
  let size_cpy = size

  for item in s:iter(a:arr)
    if size_cpy > 0
      call add(tmp, item)
    else
      call add(ret, tmp)
      let tmp = [item]
      let size_cpy = size
    endif
    let size_cpy -= 1
  endfor
  if !empty(tmp)
    call add(ret, tmp)
  endif
  return ret
endfunction


function! veast#compact(arr) abort
  if s:is_list(a:arr)
    let ret = []
    for item in a:arr
      let flag = 0
      if s:is_str(item) && strlen(item)
        let flag = 1
      elseif (s:is_list(item) || s:is_dict(item)) && len(item)
        let flag = 1
      elseif item
        let flag = 1
      endif

      if flag
        call add(ret, item)
      endif
    endfor
    return ret
  else
    throw 'argument `arr` must be type of list'
  endif
endfunction


function! veast#diff(a, b) abort
  let a_cpy = deepcopy(a:a)
  for b_item in s:iter(a:b)
    let idx = index(a_cpy, b_item)
    if idx == -1
      continue
    endif
    call remove(a_cpy, idx)
  endfor
  return a_cpy
endfunction


function! veast#concat(...) abort
  let ret = []
  for i in range(a:0)
    let item = a:000[i]
    if type(item) == type([])
      " Alias
      let items = item
      unlet item

      for item in items
        call add(ret, item)
      endfor
    else
      call add(ret, item)
    endif
  endfor
  return ret
endfunction


function! veast#drop(arr, ...) abort
  if a:0 == 1
    let cnt = a:000[0]
  else
    let cnt = 1
  endif
  let cpy = deepcopy(a:arr)
  for _ in range(cnt)
    if empty(cpy)
      break
    endif
    call remove(cpy, 0)
  endfor
  return cpy
endfunction

" vim:sts=2
