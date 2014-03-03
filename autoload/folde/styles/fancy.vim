

function! folde#styles#fancy#Formatter(params)
  let r = '--| ' . a:params.linecount . ' lines |--'  
  let l = '--| ' . a:params.feature_text . ' |--'
  return folde#format(l, '-', r)
endfunction

function! folde#styles#fancy#set_style()
  let g:folde_style='fancy'
  let g:Folde_Formatter_Function = function("folde#styles#fancy#Formatter")
endfunction



