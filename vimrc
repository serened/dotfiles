set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" The following are examples of different formats supported.
" Keep Plugin commands between here and filetype plugin indent on.
" scripts on GitHub repos
Plugin 'tpope/vim-fugitive'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'kana/vim-scratch'
Plugin 'mileszs/ack.vim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-ruby/vim-ruby'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dispatch'
Bundle 'flazz/vim-colorschemes'
Bundle 'skalnik/vim-vroom'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.
" Put your stuff after this line
"
" Size of a hard tabstop
" allow unsaved background buffers and remember marks/undo for them
 set hidden
" " remember more commands and search history
 set history=10000
 set expandtab
 set tabstop=2
 set shiftwidth=2
 set softtabstop=2
 set autoindent
 set laststatus=2
 set showmatch
 set incsearch
 set hlsearch
" " make searches case-sensitive only if they contain upper-case characters
 set ignorecase smartcase
" " highlight current line
 set cursorline
 set cmdheight=2
 set switchbuf=useopen
 set numberwidth=1
 set number
 set showtabline=2
 set winwidth=100
 set number
 set showtabline=2
 set winwidth=100
 set shell=bash
 " Prevent Vim from clobbering the scrollback buffer. See
 " " http://www.shallowsky.com/linux/noaltscreen.html
 set t_ti= t_te=
 " " keep more context when scrolling off the end of a buffer
 set scrolloff=3
 " " Store temporary files in a central spot
 set backup
 set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
 set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
 " " allow backspacing over everything in insert mode
 set backspace=indent,eol,start
 " " display incomplete commands
 set showcmd
 set hlsearch
 syntax enable     " Use syntax highlighting
 set runtimepath^=~/.vim/bundle/ctrlp.vim
 set background=dark
 let g:solarized_termcolors = 256  " New line!!
 colorscheme solarized

" Have supertab use usercompletion by default, for tke sake of ipython
let g:SuperTabDefaultCompletionType = "context"

set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Inconsolata\ for\ Powerline:h15
   endif
endif

 set pastetoggle=<leader>v
 set showmode

 set clipboard=unnamed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BIG RED UNWANTED WHITESPACE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 highlight ExtraWhitespace ctermbg=red guibg=red
 match ExtraWhitespace /(\s\+$|\t)/
 autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
 autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 autocmd InsertLeave * match ExtraWhitespace /\s\+$/
 autocmd BufWinLeave * call clearmatches()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BIG RED TABS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight Tab ctermbg=red guibg=red
match Tab /\t/
autocmd BufWinEnter * match ExtraWhitespace /\t/
autocmd InsertEnter * match ExtraWhitespace /\t/
autocmd InsertLeave * match ExtraWhitespace /\t/
autocmd BufWinLeave * call clearmatches()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 function! OpenTestAlternate()
    let new_file = AlternateForCurrentFile()
    exec ':e ' . new_file
 endfunction
 function! AlternateForCurrentFile()
    let current_file = expand("%")
    let new_file = current_file
    let in_spec = match(current_file, '^spec/') != -1
    let going_to_spec = !in_spec
    let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<services\>') != -1 || match(current_file, '\<helpers\>') != -1
    if going_to_spec
        if in_app
            let new_file = substitute(new_file, '^app/', '', '')
        end
        let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
        let new_file = 'spec/' . new_file
    else
        let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
        let new_file = substitute(new_file, '^spec/', '', '')
        if in_app
            let new_file = 'app/' . new_file
        end
    endif
    return new_file
endfunction

 """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

 function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

" Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"),'\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
"Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    "Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if filereadable("config/environment.rb")
        exec ":!zeus rspec --color --format=nested --order default". a:filename
    else
        exec ":!rspec --color --format=nested"  . a:filename
    end
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RAILS STUFFS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ShowRoutes()
 " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
 " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
 " Delete everything
  :normal 1GdG
" Put routes output in buffer
  :0r! rake -s routes
 " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
 " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" WHITESPACE SLAYER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>StripTrailingWhitespaces()
" Preparation save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
" Do the business:
  %s/\s\+$//e
" Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
  
nnoremap <leader>sr :silent :call <SID>StripTrailingWhitespaces()<CR>

source /Users/codeslinger/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
set laststatus=2

