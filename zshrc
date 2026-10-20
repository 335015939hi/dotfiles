
##### Basic Options and settings #####

export SHELL="/usr/bin/zsh"

source ~/.profile
source ~/.aliases

setopt histignorealldups

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;2D' backward-word
bindkey '^[[1;2C' forward-word
bindkey "^[[3~" delete-char

HISTSIZE=67108864
SAVEHIST=65536
if [ -z "$HISTFILE" ];then 
  HISTFILE=~/.zsh_history
fi

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'



##### Completion engine #####

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' format '[-%d-]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu yes=0 select=0
zstyle ':completion:*' prompt 'Correction'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

zmodload -i zsh/complist
# Shift-Tab: previous completion
bindkey -M menuselect $'\e[Z' reverse-menu-complete
# Completion menu navigation
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# Escape & ctrl-C: cancel menu selection
bindkey -M menuselect $'\e' send-break
bindkey -M menuselect '^C' send-break



##### External tools & plugins #####

export DEJA_HIGHLIGHT_STYLE='fg=5'
export DEJA_CYCLE_KEY='Ctrl+Tab'
export DEJA_TOGGLE_KEY=
export DEJA_CYCLE_FUZZY_KEY=
export DEJA_CYCLE_FUZZY_BACK_KEY=
export DEJA_TOGGLE_EMPTY_KEY=
export DEJA_ACCEPT_KEY=
export DEJA_WORD_ACCEPT_KEY=
export DEJA_DISMISS_KEY=

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=white'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
ZSH_HIGHLIGHT_STYLES[default]='fg=white'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=white'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=white'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=white'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=white'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=white'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[string]='fg=green'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
  source "$HOME/.local/share/deja/init.zsh"
else
  eval "$(deja init zsh)"
fi

eval "$(starship init zsh)"

command_not_found_handler() {
  command-not-found "$1"
}

source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

