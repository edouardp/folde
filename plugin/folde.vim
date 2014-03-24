"
"  Folde.vim
"
"    Vim folding plugin
"    ------------------
"    TODO: support for styles (lefty, righty)
"    TODO: support for filetype based feature extraction for multiline comments etc
"

function! Folde_Generic_Comment_Extractor()
  return folde#generic#extract_comment_feature()
endfunction


function! Folde_CSharpXMLDocComment_Extractor()

endfunction



if !exists('g:folde_style')
    let g:folde_style = 'simple'
endif

function! Folde_Initial_Chars(input_string)
    return substitute(a:input_string, '^\(\s*[^0-9A-Za-z_ ]*\).*$', '\1', 'g')
    "return substitute(a:input_string, '^\s*\([^0-9A-Za-z_ ]*\).*$', '\1', 'g')
endfunction

function! Folde_Trim(input_string)
    " Credit: http://stackoverflow.com/questions/4478891
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! Folde_Trim_Right(input_string)
    return substitute(a:input_string, '^\(.\{-}\)\s*$', '\1', '')
endfunction

" No Foldlevel
" --| Feature Text |--------------------------------------| 26 Lines |--

" With Foldlevel in Foldtext
" +---| Feature Text |--------------------------------------| 26 Lines |--
" ++--| Feature Text |--------------------------------------| 26 Lines |--

" Substitute Variables (plus formatting)
" +{level:5l-}-| {text} |--{expand:-}--| {lines:3r} Lines |--

" Substitute Functions
" --| {FuncOne()} |--{expand}--| {FuncTwo()} Lines |--

" --/ 4 /---/ Now is the witer of our discontent /---------------/ Blah / --



" {text}


" Left side items | Expando-center | Right side items




function! Folde_Exe(command)
  let save_a = @a
  try
    silent! redir @a
    silent! exe a:command
    redir END
  finally
    " Always restore everything
    let res = @a
    let @a = save_a
    return res
  endtry
endfunction


function! Folde_Format(left, center, right)
    let window_text_width = winwidth(0) - getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' ) - getwinvar( 0, '&foldcolumn' )
    let sign_width = 0
    let signs = Folde_Exe('sign place buffer='.bufnr('%'))
    if( strlen(substitute(signs, '[^\n]', '', 'g')) > 2 )
        let sign_width = 2
    endif
    let pad_width = window_text_width - strlen(a:left) - strlen(a:right) - sign_width

    return a:left . repeat(a:center, pad_width) . a:right
endfunction


function! Folde_Formatter(params)
    if !exists('g:Folde_Formatter_Function')
        if exists('g:folde_style')
            call <sid>folde_set_style(g:folde_style)
        endif
    endif

    if exists('g:Folde_Formatter_Function')
        return g:Folde_Formatter_Function(a:params)
    endif
endfunction


" Set a nicer foldtext function
set foldtext=Folde_Generator()
function! Folde_Generator()
    let start_text = Folde_Initial_Chars(getline(v:foldstart))
    let start_text = Folde_Trim_Right(start_text)
    "echo '>' . start_text . '<'

    " Feature Extraction
    let ftype = &ft
    "echo "ftype = " . ftype
    try
      let params = folde#extractors#{l:ftype}#extract()
    catch
      let start_text = getline(v:foldstart)
      let feature_text = start_text
      let params = { 'start_text': l:start_text, 'feature_text': l:feature_text }
    endtry

    " Styling
    let linecount = v:foldend - v:foldstart + 1

    let params.dashes = v:folddashes
    let params.level = v:foldlevel
    let params.linecount = linecount

    return Folde_Formatter(l:params)
endfunction



" -- FoldeStyle -------

function! s:get_folde_styles(a, l, p)
  let files = split(globpath(&rtp, 'autoload/folde/styles/'.a:a.'*'), "\n")
  return map(files, 'fnamemodify(v:val, ":t:r")')
endfunction

function! s:folde_set_style(...)
  if a:0
    call folde#set_folde_style(a:1)
  else
    echo g:folde_style
  endif
endfunction

command! -nargs=? -complete=customlist,<sid>get_folde_styles FoldeStyle call <sid>folde_set_style(<f-args>)


