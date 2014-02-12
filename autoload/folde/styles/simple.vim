function! folde#styles#simple#Formatter()
  return folde#format('--  4 lines folded ', '-', '')
endfunction

function! folde#styles#simple#set_style()
  let g:folde_style='simple'
  let g:Folde_Formatter_Function = function("folde#styles#simple#Formatter")
endfunction

