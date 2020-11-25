#include <tunables/global>

/home/**/sandboxing/scripts/bash.sh {
  include <abstractions/base>

  /home/**/sandboxing/scripts/bash.sh r,

  /usr/bin/env ix,

  / r,

  network,

  dbus bus=session,

  set rlimit nproc <= 200,

  /usr/ r,
  /{,usr/,usr/local/}{,s}bin/ r,
  /{,usr/,usr/local/}{,s}bin/** rpix,
}
