#include <tunables/global>

/home/*/sandboxing/scripts/bash.runner {
  include <abstractions/base>

  /home/*/sandboxing/scripts/bash.runner.sh r,

  /usr/bin/env ix,

  / r,

  network,

  dbus bus=session,

  # Programs and libraries
  /usr/ r,
  /{,usr/,usr/local/}{,s}bin/ r,
  /{,usr/,usr/local/}{,s}bin/** rpix,
  /{,usr/,usr/local/}lib{,32,64}/ r,
  /{,usr/,usr/local/}lib{,32,64}/** rmpix,
  /usr/{,local/}{share,include}/ r,
  /usr/{,local/}{share,include}/** rpix,

  # Tmpfs
  /{,var/}tmp/ r,
  /{,var/}tmp/** r,
  owner /{,var/}tmp/ rw,
  owner /{,var/}tmp/** rw,

}
