#!/bin/sh


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

        local deps=$(grep '^package.deps' "/Users/dkolewei/vntg/vntg-formulae/${_package_name}.vf" | cut -f2 -d=)
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
# Entry point for 'build'
#
vntg_install () {

    # TODO - parse arguments
    local _formula_name=$1
    local _file="/Users/dkolewei/vntg/vntg-formulae/${_formula_name}.vf" 

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
    # TODO: Remove last element from list as it is the package itself.


    echo "Detected missing dependencies for ${package_name}-${package_version}: ${bold} $dependency_list ${normal}"
    echo

    # Install missing dependencies
    local dep
    for dep in $(echo $dependency_list | sed "s/,/ /g")
    do
        echo "${bold}==>${normal} Installing ${package_name}-${package_version} dependency ${bold}${dep}${normal}"
        echo
    done

    # Install the requested package
    echo "${bold}==>${normal} Installing package ${package_name}-${package_version}"

}


# ----------------------------------------------------------------------
# Display help 
#
vntg_install_help () {
    echo """${bold}vntg install${normal} [--verbose] ${underline}formula${normal}:

    Build a formula from source

    ${underline}formula${normal} is the name of the formula to build.

    If ${bold}--install${normal} is specified and the build was successfull the package 
    is installed (linked) under /opt/vntg. 

    If ${bold}--dist${normal} is specified and the build was successfull the package 
    is compressed into a distribution archive. 

    If ${bold}--verbose${normal} (or -v) is passed, print the output of all build steps
    to stdout.
    """
    return 0
}