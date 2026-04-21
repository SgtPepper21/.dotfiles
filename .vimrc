"---------------------------- Misc --------------------------------------------"

" Keep temporary and backup-files in one place
" Note that these directories have to be created first!
set backup
set undofile
set backupdir=~/.vim/.backup//
set undodir=~/.vim/.undo//
set directory=~/.vim/.swp//

" Automatically cd into the directory the file is in
set autochdir

" No vi-compatibility - necessary for lots of cool vim things
set nocompatible

" Tab completion
set wildmenu
set wildignore=*.bak,*.pyc,*.swp
" Make tab completion more like bash
set wildmode=list:longest,full

" Spellchecking
setlocal spell spelllang=en_gb
syntax enable
set nospell

" Hide unused buffers
set hidden

" Remember folds when closing the file
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" Save to system clipboard
set clipboard=unnamedplus

"---------------------------- Console UI and text display ---------------------"

" Color scheme
"color desert
set background=dark
" Use slightly customized gruvbox-colorscheme
colorscheme gruvbox_custom
" Use 256_noir (clashed with transparent background)
"set t_Co=256
"color 256_noir

" Keep terminal background transparent
hi Normal guibg=NONE ctermbg=NONE

" Highlight trailing whitespace
hi TrailingSpace ctermbg=1
autocmd Filetype c,cpp,python.sage match TrailingsSpace "\s\+\n"

" Highlight current line
set cursorline

" Show matching brackets when text indicator is over them
set showmatch

" Show typed command in bottom right corner
set showcmd

" Show fileinfo in statusline
set laststatus=2
set statusline=%f%m%r%h%w\ [%Y]\ [0x%02.2B]%<\ %F%4v,%4l\ %3p%%\ of\ %L\ lines

" Turn off errorbells
set noerrorbells
set visualbell
set t_vb=

" Show linenumbers
set number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

" Show current position at the bottom
set ruler

"---------------------------- Search and text editing behaviour ---------------"

" Incremental search and highlight results
set incsearch
set hlsearch

" Set case insensitivity
set ignorecase
set smartcase

"---------------------------- Indents, tabs, etc. -----------------------------"

" Automatic indention
filetype plugin indent on
set smartindent
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set backspace=indent,eol,start

" Don't throw away indent on '#'
inoremap # X<BS># 

" Set textwidth
set textwidth=80
autocmd Filetype c,cpp,python,sage set textwidth=0

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! &s/\s\+$//ge | endif

"---------------------------- Filetype specific -------------------------------"

" Add syntax highlighting for sage
augroup filetypedetect
    autocmd! BufRead,BufNewFile *.sage,*.spyx,*.pyx setfiletype python
augroup END

" Add shebangs
augroup Shebang
    autocmd!
    autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\<nl># -*- coding: iso-8859-15 -*-\<nl>\<nl>\"|$
    autocmd BufNewFile *.sage 0put =\"#!/usr/bin/env sage\<nl>\<nl>\"|$
    autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: None -*-\<nl>\"|$
    autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
    autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
augroup END

" Make files with shebang executable
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod a+x <afile>" | endif | endif

"---------------------------- Key bindings ------------------------------------"

" Remap jj to escape insert mode (as you never type jj anyways)
inoremap jj <Esc>
nnoremap JJJJ <Nop>

inoremap <C-c> <Esc>

" Swap ; and : in normal mode
nnoremap ; :
nnoremap : ;

" Map Control+s to save a file
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>

" Clear currently highlighted search items with F1
nnoremap <F1> :let @/ = ""<CR>

" Compile/execute with F9
augroup Compile
    autocmd!
    autocmd Filetype tex,latex nnoremap <buffer> <F9> :exec '!~/scripts/compile_tex.sh' shellescape(@%, 1)<CR>
    autocmd Filetype python,sage nnoremap <buffer> <F9> :exec '!./%'<CR>
    autocmd Filetype c nnoremap <buffer> <F9> :exec '!~.scripts.compile_c.sh -op % && ./$(basename % .c)'<CR>
augroup END

" gj and gk use lines on screen instead of logical lines
" meaning they don't skip word wrapped lines
nnoremap j gj
nnoremap k gk

" Toggle linenumbers with F2
"nnoremap <silent> <F2> :set number! number?<CR>
nnoremap <F2> :call ToggleNumbers()<CR>
function! ToggleNumbers()
    if &number && !&rnu
        set nonumber
    elseif !&number
        set nu rnu
    else
        set nu nornu
    endif
endfunction

" Toggle textwidth with F3
nnoremap <F3> :call ToggleTextwidth()<CR>
function! ToggleTextwidth()
    if &textwidth==80
        set textwidth=0 textwidth?
    else
        set textwidth=80 textwidth?
    endif
endfunction

" Toggle spellchecking with F4
nnoremap <F4> :call ToggleSpellcheck()<CR>
function! ToggleSpellcheck()
    if !&spell
        setlocal spell spelllang=en_gb spelllang?
    elseif &spelllang=-"en_gb"
        setlocal spell spelllang=de spelllang?
    else
        setlocal nospell spell?
    endif
endfunction

" Window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Choose buffer to switch to
nnoremap gb :ls<CR>:b<Space>

" hardmode.vim - Vim: HARD MODE!!!
" Author:       Matt Parrott <parrott.matt@gmail.com>
" Version:      1.0

let g:hardmodemsg = "VIM: hard Mode [ ':call EasyMode()' to exit]"
let g:hardmode_on = 0

fun! HardMode()
    set backspace=0

    nnoremap <buffer> <Left> <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> <Right> <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> <Up> <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> <Down> <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> <PageUp> <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> <PageDown> <Esc>:echo g:hardmodemsg<CR>

    inoremap <buffer> <Left> <Esc>:echo g:hardmodemsg<CR>
    inoremap <buffer> <Right> <Esc>:echo g:hardmodemsg<CR>
    inoremap <buffer> <Up> <Esc>:echo g:hardmodemsg<CR>
    inoremap <buffer> <Down> <Esc>:echo g:hardmodemsg<CR>
    inoremap <buffer> <PageUp> <Esc>:echo g:hardmodemsg<CR>
    inoremap <buffer> <PageDown> <Esc>:echo g:hardmodemsg<CR>

    vnoremap <buffer> <Left> <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> <Right> <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> <Up> <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> <Down> <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> <PageUp> <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> <PageDown> <Esc>:echo g:hardmodemsg<CR>

    vnoremap <buffer> h <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> j <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> k <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> l <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> - <Esc>:echo g:hardmodemsg<CR>
    vnoremap <buffer> + <Esc>:echo g:hardmodemsg<CR>

    nnoremap <buffer> h <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> j <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> k <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> l <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> - <Esc>:echo g:hardmodemsg<CR>
    nnoremap <buffer> + <Esc>:echo g:hardmodemsg<CR>

    let g:hardmode_on = 1
    :echo g:hardmodemsg
endfun

fun! EasyMode()
    set backspace=indent,eol,start

    silent! nunmap <buffer> <Left>
    silent! nunmap <buffer> <Right>
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <PageUp>
    silent! nunmap <buffer> <PageDown>

    silent! iunmap <buffer> <Left>
    silent! iunmap <buffer> <Right>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <PageUp>
    silent! iunmap <buffer> <PageDown>

    silent! vunmap <buffer> <Left>
    silent! vunmap <buffer> <Right>
    silent! vunmap <buffer> <Up>
    silent! vunmap <buffer> <Down>
    silent! vunmap <buffer> <PageUp>
    silent! vunmap <buffer> <PageDown>

    silent! vunmap <buffer> h
    silent! vunmap <buffer> j
    silent! vunmap <buffer> k
    silent! vunmap <buffer> l
    silent! vunmap <buffer> -
    silent! vunmap <buffer> +

    silent! nunmap <buffer> h
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! nunmap <buffer> l
    silent! nunmap <buffer> -
    silent! nunmap <buffer> +

    let g:hardmode_on = 0
    :echo "You are weak..."
endfun

fun! ToggleHardMode()
    if g:hardmode_on
        call EasyMode()
    else
        call HardMode()
    end
endfun

nnoremap <leader>h <Esc>:call EasyMode()<CR>
nnoremap <leader>H <Esc>:call HardMode()<CR>

" nvim plugins
" First, run:
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" Then, add the following section to ~/.config/nvim/init.vim
" Finally, run :PlugInstall to install the listed plugins
call plug#begin()

" list your plugins here
Plug 'ThePrimeagen/vim-be-good'

call plug#end()
