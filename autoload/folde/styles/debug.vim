

function! folde#styles#debug#Formatter(params)
  return folde#format('DEBUG GOES HERE', ' ', '')
endfunction

function! folde#styles#debug#set_style()
  let g:Folde_Formatter_Function = function("folde#styles#debug#Formatter")
  let g:folde_style='debug'
endfunction

