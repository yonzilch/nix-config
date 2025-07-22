{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    wget2
  ];
}
