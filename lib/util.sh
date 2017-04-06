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
  # echo "$@" >&2 ;
  exit $error;
}

silent() { $@ >/dev/null 2>&1 ; }

reads() {
  # read multiple variables at one time
  rvars="";
  while [ "$1" != "--" ]; do
    rvars="$rvars $1";
    shift;
  done
  shift;
  read $rvars << END
  $($@)
END
}
