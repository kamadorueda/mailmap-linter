# Git Mailmap Linter

## Description

Small, easy to use, easy to install tool to lint your git mailmap

## Verifications

- Mailmap file (.mailmap) must exist
- Mailmap must be sorted
- All authors in git history must be mapped
- All authors must conform to: `Name FamilyName <email@provider.com>`
- Exclude file (.mailmap-exclude). Optional. `.mailmap-exclude`
can contain a list of regular expressions (or be empty) to
exclude from the `.mailmap` file
- `--exclude` or `-e` argument. Optional. `mailmap-linter --exclude 'regex'`
If the excludes aren't too many then use `--exclude` instead of the exclude file, ex:
`mailmap-linter --exclude '^.* <.*noreply@github.com>$'`

## Installation

Given you've installed Nix (https://nixos.org/nix/download.html)

Run the following command:

```bash
$ nix-env -i -f https://github.com/kamadorueda/mailmap-linter/archive/master.tar.gz
```

## Use

Run from the root of the repository that you want to lint:

```bash
$ mailmap-linter
```

Exclude with regex:

```bash
$ mailmap-linter --exclude '...'
```

## Use inside your CI

Use Nixos/nix as the base image for your Job: https://hub.docker.com/r/nixos/nix

Then install and use the same commands for the local build

## Example

```bash
$ mailmap-linter
[INFO] Verifying if .mailmap exists
[INFO] Verifying if .mailmap-exclude exists
[INFO] Computing contributors
[INFO] Reading current .mailmap
[INFO] Reading current .mailmap-exclude
[INFO] Verifying .mailmap format
[INFO] Verifying that every author is in the .mailmap
  [INFO] Verifying: GitHub <noreply@github.com>
  [INFO] Excluded: GitHub <noreply@github.com>
  [INFO] Verifying: Kevin Amado <kamadorueda@gmail.com>
  [INFO] Verifying: Robin Quintero <rohaquinlop301@gmail.com>
  [INFO] Verifying: Timothy DeHerrera <tim.deherrera@iohk.io>
[INFO] Verifying that .mailmap is sorted
  [INFO] OK
```
