{
  lib,
  ...
}:
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
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
  nixpkgs = {
    config.allowUnfree = lib.mkDefault false;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
