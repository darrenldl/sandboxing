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

Your system needs to have `bubblewrap` and `gcc` to run the scripts

## General usage

All bash scripts in `bw-scripts/` directory should work out of the box on most Linux distros

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
  - RW mounts `~/.mozilla` and `~/.cache/mozilla` in sandbox home
- `firefox-private`
  - No persistent home
  - Temporary persistent `Downloads` folder in sandbox home, created as temporary directory under `/tmp` on host
    - This is the only directory that host and sandbox share
- `thunderbird`
  - Persistent home as `~/sandboxes/firefox` on host
  - RW mounts `~/.thunderbird` and `~/.cache/thunderbird` in sandbox home
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

- AppArmor profiles (most likely would be hand written, but wouldn't mind if they can be automatically generated somehow)

#### Index

- `bw-script-gen/` contains the OCaml code responsible for generating the bubblewrap scripts and generating seccomp BPF generator C code
- `bw-scripts/` contains the generated bubblewrap scripts
- `seccomp-bpf/` contains the seccomp BPF generator C code

See `bw-script-gen/src/profiles.ml` for existing profiles

Run `make run` in `bw-script-gen/` to generate scripts after making updates to the profiles

## Acknowledgements

Some components (e.g. bubblewrap scripts, seccomp filter file generator) are based on the following repo

- https://github.com/valoq/bwscripts

AppArmor profile generation and other design choices are based on the following repo

- https://github.com/Whonix/sandbox-app-launcher
