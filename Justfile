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
  nix build .#image --impure --show-trace -L -v --extra-experimental-features flakes --extra-experimental-features nix-command


gc:
  # let system gc (remove unused packages, etc)
  nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
  nix-collect-garbage --delete-old


list:
  # list system packages
  nix-store -qR /run/current-system | cat


profile:
  # show system profile
  nix profile history --profile /nix/var/nix/profiles/system


switch input:
  # let system rebuild and switch
  nixos-rebuild switch --flake .#{{input}} --show-trace -L -v


update:
  # let flake update
  nix flake update --extra-experimental-features flakes --extra-experimental-features nix-command


upgrade:
  # let system totally upgrade
  nixos-rebuild switch --flake .#{{hostname}} --show-trace -L -v
