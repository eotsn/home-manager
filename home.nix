{ config, pkgs, ... }:

{
  imports = [
    ./programs/i3.nix
  ];

  nixpkgs = {
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home.username = "eottosson";
  home.homeDirectory = "/home/eottosson";

  home.packages = [
    pkgs.go_1_21
    pkgs.neovim-nightly
    pkgs.nodejs_18
    pkgs.ripgrep
    pkgs.slack
    pkgs.spotify
    pkgs.xclip
  ];

  home.file = {
    ".background".source = backgrounds/default.jpg;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Eric Ottosson";
    userEmail = "4204520+eotsn@users.noreply.github.com";
    diff-so-fancy.enable = true;
    extraConfig = {
      url = {
        "git@github.com:" = {
          insteadOf = [ "git://github.com/" "https://github.com/" ];
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
	  IdentityAgent = "~/.1password/agent.sock";
	};
      };
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    sensibleOnTop = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -as terminal-features ',xterm-256color:RGB'
      set -g status-style 'bg=#323437,fg=#74b2ff'
      set -s escape-time 0
    '';
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
