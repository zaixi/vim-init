" 快速对齐，代替 Tabularize
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
" 去除行尾空格
Plug 'ntpeters/vim-better-whitespace', {'on_event': 'CursorHold'}
" 配对括号和引号自动补全
Plug 'Raimondi/delimitMate'
" 撤销树
Plug 'mbbill/undotree', {'on' : ['UndotreeToggle']}
" Doxygen风格注释
Plug 'vim-scripts/DoxygenToolkit.vim', {'on' : ['Dox', 'DoxLic', 'DoxAuthor']}
" 快速注释
Plug 'scrooloose/nerdcommenter', { 'on': [
      \ '<Plug>NERDCommenterComment',
      \ '<Plug>NERDCommenterUncomment',
      \ '<Plug>NERDCommenterSexy',
      \ '<Plug>NERDCommenterYank',
      \ '<Plug>NERDCommenterMinimal',
      \ '<Plug>NERDCommenterInvert',
      \ ]}
" 全文快速移动，s{char} 即可触发
Plug 'easymotion/vim-easymotion',  { 'on': [
                \ '<Plug>(easymotion-overwin-f)',
                \ '<Plug>(easymotion-overwin-f2)',
                \ '<Plug>(easymotion-overwin-line)',
                \ '<Plug>(easymotion-overwin-w)',
                \ ] }
" 快速添加环绕符,ds"删除",cs"'修改"为'
Plug 'tpope/vim-surround'
" 多行编辑
Plug 'terryma/vim-multiple-cursors'
" 增强 . 重复功能
Plug 'tpope/vim-repeat'
" 文本对象: {{{
" 基础插件：提供让用户方便的自定义文本对象的接口
Plug 'kana/vim-textobj-user'
" 用 v 选中一个区域后，v/V 按分隔符扩大/缩小选区
Plug 'terryma/vim-expand-region', {'on': ['<Plug>(expand_region_expand)', '<Plug>(expand_region_shrink)']}
" 用 v 选中一个区域后，v/V 按分隔符扩大/缩小选区
Plug 'kana/vim-textobj-entire'
" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
Plug 'kana/vim-textobj-indent'
" 语法文本对象：iy/ay 基于语法的文本对象
Plug 'kana/vim-textobj-syntax'
" 函数文本对象：if/af 支持 c/c++/vim/java
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
" 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
Plug 'bps/vim-textobj-python', {'for': 'python'}
" 参数文本对象：i,/a, 包括参数或者列表元素
Plug 'sgur/vim-textobj-parameter'
" 提供 uri/url 的文本对象，iu/au 表示
Plug 'jceb/vim-textobj-uri'
" }}}

" {{{ 改变符号风格
function! String2chars(str) abort
  let save_enc = &encoding
  let &encoding = 'utf-8'
  let chars = []
  for i in range(strchars(a:str))
    call add(chars, strcharpart(a:str,  i , 1))
  endfor
  let &encoding = save_enc
  return chars
endfunction

function! s:parse_symbol(symbol) abort
  if a:symbol =~# '^[a-z]\+\(-[a-zA-Z]\+\)*$'
    return split(a:symbol, '-')
  elseif a:symbol =~# '^[a-z]\+\(_[a-zA-Z]\+\)*$'
    return split(a:symbol, '_')
  elseif a:symbol =~# '^[a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = String2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        call add(rst, tolower(word))
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  elseif a:symbol =~# '^[A-Z][a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = String2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        if !empty(word)
          call add(rst, tolower(word))
        endif
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  else
    return [a:symbol]
  endif
endfunction


function! s:delete_extra_space() abort
  if !empty(getline('.'))
    if getline('.')[col('.')-1] ==# ' '
      execute "normal! \"_ciw\<Space>\<Esc>"
    endif
  endif
endfunction

function! s:lowerCamelCase() abort
  " fooFzz
  let cword = s:parse_symbol(expand('<cword>'))
  ec cword
  if !empty(cword)
    let rst = [cword[0]]
    if len(cword) > 1
      let rst += map(cword[1:], "substitute(v:val, '^.', '\\u&', 'g')")
    endif
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:UpperCamelCase() abort
  " FooFzz
  let cword = s:parse_symbol(expand('<cword>'))
  ec cword
  if !empty(cword)
    let rst = map(cword, "substitute(v:val, '^.', '\\u&', 'g')")
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:under_score() abort
  " foo_fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:up_case() abort
  " FOO_FZZ
  let cword =map(s:parse_symbol(expand('<cword>')), 'toupper(v:val)')
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:kebab_case() abort
  " foo-fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '-')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction
" }}}

" {{{ 空格 TAB 转换
function! Tab2Spa()
    let l:tab_format = &expandtab
    set expandtab
    :%retab!
    if (l:tab_format)
        set expandtab
    else
        set noexpandtab
    endif
endfunction

function! Spa2Tab()
    let l:tab_format = &expandtab
	set noexpandtab
    :%retab!
    if (l:tab_format)
        set expandtab
    else
        set noexpandtab
    endif
endfunction

"}}}

" 精准替换: {{{
" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
  wa
  let flag = ''
  if a:confirm
    let flag .= 'gec'
  else
    let flag .= 'ge'
  endif
  let search = ''
  if a:wholeword
    let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
  else
    let search .= expand('<cword>')
  endif
  let replace = escape(a:replace, '/\&~')
  execute 'argdo %s/' . search . '/' . replace . '/' . flag
endfunction
" }}}

" vim-easy-align 设置 {{{
" 例子: EasyAlign /=/r1l3  =号对齐,左边3个空格,右边一个空格
let g:easy_align_delimiters = {
\ '#': {
\     'pattern': '#',
\     'ignore_groups': ['String'] },
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }
" }}}

" nerdcommenter 设置 {{{
" 在注释时在分隔符周围添加额外的空格，在删除时删除它们
let g:NERDSpaceDelims = 1
" 关闭默认映射
let g:NERDCreateDefaultMappings = 0

" 在取消注释时总是删除多余的空格
let g:NERDRemoveExtraSpaces = 1

" 使用紧凑语法进行美化的多行注释
let g:NERDCompactSexyComs = 1

" 对齐行向注释分隔符向左对齐而不是跟随代码缩进
let g:NERDDefaultAlign = 'left'

" 允许注释和反转空行
let g:NERDCommentEmptyLines = 1

" 在取消注释时启用尾部空格的修剪
let g:NERDTrimTrailingWhitespace = 1

" 始终使用替代定界符
let g:NERD_c_alt_style = 1
let g:NERDCustomDelimiters = {'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }}
" }}}

let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-m>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

xmap " S"
xmap ' S'
xmap ` S`
xmap [ S[
xmap ( S(
xmap { S{
xmap } S}
xmap ] S]
xmap ) S)
xmap > S>

" ALT_+/- 用于按分隔符扩大缩小 v 选区
xmap v <Plug>(expand_region_expand)
xmap V <Plug>(expand_region_shrink)
xmap <BS> <Plug>(expand_region_shrink)

" easymotion 设置
let g:EasyMotion_do_mapping = 0
nmap f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f)

LeaderName 'xi', '+改变符号风格'
LeaderName 'xd', '+删除'
LeaderName 'xt', '+Tab和SPC转换'
LeaderName 'xR', '+非整词替换'
LeaderName 'xr', '+整词替换'

call LeaderMappingDef('xd ', function('s:delete_extra_space'), '删除光标周围的额外空格')
call LeaderMappingDef('xic', function('s:lowerCamelCase'), '转换为小驼峰法')
call LeaderMappingDef('xiC', function('s:UpperCamelCase'), '转换为大驼峰法')
call LeaderMappingDef('xi-', function('s:kebab_case'),     '转换为中划线(-)法')
call LeaderMappingDef('xi_', function('s:under_score'),    '转换为下划线(_)法')
call LeaderMappingDef('xiU', function('s:up_case'),        '转换为宏定义')

call LeaderMappingDef('xtt', function('Spa2Tab'),  '空格转Tab')
call LeaderMappingDef('xt ', function('Tab2Spa'),  'Tab转空格')

call LeaderMappingDef('xy', 'call feedkeys("\"+y")',  '复制到系统')
call LeaderMappingDef('xp', 'call feedkeys("\"+p")',  '从系统粘贴')

call LeaderMappingDef('xrc', ":call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))",  '询问替换')
call LeaderMappingDef('xrw', ":call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))",  '直接替换')
call LeaderMappingDef('xRc', ":call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))",  '询问替换')
call LeaderMappingDef('xRw', ":call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))",  '直接替换')

LeaderMap 'xa', '<Plug>(EasyAlign)', '文本按规则对齐'

" vim-better-whitespace 设置
LeaderMap 'tw', 'ToggleWhitespace', '切换突出显示行尾空格'
LeaderMap 'xdw', 'StripWhitespace', '删除行尾空格'

LeaderMap 'xu', 'UndotreeToggle', '撤销树'

LeaderName 'xc', '+注释'
LeaderMap 'xcc', '<Plug>NERDCommenterComment',   '注释选择区域'
LeaderMap 'xcu', '<Plug>NERDCommenterUncomment', '反注释选择区域'
LeaderMap 'xcs', '<Plug>NERDCommenterSexy',      '块注释'
LeaderMap 'xcy', '<Plug>NERDCommenterYank',      '注释选中区域并复制'
LeaderMap 'xcm', '<Plug>NERDCommenterMinimal',   '最小化注释'
LeaderMap 'xci', '<Plug>NERDCommenterInvert',    '切换注释状态'
LeaderMap 'xcf', 'Dox',                          '生成函数注释'
LeaderMap 'xcl', 'DoxLic',                       '生成许可证注释'
LeaderMap 'xca', 'DoxAuthor',                    '生作者注释'

LeaderMap 'jj', '<Plug>(easymotion-overwin-f)',    '按一个特定字符跳'
LeaderMap 'jJ', '<Plug>(easymotion-overwin-f2)',   '按两个特定字符跳'
LeaderMap 'jl', '<Plug>(easymotion-overwin-line)', '按行跳'
LeaderMap 'jw', '<Plug>(easymotion-overwin-w)',    '按单词跳'
