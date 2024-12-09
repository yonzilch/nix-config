# just is a command runner, Justfile is very similar to Makefile, but simpler.

# use nushell for shell commands
#set shell := ["nu", "-c"]

# set hostname environment
hostname := `hostname`

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

build:
  # build system image
  sudo nix build .#image --impure --show-trace -L -v --extra-experimental-features flakes --extra-experimental-features nix-command


gc:
  # let system gc (remove unused packages, etc)
  sudo nix-collect-garbage --delete-older-than 7d


switch input:
  # let system rebuild and switch
  sudo nixos-rebuild switch --flake .#{{input}} --show-trace -L -v


update:
  # let flake update
  sudo nix flake update --extra-experimental-features flakes --extra-experimental-features nix-command


upgrade:
  # let system totally upgrade
  sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace -L -v
