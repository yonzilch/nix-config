{
  description = "NixOS Server Configurations";

  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    vaultix.url = "github:milieuim/vaultix";
  };

  outputs = inputs@{ disko, nixpkgs, vaultix, ... }:
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
          disko.nixosModules.disko
        ];
      };
    };
  };
}
