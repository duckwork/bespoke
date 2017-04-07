# /usr/bin/env dash

# set config stuff

set_borders()
{ # set borders according to config
  . $WMD/config
  case $1 in
    0x*)
      [ $# -eq 2 ] || return 1;
      chwb -s $border_width -c $border_color_normal $1;
      chwb -s $border_width -c $border_color_focus $2;
      ;;
    all)
      for w in $TMP/clients/mapped; do
        chwb -s $border_width $w;
        if [ "$w" = "$(pfw)" ]; then
          chwb -c $border_color_focus $w;
        else
          chwb -c $border_color_normal $w;
        fi
      done
    ;;
esac
}
