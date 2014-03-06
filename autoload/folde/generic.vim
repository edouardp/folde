"
"
"

function! folde#generic#extract_comment_feature()
  let linenum = v:foldstart
  while linenum < v:foldend
    let line = getline( linenum )
    let comment_content = substitute( line, '^\(\W*\)\(.*\)\(\W*\)$', '\2', 'g' )
    if comment_content != ''
      " Strip trailing non-word content
      let comment_content = substitute( comment_content, '\W*$', '', '' )
      break
    endif
    let linenum = linenum + 1
  endwhile
  return comment_content
endfunction

