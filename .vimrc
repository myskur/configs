set nocompatible              " be iMproved
set shell=/bin/bash
filetype off                  " required!
set modifiable                " allow file operations (delete etc.) in NERDTree

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" install Vundle: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" then run :PluginInstall
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'elzr/vim-json'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'instant-markdown.vim'
Plugin 'kballard/vim-swift'
Plugin 'mileszs/ack.vim'

call vundle#end()
filetype plugin indent on     " required!
filetype plugin on

" for easy installation use pathogen
execute pathogen#infect()
nnoremap <F10> :NERDTreeToggle <CR>
map <C-n> :NERDTreeFocus <CR>
let NERDTreeShowHidden=1
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q 
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

let g:vim_markdown_initial_foldlevel=1

map <C-p> :CtrlP <CR>
map <C-u> :Ack<space>
nmap U <C-r>
" correcting bad indent while pasting
nnoremap p p=`]
" map the Q letter to insert a line and paste
:nmap Q o<esc>p
"
" have space-character insert a character
noremap <silent> <space> :exe "normal i".nr2char(getchar())<CR>
" escape key mapped to jk
inoremap jk <esc>
inoremap fd <esc> :w <CR>

" delete without yanking
nnoremap D "_D
vnoremap D "_D
nnoremap x "_x
vnoremap x "_x
" replace currently selected text with default register
" without yanking it
vnoremap p "_dP
" insert tab
vnoremap <tab> >
vnoremap <S-tab> <
" quickly switch between windows
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
" ensure that file type json is set
au BufRead,BufNewFile *.json set filetype=json
" set line number on 
set number
set autoread                    "Reload files changed outside vim
" turn on syntax highlighting
syntax on
" magic for auto-completion at the : command line
set wildmenu
" turn ono the ruler status info bar at the bottom of the screen
set ruler
set hidden 
" indent ina a smart way, instead of returning to the left margin all the time
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
" expand tabs to spaces
set expandtab
" Don't wrap text (makes windows ugly)
set nowrap
" highlight all matches in a text when you search
set hlsearch
" do case insensitive searching
set ignorecase
" When a search phrase has uppercase, don't be cause insensitive
set smartcase
" when I want spell checking do it in english
set spelllang=en_us
" set the font color scheme for dark background
set background=dark
" set the constant color from default pink to green
highlight Constant ctermfg=Green  
" set the color of the suggestions menu
highlight Pmenu ctermfg=lightblue ctermbg=darkgrey guifg=#ffffff guibg=#000000
" set the color of the search highlight
highlight Search guifg=#ffffff guibg=#0000ff gui=none ctermfg=white ctermbg=darkblue 

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb
" ================ Folds ============================
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default
" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif
" ================ Scrolling ========================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
" ================ Commenting ========================
autocmd FileType c,cpp,java,javascript,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" start allow pasting in insert mode without set paste, works with tmux
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" end allow pasting in insert mode 

" spell checking for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell
" use kspell word completion with ctrl-n in insert mode
set complete+=kspell
