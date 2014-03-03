"
" Folde functions
"

function! folde#set_folde_style(name)
  try
    call folde#styles#{a:name}#set_style()
  catch
    echohl WarningMsg | echo 'The specified style cannot be found.' | echohl NONE
    if exists('g:folde_style')
      return
    else
      let g:folde_style = 'debug'
    endif
  endtry

  redraw!
  "echo "Folde Style: " . g:folde_style
endfunction


function! folde#init()

endfunction


function! folde#format(left, center, right)
    let window_text_width = winwidth(0) - getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' ) - getwinvar( 0, '&foldcolumn' )
    let sign_width = 0
    let signs = Folde_Exe('sign place buffer='.bufnr('%'))
    if( strlen(substitute(signs, '[^\n]', '', 'g')) > 2 )
        let sign_width = 2
    endif
    let pad_width = window_text_width - strwidth(a:left) - strwidth(a:right) - sign_width
    "echo pad_width
    return a:left . repeat(a:center, pad_width) . a:right
 endfunction


