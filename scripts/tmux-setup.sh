#!/bin/sh
# Ensure the tmux configuration and its plugins are in place. Called by ./dev
# (which runs at the end of every ./run) and by runs/*/tmux, so it must be
# idempotent and portable (POSIX sh; Linux and OpenBSD).
#
# - ~/.config/tmux/tmux.conf comes from env/.config/tmux (copied if missing)
# - the Tmux Plugin Manager is cloned into ~/.tmux/plugins/tpm, the path the
#   config pins via TMUX_PLUGIN_MANAGER_PATH (so ./dev wiping ~/.config/tmux
#   never removes plugins), and every @plugin from the config is installed
# - a throwaway tmux server confirms the config is actually loaded
set -u

dry_run="0"
if [ "${1:-}" = "--dry" ]; then dry_run="1"; fi

log() {
    if [ "$dry_run" = "1" ]; then echo "[DRY_RUN]: $1"; else echo "$1"; fi
}

do_run() {
    log "+ $*"
    if [ "$dry_run" = "0" ]; then "$@"; fi
}

DEV_ENV_HOME="${DEV_ENV_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"

for cmd in tmux git bash; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "tmux-setup: ERROR: $cmd is not installed (./run dev and ./run libs install them)" >&2; exit 1; }
done

# --- configuration ---
conf_dir="$HOME/.config/tmux"
conf="$conf_dir/tmux.conf"
src="$DEV_ENV_HOME/env/.config/tmux/tmux.conf"
[ -f "$src" ] || { echo "tmux-setup: ERROR: $src missing from the checkout" >&2; exit 1; }
if [ ! -s "$conf" ]; then
    log "tmux-setup: $conf missing, copying it from env/"
    do_run mkdir -p "$conf_dir"
    do_run cp "$src" "$conf"
fi
# Empty plugins/tmux and plugins/tpm stubs (old submodule entries) made TPM
# believe the plugins were installed; remove any that are still around.
for stub in "$conf_dir"/plugins/*; do
    [ -d "$stub" ] && rmdir "$stub" 2>/dev/null && log "tmux-setup: removed empty stub $stub"
done
rmdir "$conf_dir/plugins" 2>/dev/null || true

# --- plugin manager and plugins ---
tpm="$HOME/.tmux/plugins/tpm"
if [ -d "$tpm/.git" ]; then
    do_run git -C "$tpm" pull -q --ff-only || log "tmux-setup: WARN: could not update tpm"
else
    do_run git clone -q https://github.com/tmux-plugins/tpm "$tpm" || { echo "tmux-setup: ERROR: cloning tpm failed" >&2; exit 1; }
fi
# Installs (or skips, when present) every `set -g @plugin` from tmux.conf.
do_run "$tpm/bin/install_plugins" || { echo "tmux-setup: ERROR: plugin install failed (prefix + I inside tmux shows details)" >&2; exit 1; }

# --- verification on a private server, without touching a running one ---
if [ "$dry_run" = "0" ]; then
    tmux -L dev-setup-check new-session -d 2>/dev/null || { echo "tmux-setup: ERROR: tmux failed to start with $conf" >&2; exit 1; }
    loaded=$(tmux -L dev-setup-check display -p '#{config_files}')
    prefix=$(tmux -L dev-setup-check show -gv prefix)
    tmux -L dev-setup-check kill-server 2>/dev/null
    case "$loaded" in
        *"$conf"*) log "tmux-setup: OK, tmux loads $conf (prefix $prefix), plugins: $(ls "$HOME/.tmux/plugins" | tr '\n' ' ')" ;;
        *) echo "tmux-setup: ERROR: tmux did not load $conf (loaded: '${loaded:-nothing}')" >&2; exit 1 ;;
    esac
fi

log "tmux-setup: a running server keeps its old settings until: tmux kill-server"
