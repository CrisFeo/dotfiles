#! /bin/bash

# sed and grep replacements using underscore-cli
us-sed() {
  underscore --infmt=text --outfmt=text map "value.replace($1, '$2')"
}

us-grep() {
  underscore --infmt=text --outfmt=text filter "value.match(/$1/)"
}
