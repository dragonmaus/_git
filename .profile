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

# Clean up and augment PATH
command -v realpath > /dev/null || realpath() ( readlink -f "$1" )
path=
ifs="$IFS"
IFS=:
for d in "$HOME/bin" "$HOME/.cargo/bin" "$HOME/src/go/bin" "$HOME/src/go/ext/bin" "$HOME/.local/bin" $PATH /usr/games
do
	d="$( realpath "$d" 2> /dev/null || print -r -- "$d" )"
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
PATH="$path"
MANPATH="$HOME/.local/share/man:"
GOPATH="$HOME/src/go/ext:$HOME/src/go"

## Shell configuration
ENV="$HOME/.shrc"

## Global configuration
EDITOR="$( which nvim vim vi 2> /dev/null | head -1 )"
LANG=en_US.UTF-8
LC_COLLATE=C
HOSTNAME="${HOSTNAME:-"$( hostname -s )"}"

## App-specific configuration
[[ -f "$HOME/.ssh/agent.sh" ]] && . "$HOME/.ssh/agent.sh"

set +a

umask 022
