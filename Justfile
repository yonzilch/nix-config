# set hostname environment
hostname := `hostname`


anywhere input:
  # perform nixos-anywhere install
  nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./machines/{{input}}/hardware-configuration.nix --flake .#{{input}} --target-host root@{{input}}


anywhere-lb input:
  # perform nixos-anywhere install (local builder)
  nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./machines/{{input}}/hardware-configuration.nix --flake .#{{input}} --target-host root@{{input}} --build-on local


anywhere-vm input:
  # test nixos-anywhere install in local vm
  nix run github:nix-community/nixos-anywhere -- --flake .#{{input}} --vm-test


build input:
  # build
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i ;
  sudo nixos-rebuild build --flake .#{{input}} --show-trace -L -v ;
  ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i


build-vm input:
  # build a vm
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i ;
  sudo nixos-rebuild build-vm --flake .#{{input}} --show-trace -L -v ;
  ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i



format:
  # Use alejandra and deadnix to format code
  deadnix -e
  alejandra .


gc:
  # let system gc (remove unused packages, etc)
  sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
  sudo nix-collect-garbage --delete-old


keygen:
  clan secrets key generate


update:
  # let flake update
  nix flake update --extra-experimental-features flakes --extra-experimental-features nix-command


upgrade:
  # let system totally upgrade
  sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace


rebuild input:
  # perform remote rebuild action
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i ;
  git add . ; nixos-rebuild switch --flake .#{{input}} --target-host root@{{input}} -v ;
  ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i


install input:
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i ; git add . ; clan machines install {{input}} --target-host {{input}} --update-hardware-config nixos-facter ; ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i


deploy input:
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i \
  git add . ; clan machines update {{input}} --debug
  ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i


deploy-all:
  # perform clan update action
  ls sops/eval/**/* | xargs -n 1 sops -d -i ;
  git add . ; clan machines update --debug ;
  ls sops/eval/**/* | xargs -n 1 sops -e -i


encrypt-all:
  ls sops/eval/**/* | xargs -n 1 sops -e -i


encrypt input:
  ls sops/eval/{{input}}/* | xargs -n 1 sops -e -i


decrypt-all:
  ls sops/eval/**/* | xargs -n 1 sops -d -i


decrypt input:
  ls sops/eval/{{input}}/* | xargs -n 1 sops -d -i
