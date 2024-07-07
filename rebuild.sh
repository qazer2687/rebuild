#!/usr/bin/env bash

username="qazer2687"
reponame="dotfiles"

# darwin-rebuild
if [ "$(uname)" == "Darwin" ]; then

  # make both rebuild and log directory
  mkdir -p /tmp/rebuild/ && cd /tmp/rebuild

  # build system configuration
  darwin-rebuild build --flake github:$username/$reponame#$(hostname) --refresh --option eval-cache false 2>/tmp/rebuild/log

  # supress output unless an error occurs
  if [ $? -ne 0 ]; then
    cat /tmp/rebuild/log
  else
    #nvd --color always diff /run/current-system /tmp/rebuild/result | grep --color=always -Ev '\[A\.\]|\[R\.\]'
    nvd --color always diff /run/current-system /tmp/rebuild/result | awk '/\[A[.]\]|\[R[.]\]/{next} 1'
  fi

# nixos-rebuild
elif [ "$(uname)" == "Linux" ]; then
  olddrv=$(readlink -f /run/current-system)
  sudo nixos-rebuild switch --flake github:qazer2687/dotfiles#$(hostname) --refresh --option eval-cache false >/dev/null 2>"${ERROR_LOG}"
  if [ $? -ne 0 ]; then
    cat "$ERROR_LOG"
  else
    newdrv=$(readlink -f /run/current-system)
    nvd diff "$olddrv" "/run/current-system"
  fi
fi