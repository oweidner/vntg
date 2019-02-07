#/bin/sh

VNTG_SCRIPT_ROOT=/Users/dkolewei/vntg/vntg-core/

. ${VNTG_SCRIPT_ROOT}/lib/vntg_build.sh
. ${VNTG_SCRIPT_ROOT}/lib/vntg_install.sh
. ${VNTG_SCRIPT_ROOT}/lib/vntg_help.sh
# . ${VNTG_SCRIPT_ROOT}/lib/config.sh
# . ${VNTG_SCRIPT_ROOT}/lib/search.sh
# . ${VNTG_SCRIPT_ROOT}/lib/update.sh

VINTAGE_VERSION="0.1.0"
VINTAGE_ROOT="/opt/vntg/"
VINTAGE_REPOSITORY_TYPE="local"
VINTAGE_FORMULAE="/Users/dkolewei/vntg/vntg-formulae"

echo '____   ______________________________ '
echo '\   \ /   /\      \__    ___/  _____/ '
echo ' \   Y   / /   |   \|    | /   \  ___ '
echo '  \     / /    |    \    | \    \_\  \'
echo '   \___/  \____|__  /____|  \______  /'
echo '                  \/               \/ '

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

# if test $VINTAGE_PREFIX = "/" || test $VINTAGE_PREFIX = "/usr"
# then
#   # we don't want to allow these prefixes
#   odie "Refusing to continue at this prefix: $VINTAGE_PREFIX"
# fi

# The first argument is the mandatory MODE parameter
case "$1" in

  "build")
    vntg_build $*;;

  "install")
    shift;
    vntg_install $*;;

  "config")
    vintage_config $*;;
  
  "help")
    vntg_help $*;;

  "search")
    vintage_search $*;;

  "install")
    vntg_build $*;;

  "") # If no command is given, the default it 'help'
    vintage_help $*;;

  *) # Anything else will throw an error
    odie "Unknown command $1" ;;

esac

