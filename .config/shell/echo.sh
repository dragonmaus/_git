echo() (
	f='%s\n'
	case "$1" in
	(-n)
		f='%s'
		;;
	esac
	printf "$f" "$@"
)
