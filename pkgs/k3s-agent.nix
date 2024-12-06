{ config, pkgs, host, ...}:
{
  services.k3s = {
    enable = true;
    role = "agent"; # Or "agent" for worker only nodes
    token = "<randomized common secret>"; # use "cat /var/lib/rancher/k3s/server/node-token" to check
    serverAddr = "https://<ip of first node>:6443";
  };
}
