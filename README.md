# nobin.vim
[![Script manager: vishop](https://img.shields.io/badge/script%20manager-vishop-blueviolet)](https://github.com/Xvezda/vishop)

![Demo](https://gist.githubusercontent.com/Xvezda/6f3773debe7982129d789981b4d9a72e/raw/vim-nobin.gif)

I made this plugin because of auto-completion on shell environment always lead me to open a binary, not a source code.

`gcc test.c -o test`

In this case, there are two files in the same directory. `test.c` and `test`.

`vim t<Tab>`

Now, if I press tab to edit `test.c` again, `test` will appears.
I need to press tab again to make `test` to `test.c`

But most of times, I accidently open `test` binary instead.
It's way too frustrating. :(

This plugin will automatically finds original source code of executable binary, which you opened by mistake. :)

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

`Plug 'Xvezda/vim-nobin'`

or

`make install`


## Global options

| Flag                          | Description                                                                           |
|-------------------------------|----------------------------------------------------------                             |
| `g:nobin_always_yes`          | Automatically select [y]es on select screen                                           |
| `g:nobin_well_known_files`    | Regular expression list for well known binary patterns                                |
| `g:nobin_except_files`        | Exception patterns of non-binary files                                                |
## Homepage

https://github.com/Xvezda/vim-nobin


## Copyright

Copyright (C) 2020 Xvezda

MIT License

