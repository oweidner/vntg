#!/bin/sh

# Typography
# See: ANSI escape sequences:
# http://ascii-table.com/ansi-escape-sequences-vt-100.php
TEXT_B=$(tput bold) # bold
TEXT_U=$(tput smul) # underlined
TEXT_R=$(tput sgr0) # reset

# ----------------------------------------------------------------------
# Display error and exit
#
ODIE() {
  if test -t 2 # check whether stderr is a tty.
  then
    # highlight Error with underline and red color
    echo -n "${TEXT_B}Error: ${TEXT_R}" >&2
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
