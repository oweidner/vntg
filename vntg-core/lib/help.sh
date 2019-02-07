#/bin/sh

. ./lib/vntg_build.sh
. ./lib/config.sh
. ./lib/search.sh
. ./lib/update.sh


# ----------------------------------------------------------------------
# Display help functions
#
vintage_help () {

    # Disaply help for command specified as argument
    if test $# -gt 1; then
        shift;
        case "$1" in

            "build")
                vntg_build_help ;;

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
