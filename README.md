# Git Mailmap Linter

## Description

Small, easy to use, easy to install tool to lint your git mailmap

## Verifications

- Mailmap File (.mailmap) must exist
- Mailmap must be sorted
- All authors in git history must be mapped
- All authors must conform to: Name FamilyName <email@provider.com>

## Installation

```bash
$ nix-env -i -f https://github.com/kamadorueda/mailmap-linter/archive/master.tar.gz
```

## Use

Run from the root of the repository that you want to lint:

```bash
$ mailmap-linter
```

## Use inside your CI

You can use the official Nix docker image: https://hub.docker.com/r/nixos/nix

Then install and use with the same commands for the local build

## Example

```bash
$ mailmap-linter
  [INFO] Veryfing if .mailmap exists
  [INFO] Computing contributors
  [INFO] Reading current .mailmap
  [INFO] Veryting .mailmap format
    [INFO] Ok: Line 1: Kevin Amado <kamadorueda@gmail.com> Kevin Amado <kamadorueda@gmail.com>
  [INFO] Veryfing that every author is in the .mailmap
    [INFO] Veryfing: Kevin Amado <kamadorueda@gmail.com>
  [INFO] Veryfing that .mailmap is sorted
    [INFO] OK
```
