augroup MyAutoCmd
  autocmd!
augroup END

syntax on

autocmd BufWritePre * :%s/\s\+$//ge
set nocursorline
set nocursorcolumn
set modifiable
set write
set tags=tags
set expandtab
set tabstop=4
set softtabstop=0
set shiftwidth=4
set ignorecase
set smartcase
set incsearch
set hlsearch
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
set shiftround
set infercase
set virtualedit=all
set hidden
set switchbuf=useopen
set showmatch
set matchtime=3
set matchpairs& matchpairs+=<:>
set backspace=indent,eol,start
set fileencoding=utf-8

if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif

set nowritebackup
set nobackup
set noswapfile
set number
set wrap
set textwidth=0
set t_Co=256
set t_vb=
set novisualbell
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲

set guicursor=
let g:python3_host_prog = expand("/usr/bin/python")
let mapleader = "\<Space>"

nnoremap <silent><Leader>ww :w<CR>
nnoremap <silent><Leader>qq :q!<CR>
nnoremap <silent><Leader>wq :wq<CR>
nnoremap <silent><Leader>qa :qa!<CR>
command! Wsudo :w !sudo tee % >> /dev/null

inoremap jj <Esc>
nmap <silent> <Esc><Esc> :nohlsearch<CR>
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap j gj
nnoremap k gk
vnoremap v $h
nnoremap <Tab> %
vnoremap <Tab> %
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep coper
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c
cmap w!! w !sudo tee > /dev/null %

function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction

let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif

if &compatible
    set nocompatible
endif

set runtimepath+=$HOME/.vim/bundle/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('$HOME/.vim/bundle')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let g:rc_dir = expand('~/.vim/rc')
    let s:toml = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable

colorscheme iceberg

highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight EndOfBuffer ctermbg=none
