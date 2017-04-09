
# === {{CMD}}  # Installs Crystal and Shards to /progs
install () {
  if [[ "$(arch)" != 'x86_64' ]]; then
    echo "!!! Only 64-bit architecures supported." >&2
    echo "   (Only 512 fibers allowed in 32-bit architectures.)" >&2
    exit 2
  fi

  install-crystal
  install-shards
} # === end function

get-latest () {
  lynx --dump "$1" | grep -P "releases/download.+x86.+" | tr -s ' ' | cut -d' ' -f3 | sort --version-sort | tail -n1
}

download () {
  local +x URL="$1"; shift
  local +x BASENAME="$(basename "$URL")"
  mkdir -p "$THIS_DIR/tmp"
  cd "$THIS_DIR/tmp"
  rm -f "$BASENAME"
  if [[ -f cache/"$BASENAME" ]]; then
    echo "=== Using cache file: cache/$BASENAME" >&2
    cp -f "cache/$BASENAME" "$BASENAME"
  else
    curl -L "$URL" && cp -f "$BASENAME" cache/"$BASENAME"
  fi
  echo "$PWD/$BASENAME"
}

install-crystal () {
  local +x NAME="Crystal"
  local +x EXEC_FILE="crystal"
  local +x URL="https://github.com/crystal-lang/crystal/releases"

  local +x STORAGE="$THIS_DIR/progs/$EXEC_FILE"
  local +x LATEST="$(get-latest "$URL")"
  local +x BASENAME="$(basename "$LATEST")"
  local +x VERSION="${BASENAME%$*-linux*}"
  local +x DIR="$STORAGE/versions/$VERSION"
  local +x LATEST_LINK="$THIS_DIR/progs/latest-$EXEC_FILE"

  if [[ -z "$LATEST" ]]; then
    echo "!!! Could not determine latest $NAME download on the Internet." >&2
    exit 2
  fi

  if [[ -e "$DIR" ]]; then
    echo "=== Already installed $NAME:" >&2
    echo "$DIR" >&2
    "$LATEST_LINK"/bin/crystal -v >&2
    return 0
  fi

  mkdir -p "$(dirname "$DIR")"
  mkdir -p "$THIS_DIR/tmp"

  local +x TMP_FILE="$(download "$LATEST")"

  cd "$(dirname "$DIR")"
  tar -zxvf "$TMP_FILE"

  rm -f "$LATEST_LINK"
  ln -s "$DIR" "$LATEST_LINK"
  "$LATEST_LINK"/bin/crystal -v
} # === install-crystal

install-shards () {
  local +x NAME="Shards"
  local +x EXEC_FILE="shards"
  local +x URL="https://github.com/crystal-lang/shards/releases/latest"

  local +x STORAGE="$THIS_DIR/progs/$EXEC_FILE"
  local +x LATEST="$(get-latest "$URL")"
  local +x BASENAME="$(basename "$LATEST")"
  local +x VERSION="${BASENAME%$*_linux_*}"
  local +x DIR="$STORAGE/versions/$VERSION"
  local +x LATEST_LINK="$THIS_DIR/progs/latest-shards"

  if [[ -z "$LATEST" ]]; then
    echo "!!! Could not determine latest $NAME download on the Internet." >&2
    exit 2
  fi

  if [[ -x "$DIR/bin/$EXEC_FILE" ]]; then
    echo "=== Already installed $NAME:" >&2
    echo "$DIR" >&2
    "$LATEST_LINK"/bin/shards --version >&2
    return 0
  fi

  # NOTE: The uncompressed file system will be just one file.
  #       So we create a directory for it and rename the file
  #       to "shards", keeping the version info in the shards-version/bin
  #       format:
  mkdir -p "$DIR"/bin

  local +x TMP_FILE="$(download "$LATEST")"

  cd "$(dirname "$TMP_FILE")"
  local +x BIN_FILE="$(basename "$BASENAME" .gz)"
  rm -f "$BIN_FILE"
  gunzip --decompress "$TMP_FILE"
  chmod +x "$BIN_FILE"
  mv "$BIN_FILE" "$DIR"/bin/shards

  cd "$THIS_DIR/progs"
  rm -f "$LATEST_LINK"
  ln -s "$DIR" "$LATEST_LINK"
  "$LATEST_LINK"/bin/shards --version
} # === install-shard

