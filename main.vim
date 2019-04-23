" 防止重复加载
if get(s:, 'loaded', 0) != 0
	finish
else
	let s:loaded = 1
endif

" 取得本文件所在的目录
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 将 vim-init 目录加入 runtimepath
exec 'set rtp+='.s:home

"----------------------------------------------------------------------
" 模块加载
"----------------------------------------------------------------------
call Layer#Init(s:home."/init")
LeaderName 'x', '+文本'
LeaderName 't', '+切换'
LeaderName 'g', '+版本控制'
LeaderName 'f', '+文件'
LeaderName 's', '+搜索'
LeaderName 'b', '+缓冲区'
LeaderName 'q', '+quickfix/quit'
LeaderName 'j', '+跳转'
LeaderName 'w', '+窗口'
LeaderName 'm', '+标签'
LeaderName 'l', '+语言'

if !exists('s:layer_group')
	let s:layer_group = ['example', 'init-basic', 'init-config', 'init-tabsize', 'init-style']
	let s:layer_group += ['edit', 'ui', 'syntax', 'misc']
	let s:layer_group += ['autocomplete', 'git', 'tag', 'syntax-checking']
	let s:layer_group += ['search', 'quickfix']
	let s:layer_group += ['init-keymaps']
	if has('nvim') == 1
		let s:layer_group += ['neovim']
	endif
endif

for layer in s:layer_group
	Layer layer
endfor

call Layer#Load()
