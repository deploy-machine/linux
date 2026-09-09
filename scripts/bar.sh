#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# Only one instance may write the root window name. A bar.sh from a previous
# login survives logout (xenodm does not kill stray processes) and reattaches
# to the next X server, so both loops then overwrite each other every second.
for pid in $(pgrep -f 'scripts/bar.sh'); do
  [ "$pid" != "$$" ] && kill "$pid" 2>/dev/null
done

# load colors
. ~/.config/scripts/bar_themes/radium

# Linux reads /proc and /sys; OpenBSD has neither, so each module has a branch.
os=$(uname -s)

cpu() {
  if [ "$os" = OpenBSD ]; then
    cpu_val=$(sysctl -n vm.loadavg | cut -d' ' -f1)
  else
    cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  fi

  printf "^c$blue^  $cpu_val"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)
  # OpenBSD: pkg_add -un and syspatch -c both need root, so there is no check here.

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  if [ "$os" = OpenBSD ]; then
    get_capacity="$(apm -l 2>/dev/null)"
  else
    get_capacity="$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)"
  fi
  printf "^c$red^   $get_capacity"
}

brightness() {
  printf "^c$red^   "
  if [ "$os" = OpenBSD ]; then
    # xbacklight is in Xenocara base (RandR backlight property)
    printf "^c$red^%.0f
" "$(xbacklight -get 2>/dev/null || echo 0)"
  else
    printf "^c$red^%.0f
" $(cat /sys/class/backlight/*/brightness)
  fi
}

mem() {
  printf "^c$yellow^  "
  if [ "$os" = OpenBSD ]; then
    # vmstat's avm column (active virtual memory), already human-sized
    printf "^c$yellow^ $(vmstat | awk 'NR==3 { print $3 }')"
  else
    printf "^c$yellow^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
  fi
}

wlan() {
  if [ "$os" = OpenBSD ]; then
    # every wireless interface is in the "wlan" group
    if ifconfig wlan 2>/dev/null | grep -q 'status: active'; then state=up; else state=down; fi
  else
    state="$(cat /sys/class/net/wl*/operstate 2>/dev/null)"
  fi
	case "$state" in
	up) printf "^c$pink^  ^d^%s" " ^c$pink^Connected" ;;
	down) printf "^c$pink^  ^d^%s" " ^c$pink^Disconnected" ;;
	esac
}

clock() {
	printf "^c$red^  "
	printf "^c$red^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates   $(brightness)   $(cpu)   $(mem)   $(wlan)   $(clock)   $(battery)"
done
