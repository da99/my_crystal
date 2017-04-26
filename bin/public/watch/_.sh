
# === {{CMD}}
watch () {
  local +x PATH="$PATH:$THIS_DIR/../sh_color/bin"
  PATH="$PATH:$THIS_DIR/../mksh_setup/bin"
  PATH="$PATH:$THIS_DIR/bin"
  PATH="$PATH:$THIS_DIR/progs/latest-crystal/bin"
  PATH="$PATH:$THIS_DIR/progs/latest-shards/bin"

  cd "$THIS_DIR"

  if [[ ! -z "$@" ]] ; then
    echo "=== Compiling... $(date "+%H:%M:%S") ..." >&2

    local +x FILE="tmp/scratch.cr"
    if [[ ! -f "$FILE" ]]; then
      sh_color "=== File does not exist: {{$FILE}}"
    fi

    crystal build tmp/scratch.cr
    mv scratch tmp/
    tmp/scratch
    echo ""
  else
    $0 watch run || :
    mksh_setup watch "-r bin -r tmp " "$THIS_DIR/bin/my_crystal_lang watch run"
  fi

} # === end function

