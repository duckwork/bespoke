#! /usr/bin/env dash

# Utility functions
runf()
{ # runf <cmd> <args>
  f="$1"; shift;
  case "$1" in
    0x*) wid="$1" ;;
    *)
      [ $# -ge 2 ] || die $E_ARG "Not enough arguments"
      cmd="$BIN/$1"; shift;
      if [ -x "$cmd" ]; then
        wid="$($cmd $@)";
      else
        die $E_EXE "Unknown command: \"$cmd\"";
      fi
      ;;
  esac
  logx $f $wid;
}

edit()
{ # Edit a file in wm
  f="$BIN/$1";
  t="$(mktemp $TMP/${f##*/}-edit.XXXXXX)";
  cp $f $t;
  ${EDITOR:-vi} $t;
  if silent diff -q $t $f; then
    # file was not changed
    rm $t;
  else
    # file was changed
    mv $t $f;
  fi
}

# Atomic actions
focus() 
{ # focus a window
  focus_wid() {
    if wattr "$1"; then
      wtf "$1";
      chwso -r "$1";
    fi
  }
  runf focus_wid "$@";
}

map()
{ # map a window
  map_wid() {
    if wattr "$1" && ! wattr m "$1"; then
      mapw -m "$1";
    fi
  }
  runf map_wid "$@";
}

hide()
{ # unmap a window
  hide_wid() {
    if wattr "$1" && wattr m "$1"; then
      mapw -u "$1";
    fi
  }
  runf hide_wid "$@";
}

ignore()
{ # set a window's override_redirect property
  ignore_wid() {
    if wattr "$1" && ! wattr o "$1"; then
      ignw -s "$1";
    fi
  }
  runf ignore_wid "$@";
}

notice()
{ # unset a window's override_redirect property
  notice_wid() {
    if wattr "$1" && wattr o "$1"; then
      ignw -r "$1";
    fi
  }
  runf notice_wid "$@";
}

raise()
{ # raise a window to the top of the stack
  raise_wid() {
    if wattr "$1"; then
      chwso -r "$1";
    fi
  }
  runf raise_wid "$@";
}

lower()
{ # lower a window to the bottom of the stack
  lower_wid() {
    if wattr "$1"; then
      chwso -l "$1";
    fi
  }
  runf lower_wid "$@";
}
