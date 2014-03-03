
function! folde#styles#powerline#Formatter(p)
  return folde#format('—— ' . a:p.feature_text . ' ', '—', ' :' . a:p.linecount . ' ——')
endfunction

function! folde#styles#powerline#set_style()
  let g:folde_style='powerline'
  let g:Folde_Formatter_Function = function("folde#styles#powerline#Formatter")
endfunction

