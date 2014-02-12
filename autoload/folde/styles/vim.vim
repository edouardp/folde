
function! folde#styles#vim#Formatter()
  return folde#format('--  4 lines folded ', '-', '')
endfunction

function! folde#styles#vim#set_style()
  let g:folde_style='vim'
  let g:Folde_Formatter_Function = function("folde#styles#vim#Formatter")
endfunction

