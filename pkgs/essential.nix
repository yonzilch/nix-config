{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; lib.filter (pkg: pkg != which) [
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
