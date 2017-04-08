#! /usr/bin/env dash
# file-related functions

length()
{ # length <file...> :: int
  cat "$@" | sed -n '$=' ;
}

inplace()
{ # inplace <cmd...> file :: void
  local cmd='';
  while [ $# -gt 1 ]; do
    cmd="${cmd} $1";
    shift;
  done
  local f=$1;
  local t=$(mktemp $TMP/ip.XXXXXX);
  $cmd $f > $t;
  mv $t $f;
}
