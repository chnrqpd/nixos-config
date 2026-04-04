{ config, pkgs, inputs, ... }:

{
  # ─── Home Manager ────────────────────────────────────────────────────────────
  home.username      = "caio";
  home.homeDirectory = "/home/caio";

  # Não altere este valor após a instalação inicial.
  home.stateVersion = "25.11";

  # ─── Pacotes pessoais ────────────────────────────────────────────────────────
  # Adicione aqui os programas que são só seus (não do sistema inteiro).
  home.packages = with pkgs; [
    ghostty
    vscode
    tree
  ];

  # ─── Programas gerenciados pelo home-manager ──────────────────────────────────
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name  = "Caio";
      email = "seu@email.com";
    };
  };
}
