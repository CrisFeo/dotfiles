#!/usr/bin/env bash

# `make` completion
# lists all PHONY targets which are commonly used to
# implement user-facing functionality.
complete -W "\`sed -nE 's/^\.PHONY: ([^ #]+).*/\1/p' Makefile | sort\`" make
