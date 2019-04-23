set nocompatible
let mapleader = ";"
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exec 'set rtp+='.s:home

call plug#begin("~/.cache/vimfiles/")
Plug 'liuchengxu/vim-which-key'
call plug#end()
