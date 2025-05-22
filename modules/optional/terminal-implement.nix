{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    helix
    zoxide
    zellij
  ];
  programs.bash = {
    interactiveShellInit = ''
      eval "$(zoxide init bash)"
    '';
  };
}
