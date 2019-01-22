set nocompatible
filetype off
syntax on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"======================================
Plugin 'thaerkh/vim-workspace'
Plugin 'nlknguyen/copy-cut-paste.vim'
Plugin 'VundleVim/Vundle.vim'
Plugin 'django.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mileszs/ack.vim'
Plugin 'posva/vim-vue'
Plugin 'scrooloose/nerdtree'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'Chiel92/vim-autoformat'
Plugin 'chrisbra/Colorizer'
"Plugin 'davidhalter/jedi-vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'tpope/vim-fugitive'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mattn/emmet-vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'tmhedberg/matchit'
Plugin 'gregsexton/MatchTag'
Plugin 'terryma/vim-multiple-cursors'
"Plugin 'leafgarland/typescript-vim'
"Plugin 'easymotion/vim-easymotion'
"Plugin 'junegunn/fzf'
"Plugin 'chrisgillis/vim-bootstrap3-snippets'
"Plugin 'xolox/vim-misc'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"======================================
call vundle#end()
filetype plugin indent on
"======================================
set clipboard=unnamed
set t_Co=256
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp1251,cp866,koi8-r
set background=dark
set wildignore=**node_modules**
set wildignore+=*.pyc             " ignores *.pyc
colorscheme hybrid

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11
  endif
endif

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set rnu
set wildignore=*.o,*~,*.pyc
set autowriteall
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set cursorline
set hidden
let b:did_indent = 1
set nowrap
let $LANG='en'
set langmenu=en
set number
set wildmenu
set cmdheight=1
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set laststatus=2
set ignorecase
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25


"let g:workspace_session_name = 'Session.vim'
"let g:workspace_autosave_always = 1
"let g:workspace_autosave = 0


"set autochdir
"autocmd BufEnter * silent! lcd %:p:h " alternative autochdir
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4

map [q :cprev<CR>
map ]q :cnext<CR>
map [Q :cfirst<CR>
map ]Q :clast<CR>

let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-S-d>'
let g:multi_cursor_quit_key='<C-c>'
let mapleader = ","
nnoremap <leader>s :ToggleWorkspace<CR>
map <C-b> :w<CR>:!python %<CR>
map <C-n> :NERDTreeToggle<CR>
nmap <C-c> :w!<CR>
nmap <F8> :TagbarToggle<CR>
imap <C-c> <Esc>:w!<CR>
vmap <C-c> <Esc>:w!<CR>
map ," ysiw"
map ,' ysiw'
map ,( ysiw(
map ,) ysiw)
map ,[ ysiw[
map ,] ysiw]
map ,{ ysiw{
map ,} ysiw}
map <C-j> :bn <CR>
map <C-k> :bp <CR>

autocmd FileType html,css,vue,jsx,js,javascript,htmldjango,scss,sass EmmetInstall
au BufRead,BufNewFile *.vue set ft=html

let g:user_emmet_install_global = 0
let g:user_emmet_expandabbr_key = '<c-e>'
"set omnifunc=syntaxcomplete#Complete
let NERDTreeIgnore=['\.o$', '\~$', 'node_modules']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](doc|tmp|node_modules)',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ }

let g:ycm_autoclose_preview_window_after_completion = 0

"======= YCM and ULTISNIPS ============

" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-l>"
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType htmldjango noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType vue noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
autocmd FileType scss noremap <buffer> <c-f> :call CSSBeautify()<cr>


let g:netrw_cygwin = 0
let g:netrw_ssh_cmd = '"C:\Program Files\Git\usr\bin\scp.exe" -batch -T -ssh'

" functions
"
"

function RunPython()
    execute '!python '. expand('%:p')
endfunction

noremap <f4> :call RunPython() <CR>


