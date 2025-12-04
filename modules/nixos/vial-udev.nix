{ ... }:

{
  # Allow Vial/VIA to talk to keyboards over hidraw without needing root.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess"
  '';
}
