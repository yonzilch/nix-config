{
  description = "NixOS server config (powered by clan)";

  inputs.clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
  inputs.nixpkgs.follows = "clan-core/nixpkgs";

  outputs =
  { self, clan-core, ... }:
  let
    clan = clan-core.lib.buildClan {
      inherit self;
      meta.name = "nixos-server";
    };
  in
  {
    inherit (clan) nixosConfigurations clanInternals;
    devShells =
    clan-core.inputs.nixpkgs.lib.genAttrs
    [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ]
    (system: {
      default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
        packages = [ clan-core.packages.${system}.clan-cli ];
      };
    });
  };
}
