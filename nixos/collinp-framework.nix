# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # ref = "nixos-23.05";
  });
in {
  imports = [
    # For NixOS
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    plugins.comment.enable = true;
    plugins.lualine.enable = true;
    plugins.lsp = {
      enable = true;
      servers = {
        lua-ls.enable = true;
        rust-analyzer.enable = true;
        pyright.enable = true;
        yamlls.enable = true;
        terraformls.enable = true;
        sqls.enable = true;
        nixd.enable = true;
        marksman.enable = true;
        jsonls.enable = true;
        html.enable = true;
        helm-ls.enable = true;
        gopls.enable = true;
        dockerls.enable = true;
        cssls.enable = true;
        ansiblels.enable = true;
      };
    };
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      extraOptions.sources = [
        {
          name = "nvim_lsp";
        }
        {
          name = "luasnip";
        }
        {
          name = "path";
        }
        {
          name = "buffer";
        }
      ];
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-web-devicons
    ];
    colorschemes.gruvbox.enable = true;
    options = {
      number = true;
      relativenumber = true;
    };
  };
  # Bootloader.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "collinp-framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.zsh.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [canon-cups-ufr2 gutenprint cups-filters cups-bjnp];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.collinp = {
    isNormalUser = true;
    description = "Collin Pendleton";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  environment.variables.EDITOR = "nvim";

  environment.variables.LD_LIBRARY_PATH = "/nix/store/iap7s5szjmczi1yc3yfxkzbv0cmr6h02-libz-unstable-2018-03-31/lib:$LD_LIBRARY_PATH";
  environment.sessionVariables = rec {
    LD_LIBRARY_PATH = "/nix/store/iap7s5szjmczi1yc3yfxkzbv0cmr6h02-libz-unstable-2018-03-31/lib:$LD_LIBRARY_PATH";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    iotas
    floorp
    vscode
    gh
    git
    gnome-console
    dnsutils
    zsh
    neofetch
    htop
    btop
    alejandra
    gnome.gnome-terminal
    ferdium
    jetbrains.rust-rover
    jetbrains.pycharm-professional
    meld
    flatpak
    azure-cli
    bitwarden
    mpv
    gcc
    vivaldi
    zlib
    libz
    libz.dev
    zlib.dev
    nextcloud-client
    gnome.gnome-tweaks
    mgba
    onlyoffice-bin
    canon-cups-ufr2
    cups-bjnp
    libnotify
    solaar
    usbutils
    jq
    yq
    pciutils
    meshlab
    tailscale
    python3
    python311Packages.pip
  ];

  programs.hyprland.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
