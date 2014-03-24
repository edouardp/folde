"
"  C# Extractor Functions
"

function! folde#extractors#cs#extract_summary()
    let linenum = v:foldstart
    while linenum < v:foldend
      let line = getline( linenum )
      if match( line, '^\s*///\s*<summary>.*</summary>.*$' ) == 0
        return substitute( line, '^\s*///\s*<summary>\(.*\)</summary>.*$', '\1', 'g' )
      end
      if match( line, '^\s*///\s*<summary>.*$' ) == 0
        let line = getline( linenum + 1 )
        return substitute( line, '^\s*/*\s*\(.*\)$', '\1', 'g' )
      end
      let linenum = linenum + 1
    endwhile

    return getline( linenum )
endfunction


function! folde#extractors#cs#extract()
    if folde#generic#is_c_bracket_feature()
      return folde#generic#extract_c_bracket_feature()
    end

    let start_text = Folde_Initial_Chars(getline(v:foldstart))
    let start_text = Folde_Trim_Right(start_text)

    let feature_text = ''
    if match( start_text, '^\s*///.*$' ) == 0
        let feature_text = folde#extractors#cs#extract_summary()
    else
        let feature_text = folde#generic#extract_comment_feature()
    endif

    let params = { 'start_text': l:start_text, 'feature_text': l:feature_text }
    return l:params
endfunction

