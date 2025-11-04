{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) optionalAttrs;
  cfg = config.hm.qnix.hardware.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      #nvidia-uvm needed for CUDA
      kernelModules = [ "nvidia-uvm" ];
    };

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        nvidiaSettings = false;
      };

      graphics.extraPackages = with pkgs; [
        libva-vdpau-driver
      ];
    };

    environment.variables = optionalAttrs config.programs.hyprland.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
