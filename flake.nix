{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    claude-code.url = "github:sadjow/claude-code-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-code, home-manager, ... }: {
    nixosConfigurations.sinistercat = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ claude-code.overlays.default ];
          environment.systemPackages = with pkgs; [ 
            claude-code 
          ];
        })
      ];
    };
  };
}