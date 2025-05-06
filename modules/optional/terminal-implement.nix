{pkgs, ...}: {
  environment.systemPackages = [pkgs.zoxide];
  programs.bash = {
    interactiveShellInit = ''
      eval "$(zoxide init bash)"
    '';
  };
}
