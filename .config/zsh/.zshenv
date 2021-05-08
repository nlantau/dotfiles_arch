#!/usr/bin/zsh

# Default programs
export EDITOR="vim"
export VISUAL="vim"

# XDG Base Directory 
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# Zsh environment variables
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# Special
export DROPBOXDIR="$HOME/Dropbox"
export GITHUBDIR="$HOME/Github"
export VIRENVDIR="$HOME/.virtualenvs"
export SCHOOLDIR="$DROPBOXDIR/Skola/7_mot_ingenjor/1_Current"

# Vim
export MYVIMRC="$HOME/.vimrc"

# Ranger
export RANGER_LOAD_DEFAULT_RC=false
export TERM=xterm-256color

# Java - Some bug
export _JAVA_AWT_WM_NONREPARENTING=1

# Bat Manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"


