" 高亮#if #endif 对
Plug 'andymass/vim-matchup'
" 缩进线
Plug 'Yggdroot/indentLine'
" 一次性安装一大堆 colorscheme
Plug 'flazz/vim-colorschemes'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
" 状态栏
Plug 'vim-airline/vim-airline'
" 状态栏主题
Plug 'vim-airline/vim-airline-themes'
" 目录树
Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
" tmux <-> vim 切换
Plug 'christoomey/vim-tmux-navigator'

function! Layer_ui_after_config() abort
  " 设置颜色主题，会在所有 runtimepaths 的 colors 目录寻找同名配置
  "color desert256
  let g:rehash256 = 1
  " colorscheme molokai
  " colorscheme onedark
  " colorscheme one
  colorscheme solarized8_dark

  " <c-left> <c-down> <c-up> <c-right> tmux <-> vim 切换
  nnoremap <silent> <c-left> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-down> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-up> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-right> :TmuxNavigateRight<cr>
endfunction

" vim-matchup 设置
let g:matchup_matchparen_status_offscreen = 0

" indentLine 设置
let g:indentLine_enabled = 1
let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude = ['help', 'man', 'startify', 'vimfiler']
let g:indentLine_color_term=239
let g:indentLine_concealcursor = 'niv'

" {{{ 切换鼠标复制
function! ToggleMouseCopy() abort
  let s:copy_enable = get(s:,'copy_enable', 1)
  if s:copy_enable
    let s:copy_enable = 0
    let s:number = &number
    let s:signcolumn = &signcolumn
    let s:list = &list
    let s:wrap = &wrap
    let s:indentLine_char = g:indentLine_char
    set signcolumn=no
    set nonumber
    set nolist
    set wrap
    let g:indentLine_char = ''
    IndentLinesReset
  else
    let s:copy_enable = 1
    let &number = s:number
    let &signcolumn = s:signcolumn
    let &list = s:list
    let g:indentLine_char = s:indentLine_char
    let &wrap = s:wrap
    IndentLinesReset
  endif
endfunction
" }}}


LeaderName 'th', '切换高亮'
call LeaderMappingDef('thh', ':set cursorline!', '切换行高亮')
call LeaderMappingDef('thc', ':set cursorcolumn!', '切换列高亮')
call LeaderMappingDef('thi', 'IndentLinesToggle', '切换缩进高亮')
call LeaderMappingDef('thn', ':set number!', '关闭/显示行号')
call LeaderMappingDef('thr', ':set relativenumber!', '切换相对行号')
call LeaderMappingDef('tl',  ':set list!', '切换隐藏的字符')
call LeaderMappingDef('tc',  function('ToggleMouseCopy'),  '切换鼠标粘贴')

" {{{ airline 设置
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_section_b = '%n'
	let g:airline_skip_empty_sections = 1
	let g:airline_theme='deus'
	let g:airline#extensions#branch#enabled = 0
	let g:airline#extensions#syntastic#enabled = 0
	let g:airline#extensions#fugitiveline#enabled = 0
	let g:airline#extensions#csv#enabled = 0
	let g:airline#extensions#vimagit#enabled = 0

	let g:airline_powerline_fonts = 1
	let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
	let g:airline#extensions#whitespace#enabled = 0
	let g:airline_symbols = {}            " 正确显示分隔符
	let g:airline_symbols.branch = ''
	let g:airline_symbols.linenr = ''
	"let g:airline_theme= 'dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '0 ',
        \ '1': '1 ',
        \ '2': '2 ',
        \ '3': '3 ',
        \ '4': '4 ',
        \ '5': '5 ',
        \ '6': '6 ',
        \ '7': '7 ',
        \ '8': '8 ',
        \ '9': '9 '
        \}

let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#fnametruncate = 0

let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type= 2
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffers_label = 'BUFFERS'
let g:airline#extensions#tabline#tabs_label = 'TABS'

for s:i in range(1, 9)
  call LeaderMappingDef(s:i, '<Plug>AirlineSelectTab'.s:i, 'which_key_ignore')
endfor
unlet s:i
" }}}


" NERDTree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeHijackNetrw = 0

" 设置NERDTree子窗口宽度
let NERDTreeWinSize = 20
" 设置NERDTree子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden = 1
" 删除文件时自动删除文件对
let NERDTreeAutoDeleteBuffer = 1

LeaderMap 'ff', 'NERDTreeToggle', '显示/关闭文件树'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
