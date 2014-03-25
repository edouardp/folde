"
"  C# Extractor Functions
"

function! folde#extractors#cs#extract_summary()
    let linenum = v:foldstart
    while linenum < v:foldend
      let line = getline( linenum )
      if match( line, '^.*<summary>.*</summary>.*$' ) == 0
        return substitute( line, '^.*<summary>\s*\(.*\)</summary>.*$', '\1', 'g' )
      end
      if match( line, '^.*<summary>\s*$' ) == 0
        let line = getline( linenum + 1 )
        return substitute( line, '^\s*/*\s*\(.*\)$', '\1', 'g' )
      end
      if match( line, '^.*<summary>\s*.*$' ) == 0
        let line = getline( linenum )
        return substitute( line, '^.*<summary>\s*\(.*\)$', '\1', 'g' )
      end
      if match( line, '^.*@brief\s*.*$' ) == 0
        let line = getline( linenum )
        return substitute( line, '^.*@brief\s*\(.*\)$', '\1', 'g' )
      end
      if match( line, '^.*\\brief\s*.*$' ) == 0
        let line = getline( linenum )
        return substitute( line, '^.*\\brief\s*\(.*\)$', '\1', 'g' )
      end
      let linenum = linenum + 1
    endwhile

    return ''
endfunction


function! folde#extractors#cs#extract()
    if folde#generic#is_c_bracket_feature()
      return folde#generic#extract_c_bracket_feature()
    end

    let start_text = Folde_Initial_Chars(getline(v:foldstart))
    let start_text = Folde_Trim_Right(start_text)

    let feature_text = ''
    if match( start_text, '^\s*\(///\|/\*\*\|/\*!\).*$' ) == 0
        let feature_text = folde#extractors#cs#extract_summary()
        let start_text = substitute(start_text, '^\(\s*\)\(///\|/\*\*\|/\*!\).*$', '\1\2', 'g')
        if feature_text == ''
            return folde#generic#extract_comment_feature()
        end
    else
        return folde#generic#extract_comment_feature()
    endif

    let params = { 'start_text': l:start_text, 'feature_text': l:feature_text }
    return l:params
endfunction

