source "%val{config}/colors/simple.kak"

set global ui_options ncurses_assistant=cat

set global tabstop 2
set global indentwidth 2
set global aligntab false
hook global InsertChar '\t' %{ try %{ exec -draft h@ } }

set global modelinefmt '%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}}'
