

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
  echo "Folde Style: " . g:folde_style
endfunction


