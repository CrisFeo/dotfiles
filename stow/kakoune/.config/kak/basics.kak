source "%val{config}/colors/simple.kak"

set global ui_options ncurses_assistant=cat

set global tabstop 2
set global indentwidth 2
set global aligntab false

set global modelinefmt '%sh{
	#modified=$([ $kak_modified = "true" ] && echo "+ ")
	#left="$kak_bufname"
	#right="$modified$kak_cursor_line:$kak_cursor_char_column "
	#printf "%s" "$left"
  #printf "%-$(($kak_window_width - ${#left} - ${#right} - 1))s"
	#printf "%s" "$right"
}'
