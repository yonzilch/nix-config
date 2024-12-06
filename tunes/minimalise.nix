{ lib, ... }:
{
  #disabledModules = [
  #  <nixpkgs/nixos/modules/example.nix>
  #];

  documentation.enable = false;

  xdg = {
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };
}
