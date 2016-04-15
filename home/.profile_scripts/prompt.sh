#! /bin/bash

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

prompt-color-jobs() {
  prompt-color-reset
  tput setaf 5
}

prompt-color-cd() {
  prompt-color-reset
  tput setaf 3
}

prompt-color-failure() {
  prompt-color-reset
  tput setaf 1
}


# Prompt Segments

render-segment() {
  color=$1
  icon=$2
  value=$3
  printf '┤(%s%s%s) %s%s%s ├─' "$($color)"          \
                               "$icon"              \
                               "$(prompt-color-fg)" \
                               "$($color)"          \
                               "$value"             \
                               "$(prompt-color-fg)"

}

prompt-segment-git() {
  branch="$(git-current-branch)"
  if [ "$branch" != "" ]; then
    render-segment "prompt-color-git" "" "$branch"
  fi
}

prompt-segment-jobs() {
  jobs="$(jobs | wc -l | cut -b 8)"
  if [ "$jobs" != "0" ]; then
    render-segment "prompt-color-jobs" "" "$jobs"
  fi
}

prompt-segment-exit-code() {
  if [ "$EXIT_CODE" != 0 ]; then
    render-segment "prompt-color-failure" "" "$EXIT_CODE"
  fi
}

prompt-segment-cd() {
printf '┤(%s%s) %s%s%s' "$(prompt-color-cd)" \
                         "$(prompt-color-fg)" \
                         "$(prompt-color-cd)" \
                         '\w' \
                         "$(prompt-color-fg)"
}


# Prompts
prompt-full() {
  segments="$(prompt-segment-jobs &&      \
              prompt-segment-exit-code && \
              prompt-segment-git &&       \
              prompt-segment-cd)"
  printf '%s┌─%s\n\[%s\]└─►\[%s\] '  "$(prompt-color-fg)"    \
                                     "$segments"             \
                                     "$(prompt-color-fg)"    \
                                     "$(prompt-color-reset)"
}


prompt-small() {
  printf '%s┌╸%s%s\n\[%s\]└╸\[%s\]' "$(prompt-color-fg)"    \
                                    "$(prompt-color-cd)"    \
                                    '\w'                    \
                                    "$(prompt-color-fg)"    \
                                    "$(prompt-color-reset)"
}


# Rendering
prompt-command() {
  export EXIT_CODE="$?"
  if [ "$(tput cols)" -lt '80' ]; then
    PS1="$(prompt-small)"
  else
    PS1="$(prompt-full)"
  fi
}

PROMPT_COMMAND='prompt-command'
