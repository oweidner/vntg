#/bin/sh

# ----------------------------------------------------------------------
# Display help for command "config"
#
vintage_config_help () {
    if test $# -gt 0; then shift; fi
    PARAMS=$*

    echo "Help for config option"
}

# ----------------------------------------------------------------------
# Run the "config" command
#
vintage_config () {
    uname -r
    uname -s
    uname -m

    echo "Root: ${VINTAGE_ROOT}"
    echo "Repository: ${VINTAGE_REPOSITORY_TYPE}: ${VINTAGE_REPOSITORY_REPO}"
}