" =============================================================================
" matugen.vim
" A small, standalone Vim / Neovim colorscheme.
"
"this paragraph written by a human. most of this vibe-coded by chatgpt. matugen
"values written by human with help from chatgpt.
"
" Design goals:
"   - Works in Vim and Neovim
"   - No plugins
"   - Easy to hack
"   - Palette is defined in one place
"   - Every important highlight has a comment explaining its purpose
"
" To use:
"   :colorscheme matugen
"
" To make your own:
"   1. Change the colors in the PALETTE section.
"   2. Change individual highlight groups below.
"   3. Add more highlight groups as needed.
"
" =============================================================================

" -----------------------------------------------------------------------------
" Reset / setup
" -----------------------------------------------------------------------------

" highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "matugen"

" =============================================================================
" PALETTE
" =============================================================================
"
" Change colors HERE first.
"
" Keep the names semantic rather than calling them "blue1", "blue2", etc.
" That makes changing the entire theme much less painful.
"
" Format:
"   let s:name = "#RRGGBB"
"
" The GUI colors are used by both modern Vim and Neovim in GUI-capable
" terminals. The cterm values provide fallback terminal colors.
"

<* for name, value in colors *>
let s:{{ name }} = "{{ value.default.hex }}"
let s:{{ name }}_hue_plus_90 = "{{ value.default.hex | set_hue: {{value.default.hue}} + 90 }}"
let s:{{ name }}_hue_plus_180 = "{{ value.default.hex | set_hue: {{value.default.hue}} + 180 }}"
let s:{{ name }}_hue_plus_270 = "{{ value.default.hex | set_hue: {{value.default.hue}} + 270 }}"
<* endfor *>

" --- Backgrounds -------------------------------------------------------------

let s:bg          = s:surface   " Main editor background
let s:bg_dark     = s:surface_container_low   " Darker background: statusline, folds, etc.
let s:bg_light    = s:surface_container_high   " Slightly lighter background: selections
let s:bg_float    = s:surface " Floating windows / popups

" --- Foregrounds -------------------------------------------------------------

let s:fg          = s:on_surface   " Normal text
let s:fg_dim      = s:on_surface_variant  " Secondary / less important text
let s:fg_muted    = s:on_surface_variant   " Comments, inactive text, line numbers
let s:fg_bright   = s:primary_fixed   " Strongly emphasized text



" =============================================================================
" HELPER
" =============================================================================
"
" Vim's :highlight command is intentionally verbose.
" This helper lets us write:
"
"   call s:hi("Comment", s:fg_muted, "", "italic")
"
" instead of repeating the same GUI/terminal options everywhere.
"

function! s:hi(group, fg, bg, attr) abort
  let l:cmd = "highlight " . a:group

  if a:fg !=# ""
    let l:cmd .= " guifg=" . a:fg
  endif

  if a:bg !=# ""
    let l:cmd .= " guibg=" . a:bg
  endif

  if a:attr !=# ""
    let l:cmd .= " gui=" . a:attr
  else
    let l:cmd .= " gui=NONE"
  endif

  execute l:cmd
endfunction


" =============================================================================
" CORE EDITOR UI
" =============================================================================

" Normal text and the main editor background.
call s:hi("Normal", s:fg, s:bg, "")

" Text in the sign column.
call s:hi("SignColumn", s:fg_dim, s:bg, "")

" Line numbers.
call s:hi("LineNr", s:on_surface_variant, s:bg, "")

" Current line number.
call s:hi("CursorLineNr", s:primary, s:bg, "bold")

" Current cursor line.
call s:hi("CursorLine", "", s:surface_container, "NONE")

" Current cursor column.
call s:hi("CursorColumn", "", s:surface_container, "NONE")

" Cursors
call s:hi("Cursor", s:on_primary, s:primary, "")
call s:hi("lCursor", s:primary,"" , "")

" Vertical split separators.
call s:hi("VertSplit", s:primary, s:bg, "")

" Window separator in newer Vim/Neovim versions.
call s:hi("WinSeparator", s:primary, s:bg, "")

" Folded text.
call s:hi("Folded", s:fg_dim, s:bg_light, "")

" Fold column.
call s:hi("FoldColumn", s:fg_muted, s:bg, "")

" Text selected with Visual mode.
call s:hi("Visual", s:on_primary_container, s:primary_container, "")

" Incremental search / normal search matches.
call s:hi("Search", s:on_primary_container, s:primary_container, "bold")

" Currently selected search match.
call s:hi("IncSearch", s:on_tertiary_container, s:tertiary_container, "bold")

" Matching brackets / parentheses.
call s:hi("MatchParen", s:on_surface_variant, s:surface_variant, "bold")

" Non-printing characters shown with :set list.
call s:hi("NonText", s:fg_muted, s:bg, "")

" Concealed syntax.
call s:hi("Conceal", s:fg_muted, s:bg, "")

" Directory names in :Explore / netrw.
call s:hi("Directory", s:primary, s:bg, "")


" =============================================================================
" STATUSLINE / TABLINE
" =============================================================================

" Tabline background.
call s:hi("TabLine", s:fg_dim, s:bg_dark, "")

" Selected tab.
call s:hi("TabLineSel", s:fg_bright, s:bg_light, "bold")

" Empty part of tabline.
call s:hi("TabLineFill", s:fg_muted, s:bg_dark, "")


" =============================================================================
" POPUPS / COMMAND LINE
" =============================================================================

" Completion menu.
call s:hi("Pmenu", s:on_surface_variant, s:surface_variant, "")

" Selected completion item.
call s:hi("PmenuSel", s:on_primary_container, s:primary_container, "bold")

" Scrollbar in completion menu.
call s:hi("PmenuSbar", "", s:bg_light, "")

" Thumb of completion scrollbar.
call s:hi("PmenuThumb", "", s:fg_muted, "")

" Floating windows.
call s:hi("NormalFloat", s:fg, s:bg_float, "")

" Borders around floating windows.
call s:hi("FloatBorder", s:on_primary, s:primary, "")

" Messages.
call s:hi("MsgArea", s:on_surface_variant, s:surface_variant, "")

" Command-line text.
call s:hi("ModeMsg", s:fg, s:bg, "bold")

" Error messages.
call s:hi("ErrorMsg", s:on_error_container, s:error_container, "bold")

" Warning messages.
call s:hi("WarningMsg", s:on_tertiary_container, s:tertiary_container, "bold")


" =============================================================================
" DIFF
" =============================================================================

" Added lines.
call s:hi("DiffAdd", s:on_primary_container, s:primary_container, "")
" Added file.
call s:hi("GitSignsAdd", s:on_primary_container, s:primary_container, "")

" Changed lines.
call s:hi("DiffChange", s:on_tertiary_container,s:tertiary_container, "")
" Modified file.
call s:hi("GitSignsChange", s:on_tertiary_container, s:tertiary_container, "")

" Deleted lines.
call s:hi("DiffDelete", s:on_error_container, s:error_container, "")
" Deleted file.
call s:hi("GitSignsDelete", s:on_error_container, s:error_container, "")

" Diff text inside a changed line.
call s:hi("DiffText", s:on_tertiary_container, s:tertiary_container, "bold")

" netrw directory.
call s:hi("netrwDir", s:secondary, "", "")

" =============================================================================
" DIAGNOSTICS
" =============================================================================

" Errors from the language server / syntax checker.
call s:hi("DiagnosticError", s:error, "", "")

" Warnings from the language server / syntax checker.
call s:hi("DiagnosticWarn", s:tertiary, "", "")

" Informational diagnostics.
call s:hi("DiagnosticInfo", s:fg, "", "")

" Hints from the language server.
call s:hi("DiagnosticHint", s:primary, "", "")

" Underline diagnostic errors.
call s:hi("DiagnosticUnderlineError", s:error, "", "undercurl")

" Underline diagnostic warnings.
call s:hi("DiagnosticUnderlineWarn", s:tertiary, "", "undercurl")

" Underline informational diagnostics.
call s:hi("DiagnosticUnderlineInfo", s:fg, "", "undercurl")

" Underline hints.
call s:hi("DiagnosticUnderlineHint", s:primary, "", "undercurl")


" =============================================================================
" GENERIC SYNTAX
" =============================================================================

" Comments.
call s:hi("Comment", s:fg_muted, "", "italic")

" Constants such as numbers, booleans, and special literals.
call s:hi("Constant", s:secondary, "", "")

" Strings.
call s:hi("String", s:secondary, "", "")

" Character literals.
call s:hi("Character", s:secondary, "", "")

" Numbers.
call s:hi("Number", s:secondary, "", "")

" Boolean / true / false / NULL-like values.
call s:hi("Boolean", s:secondary, "", "bold")

" Identifiers and variable names.
call s:hi("Identifier", s:primary_hue_plus_90, "", "")
call s:hi("@variable", s:primary_hue_plus_90, "", "")
call s:hi("@variable.builtin", s:primary_hue_plus_90, "", "")
" Function paramters
call s:hi("@variable.parameter",s:primary_hue_plus_90,"","")

" Function names.
call s:hi("Function", s:primary_hue_plus_270, "", "underline")
call s:hi("@lsp.typemod.function.defaultLibrary.c", s:primary_hue_plus_270, "", "underline")
" Rust macros.
call s:hi("rustMacro", s:primary_hue_plus_270, "", "underline")



" Keywords.
call s:hi("Keyword", s:primary, "", "bold")
call s:hi("@keyword", s:primary, "", "bold")
" Statements such as if, else, return, break.
call s:hi("Statement", s:primary, "", "bold")
" Operators
call s:hi("@operator",s:primary,"","")

" Types such as int, char, struct, class.
call s:hi("Type", s:primary, "", "italic")
call s:hi("@lsp.typemod.type.defaultLibrary", s:primary, "", "italic")
call s:hi("@type.builtin", s:primary, "", "italic")
call s:hi("@keyword.modifier.c", s:primary, "", "italic")
call s:hi("@keyword.type.c", s:primary, "", "italic")
" C types.
call s:hi("cType", s:primary, "", "italic")
" Rust types.
call s:hi("rustType", s:primary, "", "italic")
" C storage classes such as static / extern.
call s:hi("cStorageClass", s:primary, "", "italic")


" Preprocessor directives such as #include and #define.
call s:hi("PreProc", s:primary_hue_plus_90, "", "")
" C preprocessor directives.
call s:hi("cPreProc", s:primary_hue_plus_90, "", "")

" Special language constructs.
call s:hi("Special", s:primary, "", "")
call s:hi("@punctuation.special", s:primary, "", "")
" Rust lifetimes.
call s:hi("rustLifetime", s:primary, "", "")

" Special characters such as escapes.
call s:hi("SpecialChar", s:on_surface_variant, "", "")

" Errors identified by Vim syntax highlighting.
call s:hi("Error", s:on_error, s:error, "bold")

" Todo / FIXME / NOTE markers.
call s:hi("Todo", s:on_tertiary, s:tertiary, "bold")
call s:hi("TodoBgHack", s:on_tertiary, s:tertiary, "bold")


" =============================================================================
" HTML / MARKUP
" =============================================================================

" HTML/XML tags.
call s:hi("Tag", s:primary, "", "")

" HTML/XML attributes.
call s:hi("Attribute", s:secondary, "", "")

" Markdown headings.
call s:hi("markdownHeadingDelimiter", s:primary, "", "bold")

" Markdown links.
call s:hi("markdownLinkText", s:tertiary, "", "underline")

" Markdown code.
call s:hi("markdownCode", s:on_surface_variant, s:surface_variant, "")


" =============================================================================
" TERMINAL COLORS
" =============================================================================
"
" These are useful when Vim is running in a terminal with limited color
" support. They are intentionally simple and map the palette to the
" conventional ANSI colors.
"

let s:ansi_black   = 0
let s:ansi_red     = 1
let s:ansi_green   = 2
let s:ansi_yellow  = 3
let s:ansi_blue    = 4
let s:ansi_magenta = 5
let s:ansi_cyan    = 6
let s:ansi_white   = 7

" Basic terminal fallbacks.
execute "highlight Comment ctermfg=" . s:ansi_black . " cterm=italic"
execute "highlight String ctermfg=" . s:ansi_green
execute "highlight Number ctermfg=" . s:ansi_yellow
execute "highlight Function ctermfg=" . s:ansi_blue . " cterm=bold"
execute "highlight Keyword ctermfg=" . s:ansi_magenta . " cterm=bold"
execute "highlight Type ctermfg=" . s:ansi_cyan . " cterm=bold"
execute "highlight Error ctermfg=" . s:ansi_white . " ctermbg=" . s:ansi_red . " cterm=bold"
execute "highlight Todo ctermfg=" . s:ansi_black . " ctermbg=" . s:ansi_yellow . " cterm=bold"


" =============================================================================
" OPTIONAL: TERMINAL TRUECOLOR
" =============================================================================
"
" Neovim and modern Vim can use truecolor terminals.
"
" If your terminal supports it, this gives the GUI hex colors above priority.
"

if has("termguicolors")
  set termguicolors
endif


" =============================================================================
" END
" =============================================================================
"
" The most useful commands while hacking this:
"
"   :hi Normal
"   :hi Comment
"   :hi Function
"
" To see what a piece of text actually uses:
"
"   :Inspect
"
" (Neovim only; Vim does not have this command.)
"
" In Vim, :syntax list and :hi are your friends.
"
" =============================================================================

