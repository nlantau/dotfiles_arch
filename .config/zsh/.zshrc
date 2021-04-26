# nlantau .zshrc 
# Modified 2021-04-26

# Source aliases, fzf (incl. functions)
[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
[ -f "$HOME/.secret" ] && source "$HOME/.secret"

# Load completions system
zmodload -i zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ":completion:*" matcher-list 'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü}'
zstyle ':completion:*' special-dirs true

# Git info
zstyle ':vcs_info:git:*' formats "%F{red}%s%f %b" 

# Auto/tab complete, colors & git prompt
autoload -Uz compinit && compinit   # Completion
autoload -U colors && colors	    # Colored prompt output
autoload -Uz vcs_info		    # Git prompt 
precmd() { vcs_info } 

# vi mode
bindkey -v

# Add ~/.config/functions/ to fpath
fpath=($HOME/.config/functions $fpath)
autoload ez ex pan 

# setopt
setopt PROMPT_SUBST

# PS1 & RPS1
PROMPT="λ %F{green}%1~ %f> "
RPROMPT='${vcs_info_msg_0_}' 

# Paths
typeset -U path
path=($XDG_CONFIG_HOME/scripts "$path[@]")
path=($HOME/connections "$path[@]")

