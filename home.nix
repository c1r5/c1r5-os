{config, pkgs, ...}:
let
	user = "c1r5dev";
in
{
	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
		};

		vscode = {
			enable = true;
			package = pkgs.vscode.fhs;
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
			# Terminal 
			kitty
			# Web Browser
			google-chrome
			# lang
			python3
			rustup
			nodejs
			gcc
			clang-tools
			
			# NodeJS
			nodePackages.vscode-langservers-extracted
			nodePackages.typescript
			nodePackages.typescript-language-server
			nodePackages.dockerfile-language-server-nodejs
      
			# customization
			cowsay
			conky
			
			# cli
			git
			httpie
			iotop
			iftop
			nvitop
			htop
			ripgrep
			lsof
			usbutils
			fastfetch

			# archives
			zip
			xz
			unzip
			p7zip
		];
	};
}
