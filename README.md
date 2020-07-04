# nobin.vim

![Demo](https://gist.githubusercontent.com/Xvezda/ee6613c4ae2ce743b445f2cfc6e837b2/raw/17ceb993c092c12207d0a0f12a62ad763723af61/vim-nobin.gif)

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
| `g:nobin_accept_trailing_dot` | Accept trailing dot file name (Useful when you type and tab completion including dot) |
| `g:nobin_except_files`        | Exception patterns of non-binary files                                                |
## Homepage

https://github.com/Xvezda/vim-nobin


## Copyright

Copyright (C) 2020 Xvezda

MIT License

