{ config, pkgs, ... }:
let
	user = "c1r5dev";
in
{
	services.udev.packages = [
    pkgs.android-udev-rules
  ];

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
				flake-update = "sudo nixos-rebuild switch --flake ."
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
		spotify
		jetbrains-toolbox
		jetbrains.jdk
		vim 
		wget
	];
		
	environment.variables.EDITOR = "vim";
	system.stateVersion = "24.11";
}
