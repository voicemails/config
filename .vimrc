set noswapfile
set ttimeoutlen=0

filetype plugin on
filetype indent on

set expandtab
set autoindent
set tabstop=4
set shiftwidth=4

set hidden
set backspace=start,indent,eol

set wildmenu

packadd termdebug
set makeprg=make

runtime macros/matchit.vim

function! HtmlElement()
    let l:opening = input("Tag: ")
    if strchars(l:opening) > 0
        let l:closing = split(l:opening, " ")[0]
        return ["<" . l:opening . ">", "</" . l:closing . ">"]
    endif
    return ["", ""]
endfunction

function! HtmlInline()
    let l:element = HtmlElement()
    if strchars(l:element[0]) > 0
        execute "normal! i" . l:element[0] . l:element[1]
        execute "normal! F>"
    endif
endfunction

function! HtmlMultiline()
    let l:element = HtmlElement()
    if strchars(l:element[0]) > 0
        execute "normal! i" . l:element[0] . "\n\n" . l:element[1]
        execute "normal! k"
    endif
endfunction

function! HtmlVoid()
    let l:element = HtmlElement()
    execute "normal! i" . l:element[0]
endfunction

function! HtmlSurround()
    let l:element = HtmlElement()
    let l:delimiter = ""
    if strchars(l:element[0]) > 0
        execute "normal! `<"
        let l:start = line(".")
        execute "normal! `>"
        let l:end = line(".")
        let l:linecount = abs(l:start - l:end)
        if l:linecount > 0
            let l:delimiter = "\n"
        endif
        execute "normal! a" . l:delimiter . l:element[1]
        execute "normal! `<"
        execute "normal! i" . l:element[0] . l:delimiter
        if l:linecount > 0
            execute "normal! k0V`>j=$"
        endif
    endif
endfunction

nnoremap ><lt> :call HtmlInline()<CR>
nnoremap <lt>> :call HtmlMultiline()<CR>
nnoremap <lt>. :call HtmlVoid()<CR>
vnoremap . <Esc>:call HtmlSurround()<CR>

nnoremap _ :set spell!<CR>

syntax on
set background=dark

highlight clear Normal
highlight clear Comment
highlight clear Constant
highlight clear Identifier
highlight clear Statement
highlight clear PreProc
highlight clear Type
highlight clear Special
highlight clear Underlined
highlight clear Ignore
highlight clear Error
highlight clear Todo
highlight clear Search

highlight Comment ctermfg=Gray
highlight link Todo Comment

set hlsearch
set incsearch
highlight Search ctermfg=White ctermbg=DarkGray
