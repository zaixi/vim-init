" 用于在侧边符号栏显示 git/svn 的 diff
Plug 'mhinz/vim-signify'
" Git 支持
Plug 'tpope/vim-fugitive', {'on' : [
			\'Gdiff',
			\'Git push',
			\'Gblame',
			\'Gstatus',
			\'GV',
			\]}
" 更好的 git log
Plug 'junegunn/gv.vim', {'on' : ['GV']}
" 异步 git 命令
Plug 'lambdalisue/gina.vim', {'on' : ['Gina']}
" 目录树显示git状态
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': [
			\'NERDTree',
			\'NERDTreeFocus',
			\'NERDTreeToggle',
			\'NERDTreeCWD',
			\'NERDTreeFind',
			\]}
" 提供 gist 接口
Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }

LeaderMap 'gd', 'Gdiff',            'git diff'
LeaderMap 'gp', 'Git push',         'git push'
LeaderMap 'gb', 'Gblame',           'git blame'
LeaderMap 'gs', 'Gstatus',          'git status'
LeaderMap 'ga', ':Gina add %',      'git add 当前文件'
LeaderMap 'gA', ':Gina add .',      'git add 所有文件'
LeaderMap 'gu', ':Gina reset -q %', 'git reset 当前文件'
LeaderMap 'gU', ':Gina reset -q .', 'git reset 所有文件'
LeaderMap 'gc', ':Gina commit',     'git commit(!切换 --amend)'
LeaderMap 'gv', ':GV!',             'git log 当前文件'
LeaderMap 'gV', ':GV',              'git log 当前仓库'

" signify 调优
let g:signify_vcs_list = ['git', 'svn']
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'
let g:signify_sign_changedelete      = g:signify_sign_change

" git 仓库使用 histogram 算法进行 diff
let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
