{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  windowsGpuPassthrough = false;
  windowsDiskName = "win11.qcow2";
  windowsNvramPath = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";

  windowsGpuHostdevs = ''
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
      </source>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x03' slot='0x00' function='0x1'/>
      </source>
    </hostdev>
  '';

  windows11Xml = pkgs.writeText "windows11.xml" (
    builtins.replaceStrings
      [
        "@OVMF_CODE@"
        "@OVMF_VARS@"
        "@WINDOWS_DISK@"
        "@WINDOWS_NVRAM@"
        "@VIRTIO_WIN_ISO@"
        "<!-- passthrough-hostdevs -->"
      ]
      [
        "${pkgs.OVMFFull.firmware}"
        "${pkgs.OVMFFull.variablesMs}"
        windowsDiskName
        windowsNvramPath
        "${inputs.nixvirt.lib.guest-install.virtio-win.iso}"
        (lib.optionalString windowsGpuPassthrough windowsGpuHostdevs)
      ]
      (builtins.readFile ../../vms/windows11.xml)
  );

  defaultNetworkXml = pkgs.writeText "libvirt-default-network.xml" ''
    <network>
      <name>default</name>
      <uuid>f699df36-e8ec-4608-b052-915cd3df6766</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:16:e1:2d'/>
      <ip address='192.168.122.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.2' end='192.168.122.254'/>
        </dhcp>
      </ip>
    </network>
  '';

  defaultPoolXml = pkgs.writeText "libvirt-default-pool.xml" ''
    <pool type='dir'>
      <name>default</name>
      <uuid>0eadfe48-12f5-4dc9-b541-4b71b00b8203</uuid>
      <target>
        <path>/var/lib/libvirt/images</path>
      </target>
    </pool>
  '';

  windowsVolumeXml = pkgs.writeText "windows11-volume.xml" ''
    <volume>
      <name>${windowsDiskName}</name>
      <capacity unit='GiB'>128</capacity>
      <target>
        <format type='qcow2'/>
      </target>
    </volume>
  '';
in
{
  imports = [
    inputs.microvm.nixosModules.host
    inputs.nixvirt.nixosModules.default
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];
  boot.initrd.kernelModules = lib.optionals windowsGpuPassthrough [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];
  boot.extraModprobeConfig = lib.optionalString windowsGpuPassthrough ''
    options vfio-pci ids=1002:73bf,1002:ab28
  '';

  security.polkit.enable = true;

  users.users.domagoj.extraGroups = [
    "kvm"
    "libvirtd"
  ];

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
    qemu = {
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  virtualisation.libvirt = {
    enable = true;
    swtpm.enable = true;
    connections."qemu:///system" = {
      networks = [
        {
          definition = defaultNetworkXml;
          active = true;
        }
      ];
      pools = [
        {
          definition = defaultPoolXml;
          active = true;
          volumes = [
            {
              definition = windowsVolumeXml;
            }
          ];
        }
      ];
      domains = [
        {
          definition = windows11Xml;
        }
      ];
    };
  };

  microvm.vms = {
    nixos-dev = {
      autostart = false;
      restartIfChanged = false;
      config = import ../../vms/nixos-dev.nix;
    };
    nixos-lab = {
      autostart = false;
      restartIfChanged = false;
      config = import ../../vms/nixos-lab.nix;
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  environment.systemPackages = with pkgs; [
    dnsmasq
    spice
    spice-gtk
    spice-protocol
    swtpm
    virt-viewer
    virtiofsd
    virtio-win
    win-spice
  ];
}
