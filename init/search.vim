" 快速文件搜索
Plug 'junegunn/fzf'
" 使用 :FlyGrep 命令进行实时 grep
Plug 'wsdjeg/FlyGrep.vim', {'on' : ['FlyGrep']}
" 使用 :CtrlSF 命令进行模仿 sublime 的 grep
Plug 'dyng/ctrlsf.vim', {'on' : ['CtrlSF']}
" 模糊搜索(代替fzf)
Plug 'Yggdroot/LeaderF',  { 'do': './install.sh', 'on': [
			\'Leaderf',
			\'LeaderfFile',
			\'LeaderfMru',
			\'LeaderfFunction',
			\'LeaderfBufTag',
			\'LeaderfBuffer',
			\]}

" FlyGrep 设置
let g:spacevim_debug_level = 1
" ctrlsf 设置
let g:ctrlsf_context      = '-B 0 -A 0'
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_auto_close   = 0

" Leaderf 设置 {{{
" CTRL+p 打开文件模糊匹配
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_ShortcutB = ''
" 最大历史文件保存 2048 个
let g:Lf_MruMaxFiles = 2048

" ui 定制
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

" 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')

" 显示绝对路径
let g:Lf_ShowRelativePath = 0

" 隐藏帮助
let g:Lf_HideHelp = 1

" 模糊匹配忽略扩展名
let g:Lf_WildIgnore = {
			\ 'dir': ['.svn','.git','.hg'],
			\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
			\ }

" MRU 文件忽略扩展名
let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
let g:Lf_StlColorscheme = 'powerline'

" 禁用 function/buftag 的预览功能，可以手动用 p 预览
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

" 使用 ESC 键可以直接退出 leaderf 的 normal 模式
let g:Lf_NormalMap = {
			\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
			\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
			\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
			\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
			\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
			\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
			\ }

function! LeaderfFindFile()
 let save_iskeyword = &iskeyword
 set iskeyword-=<,>
 set iskeyword+=.
 let l:word = expand('<cword>')
 silent exec 'Leaderf file --cword'
 exec 'set iskeyword='.save_iskeyword
endfunction
"}}}

noremap <c-p> :LeaderfFile<cr>

call LeaderMappingDef('sc',  'call feedkeys(":nohlsearch\<CR>")',  '清除高亮')
LeaderMap 's/', 'FlyGrep',         '实时搜索'
LeaderMap 'sp', 'CtrlSF',          '在工程中搜索'
LeaderMap 'bl', 'LeaderfBuffer',   'buffers 列表'
LeaderMap 'sF', 'LeaderfFindFile', '搜索光标下文件'
LeaderMap 'sf', 'LeaderfFunction', '搜索function'
LeaderMap 'sm', 'LeaderfMru',      '搜索Mru'
LeaderMap 'st', 'LeaderfBufTag',   '搜索Buf tag'
