{ config, pkgs, ... }:
let
	user = "c1r5dev";
in
{

  services.nginx = {
  	enable = true;
		virtualHosts."localhost" = {
			listen = [{
				addr = "0.0.0.0";
				port = 80;
    	}]; 

			locations."/videos/" = {
				root = "~/Videos/Movies";
        extraConfig = ''
          autoindex on;
          add_header Accept-Ranges bytes;
          types { video/mp4 mp4; }
        '';
			};

			locations."/api/" = {
				proxyPass = "http://localhost:3000/";
				extraConfig = ''
					proxy_set_header Host $host;
					proxy_set_header X-Real-IP $remote_addr;
					proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
			};
		};
  };

  systemd.services.nginx.serviceConfig.ProtectHome = false;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
	
	services.udev.packages = [
    pkgs.android-udev-rules
  ];

	services.plex = {
		enable = true;
		openFirewall = true;
	};
	
	programs = {
		firefox.enable = true;
		zsh = {
			enable = true;
			enableCompletion = true;
			enableAutosuggestions = true;
			syntaxHighlighting.enable = true;
			shellAliases = {
				ll = "ls -l";
				la = "ls -la";
				update = "sudo nixos-rebuild switch";
				flake-update = "sudo nixos-rebuild switch --flake .";
			};
			ohMyZsh = {
				enable = true;
				plugins = [ "git" ];
				theme = "gnzh";
			};
		};
	};

	users = {
		defaultUserShell = pkgs.zsh;
		users.c1r5dev = {
		  isNormalUser = true;
		  description = user;
		  hashedPassword = "$6$6Ryb5VE0lOrBQd8K$mxCs1qVLMwReAtnK9slIN.Z53mnU85xlJO7c1H9IhwEpqeCfNEIOVY0wx4Xc5NO1O8wVWH3Rc0eeHk/3BR3lm/";
		  extraGroups = [ "networkmanager" "wheel" "adbusers" "kvm"];
		  packages = with pkgs; [];
		};
	};
  
	nixpkgs.config.allowUnfree = true;
	
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	imports = [ ./hardware-configuration.nix ];

	hardware.graphics = {
		enable = true;
	};
	
	hardware.nvidia.open = false;
	
	virtualisation.docker = {
		enable = true;
		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};
		
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "c1r5dev-os"; 
	networking.networkmanager.enable = true;
		
	time.timeZone = "America/Sao_Paulo";

	i18n.defaultLocale = "en_US.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pt_BR.UTF-8";
		LC_IDENTIFICATION = "pt_BR.UTF-8";
		LC_MEASUREMENT = "pt_BR.UTF-8";
		LC_MONETARY = "pt_BR.UTF-8";
		LC_NAME = "pt_BR.UTF-8";
		LC_NUMERIC = "pt_BR.UTF-8";
		LC_PAPER = "pt_BR.UTF-8";
		LC_TELEPHONE = "pt_BR.UTF-8";
		LC_TIME = "pt_BR.UTF-8";
	};
		
	services.xserver.videoDrivers = ["nvidia"];
	services.xserver.xkb = {
		layout = "br";
		variant = "";
	};
		
	console.keyMap = "br-abnt2";

	security.rtkit.enable = true;

	services.printing.enable = true;
	hardware.pulseaudio.enable = false;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	environment.systemPackages = with pkgs; [
		# Vscode Plugin
		nixpkgs-fmt

		# Services
		nginx
		plex
		
		# Lang 
		python3
		rustup
		nodejs
		kotlin
		gcc
		clang-tools

		# Tools
		gearlever
		appimage-run
		
		# Web Browser
		google-chrome

		# archives
		zip
		xz
		unzip
		p7zip

		# Development
		jetbrains-toolbox
		jetbrains.jdk

		# CLI
		git
		usbutils
		nvitop
		iftop
		iotop
		htop
		lsof

		# Editor
		vim
		wget
	];
	
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [
			4000
			3000
			8080
			80
		];
	};
	environment.variables.EDITOR = "vim";
	system.stateVersion = "24.11";
}
