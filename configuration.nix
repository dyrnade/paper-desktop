{ config, pkgs, lib, modulesPath, inputs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  services.sshd.enable = false;
  services.xserver.desktopManager.paperde.enable = true;

  networking.hostName = "nixos";

  environment.systemPackages = with pkgs; [
    pkgs.vim
  ];

  system.stateVersion = "nixos-unstable";
}
