{
  description = "powerkit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosModules = {
          inherit (import ./nixos-modules.nix) powerkit-1_0;
        };
      };
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {
        packages.powerkit-1_0 = pkgs.libsForQt5.callPackage ./powerkit-1_0.nix { };
      };
    };
}

