{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.dms.nixosModules.dank-material-shell
  ];

  # ─── Boot ────────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── Nix ─────────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # ─── Rede ────────────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ─── Localização ─────────────────────────────────────────────────────────────
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT    = "pt_BR.UTF-8";
    LC_MONETARY       = "pt_BR.UTF-8";
    LC_NAME           = "pt_BR.UTF-8";
    LC_NUMERIC        = "pt_BR.UTF-8";
    LC_PAPER          = "pt_BR.UTF-8";
    LC_TELEPHONE      = "pt_BR.UTF-8";
    LC_TIME           = "pt_BR.UTF-8";
  };

  # ─── Desktop / Display ───────────────────────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout  = "us";
    variant = "intl";
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  console.keyMap = "us-acentos";

  # ─── Áudio ───────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ─── Impressão ───────────────────────────────────────────────────────────────
  services.printing.enable = true;

  # ─── Usuários ────────────────────────────────────────────────────────────────
  users.users.caio = {
    isNormalUser = true;
    description  = "Caio Henrique Primo Dario";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # ─── Programas ───────────────────────────────────────────────────────────────
  programs.firefox.enable = true;
  programs.dank-material-shell.enable = true;

  # Pacotes instalados globalmente (prefira home.nix para pacotes pessoais)
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  # ─── Versão do sistema ───────────────────────────────────────────────────────
  # Não altere este valor após a instalação inicial.
  system.stateVersion = "25.11";
}
