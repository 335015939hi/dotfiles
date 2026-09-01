export SHELL="/usr/bin/zsh"

source ~/.profile
source ~/.aliases

setopt histignorealldups

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey "^[[3~" delete-char

HISTSIZE=67108864
SAVEHIST=65536
if [ -z "$HISTFILE" ];then 
  HISTFILE=~/.zsh_history
fi


eval "$(starship init zsh)"

#if [ "$TMUX" "=" "" ];then
#	if tmux list-sessions 2>/dev/null|grep -vF '(attached)' >/dev/null 2>&1;then
#		tmux attach || tmux
#	else
#		tmux
#	fi
#fi


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' format '[-%d-]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=0
zstyle ':completion:*' prompt 'Correction'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/tony/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
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
ZSH_HIGHLIGHT_STYLES[string]='fg=green'``
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if which carapace >/dev/null 2>&1;then
  source <(carapace _carapace zsh)
fi

command_not_found_handler() {
  command-not-found "$@"
}


