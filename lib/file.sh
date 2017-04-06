#! /usr/bin/env dash
# file-related functions

length()
{ # length <file...> :: int
  cat "$@" | sed -n '$=' ;
}

inplace()
{ # inplace <cmd...> file :: void
  cmd='';
  while [ $# -gt 1 ]; do
    cmd="${cmd} $1";
    shift;
  done
  f=$1;
  t=$(mktemp ip.XXXXXX);
  $cmd $f > $t;
  mv $t $f;
}
