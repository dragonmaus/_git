# ~/.profile

# User-specific shell login profile

# Enforce `separation of concerns' between login and interactive shells
shell="$( basename "$SHELL" )"
shell="${shell:-sh}"
case "$-" in
(*i*)
	exec "$shell" -l -c 'exec "$shell" -i "$@"' "$shell" "$@"
	;;
esac

# Ensure that `echo' is sane
case "$KSH_VERSION" in
(*MIRBSD\ KSH*|*LEGACY\ KSH*|*PD\ KSH*)
	alias echo='print -R'
	;;
(*)
	echo() (
		f='%s\n'
		case "$1" in
		(-n)
			f='%s'
			shift
			;;
		esac
		printf "$f" "$*"
	)
	;;
esac

# XDG directories
CONF="${XDG_CONFIG_HOME:-"$HOME/.config"}"
DATA="${XDG_DATA_HOME:-"$HOME/.local/share"}"

# Clean up and augment PATH
command -v realpath > /dev/null || realpath() ( readlink -f "$1" )
path=
ifs="$IFS"
IFS=:
for d in "$HOME/bin" "$HOME/.cargo/bin" "$HOME/src/go/bin" "$HOME/src/go/ext/bin" "$HOME/.local/bin" $PATH /usr/games
do
	d="$( realpath "$d" 2> /dev/null || echo "$d" )"
	case ":$path:" in
	(*":$d:"*)
		continue
		;;
	esac
	path="$path:$d"
done
IFS="$ifs"
path="${path#:}"

# Start ssh-agent if not already running
pgrep -qx -U "$( id -u )" ssh-agent || ssh-agent > "$HOME/.ssh/agent.sh"

# Set environment
set -a

## Paths
GOPATH="$HOME/src/go/ext:$HOME/src/go"
MANPATH="$DATA/man:"
PATH="$path"

## Shell configuration
ENV="$CONF/shell/init.sh"

## Global configuration
EDITOR="$( which nvim vim vi 2> /dev/null | head -1 )"
HOSTNAME="${HOSTNAME:-"$( hostname -s )"}"
LANG=en_US.UTF-8
LC_COLLATE=C

set +a

# SSH agent
[[ -f "$HOME/.ssh/agent.sh" ]] && . "$HOME/.ssh/agent.sh"

umask 022