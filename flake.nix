{
  description = "NixOS server config (powered by clan)";

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    clan-core = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "https://git.clan.lol/clan/clan-core/archive/5cc8f3b2b3a12378f4bb4f44def7232440b28f2c.tar.gz";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (_: {
      imports = [./machines];
      systems = ["x86_64-linux"];
      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            inputs'.clan-core.packages.clan-cli
            alejandra
            commitlint-rs
            compose2nix
            deadnix
            sops
          ];
        };
      };
    });
}
