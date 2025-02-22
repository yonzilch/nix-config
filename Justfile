# set hostname environment
hostname := `hostname`

build-image:
  # build system image
  nix build .#image --impure --show-trace -L -v --extra-experimental-features flakes --extra-experimental-features nix-command


build input:
  # build
  nixos-rebuild build --flake .#{{input}} --show-trace -L -v


build-vm input:
  # build a vm
  nixos-rebuild build-vm --flake .#{{input}} --show-trace -L -v


clean-channels:
  # remove nix-channel files
  rm -rf /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr/channels


gc:
  # let system gc (remove unused packages, etc)
  nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
  nix-collect-garbage --delete-old


ghc:
  # generate hardware.nix
  nixos-generate-config --show-hardware-config > ./hosts/{{hostname}}/hardware.nix


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
  nixos-rebuild switch --flake .#{{hostname}} --show-trace


deploy input:
  # perform a remote deploy
  nixos-rebuild switch --flake .#{{input}} --target-host root@{{input}} -v


anywhere input:
  # perform nixos-anywhere install
  nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/{{input}}/hardware.nix --flake .#{{input}} --target-host root@{{input}}

anywhere-test input:
  # test nixos-anywhere install in local vm
  nix run github:nix-community/nixos-anywhere -- --flake .#{{input}} --vm-test
