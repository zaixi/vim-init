" 给不同语言提供字典补全，插入模式下 c-x c-k 触发
Plug 'asins/vim-dict'
" 模板补全语法文件
"Plug 'honza/vim-snippets'
" 自动补全
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'on_event': 'InsertEnter'}
Plug 'honza/vim-snippets', { 'on_event': 'InsertEnter' }

" 模板补全
"Plug 'SirVer/ultisnips', { 'on_event': 'InsertEnter' }
" 超级补全
"Plug 'Valloric/YouCompleteMe', {  'do': './install.py --clang-completer', 'on_event': 'InsertEnter' }
" 在底部显示函数参数
"Plug 'Shougo/echodoc.vim', { 'on_event': 'InsertEnter' }
" 自动生成超级补全配置
"Plug 'rdnetto/YCM-Generator',  { 'on': ['YcmGenerateConfig', 'CCGenerateConfig']}
" YcmGenerateConfig

" echodoc.vim 设置
"set noshowmode
"let g:echodoc#enable_at_startup = 1

" {{{ ultisnips 设置
let g:UltiSnipsExpandTrigger = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:ulti_expand_res = 0
function! Ulti_ExpandOrEnter()
	call UltiSnips#ExpandSnippet()
	if g:ulti_expand_res
		return ''
	elseif pumvisible()
		return " "
	else
		return "\<Enter>"
	endif
endfunction
" }}}

" {{{ coc 设置

let g:coc_config_home = g:home."/tools/conf"
let g:coc_global_extensions = ['coc-json', 'coc-snippets', 'coc-tag', 'coc-word', 'coc-omni', 'coc-dictionary', 'coc-highlight', 'coc-yank', 'coc-cmake']
let g:coc_snippet_next = '<tab>'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

function! g:Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" function! s:coc_autocmd() abort
  " Highlight the symbol and its references when holding the cursor.
  " autocmd CursorHold * silent call CocActionAsync('highlight')

  " augroup mygroup
  "   autocmd!
  "   " Setup formatexpr specified filetype(s).
  "   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "   " Update signature help on jump placeholder.
  "   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " augroup end
" endfunction

" autocmd InsertEnter * silent call s:coc_autocmd()

" }}}

call LeaderMappingDef('ls', ":call Show_documentation()",  '显示文档')

LeaderMap 'ld', '<Plug>(coc-definition)',       '跳转到定义'
LeaderMap 'ly', '<Plug>(coc-type-definition)',  '跳转到类型定义'
LeaderMap 'li', '<Plug>(coc-implementation)',   '跳转到实现'
LeaderMap 'lr', '<Plug>(coc-references)',       '跳转到引用'
LeaderMap 'ln', '<Plug>(coc-rename)',           '重命名'

LeaderMap 'lo', '<Plug>(coc-refactor)',         '重命名'

LeaderMap 'la', '<Plug>(coc-format-selected)',  '格式化选中区域'

LeaderName 'le', '错误诊断'
LeaderMap 'lep', '<Plug>(coc-diagnostic-prev)', '跳到上个错误'
LeaderMap 'len', '<Plug>(coc-diagnostic-next)', '跳到下个错误'

"----------------------------------------------------------------------
"{{{ YouCompleteMe 默认设置：YCM 需要你另外手动编译安装
"----------------------------------------------------------------------

" 禁用预览功能：扰乱视听
let g:ycm_add_preview_to_completeopt = 0
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments = 1

" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf = 0

" 不创建 YcmShowDetailedDiagnostic 的映射
let g:ycm_key_detailed_diagnostics = ''

" 禁用诊断功能：我们用前面更好用的 ALE 代替
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone,noselect

" noremap <c-z> <NOP>

" 两个字符自动触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

"----------------------------------------------------------------------
" Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
"----------------------------------------------------------------------
let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "objc":1,
			\ "objcpp":1,
			\ "python":1,
			\ "java":1,
			\ "javascript":1,
			\ "coffee":1,
			\ "vim":1,
			\ "go":1,
			\ "cs":1,
			\ "lua":1,
			\ "perl":1,
			\ "perl6":1,
			\ "php":1,
			\ "ruby":1,
			\ "rust":1,
			\ "erlang":1,
			\ "asm":1,
			\ "nasm":1,
			\ "masm":1,
			\ "tasm":1,
			\ "asm68k":1,
			\ "asmh8300":1,
			\ "asciidoc":1,
			\ "basic":1,
			\ "vb":1,
			\ "make":1,
			\ "cmake":1,
			\ "html":1,
			\ "css":1,
			\ "less":1,
			\ "json":1,
			\ "cson":1,
			\ "typedscript":1,
			\ "haskell":1,
			\ "lhaskell":1,
			\ "lisp":1,
			\ "scheme":1,
			\ "sdl":1,
			\ "sh":1,
			\ "zsh":1,
			\ "bash":1,
			\ "man":1,
			\ "markdown":1,
			\ "matlab":1,
			\ "maxima":1,
			\ "dosini":1,
			\ "conf":1,
			\ "config":1,
			\ "zimbu":1,
			\ "ps1":1,
			\ }
"}}}

function! Layer_autocomplete_after_config() abort

endfunction
