{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
