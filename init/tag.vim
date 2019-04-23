" 标签浏览
Plug 'majutsushi/tagbar', {'on' : ['TagbarToggle']}
" Makefile 标签扩展
Plug 'tenfyzhong/tagbar-makefile.vim', {'on' : ['TagbarToggle']}
" 提供 ctags/gtags 后台数据库自动更新功能
Plug 'ludovicchabant/vim-gutentags'
" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
Plug 'skywind3000/gutentags_plus', {'on' : ['GscopeFind']}

" gutentags 设置: {{{
"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
let g:gutentags_project_root = ['.root']
let g:gutentags_ctags_tagfile = '.tags'

" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 默认禁用自动生成
let g:gutentags_modules = []

" 如果有 ctags 可执行就允许动态生成 ctags 文件
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif

" 如果有 gtags 可执行就允许动态生成 gtags 数据库
if executable('gtags') && executable('gtags-cscope')
	let g:gutentags_modules += ['gtags_cscope']
endif

" 设置 ctags 的参数
let g:gutentags_ctags_extra_args = []
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 使用 universal-ctags 的话需要下面这行，请反注释
" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁止 gutentags 自动链接 gtags 数据库
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_plus_nomap = 1
map <C-]> :GscopeFind g <C-R><C-W><cr>

function! g:Cscope_find(type)
	if a:type ==# 'f' || a:type ==# 'i'
		let l:cfile = expand("<cfile>")
		exec ":GscopeFind ".a:type." ".l:cfile
	else
		let l:cword = expand("<cword>")
		exec ":GscopeFind ".a:type." ".l:cword
	endif
endfunction
" }}}

let tagbar_left = 1
let tagbar_width = 25
let g:tagbar_compact = 1

call LeaderMappingDef('tt', 'TagbarToggle',     '标签浏览')
call LeaderMappingDef('ms', 'Cscope_find("s")', '查找符号')
call LeaderMappingDef('mg', 'Cscope_find("g")', '查找定义')
call LeaderMappingDef('mr', 'Cscope_find("c")', '查找引用')
call LeaderMappingDef('mt', 'Cscope_find("t")', '查找字符串')
call LeaderMappingDef('me', 'Cscope_find("e")', '查找符号(egrep模式)')
call LeaderMappingDef('mf', 'Cscope_find("f")', '查找文件')
call LeaderMappingDef('mi', 'Cscope_find("i")', '查找#including')
