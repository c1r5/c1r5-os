{config, pkgs, lib, ...}:
let
	user = "c1r5dev";
in
{
	nixpkgs.config.allowUnfree = true;

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

	dconf = {
		enable = true;
		settings = {
			"org/gnome/shell" = {
				disable-user-extensions = false; # Ensure extensions are not disabled
				enabled-extensions = [
					pkgs.gnomeExtensions.dash-to-dock.extensionUuid
					pkgs.gnomeExtensions.blur-my-shell.extensionUuid
					# Add UUIDs for other extensions
				];
    	};
			
			"org/gnome/desktop/interface" = {
				clock-show-weekday = true;
				color-scheme = "prefer-dark";
			};
		};
	};

	programs = {
		direnv.enable = true;

		neovim = {
			enable = true;
			defaultEditor = true;
		};

		vscode = {
			enable = true;
		};

		bash = {
			enable = true;
			enableCompletion = true;
		};
	};

	home = {
		stateVersion = "24.11";
		username = user;
		homeDirectory = "/home/${user}";
		packages = with pkgs; [
			# Media
			ffmpeg_6-full
			vlc
			spotify

			#Torrent
			qbittorrent

			#VoIp
			discord-ptb

			# Terminal 
			kitty

			# NodeJS
			nodePackages.npm
			nodePackages.node2nix				
			nodePackages.typescript
			nodePackages.typescript-language-server
			nodePackages.dockerfile-language-server-nodejs
			
			# customization
			cowsay
			conky
			
			# cli
			httpie
			ripgrep
			fastfetch
		];
	};
}
