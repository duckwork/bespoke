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
  printf '%s\n' "$@";
  exit $error;
}

log() {
  $WMVERBOSE && echo "$@";
  silent type "$1" || [ -x "$1" ] && $@ ;
}

silent() { $@ >/dev/null 2>&1 ; }

length() { cat "$@" | sed -n '$=' ; }

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

inplace() {
  cmd='';
  while [ $# -gt 1 ]; do
    cmd="${cmd} $1";
    shift;
  done; f=$1;
  t=$(mktemp ip.XXXXXX);
  $cmd $f > $t;
  mv $t $f;
}
