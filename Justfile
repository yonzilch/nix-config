# set hostname environment
hostname := `hostname`



update:
  # let flake update
  sudo nix flake update --extra-experimental-features flakes --extra-experimental-features nix-command


upgrade:
  # let system totally upgrade
  sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace


install input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines install {{input}} --target-host {{input}} --update-hardware-config nixos-facter ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


deploy input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines update {{input}} ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


encrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


decrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i
