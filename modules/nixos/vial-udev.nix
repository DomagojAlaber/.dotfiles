{ ... }:

{
  # Allow Vial/VIA to talk to keyboards over hidraw without needing root.
  # Allow Vial/VIA to talk to keyboards over hidraw without needing root.
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="55d4", ATTRS{idProduct}=="0664", MODE="0660", TAG+="uaccess", TAG+="udev-acl"

    # Stable symlink for Bluetooth Lily58 / Silakka54 keyboard for Kanata.
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="Lily58 Keyboard", SYMLINK+="input/by-id/kanata-lily58-bt-event-kbd"
  '';
  services.tailscale.enable = true;
}
