let s:TYPE = {
      \   'string':  type(''),
      \   'list':    type([]),
      \   'dict':    type({}),
      \   'funcref': type(function('call'))
      \ }

let s:plugins=[]
let s:plug_options = {}
"let g:plugin_manager = 'dein'
let g:plugin_manager = 'vim-plug'
let g:plugin_install_dir = '~/.cache/vimfiles/'
let g:plugin_mangager_checkinstall = 1

function! s:install_manager(plugins_dir, root_dir) abort
  " Fsep && Psep
  if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
  else
    let s:Psep = ':'
    let s:Fsep = '/'
  endif
  if g:plugin_manager ==# 'dein'
    "auto install dein
    if filereadable(expand(a:plugins_dir)
          \ . join(['repos', 'github.com',
          \ 'Shougo', 'dein.vim', 'README.md'],
          \ s:Fsep))
          \ && filereadable(expand(a:plugins_dir)
          \ . join(['repos', 'github.com',
          \ 'wsdjeg', 'dein-ui.vim', 'README.md'],
          \ s:Fsep))
      let g:_dein_installed = 1
    else
      if executable('git')
        if !filereadable(expand(a:plugins_dir)
              \ . join(['repos', 'github.com',
              \ 'Shougo', 'dein.vim', 'README.md'],
              \ s:Fsep))

          silent exec '!git clone https://github.com/Shougo/dein.vim "'
                \ . expand(a:plugins_dir)
                \ . join(['repos', 'github.com',
                \ 'Shougo', 'dein.vim"'], s:Fsep)
        endif

        if !filereadable(expand(a:plugins_dir)
              \ . join(['repos', 'github.com',
              \ 'wsdjeg', 'dein-ui.vim', 'README.md'],
              \ s:Fsep))

          silent exec '!git clone https://github.com/wsdjeg/dein-ui.vim "'
                \ . expand(a:plugins_dir)
                \ . join(['repos', 'github.com',
                \ 'wsdjeg', 'dein-ui.vim"'], s:Fsep)
        endif
        let g:_dein_installed = 1
      else
        echohl WarningMsg
        echom 'You need install git!'
        echohl None
      endif
    endif
    exec 'set runtimepath+='. fnameescape(a:plugins_dir)
          \ . join(['repos', 'github.com', 'Shougo',
          \ 'dein.vim'], s:Fsep)
    exec 'set runtimepath+='. fnameescape(a:plugins_dir)
          \ . join(['repos', 'github.com', 'wsdjeg',
          \ 'dein-ui.vim'], s:Fsep)
  elseif g:plugin_manager ==# 'vim-plug'
    "auto install vim-plug
    if filereadable(expand(a:plugins_dir)
          \ . join(['vim-plug', 'README.md',], s:Fsep))
      let g:_plug_installed = 1
    else
      if executable('git')
        "silent !git clone https://github.com/junegunn/vim-plug ~/vim-plug
        silent exec '!git clone https://github.com/junegunn/vim-plug "'
              \ . expand(a:plugins_dir)
              \ . join(['vim-plug"'], s:Fsep)
              \ . ' --depth 1'
        silent exec '!ln -s '
              \ . expand(a:plugins_dir)
              \ . join(['vim-plug', 'plug.vim'], s:Fsep)
              \ . " "
              \. join([s:Fsep, a:root_dir, 'autoload'], s:Fsep )
        let g:_plug_installed = 1
      else
        echohl WarningMsg
        echom 'You need install git!'
        echohl None
      endif
    endif
    exec 'set runtimepath+='. fnameescape(a:plugins_dir)
          \ . join(['vim-plug'], s:Fsep)
    autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
  endif
endfunction

function! s:to_a(v) abort
  return type(a:v) == s:TYPE.list ? a:v : [a:v]
endfunction

function! PluginManager#addPlugin(plugin, ...) abort
  if index(s:plugins, a:plugin) < 0
    call add(s:plugins, a:plugin)
    let s:plug_options[a:plugin] = {}
  endif
  if a:0 == 1
    let s:plug_options[a:plugin] = a:1
    if g:plugin_manager ==# 'vim-plug'
      if has_key(a:1, 'on_event')
        let s:plug_options[a:plugin]["on"] = []
        let l:group = 'load/'.a:plugin
        let l:name = split(a:plugin, '/')[1]
        let l:events = join(s:to_a(a:1.on_event), ',')
        let l:load = printf("call plug#load('%s')", l:name)
        execute "augroup" l:group
        autocmd!
        execute 'autocmd' l:events '*' l:load '|' 'autocmd!' l:group
        execute 'augroup END'
      endif
    endif
  endif
endfunction

function! PluginManager#addPlugins(plugins, ...) abort
  let type = type(a:plugins)
  if type ==# s:TYPE.string
    if a:0 == 0
      call PluginManager#addPlugin(a:plugins)
    else
      call PluginManager#addPlugin(a:plugins, a:1)
    endif
  elseif type ==# s:TYPE.list
    for plugin in a:plugins
      if len(plugin) == 2
        call PluginManager#addPlugin(plugin[0], plugin[1])
      else
        call PluginManager#addPlugin(plugin)
      endif
    endfor
  else
    throw 'Invalid argument type (expected: string or list)'
  endif
endfunction

function! PluginManager#ShowPlugins() abort
  for plugin in s:plugins
    echo plugin."," s:plug_options[plugin]
  endfor
endfunction

function! PluginManager#begin(path, root_path) abort
  call s:install_manager(a:path, a:root_path)
  let g:plugin_install_dir = a:path
endfunction

function! PluginManager#end() abort
  if g:plugin_manager ==# 'dein'
    call dein#begin(g:plugin_install_dir)
    for plugin in s:plugins
      call dein#add(plugin, s:plug_options[plugin])
    endfor
    call PluginManager#addPlugin('Shougo/dein.vim')
    call PluginManager#addPlugin('wsdjeg/dein-ui.vim')
    call dein#end()
    if g:plugin_mangager_checkinstall == 1
      silent! let g:_plugin_manager_checking_flag= dein#check_install()
      if g:_plugin_manager_checking_flag
        augroup PluginManagerCheckInstall
          au!
          au VimEnter * DeinUpdate
        augroup END
      endif
    endif
  elseif g:plugin_manager ==# 'vim-plug'
    call plug#begin(g:plugin_install_dir)
    for plugin in s:plugins
      call plug#(plugin, s:plug_options[plugin])
    endfor
    call PluginManager#addPlugin('junegunn/vim-plug')
    call plug#end()
  endif
endfunction
