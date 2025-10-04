{ pkgs, ... }:
{

  programs.fish = {
    enable = true;
    shellAbbrs = {
      cd = "z";
      cat = "bat";
      ip = "ip -c";
      vim = "nvim";
      rm = "rip";
      jfu = "journalctl -fu";
      gcm = "git commit -m \"";
      gcmn = "git commit --no-gpg-sign -m \"";
      jf = "journalctl -f";
      dc = "docker-compose";
      fd = "fd -HI";
      cpugov = "cpupower frequency-set -g";
      # "sudo-" = "sudoedit";
      se = "sudoedit";
      "_" = "sudo";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "done";
        inherit (done) src;
      }
      {
        name = "bass";
        inherit (bass) src;
      }
    ];
    shellAliases = rec {
      rg = "rg -i --hidden";
      tree = "eza -T";
      zathura = "zathura --fork";
      nix-shell = "nix-shell --command 'fish'";
      ssh = "TERM=xterm-256color ${pkgs.openssh}/bin/ssh";
    };
    functions = {
      sudoedit = ''
        set -lx SUDO_COMMAND "sudoedit $argv";
        command sudoedit $argv;
      '';
    };
    interactiveShellInit = ''
      set fish_greeting #Disables "Welcome to fish! message"
      if test (uname -s) = "Darwin"
        eval (/opt/homebrew/bin/brew shellenv)
      end
    '';
  };
}
