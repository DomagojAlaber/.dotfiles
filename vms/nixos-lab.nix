{ ... }:

{
  imports = [ ./common/headless.nix ];

  networking.hostName = "nixos-lab";

  microvm = {
    hypervisor = "qemu";
    vcpu = 2;
    mem = 3072;
    interfaces = [
      {
        type = "user";
        id = "nixos-lab-user";
        mac = "02:00:00:00:22:22";
      }
    ];
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2222;
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
        image = "nixos-lab-data.img";
        mountPoint = "/var/lib/nixos-lab";
        size = 20480;
        label = "nixos-lab-data";
      }
    ];
  };
}
