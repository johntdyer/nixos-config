# Extra filesystems for external drives.
{ pkgs, ... }:
{
  # APFS (Mac-formatted USB drives) via the linux-apfs-rw kernel module.
  # Mount read-only: sudo mount -t apfs -o ro /dev/sdX2 /mnt/usb
  boot.supportedFilesystems = [ "apfs" ];

  # Userspace fallback if the kernel module lags behind the kernel, and for
  # encrypted volumes: sudo apfs-fuse -o allow_other /dev/sdX2 /mnt/usb
  environment.systemPackages = [ pkgs.apfs-fuse ];
}
