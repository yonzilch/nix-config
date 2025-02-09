{
  description = "NixOS Server Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      hostname = "atlantic";
    in
    {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit hostname;
            inherit inputs;
          };
          modules = [
            ./hosts/${hostname}/config.nix
          ];
        };
      };
    };
}
