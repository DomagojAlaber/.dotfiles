{ ... }:

{
  imports = [ ./common/headless.nix ];

  networking.hostName = "nixos-dev";

  microvm = {
    hypervisor = "qemu";
    vcpu = 4;
    mem = 4096;
    interfaces = [
      {
        type = "user";
        id = "nixos-dev-user";
        mac = "02:00:00:00:22:21";
      }
    ];
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2221;
        guest.port = 22;
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
    ];
    volumes = [
      {
        image = "nixos-dev-data.img";
        mountPoint = "/var/lib/nixos-dev";
        size = 40960;
        label = "nixos-dev-data";
      }
    ];
  };
}
