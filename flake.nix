{
  description = "NixOS server config (powered by clan)";

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    clan-core = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {...}: {
        imports = [
          ./machines/flake-module.nix
          inputs.clan-core.flakeModules.default
        ];
        systems = ["x86_64-linux"];

        perSystem = {
          system,
          pkgs,
          ...
        }: {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              clan-core.packages.${system}.clan-cli
              alejandra
              commitlint-rs
              deadnix
              sops
            ];
          };
        };
      }
    );
}
