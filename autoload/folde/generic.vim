"
"
"

function! folde#generic#first_line()
endfunction

function! folde#generic#last_line()
endfunction

function! folde#generic#starts_with()
endfunction

function! folde#generic#ends_with()
endfunction

function! folde#generic#extract_comment_feature()
  let start_text = Folde_Initial_Chars(getline(v:foldstart))
  let start_text = Folde_Trim_Right(start_text)

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

  let params = { 'start_text': l:start_text, 'feature_text': l:comment_content }
  return l:params
endfunction


function! folde#generic#is_c_bracket_feature()
    let start_text = getline(v:foldstart)
    let start_text = Folde_Trim_Right(l:start_text)
    let end_text = getline(v:foldend)
    let end_text = Folde_Trim(l:end_text)

    if( strpart(l:start_text, len(l:start_text)-1, 1) == '{' )
        if( strpart(l:end_text, 0, 1) == '}' )
            return 1
        end
    end

    return 0
endfunction


function! folde#generic#extract_c_bracket_feature()
    let start_text = getline(v:foldstart)
    let start_text = Folde_Trim_Right(l:start_text)
    let end_text = getline(v:foldend)
    let end_text = Folde_Trim(l:end_text)

    let feature_text = l:start_text . '...' . l:end_text
    let start_text = ''
    let params = { 'start_text': l:start_text, 'feature_text': l:feature_text }
    return l:params
endfunction
