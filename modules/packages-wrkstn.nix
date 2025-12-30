{ pkgs, lib, ... }:
{
    home.packages = with pkgs; [
      # ==========================================
      # Personal Apps - Workstation Specific
      # ==========================================

      # -- Media / Office / Social --
      spotify           # Proprietary music streaming service
      discord           # All-in-one voice and text chat for gamers
      obsidian          # Knowledge base that operates on local Markdown files
    ];
}