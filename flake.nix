{
  description = "NixOS Server Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    vaultix.url = "github:milieuim/vaultix";
  };

  outputs = inputs@{ nixpkgs, vaultix, ... }:
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
          vaultix.nixosModules.vaultix
        ];
      };
    };
  };
}
