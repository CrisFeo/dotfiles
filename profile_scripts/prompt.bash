# Colors
prompt-color-reset() {
    tput sgr0
}

prompt-color-fg() {
    prompt-color-reset
    tput setaf 4
}

prompt-color-git() {
    prompt-color-reset
    tput setaf 2
}

prompt-color-cd() {
    prompt-color-reset
    tput setaf 3
}

prompt-color-success() {
    prompt-color-reset
    tput setaf 2
}

prompt-color-failure() {
    prompt-color-reset
    tput setaf 1
}


# Prompt Segments
prompt-segment-git() {
    branch="$(git-current-branch)"
    if [ "$branch" != "" ]; then
	echo "┤($(prompt-color-git)$(prompt-color-fg)) $(prompt-color-git)$branch$(prompt-color-fg) ├"
    fi
}

prompt-segment-exit-code() {
    if [ "$EXIT_CODE" != 0 ]; then
	echo "┤($(prompt-color-failure)!$(prompt-color-fg)) $(prompt-color-failure)${EXIT_CODE}$(prompt-color-fg) ├─"
    fi
}


# Helpers
prompt-command() {
    export EXIT_CODE="$?"
}


# The complete prompt
PROMPT_COMMAND='prompt-command'
PS1='$(prompt-color-fg)┌─$(prompt-segment-exit-code)$(prompt-segment-git)─┤($(prompt-color-cd)$(prompt-color-fg)) $(prompt-color-cd)\w\n\[$(prompt-color-fg)\]└─►\[$(prompt-color-reset)\] '
