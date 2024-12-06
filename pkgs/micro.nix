{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    micro
  ];
}
