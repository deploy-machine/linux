export XDG_CONFIG_HOME=$HOME/.config
VIM="nvim"

PERSONAL=$HOME/personal

# FZF initialization
#if [ -f "$HOME/.fzf.zsh" ]; then
#	source "$HOME/.fzf.zsh"
#fi

# Export other environment variables
export GOPATH="$HOME/.local/go"
export GIT_EDITOR="$VIM"
export DENO_INSTALL="$HOME/.deno"
export N_PREFIX="$HOME/.local/n"
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export DEV_ENV_HOME="$HOME/dev"

#bindkey -s '^f' "tmux-sessionizer\n"

# Function to output a specific range of lines from a file
catr() {
	tail -n "+$1" "$3" | head -n "$(( $22 - $1 + 1))"
}

# Function to remove newline from file output
cat1Line() {
	cat "$1" | tr -d "\n"
}

# Function to add a directory to the PATH if not already present
addToPath() {
	if echo "$PATH" | grep -qv "$1"; then
		export PATH="$PATH:$1"
	fi
}

# Function to add a directory to the front oif the PATH if not already present
addToPathFront() {
	if echo "$PATH" | grep -qv "$1"; then
		export PATH="$1:$PATH"
	fi
}

# Add directoriues to PATH
addToPathFront "$HOME/.local/.npm-global/bin"
addToPathFront "$HOME/.local/scripts"
addToPathFront "$HOME/.local/bin"
addToPathFront "$HOME/.local/n/bin"
addToPathFront "$HOME/.local/apps"

# Additional path configurations
addToPathFront "$HOME/.local/go/bin"
addToPathFront "/usr/local/go/bin"
addToPathFront "$HOME/.deno/bin"
addToPath "$HOME/.cargo/bin"

# Define alias for 'gt'
alias gt='NODE_OPTIONS="--no-deprecation" gt'

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
	exec startx &>/dev/null 
	xrandr --output DP-2 --primary --mode 1920x1080 --rate 240 --output DP-1 --right-of DP-2 --mode 1920x1080 --rate 60 --output HDMI-1 --left-of DP-2 --mode 1920x1080 --rate 60
	feh --bg-fill ~/Pictures/gowall/hokusai.jpg
	picom -b --experimental-backends &
fi
source /home/simbaclaws/.deno/env
source /home/simbaclaws/.local/share/bash-completion/completions/deno.bash

