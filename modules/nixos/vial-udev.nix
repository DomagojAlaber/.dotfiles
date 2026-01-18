{ ... }:

{
  # Allow Vial/VIA to talk to keyboards over hidraw without needing root.
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="55d4", ATTRS{idProduct}=="0664", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  '';
}
