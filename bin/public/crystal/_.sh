
# === {{CMD}}  -args -to -crystal binary
crystal () {
  unset -f crystal
  PATH="$PATH:$THIS_DIR/progs/latest-crystal/bin"
  crystal "$@"
} # === end function
