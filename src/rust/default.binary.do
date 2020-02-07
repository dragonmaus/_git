redo-always

realpath "$( which "$2" )" > "$3"
redo-stamp < "$3"
