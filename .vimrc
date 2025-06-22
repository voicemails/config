set ttimeoutlen=0

filetype plugin on
filetype indent on

set expandtab
set autoindent
set tabstop=4
set shiftwidth=4

set hidden
set backspace=start,indent,eol

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
nnoremap ><lt> :call HtmlInline()<CR>

function! HtmlMultiline()
    let l:element = HtmlElement()
    if strchars(l:element[0]) > 0
        execute "normal! i" . l:element[0] . "\n\n" . l:element[1]
        execute "normal! k"
    endif
endfunction
nnoremap <lt>> :call HtmlMultiline()<CR>

function! HtmlVoid()
    let l:element = HtmlElement()
    execute "normal! i" . l:element[0]
endfunction
nnoremap <lt>. :call HtmlVoid()<CR>

function! HtmlSurround()
    let l:element = HtmlElement()
    if strchars(l:element[0]) > 0
        execute "normal! `>"
        execute "normal! a" . l:element[1]
        execute "normal! `<"
        execute "normal! i" . l:element[0]
    endif
endfunction
vnoremap . <Esc>:call HtmlSurround()<CR>
