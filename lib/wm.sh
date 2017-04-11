# Built-in functions for wm

# Utility functions (that shouldn't go in util.sh)
_runf () # Run a function with a wid or something that'll get to a wid
{ # _runf <win> | <cmd> [args...]
  local f="$1" wid; shift;
  case "$1" in
    # If it's a window, easy!
    0x*) wid="$1" ;;
    # Otherwise, it's a command that should get us a window
    *)
      [ $# -ge 1 ] || die $E_ARG "${0}: _runf: Not enough arguments";
      cmd="$BIN/$1"; shift;
      if [ -x "$cmd" ]; then
        wid="$($cmd "$@")";
      else
        die $E_EXE "${0}: _runf: Unknown command: \"$cmd\"";
      fi
      ;;
  esac
  # Test that it's a window, whatever it is
  silent expr match "$wid" '0x[0-9A-Fa-f]\+' || {
    die $E_WIN "${0}: _runf: Bad window \"$wid\"";
  }
  # Do the thing
  $f $wid;
}

wm_edit () # Edit a wm file, using a temporary file for safety
{ # wm_edit <file>
  local f="$1" t="$(mktemp $TMP/${f##*/}-edit.XXXXXX)";
  cp $f $t;
  ${EDITOR:-vi} $t;
  if silent diff -q $t $f; then
    # file wasn't changed
    rm $t;
  else
    # file was changed
    mv $t $f;
  fi
}

wm_run_hook () # Run a hook in $HKS by name
{ # wm_run_hook <hook>
  local h="$HKS/$1"; shift;
  [ -x "$h" ] && $h "$@";
}

# Atomic window-management actions (with hooks!)
# Each of these takes one wid and does something with it using
# the _runf function above.
wm_focus () # Focus a window
{
  focus_wid () {
    if wattr "$1"; then
      prev=$(pfw);
      # chwso -r "$1";
      wtf "$1";
      # wm_run_hook focus.wm "$1" "$prev";
    fi
  }
  _runf focus_wid "$@";
}

wm_map () # Map a window
{
  map_wid () {
    if wattr "$1" && ! wattr m "$1"; then
      mapw -m "$1";
    fi
    # wm_run_hook map.wm "$1";
  }
  _runf map_wid "$@";
}

wm_hide () # Unmap a window
{
  hide_wid () {
    if wattr "$1" && wattr m "$1"; then
      mapw -u "$1";
    fi
    # wm_run_hook hide.wm "$1";
  }
  _runf hide_wid "$@";
}

wm_ignore () # set a window's override_redirect property
{
  ignore_wid () {
    if wattr "$1" && ! wattr o "$1"; then
      ignw -s "$1";
    fi
    # wm_run_hook ignore.wm "$1";
  }
  _runf ignore_wid "$@";
}

wm_notice () # unset a window's override_redirect property
{
  notice_wid () {
    if wattr "$1" && wattr o "$1"; then
      ignw -r "$1";
    fi
    # wm_run_hook notice.wm "$1";
  }
  _runf notice_wid "$@";
}

wm_raise () # raise a window to the top of the X stack
{
  raise_wid () {
    if wattr "$1"; then
      chwso -r "$1";
    fi
    # wm_run_hook raise.wm "$1";
  }
  _runf raise_wid "$@";
}

wm_lower () # lower a window to the bottom of the X stack
{
  lower_wid () {
    if wattr "$1"; then
      chwso -l "$1";
    fi
    # wm_run_hook lower.wm "$1";
  }
  _runf lower_wid "$@";
}

wm_kill () # kill a window
{
  kill_wid () {
    if wattr "$1"; then
      # TODO look into killwa
      killw "$1";
    fi
    # wm_run_hook kill.wm "$1"
  }
  _runf kill_wid "$@";
}
