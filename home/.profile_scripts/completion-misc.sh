#! /bin/bash


complete -W "\`sed -nE 's/^\.PHONY: ([^ #]+).*/\1/p' Makefile | sort\`" make