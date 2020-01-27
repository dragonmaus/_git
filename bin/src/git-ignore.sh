#!/bin/sh

set -e

echo() {
	print -r -- "$*"
}

find_gitignore() (
	while :
	do
		if [[ -f .gitignore || -d .git ]]
		then
			echo "$( env - "PATH=$PATH" pwd )/.gitignore"
			return 0
		fi
		if [[ . -ef .. ]]
		then
			return 1
		fi
		cd ..
	done
)

if file="$( find_gitignore )"
then
	[[ -e "$file" ]] || touch "$file"

	rm -f "$file{tmp}"
	for line
	do
		echo "$line"
	done | cat "$file" - | sort -u | grep . > "$file{tmp}"

	rm -f "$file{new}"
	{
		grep -v '^!' < "$file{tmp}" || :
		grep '^!' < "$file{tmp}" || :
	} > "$file{new}"
	rm -f "$file{tmp}"

	print -n "Updating $file... "
	if cmp -s "$file" "$file{new}"
	then
		echo 'Nothing to do!'
	else
		mv -f "$file{new}" "$file"
		echo 'Done!'
	fi
	rm -f "$file{new}"
else
	echo "$0: Not inside a git repository"
	exit 1
fi
