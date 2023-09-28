#!/bin/zsh

compress() {
    tar czvf $1.tar.gz $1
}

# ftmuxp - propose every possible tmuxp session
ftmuxp() {
    if [[ -n $TMUX ]]; then
        return
    fi

    # get the IDs
    ID="$(ls $XDG_CONFIG_HOME/tmuxp | sed -e 's/\.yml$//')"
    if [[ -z "$ID" ]]; then
        tmux new-session
    fi

    create_new_session="Create New Session"

    ID="${create_new_session}\n$ID"
    ID="$(echo $ID | fzf | cut -d: -f1)"

    if [[ "$ID" = "${create_new_session}" ]]; then
        tmux new-session
    elif [[ -n "$ID" ]]; then
        # Change name of urxvt tab to session name
        printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
        tmuxp load "$ID"
    fi
}

jrnl() {
    if [[ ! $1 ]]; then
        year=$(date '+%Y')
        month=$(date '+%m')
        day=$(date '+%d')
    else
        year=$(date --date="$1 day" '+%Y')
        month=$(date --date="$1 day" '+%m')
        day=$(date --date="$1 day" '+%d')
    fi

    template="* JOURNAL - $year/$month/$day

** Worklog

DEVBRIMVP-1 = External Meetings
DEVBRIMVP-2 = Internal Meetings
DEVBRIMVP-3 = Sprint Work

** Notes
    "

    if [[ ! -d "$HOME/journal/$year/$month" ]]; then
        mkdir -p "$HOME/journal/$year/$month"
    fi

    if [[ ! -f "$HOME/journal/$year/$month/$day.md" ]]; then
        touch "$HOME/journal/$year/$month/$day.md" 
        echo $template >> "$HOME/journal/$year/$month/$day.md" 
    fi

    nvim "$HOME/journal/$year/$month/$day.md" 
}
