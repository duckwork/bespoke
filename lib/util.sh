# wm.sh
# WM utility functions
# Most everything will source this file; keep it lean!

# Exit codes
SUCCESS=0;  # Success!
E_EXE=126;  # POSIX: Executable problem
E_FNF=127;  # POSIX: File not found
E_ARG=1;    # Argument is dumb
E_WIN=3;    # Window not found or is otherwise unavailable

die () # Fail spectacularly
{
  err=$1; shift;
  printf '%s\n' "$@" >&2;
  exit $err;
}

# log () # Give a helpful message when called with -v
# {
#   if $WMVERBOSE; then
#     printf '%s\n' "$@" >&2;
#   fi
# }
# logx () # Log and then execute an action
# {
#   log "$@";
#   $@;
# }

silent () # Run a command silently
{
  $@ >/dev/null 2>&1;
}

reads () # Read multiple variables from a command
{ # reads <vars...> -- <cmd>
  local rvars='';
  while [ "$1" != '--' ]; do
    rvars="${rvars} ${1}";
    shift;
  done; shift;
  read $rvars <<- END
  $($@)
END
}
