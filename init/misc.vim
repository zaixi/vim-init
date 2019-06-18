" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'
if !argc()
	" 展示开始画面，显示最近编辑过的文件
	Plug 'mhinz/vim-startify'
	" 默认显示 startify
	let g:startify_disable_at_vimenter = 0
	let g:startify_session_dir = '~/.vim/session'
endif
" 一次性安装一大堆 colorscheme
Plug 'flazz/vim-colorschemes'
" 支持库，给其他插件用的函数库
Plug 'xolox/vim-misc'
" vim 中文文档
Plug 'yianwillis/vimcdoc'
" 编辑数据统计
Plug 'wakatime/vim-wakatime'
"  输入法状态保存
if executable('fcitx')
  Plug 'lilydjwg/fcitx.vim', { 'on_event' : 'InsertEnter'}
endif
Plug 'lambdalisue/suda.vim'
" 在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
Plug 't9md/vim-choosewin', {'on' : ['ChooseWin', 'ChooseWinSwap']}
" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
Plug 'kshenoy/vim-signature'
" 自动设置tab
Plug 'tpope/vim-sleuth'
" markdown预览
Plug 'iamcco/markdown-preview.vim', {'on' : ['<Plug>MarkdownPreview']}

" q 智能关闭窗口: {{{
let g:smartcloseignorewin = ['__Tagbar__' , 'vimfiler:default']
let g:smartcloseignoreft  = [
			\ 'tagbar',
			\ 'nerdtree',
			\ 'ctrlsf',
			\ 'fugitive',
			\ 'vimfiler',
			\ 'defx',
			\ 'HelpDescribe',
			\ 'VebuggerShell',
			\ 'VebuggerTerminal',
			\ ]
function! WindowSmartClose() abort
  let ignorewin = get(g:,'smartcloseignorewin',[])
  let ignoreft = get(g:, 'smartcloseignoreft',[])
  let win_count = winnr('$')
  let num = win_count
  for i in range(1,win_count)
    if index(ignorewin , bufname(winbufnr(i))) != -1 ||
		\ index(ignoreft, getbufvar(bufname(winbufnr(i)),'&filetype')) != -1
      let num = num - 1
    endif
    if getbufvar(winbufnr(i),'&buftype') ==# 'quickfix'
      let num = num - 1
    endif
  endfor
  if num == 1
  else
    quit
  endif
endfunction

" }}}

nnoremap <silent> q :call WindowSmartClose()<cr>
call LeaderMappingDef('fw', ":w suda://%", '以sudo保存文件')
LeaderMap  'ww', 'ChooseWin',             '选择窗口'
LeaderMap  'wm', 'ChooseWinSwap',         '交换窗口'
LeaderMap  'wd', '<c-w>c',                '删除窗口'
LeaderMap  'lp', '<Plug>MarkdownPreview', 'Markdown预览'
LeaderName 'mm', '+标签'
call LeaderMappingDef('mma', 'm.',  '添加标签')
call LeaderMappingDef('mmd', 'm\<space>',  '删除所有标签')
call LeaderMappingDef('mmn', ']`',  '上一个标签')
call LeaderMappingDef('mmp', '[`',  '下一个标签')
call LeaderMappingDef('mm-', 'm\-', '删除当前行标签')
call LeaderMappingDef('mm/', 'm/', '标签列表')
