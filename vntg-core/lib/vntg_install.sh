#!/bin/sh

. ${VNTG_SCRIPT_ROOT}/lib/vntg_utils.sh
. ${VNTG_SCRIPT_ROOT}/lib/vntg_config.sh


# ----------------------------------------------------------------------
# _is_installed: returns true if package is installed, false otherwise.
#  o param 1 <package_name>: package name to check
#  o param 2 <package_version>: package version to check
# 
_is_installed() {
    local _package_name=$1
    local _package_version=$2

    if [ -d "/opt/vntg/pkg/${_package_name}/${_package_version}" ]; then
        # TODO: Check if packages is linked properly into /opt/vntg.
        #       If not, suggest to run 'vntg relink'
        return 0
    else
        return 1
    fi
}

# ----------------------------------------------------------------------
# _get_deps_recursive: retrieves a list of all required and missing packages
#  o param 1 <package_name>: package name to get dependencies for
#  o param 2 <package_version>: package version to get dependencies for
#
_get_deps_recursive() {
    local _package_name=$1
    local _package_version=$2

    if ! _is_installed ${_package_name} ${_package_version}; then
        local _file="$VNTG_CFG_BASE/vntg-formulae/${_package_name}.vf" 
        [ ! -f "${_file}" ] && echo "Formula $_file not found." && exit -1

        local deps=$(grep '^package.deps' ${_file} | cut -f2 -d=)
        local dep
        for dep in $(echo $deps | sed "s/,/ /g")
        do
            local _name=$(echo $dep | cut -f1 -d-)
            local _package=$(echo $dep | cut -f2 -d-)
            _get_deps_recursive ${_name} ${_package}
        done
        dependency_list="${dependency_list},${_package_name}"
    else
        return
    fi

}

# ----------------------------------------------------------------------
# _download_binary_package
#  o param 1 <package_name>: name of the package to download
#  o param 2 <package_version>: version of the package to download
#
_download_binary_package () {
    local _package_name=$1
    local _package_version=$2

    # Make sure file exists
    local _file="$VNTG_CFG_BASE/vntg-formulae/${_package_name}.vf" 
    [ ! -f "${_file}" ] \
        && odie "Formula $_file not found." && exit -1

    # Make sure package.location is defined
    local _url=$(grep '^package.location' ${_file} | cut -f2 -d=)
    [ -z ${_url} ] \
        && odie "package.location not defined in ${_file}" && exit -1
    
    echo " o Downloading package from $_url"
}

# ----------------------------------------------------------------------
# _unpack_binary_package: unpacks the tar archive into /opt/vntg/pkg/
#  o param 1 <package_name>: name of the package to unpack
#  o param 2 <package_version>: version of the package to unpack
#
_unpack_binary_package () {
    local _package_name=$1
    local _package_version=$2

    echo " o Installing package into ${TEXT_B}/opt/vntg/${_package_name}/${_package_version}/${TEXT_R}"

}

# ----------------------------------------------------------------------
# _display_notice: 
#  o param 1 <package_name>: name of the package to unpack
#  o param 2 <package_version>: version of the package to unpack
#
_activate_package () {
    local _package_name=$1
    local _package_version=$2

    echo " o Linking package content into /opt/vntg/"

}

# ----------------------------------------------------------------------
# Entry point for 'build'
#
vntg_install () {

    # TODO - parse arguments
    local _formula_name=$1
    local _file="$VNTG_CFG_BASE/vntg-formulae/${_formula_name}.vf" 

    if [ ! -f "${_file}" ]
    then
        echo "Formula $_file not found."
        exit -1
    else
        while IFS='=' read -r key value
        do
            # skip empty lines
            [ -z $key ] && continue

            key=$(echo $key | tr '.' '_')
            eval local ${key}=\${value}
        done < "$_file"
    fi

    package_name=$(echo ${package_name} | sed -e 's/^ *//g;s/ *$//g')
    package_deps=$(echo ${package_deps} | sed -e 's/^ *//g;s/ *$//g')
    package_version=$(echo ${package_version} | sed -e 's/^ *//g;s/ *$//g')
    package_location=$(echo ${package_location} | sed -e 's/^ *//g;s/ *$//g')

    # Recursively retrieve missing dependencies
    dependency_list=""
    _get_deps_recursive ${package_name} ${package_version}
    # Remove first comma and last element from list as it is the package itself.
    dependency_list=$(echo $dependency_list | sed "s/,${package_name}//g" | tail -c +2)

    echo "Missing dependencies for ${package_name}-${package_version}: ${bold}$dependency_list ${normal}"
    echo

    # Install missing dependencies
    local dep
    for dep in $(echo $dependency_list | sed "s/,/ /g" )
    do
        echo "${TEXT_B}==>${TEXT_R} Installing ${package_name}-${package_version} dependency ${TEXT_B}${dep}${TEXT_R}"
        _download_binary_package ${dep} # exits on error - TODO: rollback
        _unpack_binary_package ${dep}   # exits on error - TODO: rollback
        _activate_package ${dep}   # exits on error - TODO: rollback
        echo
    done

    # All dependencies are installed. Now we can finally 
    # install the requested package
    echo "${TEXT_B}==>${TEXT_R} Installing package ${package_name}-${package_version}"
    _download_binary_package ${package_name} ${package_version}
    _unpack_binary_package ${package_name} ${package_version}
    _activate_package ${package_name} ${package_version}

}


# ----------------------------------------------------------------------
# Display help 
#
vntg_install_help () {
    echo """${TEXT_B}vntg install${TEXT_R} [--verbose] ${TEXT_U}formula${TEXT_R}:

    Install a formula as binary package.

    ${TEXT_U}formula${TEXT_R} is the name of the formula to install.

    If ${TEXT_B}--verbose${TEXT_R} (or -v) is passed, print the output of all installation 
    steps to stdout.
    """
    return 0
}
