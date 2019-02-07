#!/bin/sh


# ----------------------------------------------------------------------
# _is_installed: returns true if package is installed, false otherwise.
#  o param 1 <name>: package name to check
#  o param 2 <version>: package version to check
# 
_is_installed() {
    return 1
}

# ----------------------------------------------------------------------
# _get_deps_recursive: retrieves all required and not installed packages
#  o param 1 <name>: package name to check
#
_get_deps_recursive() {
    
    local _name=$1

    local deps=$(grep '^package.deps' "/Users/dkolewei/vntg/vntg-formulae/${_name}.vf" | cut -f2 -d=)
    for dep in $(echo $deps | sed "s/,/ /g")
    do
        _get_deps_recursive $(echo $dep | cut -f1 -d-)
    done

    dependency_list=$dependency_list",$_name"
    # echo $x


    # local dep
    # for dep in $(echo $package_deps | sed "s/,/ /g")
    #     do
    #         # split dependency into name and version
    #         local dep_name=$(echo $dep | cut -f1 -d-)
    #         local dep_version=$(echo $dep | cut -f2 -d-)

    #         if ! _is_installed $dep_name $dep_version; then
    #             echo " o ${dep} is missing"
    #             _get_deps_recursive $dep_name $dep_version
    #             #exit 1
    #         else
    #             echo " o ${dep} found"
                
    #         fi
    #     done

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

    echo "${bold}==>${normal} Installing package ${package_name} ${package_version} from ${package_location}"

    # Recursively retrieve missing dependencies
    dependency_list=""
    _get_deps_recursive ${package_name} ${package_version}
    echo "    Missing dependencies for ${package_name}: ${bold} $dependency_list ${normal}"

    # Install missing dependencies
    local dep
    for dep in $(echo $dependency_list | sed "s/,/ /g")
    do
        echo "${bold}==>${normal} Installing ${package_name} ${package_version} dependency ${bold}${dep}${normal}"
        echo
    done
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