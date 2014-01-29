"
"  Folde.vim
"
"    Vim folding plugin
"    ------------------
"    TODO: support for styles (lefty, righty)
"    TODO: support for filetype based feature extraction for multiline comments etc
"


function! Folde_PS1_Generator()
    let lines = join(getline(v:foldstart, v:foldend), "\n")
    let sub = substitute( lines, '\s\{-}\(<#\).*\.[Ss][Yy][Nn][Oo][Pp][Ss][Ii][Ss]\_.\{-}\(\w[^\x0]*\).*', '\1 \2', '' )
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


" Set a nicer foldtext function
set foldtext=Folde_Generator()
function! Folde_Generator()
    let line = getline(v:foldstart)

    let feature = ''

    " Feature Extraction
    if match( line, '^<#.*$' ) == 0
        let feature = Folde_PS1_Generator()
    endif

    if feature == ''
        let feature = line
    endif

    " Styling
    let n = v:foldend - v:foldstart + 1
    let info = "   " . n . " lines " 
    let feature = feature . repeat(' ', 120)

    let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    let fold_w = getwinvar( 0, '&foldcolumn' )
    let feature = strpart( feature, 0, winwidth(0) - strlen( info ) - num_w - fold_w )
    return feature . info 
endfunction 



