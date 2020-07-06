"======================================================================
"
" init-tabsize.vim - 大部分人对 tabsize 都有自己的设置，改这里即可
"
" Created by skywind on 2018/05/30
" Last Modified: 2018/05/30 22:05:44
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :


"----------------------------------------------------------------------
" 默认缩进模式（可以后期覆盖）
"----------------------------------------------------------------------

" 设置缩进宽度
set sw=4

" 设置 TAB 宽度
set ts=4

" 禁止展开 tab (noexpandtab)
set noet

" 如果后面设置了 expandtab 那么展开 tab 为多少字符
set softtabstop=4

" 和smarttab配合使用
set shiftwidth=4

" 行首的 <Tab> 根据 'shiftwidth' 插入空白
set smarttab

augroup PythonTab
	au!
	" 如果你需要 python 里用 tab，那么反注释下面这行字，否则vim会在打开py文件
	" 时自动设置成空格缩进。
	"au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END

if exists("g:loaded_linuxsty")
    finish
endif
let g:loaded_linuxsty = 1

set wildignore+=*.ko,*.mod.c,*.order,modules.builtin

augroup linuxsty
    autocmd!

    autocmd FileType c,cpp call s:LinuxConfigure()
    autocmd FileType diff setlocal ts=8
    autocmd FileType rst setlocal ts=8 sw=8 sts=8 noet
    autocmd FileType kconfig setlocal ts=8 sw=8 sts=8 noet
    autocmd FileType dts setlocal ts=8 sw=8 sts=8 noet
augroup END

function s:LinuxConfigure()
    let apply_style = 0

    if exists("g:linuxsty_patterns")
        let path = expand('%:p')
        for p in g:linuxsty_patterns
            if path =~ p
                let apply_style = 1
                break
            endif
        endfor
    else
        let apply_style = 1
    endif

    if apply_style
        call s:LinuxCodingStyle()
    endif
endfunction

command! LinuxCodingStyle call s:LinuxCodingStyle()

function! s:LinuxCodingStyle()
    call s:LinuxFormatting()
    call s:LinuxKeywords()
endfunction

function s:LinuxFormatting()
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal softtabstop=8
    setlocal textwidth=80
    setlocal noexpandtab

    setlocal cindent
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction

function s:LinuxKeywords()
    syn keyword cOperator likely unlikely
    syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
    syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
endfunction
