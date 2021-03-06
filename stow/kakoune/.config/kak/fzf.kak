def add-jump-targets \
-docstring 'open a new scratch buffer listing jump targets' \
-params 2 \
-file-completion \
%{ eval %sh{
  if [[ "$kak_buflist" =~ '*jump*' ]]; then
    echo 'edit -scratch *jump*'
    echo 'exec gjo<ret><esc>'
  else
    echo 'edit -scratch *jump*'
    echo 'map buffer normal <ret> :jump-file-target<ret>'
  fi
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  printf 'exec "i# %s [%s]<ret><esc>"\n' "$1" "$timestamp"
  printf 'exec "!cat %s<ret>"\n' "$2"
}}

def jump-file-target \
-docstring 'jump to the file target under the cursor' \
%{
  exec '<space>;xHs^[^#].*$<ret>'
  eval %sh{
    if [[ "$kak_selection" =~ ':' ]]; then
      F=$(cut -d ':' -f 1 <<< "$kak_selection")
      L=$(cut -d ':' -f 2 <<< "$kak_selection")
      printf 'edit -existing "%s" "%s"\n' "$F" "$L"
    else
      printf 'edit -existing "%s"\n' "$kak_selection"
    fi
  }
}

def jump-buffer -docstring 'jump to buffer using fzf' %{ eval %sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
  tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
  mkfifo "$in" "$out"
  (printf '%s\n' $kak_buflist | sed -e "s/^'//" -e "s/'$//" > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf --multi < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [[ ! -n "$RESULT" ]]; then exit; fi
  lines=$(wc -l  <<< "$RESULT" | awk '{print $1}')
  if [[ "$lines" -eq 1 ]]; then
    printf 'buffer "%s"\n' "$RESULT"
  elif [[ "$lines" -gt 1 ]]; then
    list="$tmp/list"
    printf '%s' "$RESULT" > "$list"
    printf 'add-jump-targets "Buffers" %s\n' "$list"
  fi
}}

def jump-file -docstring 'jump to file using fzf' %{ eval %sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
  tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
  mkfifo "$in" "$out"
  (ag --nogroup --nocolor --hidden --ignore '.git' --files-with-matches '' > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf --multi < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [[ ! -n "$RESULT" ]]; then exit; fi
  lines=$(wc -l  <<< "$RESULT" | awk '{print $1}')
  if [[ "$lines" -eq 1 ]]; then
    printf 'edit "%s"\n' "$RESULT"
  elif [[ "$lines" -gt 1 ]]; then
    list="$tmp/list"
    printf '%s' "$RESULT" > "$list"
    printf 'add-jump-targets Files %s\n' "$list"
  fi
}}

def jump-line -docstring 'jump to line using fzf' %{ eval %sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
  tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
  mkfifo "$in" "$out"
  (ag --nogroup --nocolor --hidden --ignore '.git' '^.*$' > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf --multi < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [[ ! -n "$RESULT" ]]; then exit; fi
  lines=$(wc -l  <<< "$RESULT" | awk '{print $1}')
  if [[ "$lines" -eq 1 ]]; then
    F=$(cut -d ':' -f 1 <<< "$RESULT")
    L=$(cut -d ':' -f 2 <<< "$RESULT")
    printf 'edit "%s" "%s"\n' "$F" "$L"
  elif [[ "$lines" -gt 1 ]]; then
    list="$tmp/list"
    printf '%s' "$RESULT" > "$list"
    printf 'add-jump-targets Lines %s\n' "$list"
  fi
}}
