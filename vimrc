" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"是否生成一个备份文件.(备份的文件名为原文件名加“~“后缀.)
"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif

set number "显示行号.
set tabstop=8 "设置tab键为8个空格.
set shiftwidth=8 "设置当行之间交错时使用8个空格
set showmatch "设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set background=dark "背景颜色暗色.
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" pathogen
execute pathogen#infect()

" Tlist
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Show_One_File=1
let Tlist_OnlyWindow=1
let Tlist_Use_Right_Window=0
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_Menu=1
let Tlist_Max_Submenu_Items=10
let Tlist_Max_Tag_length=20
let Tlist_Use_SingleClick=0
let Tlist_Auto_Open=0
let Tlist_Close_On_Select=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Process_File_Always=0
let Tlist_WinHeight=10
let Tlist_WinWidth=18
let Tlist_Use_Horiz_Window=0

" WinManager
let g:winManagerWindowLayout='TagList'
cmap wm :WMToggle<cr>

" Cscope
if has("cscope")
    set cscopetag   " 使支持用 Ctrl+"  和 Ctrl+t 快捷键在代码间跳来跳去
    " check cscope for definition of a symbol before checking ctags:
    " set to 1 if you want the reverse search order.
    set csto=1

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB !=""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose

    nmap <C-j>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-j>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-j>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-j>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-j>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-j>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-j>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-j>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif"
