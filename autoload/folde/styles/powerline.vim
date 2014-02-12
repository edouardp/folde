
function! folde#styles#powerline#Formatter()
  return folde#format('—— Left ', '—', ' :10 ——')
endfunction

function! folde#styles#powerline#set_style()
  let g:folde_style='powerline'
  let g:Folde_Formatter_Function = function("folde#styles#powerline#Formatter")
endfunction

