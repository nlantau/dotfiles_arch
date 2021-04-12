# nlantau .zshrc 

# Source aliases, fzf (incl. functions)
[ -f "${ZDOTDIR}/aliasrc" ] && source "${ZDOTDIR}/aliasrc"
#[ -f "${XDG_CONFIG_HOME}/fzf/.fzf.zsh" ] && source "${XDG_CONFIG_HOME}/fzf/.fzf.zsh"

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
autoload -U colors && colors		# Colored prompt output
autoload -Uz vcs_info				# Git prompt 
precmd() { vcs_info } 

# vi mode
bindkey -v

# Add ~/.config/functions/ to fpath
fpath=($HOME/.config/functions $fpath)
autoload ez #fa fd fdr ff gacp gs s38 s39

# setopt
setopt PROMPT_SUBST
#setopt autocd

# PS1 & RPS1
PROMPT="λ %F{green}%1~ %f> "
RPROMPT='${vcs_info_msg_0_}' 




