{
  powerkit-1_0 =
    { config, lib, pkgs, ...}: {
      options = {
        services.powerkit = {
          enable = lib.mkEnableOption "powerkit";
        };
      };
      config =
        let
          cfg = config.services.powerkit;
          powerkit = pkgs.libsForQt5.callPackage ./powerkit-1_0.nix { };
        in
        lib.mkIf cfg.enable {
          services.udev.packages = [
            powerkit
          ];
          services.upower.enable = true;
          environment.systemPackages = [
            powerkit
            pkgs.xscreensaver
          ];
          systemd.user.services.powerkit = {
            wantedBy = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              Type = "dbus";
              BusName = "org.freedesktop.PowerKit";
              ExecStart = "${powerkit}/bin/powerkit";
            };
          };
        };
    };
}

