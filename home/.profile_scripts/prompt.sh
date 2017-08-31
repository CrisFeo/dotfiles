#!/usr/bin/env bash

## Colors
####################

prompt-color-reset() {
  tput sgr0
}

prompt-color-git() {
  prompt-color-reset
  tput setaf 2
}

prompt-color-jobs() {
  prompt-color-reset
  tput setaf 5
}

prompt-color-cd() {
  prompt-color-reset
  tput setaf 3
}

prompt-color-fg() {
  prompt-color-reset
  if [ "$EXIT_CODE" == 0 ]; then
    tput setaf 4
  else
    tput setaf 1
  fi
}


## Rendering
####################

prompt-render-bubble() {
  prompt-color-fg
  if [ "$(jobs | grep -E '^\[\d+\]' | grep -v 'Done')" == "" ]; then
    printf '○ '
  else
    printf '◉ '
  fi
}

prompt-render-git() {
  branch="$(git-current-branch)"
  prompt-color-git
  if [ "$branch" != "" ]; then
    printf '%s«%s%s%s» ' "$(prompt-color-fg)"  \
                         "$(prompt-color-git)" \
                         "$branch"             \
                         "$(prompt-color-fg)"
  fi
}

prompt-render-cd() {
  prompt-color-cd
  printf '%s\n' "$(pwd)"
}


## Prompt command
####################

prompt-command() {
  export EXIT_CODE="$?"
  prompt-render-bubble
  prompt-render-git
  prompt-render-cd
  prompt-color-reset
  PS1=$(printf '\[%s\]» \[%s\]' "$(prompt-color-fg)" "$(prompt-color-reset)")
}

PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''prompt-command;'
