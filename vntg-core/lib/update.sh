#/bin/sh

# ----------------------------------------------------------------------
# Display help for command "update"
#
vintage_update_help () {
    if test $# -gt 0; then shift; fi
    PARAMS=$*

    echo "Help for update option"
}

download_repo () {

    mkdir -p ${VINTAGE_ROOT}/.repo/

    cp -r ${VINTAGE_REPOSITORY_REPO}/* ${VINTAGE_ROOT}/.repo/
}

# ----------------------------------------------------------------------
# Run the "update" command
#
vintage_update () {
    download_repo
}