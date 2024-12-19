{ config, lib, pkgs, ... }:
{
  environment.systemPackages = lib.filter (pkg: pkg != pkgs.which) with pkgs; [
    curl
    fastfetch
    just
    micro
    wget
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
    lfs.enable = true;
  };
}
