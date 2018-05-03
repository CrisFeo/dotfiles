def fzf-buffer -docstring 'jump to buffer using fzf' -allow-override %{%sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
	tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
	mkfifo "$in" "$out"
	(printf '%s\n' "$kak_buflist" | tr : '\n' > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [ -n "$RESULT" ]; then
    CMD=$(printf 'eval -client %s buffer %s\n' "$kak_client" "$RESULT")
    kak -p "$kak_session" <<< "$CMD"
  fi
}}

def fzf-file -docstring 'jump to file using fzf' -allow-override %{%sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
	tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
	mkfifo "$in" "$out"
  (ag --nogroup --nocolor --hidden --ignore '.git' --files-with-matches '' > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [ -n "$RESULT" ]; then
    CMD=$(printf 'eval -client %s edit %s\n' "$kak_client" "$RESULT")
    kak -p "$kak_session" <<< "$CMD"
  fi
}}

def fzf-line -docstring 'jump to line using fzf' -allow-override %{%sh{
  if [ -z "$TMUX" ]; then
    echo "echo -markup '{Error}This command is only available in a tmux session'"
    exit
  fi
	tmp=$(mktemp -d -t fzf-temp-XXXXXXXX)
  in="$tmp/in"
  out="$tmp/out"
	mkfifo "$in" "$out"
  (ag --nogroup --nocolor --hidden --ignore '.git' '^.*$' > $in) > /dev/null 2>&1 < /dev/null &
  (tmux new-window "fzf < $in > $out") > /dev/null 2>&1 < /dev/null &
  RESULT=$(cat "$out")
  if [ -n "$RESULT" ]; then
  	F=$(cut -d ':' -f 1 <<< "$RESULT")
  	L=$(cut -d ':' -f 2 <<< "$RESULT")
    CMD=$(printf 'eval -client %s edit %s %s\n' "$kak_client" "$F" "$L")
    kak -p "$kak_session" <<< "$CMD"
  fi
}}
