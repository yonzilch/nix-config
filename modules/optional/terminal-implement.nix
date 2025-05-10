{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    helix
    zoxide
  ];
  programs.bash = {
    interactiveShellInit = ''
      eval "$(zoxide init bash)"
    '';
  };
}
