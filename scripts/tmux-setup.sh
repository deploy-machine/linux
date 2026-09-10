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

# --- does tmux load the config at all? (checked on a private server) ---
# Everything below depends on it: TPM reads TMUX_PLUGIN_MANAGER_PATH from the
# server, and that variable is set by the config.
sock="dev-setup-check"
if [ "$dry_run" = "0" ]; then
    tmux -L "$sock" kill-server 2>/dev/null
    tmux -L "$sock" new-session -d 2>/dev/null || { echo "tmux-setup: ERROR: tmux failed to start (config error?)" >&2; tmux -L "$sock" new-session -d; exit 1; }
    loaded=$(tmux -L "$sock" display -p '#{config_files}')
    prefix=$(tmux -L "$sock" show -gv prefix)
    tpm_env=$(tmux -L "$sock" show-environment -g TMUX_PLUGIN_MANAGER_PATH 2>&1)
    tmux -L "$sock" kill-server 2>/dev/null
    case "$loaded" in
        *"$conf"*) log "tmux-setup: tmux loads $conf (prefix $prefix, $tpm_env)" ;;
        *)
            {
                echo "tmux-setup: ERROR: tmux did not load $conf"
                echo "  config files tmux loaded : '${loaded:-none}'"
                echo "  tmux version             : $(tmux -V)"
                echo "  XDG_CONFIG_HOME          : '${XDG_CONFIG_HOME:-unset}'"
                echo "  TMUX_CONF                : '${TMUX_CONF:-unset}'"
                echo "  HOME                     : '$HOME'"
                echo "  $conf:"; ls -la "$conf" 2>&1 | sed 's/^/    /'
                [ -e "$HOME/.tmux.conf" ] && { echo "  ~/.tmux.conf exists (it is loaded too):"; ls -la "$HOME/.tmux.conf" | sed 's/^/    /'; }
            } >&2
            exit 1 ;;
    esac
fi

# --- plugin manager and plugins ---
tpm="$HOME/.tmux/plugins/tpm"
if [ -d "$tpm/.git" ]; then
    do_run git -C "$tpm" pull -q --ff-only || log "tmux-setup: WARN: could not update tpm"
else
    do_run git clone -q https://github.com/tmux-plugins/tpm "$tpm" || { echo "tmux-setup: ERROR: cloning tpm failed" >&2; exit 1; }
fi
# Installs (or skips, when present) every `set -g @plugin` from tmux.conf. TPM
# talks to whatever server `tmux` reaches; a server started before the config
# had set-environment lacks the plugin path, so point it at a private socket
# directory where a fresh server (which reads the config) is started.
if [ "$dry_run" = "0" ]; then
    tpm_tmp=$(mktemp -d)
    if TMUX= TMUX_TMPDIR="$tpm_tmp" "$tpm/bin/install_plugins"; then
        log "tmux-setup: plugins present in $HOME/.tmux/plugins: $(ls "$HOME/.tmux/plugins" | tr '
' ' ')"
    else
        echo "tmux-setup: ERROR: plugin install failed" >&2; TMUX_TMPDIR="$tpm_tmp" tmux kill-server 2>/dev/null; rm -rf "$tpm_tmp"; exit 1
    fi
    TMUX_TMPDIR="$tpm_tmp" tmux kill-server 2>/dev/null
    rm -rf "$tpm_tmp"
else
    log "+ $tpm/bin/install_plugins (on a private server)"
fi

log "tmux-setup: a running server keeps its old settings until: tmux kill-server"
