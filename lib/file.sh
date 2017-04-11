# file-related functions

length () # Get the length of a file
{ # length <file...>
  cat "$@" | sed -n '$=';
}

inplace () # Operate a file in-place (using a temp file)
{ # inplace <cmd...> file
  local cmd='';
  [ $# -ge 2 ] || die $E_ARG "${0}: inplace: Not enough arguments";
  while [ $# -gt 1 ]; do
    cmd="${cmd} ${1}";
    shift;
  done
  local f=$1 t=$(mktemp $TMP/inplace.XXXXXX);
  $cmd $f > $t;
  mv $t $f;
}
