{ ... }:
{
  services.vsftpd = {
    enable = true;

    anonymousUser = true;
    anonymousUserNoPassword = true;
    anonymousUploadEnable = true;
    anonymousMkdirEnable = true;
    extraConfig = ''
anon_mkdir_write_enable=YES
anon_other_write_enable=YES

delete_failed_uploads=YES
    '';

    localUsers = false;

    writeEnable = true;

    chrootlocalUser = true;

    allowWriteableChroot = true;

    localRoot = "/mnt/";
    anonymousUserHome = "/mnt/";
  };
}
