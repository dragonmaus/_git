redo-ifchange all.list
{
	echo /.gitignore
	sed 's;^;/;' < all.list
} | sort -u > "$3"
