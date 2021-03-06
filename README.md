# Sandboxing

Scripts, files and tools related to sandboxing

## Description

This sandboxing suite primarily targets desktop use, but may include assets for server use

The scripts and files in this repo are designed to be readily usable on most systems

- You only have to install OCaml toolchain if you want to develop upon the generator

Basics

- Private home for programs
- Shell interpreter access is removed in the sandbox
- Access to number of binaries is minimized (via bubblewrap and AppArmor)
- Fairly strict seccomp filters are supplied to bubblewrap
- Fairly strict AppArmor profiles are generated

Note that some profiles assume usage of Wayland

## Install

Simply `git clone https://github.com/darrenldl/sandboxing.git` in home

Your system needs to have `bubblewrap`, `gcc` and `apparmor` to run the scripts

## Installation

__Important__: Please make sure the following directories are not already in use in your `$HOME`

- `sandboxing/`
- `sandboxes/`
- `sandbox-logs/`

All bash scripts in `scripts/` directory should work out of the box on most Linux distros

The scripts assume they stay in their original positions in the local copy of the repository, however

One can invoke them via the full path

```
./sandboxing/scripts/firefox.sh &
```

or use `add_links.sh DEST` to create symlinks to the scripts

```
./sandboxing/add_links.sh ~/.bin # say ~/.bin is in our PATH variable
sandbox-firefox-private &        # all symlinks are prefixed with "sandbox-" to allow easy removal
                                 # and avoid shadowing
```

## General usage

Invoke the script directly (or via symlink),
stdout are stored as `~/sandboxing-sandbox-logs/profile/*.stdout`,
stderr are stored as `~/sandboxing-sandbox-logs/profile/*.stderr`

See the following section for profile specific usage

## Profiles

Only the listed profiles are considered stable

Following serves as rough descriptions only, check the scripts directly to see if they fit your needs

#### Internet

- `firefox`
  - Persistent home as `~/sandboxing-sandboxes/firefox` on host
- `firefox-tmp`
  - No persistent home
  - Temporary persistent `Downloads` folder in sandbox home, created as temporary directory under `/tmp` on host
    - This is the only directory that host and sandbox share
  - Is __NOT__ hardened against tracking/fingerprinting
- `firefox-private`
  - Same as `firefox-tmp`, but uses the hardened `user.js` transparently (should work on most Linux distros)
  - __Important__: Please check the `user.js` is indeed loaded correctly, see https://github.com/pyllyukko/user.js/#verifying for how to verify
- `thunderbird`
  - Persistent home as `~/sandboxing-sandboxes/thunderbird` on host
- `discord`
  - Persistent home as `~/sandboxing-sandboxes/discord` on host
  - AppArmor profile not usable yet

#### PDF reading

- `okular-ro`
  - No persistent home
  - Accepts exactly one argument for file to be read, e.g. `sandbox-okular-ro file.pdf`
  - RO mounts only the specified PDF file in sandbox home
  - No network access

- `okular-rw`
  - No persistent home
  - Accepts exactly one argument for file to be read, e.g. `sandbox-okular-rw file.pdf`
  - RW mounts only the specified PDF file in sandbox home
  - No network access

#### Image viewing

- `eom-ro`
  - No persistent home
  - Accepts exactly one argument for file to be read, e.g. `sandbox-eom-ro file.png`
  - RO mounts only the specified file in sandbox home
  - No network access

## Development

#### TODO

- Make each sandbox use a separate user (not sure yet)

- Transition to syscall whitelist instead of blacklist

- Network namespace set up with routing and DNS

#### WIP

- Discord AppArmor profile

#### Index

- `aa-profiles/` contains the generated AppArmor profiles
- `firefox-hardening/` contains files specific to Firefox
- `gen/` contains the OCaml code responsible for generating the bubblewrap scripts and generating seccomp BPF generator C code
- `runners/` contains the generated runner C code
- `scripts/` contains the generated bubblewrap scripts
- `seccomp-bpfs/` contains the generated seccomp BPF generator C code

See `gen/src/profiles.ml` for existing profiles

Run `make run` in `bw-script-gen/` to generate scripts after making updates to the profiles

## Acknowledgements

Some components (e.g. bubblewrap scripts, seccomp filter blacklist) are based on the following repo

- https://github.com/valoq/bwscripts

AppArmor profile generation, seccomp filter whitelist, and other design choices are based on the following repo

- https://github.com/Whonix/sandbox-app-launcher

Files in `firefox-hardening/` are from the following repo

- https://github.com/pyllyukko/user.js/
