{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    claude-code.url = "github:sadjow/claude-code-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-code, home-manager, ... }:
    let
      hostname = "nixos";  # Define hostname once
      system = "x86_64-linux";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ claude-code.overlays.default ];
            networking.hostName = hostname;  # Set hostname from variable
          }
        ];
      };
    };
}
