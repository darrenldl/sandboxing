# Sandboxing

Scripts, files and tools related to sandboxing

## Index

- `bw-script-gen/` contains the OCaml code responsible for generating the bubblewrap scripts
- `bw-scripts/` contains the generated bubblewrap scripts

## Usage

See `bw-script-gen/src/profiles.ml` for existing profiles

Run `make run` in `bw-script-gen/` to generate scripts

Generated scripts assume home jails are stored in `~/jails`

## Acknowledgements

Bubblewrap scripts and seccomp filter file generator are based on the following repo

- https://github.com/valoq/bwscripts
