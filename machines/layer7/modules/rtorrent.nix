{lib, ...}: {
  networking.firewall = {
    allowedTCPPorts = [6881 50000];
    allowedUDPPorts = [6881 50000];
  };
  services = {
    rtorrent = {
      configText = lib.mkForce ''
        # flood require
        method.insert=d.down.sequential,value|const,0
        method.insert=d.down.sequential.set,value|const,0
        method.redirect=load.throw,load.normal
        method.redirect=load.start_throw,load.start

        # BitTorrent
        ## Global upload and download rate in KiB, `0` for unlimited
        throttle.global_down.max_rate.set = 0
        throttle.global_up.max_rate.set = 0

        ## Maximum number of simultaneous downloads and uploads slots
        throttle.max_downloads.global.set = 65000
        throttle.max_uploads.global.set = 65000

        ## Maximum and minimum number of peers to connect to per torrent while downloading
        throttle.min_peers.normal.set = 1
        throttle.max_peers.normal.set = 51121

        ## Same as above but for seeding completed torrents (seeds per torrent)
        throttle.min_peers.seed.set = -1
        throttle.max_peers.seed.set = -1

        ## Networking
        protocol.pex.set = yes
        trackers.use_udp.set = yes
        dht.mode.set = auto
        network.port_range.set = 50000-50000
        network.port_random.set = no

        network.scgi.open_port = 127.0.0.1:5000
        network.xmlrpc.size_limit.set = 2000000
        network.http.ssl_verify_peer.set = 0

        network.max_open_files.set = 65000
        network.max_open_sockets.set = 4096
        network.http.max_open.set = 4096
        network.send_buffer.size.set = 512M
        network.receive_buffer.size.set = 512M
        protocol.encryption.set = allow_incoming,enable_retry,prefer_plaintext

        # Memory Settings
        pieces.hash.on_completion.set = no
        pieces.preload.type.set = 1
        pieces.memory.max.set = 2048M
      '';
      enable = true;
      group = "www";
      user = "rtorrent";
    };
  };
}
