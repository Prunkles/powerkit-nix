# Nix [rodlie/powerkit](https://github.com/rodlie/powerkit) package and module

## Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    powerkit.url = "github:Prunkles/powerkit-nix";
  };
  outputs = { nixpkgs, powerkit, ... }:
    {
      nixosConfigurations."foo" = nixpkgs.lib.nixosSystem {
        modules = [
          powerkit.nixosModules.powerkit-1_0
          ({ ... }: {
            services.powerkit.enable = true;
          })
        ];
      };
    };
}
```

