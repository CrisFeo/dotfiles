#! /bin/bash

getLatestVersion() {
  brew info --json=v1 "$1" | \
    us extract '0.versions.stable'
}

getInstalledVersion() {
  brew info --json=v1 "$1" | \
    us extract '0.installed' | \
    us pluck 'version' | \
    us process 'data.sort()' | \
    us process 'data[data.length-1]'
}
