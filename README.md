# NixOS Config — Caio PC

Configuração pessoal do NixOS usando Flakes e Home Manager.

## Estrutura

```
.
├── flake.nix              # Entrypoint: inputs e outputs do sistema
├── configuration.nix      # Configuração do sistema (boot, rede, serviços)
├── home.nix               # Configuração do usuário via Home Manager
└── README.md              # Este arquivo
```

> `hardware-configuration.nix` é gerado automaticamente pelo instalador e não é versionado.

---

## Pré-requisitos

- NixOS instalado com suporte a Flakes
- Git configurado
- Chave SSH adicionada ao GitHub (ver seção abaixo)

---

## Instalação em uma máquina nova

1. Instale o NixOS normalmente até o final

2. Clone o repositório:
```bash
git clone git@github.com:seu-usuario/nome-do-repo.git ~/nixos-config
```

3. Copie o `hardware-configuration.nix` gerado pela instalação:
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/
```

4. Aplique a configuração:
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

---

## Comandos principais

### Aplicar mudanças no sistema

Após editar qualquer arquivo de configuração:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

### Ver o que mudaria antes de aplicar

```bash
sudo nixos-rebuild dry-activate --flake ~/nixos-config#nixos
```

### Atualizar inputs (nixpkgs, home-manager, dms, etc.)

```bash
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

### Atualizar apenas um input específico

```bash
nix flake update nixpkgs
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

---

## Como instalar um programa

**Programas pessoais** (recomendado) — edite `home.nix`:

```nix
home.packages = with pkgs; [
  meu-programa  # adicione aqui
];
```

**Programas do sistema** (para todos os usuários) — edite `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  meu-programa  # adicione aqui
];
```

Depois aplique com `sudo nixos-rebuild switch --flake ~/nixos-config#nixos`.

### Buscar o nome de um pacote

```bash
nix search nixpkgs nome-do-programa
```

---

## Rollback (voltar para uma versão anterior)

Liste as gerações disponíveis:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

Voltar para a geração anterior:

```bash
sudo nixos-rebuild switch --rollback
```

Ou escolha uma geração específica no menu do bootloader ao iniciar o sistema.

---

## Versionamento com Git

### Workflow do dia a dia

```bash
cd ~/nixos-config

# edita o que quiser sem sudo
vim home.nix

# salva no git
git add .
git commit -m "feat: adiciona programa X"
git push

# aplica no sistema
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

> **Importante:** o Nix só lê arquivos rastreados pelo git. Após criar um arquivo novo, sempre rode `git add` antes do `nixos-rebuild switch`.

---

## Configurando SSH para o GitHub

Gere uma chave SSH:

```bash
ssh-keygen -t ed25519 -C "seu@email.com"
```

Copie a chave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

Adicione no GitHub em **Settings → SSH and GPG keys → New SSH key**.

Configure o remote do repositório para usar SSH:

```bash
git remote set-url origin git@github.com:seu-usuario/nome-do-repo.git
```

Teste a conexão:

```bash
ssh -T git@github.com
```

---

## Limpeza de gerações antigas

Remover todas as gerações antigas:

```bash
sudo nix-collect-garbage -d
```

Manter apenas as últimas N gerações:

```bash
sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage
```
