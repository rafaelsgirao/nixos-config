# Firejail profile for ferdium
# This file is overwritten after every install/update
# Persistent local customizations
include ferdium.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.cache/Ferdium
noblacklist ${HOME}/.config/Ferdium
noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/Ferdium
mkdir ${HOME}/.config/Ferdium
mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/Ferdium
whitelist ${HOME}/.config/Ferdium
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
private-dev
private-tmp
