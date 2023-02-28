source "$XDG_CONFIG_HOME/zsh/aliases"

# +------------+
# | NAVIGATION |
# +------------+

setopt AUTO_CD # Go to folder path without using cd.
setopt AUTO_PUSHD # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.
setopt CORRECT    # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
setopt AUTO_PARAM_SLASH
unsetopt CASE_GLOB

# +---------+
# | HISTORY |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -U compinit; compinit

# Autocomplete hidden files
_comp_options+=(globdots)
source ~/dotfiles/wsl2/zsh/external/completion.zsh

fpath=($ZDOTDIR/external $fpath)

autoload -Uz prompt_purification_setup; prompt_purification_setup

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using pushd or popd
setopt PUSHD_SILENT

bindkey -v
export KEYTIMEOUT=1

autoload -Uz cursor_mode && cursor_mode

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source ~/dotfiles/wsl2/zsh/external/bd.zsh

source $DOTFILES/wsl2/zsh/scripts.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# +---------+
# | Startup |
# +---------+
if [[ "$(tty)" = "/dev/tty1" ]];
then
    pgrep i3 || exec ssh-agent startx "$XDG_CONFIG_HOME/X11/xinitrc"
else
    ftmuxp
fi

#
# This line should be on the bottom
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
