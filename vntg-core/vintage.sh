#/bin/sh

. ./lib/config.sh
. ./lib/help.sh
. ./lib/search.sh
. ./lib/update.sh


VINTAGE_VERSION="0.1.0"
VINTAGE_PREFIX="/opt/vintage"

VINTAGE_ROOT="/opt/vintage/"
VINTAGE_REPOSITORY_TYPE="local"
VINTAGE_REPOSITORY_REPO="/Users/architeuthis/Projects/vintage/repo/"

# ANSI escape sequences:
# http://ascii-table.com/ansi-escape-sequences-vt-100.php
TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)

# ----------------------------------------------------------------------
# Display error and exit
#
odie() {
  if test -t 2 # check whether stderr is a tty.
  then
    # highlight Error with underline and red color
    echo -n "${TEXT_BOLD}Error: ${TEXT_RESET}" >&2
  else
    echo -n "Error: " >&2
  fi
  if test $# -eq 0
  then
    /bin/cat >&2
  else
    echo "$*" >&2
  fi
  exit 1
}

# ----------------------------------------------------------------------
# Change directory
#
chdir() {
  cd "$@" >/dev/null || odie "Error: failed to cd to $*!"
}

if test $VINTAGE_PREFIX = "/" || test $VINTAGE_PREFIX = "/usr"
then
  # we don't want to allow these prefixes
  odie "Refusing to continue at this prefix: $VINTAGE_PREFIX"
fi

# The first argument is the mandatory MODE parameter
case "$1" in

  "config")
    vintage_config $*;;
  
  "help")
    vintage_help $*;;

  "search")
    vintage_search $*;;

  "update")
    vintage_update $*;;

  "") # If no command is given, the default it 'help'
    vintage_help $*;;

  *) # Anything else will throw an error
    odie "Unknown command $1" ;;

esac

