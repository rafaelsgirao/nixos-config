{ lib, ... }:
let
  inherit (lib.kernel) yes no;
in
{

  # https://cateee.net/lkddb/web-lkddb/SECURITY_LOCKDOWN_LSM.html
  # https://cateee.net/lkddb/web-lkddb/MODULE_SIG.html
  # https://linuxsecurity.com/features/how-to-secure-the-linux-kernel
  # https://github.com/torvalds/linux/blob/6ba59ff4227927d3a8530fc2973b80e94b54d58f/Documentation/admin-guide/module-signing.rst#id21
  # https://unix.stackexchange.com/questions/117521/what-is-the-difference-between-select-vs-depends-in-the-linux-kernel-kconfig
  # https://android.googlesource.com/kernel/common/+/a4eacf3227bd/certs/Kconfig
  # https://github.com/torvalds/linux/blob/master/security/lockdown/Kconfig
  boot.kernelPatches = [{
    name = "enable-lockdown-lsm";
    patch = null;
    extraStructuredConfig = {
      SECURITY_LOCKDOWN_LSM = yes;
      MODULE_SIG_KEY = "dummy-value-here-so-the-kernel-doesnt-generate-the-key-itself.pem";
      MODULE_SIG_ALL = no;
    };
  }];
}
