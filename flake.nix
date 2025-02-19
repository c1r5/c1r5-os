{
  description = "c1r5dev-os";

  inputs = {
  	home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
  	};
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
  	let
  		system = "x86_64-linux";
  		user = "c1r5dev";
  	in {
	nixosModules = {
		declarativeHome = {...}: {
			config = {
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
			};
		};
		gnome = { pkgs, ... }: {
          config = {
            services.xserver.enable = true;
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;
            environment.gnome.excludePackages = (with pkgs; [
				gnome-photos
				gnome-tour
				cheese # webcam tool
				gnome-music
				gedit # text editor
				epiphany # web browser
				geary # email reader
				tali # poker game
				iagno # go game
				hitori # sudoku game
				yelp # Help view
				atomix # puzzle game
				gnome-characters
				gnome-contacts
				gnome-initial-setup
            ]);
            programs.dconf.enable = true;
            environment.systemPackages = with pkgs; [
              gnome-tweaks
            ];
          };
        };
		
		user-c1r5dev = {...}: {
			config = {
				home-manager.extraSpecialArgs = {inherit user;};
				home-manager.users.${user} = import ./home.nix;
			};
		};
	};
  	nixosConfigurations = {
		c1r5dev-os = nixpkgs.lib.nixosSystem {
			inherit system;
			modules = with self.nixosModules; [
				./configuration.nix
				home-manager.nixosModules.home-manager 
				gnome
				declarativeHome
				user-c1r5dev
			];
		};
  	};
  };
}
