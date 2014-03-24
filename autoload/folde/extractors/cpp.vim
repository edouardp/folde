"
"  C++ Extractor Functions
"

function! folde#extractors#cpp#extract()
  if folde#generic#is_c_bracket_feature()
    return folde#generic#extract_c_bracket_feature()
  end

  return folde#generic#extract_comment_feature()
endfunction

