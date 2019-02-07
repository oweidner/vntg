#/bin/sh

. ${VNTG_SCRIPT_ROOT}/lib/vntg_build.sh
. ${VNTG_SCRIPT_ROOT}/lib/vntg_install.sh
# . ${VNTG_SCRIPT_ROOT}/lib/config.sh
# . ${VNTG_SCRIPT_ROOT}/lib/search.sh
# . ${VNTG_SCRIPT_ROOT}/lib/update.sh


# ----------------------------------------------------------------------
# Display help functions
#
vntg_help () {

    # Disaply help for command specified as argument
    if test $# -gt 1; then
        shift;
        case "$1" in

            "build")
                vntg_build_help ;;

            "install")
                vntg_install_help ;;

            "config")
                vintage_config_help; break ;;
            
            "search")
                vintage_search_help; break ;;

            "update")
                vintage_update_help; break ;;

            *) # Anything else will throw an error
                odie "Unknown help topic: $1" ;;
        esac

    # If no arguments are given, display default help
    else
        # Display general help
        echo "Help: $PARAMS"
    fi
}
