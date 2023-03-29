syntax on
set number
" Enable automatic indentation
set ai
set si
" Indent with 4 spaces instead of tabs
set ts=4
set expandtab

" Make searches case-insensitive
set ignorecase
" Except when uppercase letters are used in the query string
set smartcase
" Highlight search results
set hlsearch
" Select usable search highlighting colors that also work for vimdiff
hi Search cterm=NONE ctermfg=black ctermbg=yellow

" Autocomplete of brackets and parentheses...
inoremap ( ()<Esc>i
inoremap { {<CR>}<Esc>kA<CR>
inoremap [ []<Esc>i
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

" TODO: this function should also move to the end of the bracket when it isn't on the line immediately under?
function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j$a"
 endif
endf

function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf

" Git blame function, source: https://www.reddit.com/r/vim/comments/9ydreq/comment/ea1sgej/
function! s:Blame(bufnr, filename, ...)
  let view = winsaveview()
  normal! gg
  let width = get(a:000, 0, 40)
  execute 'leftabove ' . width . 'vnew'
  set buftype=nofile
  set bufhidden=wipe
  set nowrap
  set noswapfile
  execute 'autocmd BufWipeout <buffer> call setbufvar(' . a:bufnr .', "&scrollbind", 0)'
  execute 'read!git blame ' . shellescape(a:filename)
  0delete _
  set scrollbind
  wincmd p
  set scrollbind
  call winrestview(view)
endfunction
command! -count Blame call s:Blame(bufnr('%'), expand('%:p'), <f-args>)
