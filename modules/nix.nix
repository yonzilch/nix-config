{ pkgs, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      gc-keep-outputs = false;
      gc-keep-derivations = false;
      experimental-features = [ "nix-command" "flakes" ];
      extra-builtins-file = [ ../libs/extra-builtins.nix ];
      plugin-files = "${pkgs.nix-plugins}/lib/nix/plugins";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };
}
