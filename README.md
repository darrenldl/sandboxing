# Sandboxing

Scripts, files and tools related to sandboxing

## Description

This sandboxing suite primarily targets desktop use, but may include assets for server use

One main focus is to provide a private home for programs, which is often where the most
important files are stored

Note that some profiles assume usage of Wayland

## General usage

All bash scripts in `bw-scripts/` directory should work out of the box on most Linux distros
as long as you have gcc installed already

The scripts assume they stay in the local copy of the repository, however

One can invoke them via the full path

```
./sandboxing/bw-scripts/firefox.sh
```

or use `add_links.sh DEST` to create symlinks to the scripts

```
./sandboxing/add_links.sh ~/.bin # say ~/.bin is in our PATH variable
sandbox-firefox-private          # all symlinks are prefixed with "sandbox" to allow easy removal
                                 # and avoid shadowing
```

## Development

#### Index

- `bw-script-gen/` contains the OCaml code responsible for generating the bubblewrap scripts and generating seccomp BPF generator C code
- `bw-scripts/` contains the generated bubblewrap scripts
- `seccomp-bpf/` contains the seccomp BPF generator C code

See `bw-script-gen/src/profiles.ml` for existing profiles

Run `make run` in `bw-script-gen/` to generate scripts after making updates to the profiles

## Acknowledgements

Some components (e.g. bubblewrap scripts, seccomp filter file generator) are based on the following repo

- https://github.com/valoq/bwscripts
