"
"  PS1 Feature Extractor
"

function! folde#extractors#ps1#extract_synopsis()
    let lines = join(getline(v:foldstart, v:foldend), "\n")
    let sub = substitute( lines, '\s\{-}\(<#\).*\.[Ss][Yy][Nn][Oo][Pp][Ss][Ii][Ss]\_.\{-}\(\w[^\x0]*\).*', '\2', '' )
    "                             space (non-greedy)
    "                                     <#
    "                                         Anything
    "                                            .Synopsis (case insensitive)
    "                                                                             space (non-greedy)
    "                                                                                     word character
    "                                                                                         Anything but NUL
    "                                                                                                anything

    if sub == lines
      let sub = getline(v:foldstart)
    endif
    return sub
endfunction

function! folde#extractors#ps1#extract()
    if folde#generic#is_c_bracket_feature()
      return folde#generic#extract_c_bracket_feature()
    end

    let start_text = Folde_Initial_Chars(getline(v:foldstart))
    let start_text = Folde_Trim_Right(start_text)

    let feature_text = ''
    if match( start_text, '^\s*<#.*$' ) == 0
        let feature_text = folde#extractors#ps1#extract_synopsis()
    else
        let feature_text = folde#generic#extract_comment_feature()
    endif

    let params = { 'start_text': l:start_text, 'feature_text': l:feature_text }
    return l:params
endfunction

