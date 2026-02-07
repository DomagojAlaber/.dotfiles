{ pkgs, ... }:

let
  kanataConfig = ''
    (defcfg
      process-unmapped-keys yes
      ;; Optional but often helps with home-row mods:
      ;; concurrent-tap-hold yes
    )

    (defvar
      tap-time 200
      hold-time 200
    )

    (defsrc
      caps
      a s d f   j k l ;
      f12
    )

    ;; --- OS-specific definition of the "WM modifier" emitted by A / ;
    (platform (linux)
      (defalias
        wmL lmet   ;; Super
        wmR rmet
      )
    )

    (platform (win winiov2 wintercept)
      (defalias
        wmL lmet   ;; Win
        wmR rmet
      )
    )

    (platform (macos)
      (defalias
        ;; "Hyper-lite": ctrl+alt+cmd (no shift) to avoid macOS Cmd-* conflicts
        wmL (multi lctl lalt lmet)
        wmR (multi rctl ralt rmet)
      )
    )

    (defalias
      ;; left hand
      a-mod (tap-hold $tap-time $hold-time a @wmL)
      s-mod (tap-hold $tap-time $hold-time s lalt)
      d-mod (tap-hold $tap-time $hold-time d lsft)
      f-mod (tap-hold $tap-time $hold-time f lctl)

      ;; right hand
      j-mod (tap-hold $tap-time $hold-time j rctl)
      k-mod (tap-hold $tap-time $hold-time k rsft)
      l-mod (tap-hold $tap-time $hold-time l ralt)
      ;-mod (tap-hold $tap-time $hold-time ; @wmR)
    )

    (deflayer base
      esc
      @a-mod @s-mod @d-mod @f-mod   @j-mod @k-mod @l-mod @;-mod
      lrld
    )
  '';
in
{
  home.packages = [ pkgs.kanata ];

  home.file.".config/kanata/kanata.kbd".text = kanataConfig;
}
