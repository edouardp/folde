

function! folde#styles#simple#Formatter(params)
  let r = a:params.linecount . ' lines '  
  echo ">" . a:params.start_text . "< >" . a:params.feature_text . "<"

  " TODO: Fix this mess.
  if a:params.start_text != a:params.feature_text && a:params.start_text != '' 
    let l = a:params.start_text . ' ' . a:params.feature_text
  else
    let l = a:params.feature_text
  endif
  return folde#format(l, ' ', r)
endfunction

function! folde#styles#simple#set_style()
  let g:folde_style='simple'
  let g:Folde_Formatter_Function = function("folde#styles#simple#Formatter")
endfunction



