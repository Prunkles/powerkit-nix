{
  powerkit-1_0 =
    { config, lib, pkgs, ...}: {
      options = {
        services.powerkit = {
          enable = lib.mkEnableOption "powerkit";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.libsForQt5.callPackage ./powerkit-1_0.nix { };
          };
        };
      };
      config =
        let
          cfg = config.services.powerkit;
        in
        lib.mkIf cfg.enable {
          services.udev.packages = [
            cfg.package
          ];
          services.upower.enable = true;
          environment.systemPackages = [
            cfg.package
            pkgs.xscreensaver
          ];
          systemd.user.services.powerkit = {
            wantedBy = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              Type = "dbus";
              BusName = "org.freedesktop.PowerKit";
              ExecStart = "${cfg.package}/bin/powerkit";
            };
          };
        };
    };
}

