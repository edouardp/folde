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




function! Folde_Formatter(linecount, start_text, feature_text)
    if g:folde_style == 'testing'
        return '--| ' . a:linecount . ' | ' . a:start_text . ' | ' . a:feature_text . ' |'
    endif

    if g:folde_style == 'righty'
        let linecount_text = "   " . a:linecount . " lines " 
        let padded_feature_text = a:start_text . ' ' . a:feature_text . repeat(' ', 240)

        let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
        let fold_w = getwinvar( 0, '&foldcolumn' )
        let padded_feature_text = strpart( padded_feature_text, 0, winwidth(0) - strlen( linecount_text ) - num_w - fold_w )
        return padded_feature_text . linecount_text 
    endif
endfunction 


" Set a nicer foldtext function
set foldtext=Folde_Generator()
function! Folde_Generator()
    let start_text = getline(v:foldstart)

    let feature_text = ''

    " Feature Extraction
    if match( start_text, '^<#.*$' ) == 0
        let feature_text = Folde_PS1_Extractor()
    endif

    if feature_text == ''
        let feature_text = start_text
    endif

    " Styling
    let linecount = v:foldend - v:foldstart + 1

    return Folde_Formatter(linecount, start_text, feature_text)
endfunction 



