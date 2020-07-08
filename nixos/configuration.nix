# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.configurationLimit = 20;
  boot.loader.grub.zfsSupport = true;
  boot.supportedFilesystems = [ "zfs" "xfs" "ext4" ];
  boot.zfs.enableUnstable = true;
  boot.kernelParams = [
    "elevator=none"
    "intel_iommu=on"
    "amd_iommu=on" ];
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "994d9128";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = { defaultLocale = "de_AT.UTF-8"; };

  console.font = "Lat2-Terminus16";
  console.keyMap = "de";

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # kernel level debugging with bpf
  programs.bcc.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # dl
    wget
    aria2
    youtube-dl
    ffsend
    git
    curl
    android-file-transfer

    # dev
    go
    tinygo
    nixfmt

    # base cli
    coreutils
    man
    emacs
    htop
    tmux
    tree
    file

    # multimedia
    cmus
    mpv
    ffmpeg
    firefox

    # virt
    qemu
    virglrenderer
    virt-manager

    # debug
    strace
    python38Packages.glances
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # ZFS
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "monthly";
  services.zfs.autoScrub.pools = [ "rpool" ];
  services.zfs.trim.enable = true;
  services.zfs.trim.interval = "weekly";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "de:nodeadkeys";

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };

  #services.xserver.videoDrivers = ["amdgpu"];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # flatpak support
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # steam
  hardware.steam-hardware.enable = true;

  # emacs
  services.emacs.enable = true;

  # qemu
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;

  # containers
  virtualisation.docker.enable = true;

  # nix
  nixpkgs.config.allowUnfree = true;
  nix.useSandbox = true;

  # netdata system monitoring
  services.netdata.enable = true;
  services.netdata.config = # don't forget to create a dataset with a 1G quota for this
    ''
      [global]
      memory mode = dbengine
      cache directory = /var/cache/netdata
      history = 3600
      update every = 30
    '';
  services.netdata.python.extraPackages =
  ''
    ps: [
      ps.docker
    ]
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "zfs"
      "networkmanager"
      "systemd-journal"
      "docker"
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.autoUpgrade.enable = true;
  system.stateVersion = "20.03"; # Did you read the comment?

}

