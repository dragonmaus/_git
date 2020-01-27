redo-ifchange all.list
redo-ifchange .gitignore
tr '\n' '\0' < all.list | xargs -0r redo-ifchange
