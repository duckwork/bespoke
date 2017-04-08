#! /usr/bin/env dash
# WM utility functions, making life easier

# Error codes
SUCCESS=0
E_EXE=126
E_FNF=127
E_ARG=1
E_WIN=3

die() {
  error=$1; shift;
  echo "$@" >&2 ;
  exit $error;
}

log() {
  if $WMVERBOSE; then
    echo "$@" >&2;
  fi
}
logx() {
  log $@;
  $@;
}

silent() { $@ >/dev/null 2>&1 ; }

reads() {
  # read multiple variables at one time
  local rvars="";
  while [ "$1" != "--" ]; do
    rvars="$rvars $1";
    shift;
  done
  shift;
  read $rvars << END
  $($@)
END
}
