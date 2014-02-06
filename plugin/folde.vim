"
"  Folde.vim
"
"    Vim folding plugin
"    ------------------
"    TODO: support for styles (lefty, righty)
"    TODO: support for filetype based feature extraction for multiline comments etc
"


function! Folde_PS1_Extractor()
    let lines = join(getline(v:foldstart, v:foldend), "\n")
    let sub = substitute( lines, '\s\{-}\(<#\).*\.[Ss][Yy][Nn][Oo][Pp][Ss][Ii][Ss]\_.\{-}\(\w[^\x0]*\).*', '\2', '' )
    "                             space (non-greedy)
    "                                     <#
    "                                         Anything
    "                                            .Synopsis (case insensitive)
    "                                                                             space (non-greedy)
    "                                                                                     word character
    "                                                                                         Anything but NUL
    "                                                                                                anything
    "                                                                             

    if sub == lines
      let sub = getline(v:foldstart)
    endif
    return sub
endfunction 

let g:folde_style = 'lefty'
let g:folde_style = 'vim'
let g:folde_style = 'righty'
let g:folde_style = 'hard_right'
let g:folde_style = 'testing'


function! Folde_Trim(input_string)
    " Credit: http://stackoverflow.com/questions/4478891
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction


" No Foldlevel
" --| Feature Text |--------------------------------------| 26 Lines |--

" With Foldlevel in Foldtext
" +---| Feature Text |--------------------------------------| 26 Lines |--
" ++--| Feature Text |--------------------------------------| 26 Lines |--

" Substitute Variables (plus formatting)
" +{level:5l-}-| {text} |--{expand:-}--| {lines:3r} Lines |--

" Substitute Functions
" --| {FuncOne()} |--{expand}--| {FuncTwo()} Lines |-- 



" {text}


" Left side items | Expando-center | Right side items




function! Folde_Exe(command)
  let save_a = @a
  try 
    silent! redir @a
    silent! exe a:command
    redir END
  finally
    " Always restore everything
    let res = @a
    let @a = save_a
    return res
  endtry
endfunction


function! Folde_Format(left, center, right)
    let window_text_width = winwidth(0) - getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' ) - getwinvar( 0, '&foldcolumn' )
    let sign_width = 0
    let signs = Folde_Exe('sign place buffer='.bufnr('%'))
    if( strlen(substitute(signs, '[^\n]', '', 'g')) > 2 )
        let sign_width = 2
    endif
    let pad_width = window_text_width - strlen(a:left) - strlen(a:right) - sign_width
    
    return a:left . repeat(a:center, pad_width) . a:right
endfunction


function! Folde_Formatter(dashes, level, linecount, start_text, feature_text)
    if g:folde_style == 'testing'
        return '--| dashes: ' . v:folddashes . ' | level: ' . v:foldlevel . ' | lines: ' . a:linecount . ' | ' . a:start_text . ' | ' . a:feature_text . ' |'
    endif

    if g:folde_style == 'righty'
        let linecount_text = "   " . a:linecount . " lines " 
        let padded_feature_text = a:start_text . ' ' . a:feature_text . repeat(' ', 240)

        let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
        let fold_w = getwinvar( 0, '&foldcolumn' )
        let padded_feature_text = strpart( padded_feature_text, 0, winwidth(0) - strlen( linecount_text ) - num_w - fold_w )
        return padded_feature_text . linecount_text 
    endif

    if g:folde_style == 'test2'
        return Folde_Format('--| Left |', '-', '| Right |--')
    endif
endfunction 


" Set a nicer foldtext function
set foldtext=Folde_Generator()
function! Folde_Generator()
    let start_text = Folde_Trim(getline(v:foldstart))

    " Feature Extraction
    let feature_text = ''
    if match( start_text, '^<#.*$' ) == 0
        let feature_text = Folde_PS1_Extractor()
    endif

    if feature_text == ''
        let feature_text = start_text
    endif

    " Styling
    let linecount = v:foldend - v:foldstart + 1

    return Folde_Formatter(v:folddashes, v:foldlevel, linecount, start_text, feature_text)
endfunction 


