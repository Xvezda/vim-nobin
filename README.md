# nobin.vim
I made this plugin because of auto-completion on shell environment always lead me to open a binary, not a source code.

`gcc test.c -o test`

In this case, is two files in same directory. `test.c` and `test`.

`vim t<Tab>`

Now, if I press tab to edit `test.c` again, `test` will appears.
I need to press tab again to make `test` to `test.c`

But most of times, I accidently open `test` binary instead.
It's way too frustrating. :(

This plugin will find original source code of executable binary, which you opened by mistake. :)

