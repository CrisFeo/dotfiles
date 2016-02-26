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


# Settings
prompt-width() {
  tput cols
}


# Prompt Segments
prompt-segment-git() {
  branch="$(git-current-branch)"
  if [ "$branch" != "" ]; then
	  echo "┤($(prompt-color-git)$(prompt-color-fg)) $(prompt-color-git)$branch$(prompt-color-fg) ├"
  fi
}

prompt-segment-jobs() {
  jobs=$(jobs | wc -l | cut -b 8)
  if [ "$jobs" != "0" ]; then
    echo "┤($(prompt-color-jobs)J$(prompt-color-fg)) $(prompt-color-jobs)$jobs$(prompt-color-fg) ├"
  fi
}

prompt-segment-exit-code() {
  if [ "$EXIT_CODE" != 0 ]; then
	  echo "┤($(prompt-color-failure)!$(prompt-color-fg)) $(prompt-color-failure)${EXIT_CODE}$(prompt-color-fg) ├─"
  fi
}


# Prompts
prompt-full() {
  echo '$(prompt-color-fg)┌─$(prompt-segment-jobs)$(prompt-segment-exit-code)$(prompt-segment-git)─┤($(prompt-color-cd)$(prompt-color-fg)) $(prompt-color-cd)\w\n\[$(prompt-color-fg)\]└─►\[$(prompt-color-reset)\] '
}


prompt-small() {
  echo '$(prompt-color-fg)┌╸$(prompt-color-cd)\w\n\[$(prompt-color-fg)\]└╸\[$(prompt-color-reset)\]'
}


# Rendering
prompt-command() {
  export EXIT_CODE="$?"
  if [ "$(tput cols)" -lt '80' ]; then
    PS1=$(prompt-small)
  else
    PS1=$(prompt-full)
  fi
}

PROMPT_COMMAND='prompt-command'
