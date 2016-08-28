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

"设置vim列出命令tab补全,包括命令和命令参数
"当输入":+命令的一些字母" 后按Tab键时自动补全时行为为:
"  1.出现一个list，此时可进行并再次按Tab补全
"  2.跳至列表第一个选项或者自动补全当前输入
" vim默认行为没有步骤1，直接跳转第一个选项，而且不会显示整体列表
set wildmode=list:longest,full
set wildmenu 

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
nmap zm :WMToggle<cr>

" Cscope
if has("cscope")
	set cst
	"set nocst
	set csto=1
	set csverb
	"set nocsverb
	set cscopequickfix=s-,c-,d-,i-,t-,e-
	"set cspc=3

	"      add cscope.out
	nmap <C-\>a :cs add cscope.out<CR><CR>

	"      0或者s —— 查找这个C符号
	"      1或者g —— 查找这个定义
	"      2或者d —— 查找被这个函数调用的函数（们）
	"      3或者c —— 查找调用这个函数的函数（们）
	"      4或者t —— 查找这个字符串
	"      6或者e —— 查找这个egrep匹配模式
	"      7或者f —— 查找这个文件
	"      8或者i —— 查找#include这个文件的文件（们）
	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

	nmap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

"============================================================================================
set fencs=utf-8,cp936

" 删除行尾空格
nnoremap <leader>f :%s/\s\+$//<cr>

let g:go_fmt_autosave = 0

function! KRIndent()
	let c_space_errors = 0
	set fileformats=unix
	set textwidth=120
	set noexpandtab
	set shiftround
	set cindent
	set formatoptions=tqln
	set cinoptions=:0,l1,t0,g0
	syntax keyword cType u8 u16 u32 u64 s8 s16 s32 s64 off64_t
	highlight default link LinuxError ErrorMsg

	syntax match LinuxError / \+\ze\t/     " spaces before tab
	syntax match LinuxError /\s\+$/        " trailing whitespaces
	syntax match LinuxError /\%121v.\+/    " virtual column 121 and more
endfunction

function! PythonIndent()
	set fileformats=unix
	set textwidth=120
	set expandtab
	set shiftround
	set tabstop=4
	set shiftwidth=4
	let python_highlight_all = 1
	highlight default link LinuxError ErrorMsg

	syntax match LinuxError / \+\ze\t/     " spaces before tab
	syntax match LinuxError /\s\+$/        " trailing whitespaces
	syntax match LinuxError /\%121v.\+/    " virtual column 121 and more
endfunction

if has("autocmd")
	autocmd FileType c,cpp,h,hh call KRIndent()
	autocmd FileType python call PythonIndent()
endif
