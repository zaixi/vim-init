" 异步执行
Plug 'skywind3000/asyncrun.vim', {'on_cmd': 'AsyncRun'}
" 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
" 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
Plug 'mh21/errormarker.vim', {'on' : ['RemoveErrorMarkers']}
" 使用 <space>ha 清除 errormarker 标注的错误
"noremap <silent><space>ha :RemoveErrorMarkers<cr>

" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
Plug 'skywind3000/vim-preview', {'on' : [
			\'PreviewQuickfix',
			\'PreviewClose',
			\'PreviewScroll',
			\'PreviewScroll',
			\]}

" vim-preview 设置: {{{
" 搜索后将焦点更改为quickfix窗口
let g:gutentags_plus_switch = 1
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
autocmd FileType qf nnoremap <silent><buffer> q :cclose<cr>
autocmd FileType qf nnoremap <silent><buffer> <c-u> :PreviewScroll -1<cr>
autocmd FileType qf nnoremap <silent><buffer> <c-d> :PreviewScroll +1<cr>
" 自动打开 quickfix window ，高度为 8
let g:asyncrun_open = 8
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1
" }}}

LeaderMap  'qn', 'cnext', '下一个错误'
LeaderMap  'qp', 'cprev', '上一个错误'
LeaderMap  'ql', 'clist', '错误列表'
call LeaderMappingDef('qr',  'call feedkeys(":AsyncRun ")',  '异步运行')
call LeaderMappingDef('qq',  ":call asyncrun#quickfix_toggle(8)",  '打开/关闭 quickfix')
