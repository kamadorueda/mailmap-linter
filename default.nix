{nixpkgs ? import <nixpkgs> {}}:
with nixpkgs; let
  dependencies = [
    coreutils
    gnugrep
    git
  ];

  wrapper = writeShellScriptBin "mailmap-linter" ''
    set -o errexit
    set -o nounset
    set -o pipefail

    export PATH="${lib.makeBinPath dependencies}"

    mailmap_exclude=()

    echo '[INFO] Veryfing if .mailmap exists'
    test -e .mailmap \
      ||  {
            echo '  [ERROR] Please add a .mailmap file in the root of the repo'
            exit 1
          }

    echo '[INFO] Computing contributors'
    mapfile -t 'authors' < \
      <((
              git -P log --format='%aN <%aE>' \
          &&  git -P log --format='%cN <%cE>'
        ) | LC_ALL=C sort \
          | uniq)

    echo '[INFO] Reading current .mailmap'
    mapfile -t 'mailmap' < \
      .mailmap

    test -e .mailmap-exclude \
      && echo '[INFO] Found .mailmap-exclude file' \
      && echo '  [INFO] Reading current .mailmap-exclude' \
      && mapfile -t 'mailmap_exclude' < .mailmap-exclude

    while (( "$#" )); do
      case "$1" in
        -e|--exclude)
          mailmap_exclude+=("$2")
          shift 2
          ;;
        *)
          echo "Unknown option: $1"
          exit 1
          ;;
      esac
    done

    echo '[INFO] Veryfing .mailmap format'
    line_number=0
    format='^[A-Z][[:alpha:]]+ [A-Z][[:alpha:]]+ <.*> (.*?) <.*?>$'
    for mapping in "''${mailmap[@]}"
    do
      line_number=$((line_number + 1))
      if ! echo "$mapping" | grep -qP "$format"
      then
        echo "  [ERROR] Expected: $format"
        echo "          Line $line_number: $mapping"
        exit 1
      fi
    done

    echo '[INFO] Veryfing that every author is in the .mailmap'
    success=true
    for author in "''${authors[@]}"
    do
      echo "  [INFO] Veryfing: $author"

      found=false
      for exclude in "''${mailmap_exclude[@]}"
      do
        if [[ $author =~ $exclude ]]
        then
          echo "  [INFO] Excluded: $author"
          continue 2
        fi
      done
      for mapping in "''${mailmap[@]}"
      do
        if [[ $mapping == *"$author"* ]]
        then
          found=true
          break
        fi
      done

      if test "$found" != "true"
      then
        echo "  [ERROR] Please add a .mailmap entry for: $author"
        success=false
      fi
    done

    if test "$success" != 'true'
    then
      exit 1
    fi

    echo '[INFO] Veryfing that .mailmap is sorted'
    if LC_ALL=C sort --check=silent .mailmap
    then
      echo '  [INFO] OK'
    else
      echo '  [ERROR] Please sort the .mailmap with: $ LC_ALL=C sort .mailmap'
      exit 1
    fi
  '';
in
  stdenv.mkDerivation {
    name = "mailmap-linter";

    installPhase = ''
      mkdir -p $out/bin
      install ${wrapper}/bin/* $out/bin
    '';

    src = ./.;
  }
