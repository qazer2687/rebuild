#!/usr/bin/env bash

username="qazer2687"
reponame="dotfiles"

mkdir -p /tmp/rebuild/ && cd /tmp/rebuild

# darwin-rebuild
if [ "$(uname)" == "Darwin" ]; then

  # build system configuration
  darwin-rebuild build --flake github:$username/$reponame#$(hostname) --refresh --option eval-cache false 2>/tmp/rebuild/log

  # supress output unless an error occurs
  if [ $? -ne 0 ]; then
    cat /tmp/rebuild/log
  else
    nvd diff /run/current-system /tmp/rebuild/result
  fi

# nixos-rebuild
elif [ "$(uname)" == "Linux" ]; then
  # build system configuration
  sudo nixos-rebuild build --flake github:$username/$reponame#$(hostname) --refresh --option eval-cache false 2>/tmp/rebuild/log

  # supress output unless an error occurs
  if [ $? -ne 0 ]; then
    cat /tmp/rebuild/log
  else
    nvd diff /run/current-system /tmp/rebuild/result
  fi
fi