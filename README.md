# Sandboxing

Scripts, files and tools related to sandboxing

## Description

This sandboxing suite primarily targets desktop use, but may include assets for server use

One main focus is to provide a private home for programs, which is often where the most
important files are stored

By default, a fairly strict seccomp filter is supplied to bubblewrap

Note that some profiles assume usage of Wayland

## Install

Simply `git clone https://github.com/darrenldl/sandboxing.git` in home

Your system needs to have `bubblewrap`, `gcc` and `apparmor` to run the scripts

## General usage

__Important__: Please make sure the following directories are not already in use in your `$HOME`

- `sandboxing/`
- `sandboxing-sandboxes/`
- `sandboxing-sandbox-logs/`

All bash scripts in `scripts/` directory should work out of the box on most Linux distros

The scripts assume they stay in their original positions in the local copy of the repository, however

One can invoke them via the full path

```
./sandboxing/bw-scripts/firefox.sh &
```

or use `add_links.sh DEST` to create symlinks to the scripts

```
./sandboxing/add_links.sh ~/.bin # say ~/.bin is in our PATH variable
sandbox-firefox-private &        # all symlinks are prefixed with "sandbox-" to allow easy removal
                                 # and avoid shadowing
```

## Profiles

Only the listed profiles are considered stable

Following serves as rough descriptions only, check the scripts directly to see if they fit your needs

#### Internet

- `firefox`
  - Persistent home as `~/sandboxes/firefox` on host
- `firefox-private`
  - No persistent home
  - Temporary persistent `Downloads` folder in sandbox home, created as temporary directory under `/tmp` on host
    - This is the only directory that host and sandbox share
- `thunderbird`
  - Persistent home as `~/sandboxes/firefox` on host
- `discord`
  - Persistent home as `~/sandboxes/discord` on host

#### PDF reading

- `okular-ro`
  - No persistent home
  - Accepts exactly one argument for file to be read, e.g. `sandbox-okular-ro file.pdf`
  - RO mounts only the specified PDF file in sandbox home
  - No network access

- `okular-rw`
  - No persistent home
  - Accepts exactly one argument for file to be read, e.g. `sandbox-okular-ro file.pdf`
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

- Make each sandbox use a separate user

- Transition to syscall whitelist instead of blacklist

#### WIP

- Transition to generating runner code in C instead of shell script, to allow disabling shell binaries altogether

#### Index

- `gen/` contains the OCaml code responsible for generating the bubblewrap scripts and generating seccomp BPF generator C code
- `scripts/` contains the generated bubblewrap scripts
- `seccomp-bpf/` contains the generated seccomp BPF generator C code
- `aa-profiles/` contains the generated AppArmor profiles

See `bw-script-gen/src/profiles.ml` for existing profiles

Run `make run` in `bw-script-gen/` to generate scripts after making updates to the profiles

## Acknowledgements

Some components (e.g. bubblewrap scripts, seccomp filter file generator) are based on the following repo

- https://github.com/valoq/bwscripts

AppArmor profile generation and other design choices are based on the following repo

- https://github.com/Whonix/sandbox-app-launcher
