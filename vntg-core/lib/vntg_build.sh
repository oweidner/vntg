#!/bin/sh


# do_check_formula(): Parse a formula file
#   o param 1: formula name
#
do_check_formula() {
    
    local _formula_name=$1

    if [ ! -f "${FORMULAE}/${1}" ]
    then
        echo "$file not found."
        exit -1
    else
        echo "$_formula_name found."

        while IFS='=' read -r key value
        do
            # skip empty lines
            [ -z $key ] && continue

            key=$(echo $key | tr '.' '_')
            eval ${key}=\${value}
        done < "${FORMULAE}/${1}"

        echo "\nBuilding package:"
        echo "================="
        echo "Package Name     = " ${package_name}
        echo "Package Version  = " ${package_version}
        echo "Package Location = " ${package_location}
        echo "Package Deps     = " ${package_deps}
    fi
}

# ----------------------------------------------------------------------
# do_check_dep: checks if package exists in the /opt/vntg tree.
#  o param 1 <name>: package name to check
#  o param 2 <version>: package version to check
#
do_check_dep() {
    local _name=$1
    local _version=$2

    if [ -d "/opt/vntg/pkg/${_name}/${_version}" ]; then
        # TODO: Check if packages is linked properly into /opt/vntg.
        #       If not, suggest to run 'vntg relink'
        return 0
    else
        return 1
    fi
}

do_source_get () {
    source_location=$1
    name=$2
    version=$3

    archive=$(basename $source_location)
    srcdir=/opt/vntg/src/${name}/${version}
    rm -rf $archive 
    rm -rf $srcdir

    mkdir -p $srcdir
    cd /opt/vntg/src/
    wget $source_location
    
    tar xzf $archive -C /opt/vntg/src/${name}/${version} --strip-components=1
    rm $archive
}

do_source_configure () {
    name=$1
    version=$2
    configure_flags=$3

    cd /opt/vntg/src/${name}/${version}
    configure="./configure --prefix=/opt/vntg/pkg/${name}/${version} --libdir=/opt/vntg/pkg/${name}/${version}/lib64 ${configure_flags}"
    $configure
}

do_source_build () {
    name=$1
    version=$2
    cd /opt/vntg/src/${package_name}/${package_version}
    # make
    # make install
    #make clean

    # copy build file to .vntg
    mkdir /opt/vntg/pkg/${package_name}/${package_version}/.vntg/
    cp ${FORMULAE}/$file /opt/vntg/pkg/${package_name}/${package_version}/.vntg/
}

do_package () {
    name=$1
    version=$2

    # copy build file to .vntg
    mkdir /opt/vntg/pkg/${package_name}/${package_version}/.vntg/
    cp ${FORMULAE}/$file /opt/vntg/pkg/${package_name}/${package_version}/.vntg/

    # create archive
    cd /opt/vntg/pkg/
    tar cfz vntg-${name=}-${version}.tgz ${name=}/${version}

    for miscfile in $(echo ${pacakge_src_build_copyfiles} | sed "s/,/ /g")
    do
        # copy the file to distribution directory
        cp /opt/vntg/src/${package_name}/${package_version}/${miscfile} /opt/vntg/pkg/${package_name}/${package_version}/
    done

}

do_install_from_source () {
    do_source_get ${package_src_location} ${package_name} ${package_version}
    do_source_configure ${package_name} ${package_version} ${package_src_build_configure}
    do_source_build ${package_name} ${package_version}
}

# Strip leading and trailing whitespaces
# package_name=$(echo ${package_name} | sed -e 's/^ *//g;s/ *$//g')
# package_deps=$(echo ${package_deps} | sed -e 's/^ *//g;s/ *$//g')
# package_version=$(echo ${package_version} | sed -e 's/^ *//g;s/ *$//g')
# package_src_build_configure=$(echo ${package_src_build_configure} | sed -e 's/^ *//g;s/ *$//g')
# package_src_location=$(echo ${package_src_location} | sed -e 's/^ *//g;s/ *$//g')

# check dependencies
# for each dependecy, do the following:
# 1. check if depdent package is installed

# for dep in $(echo $package_deps | sed "s/,/ /g")
# do
#     # split dependency into name and version
#     dep_name=$(echo $dep | cut -f1 -d-)
#     dep_version=$(echo $dep | cut -f2 -d-)

#     if ! do_check_dep $dep_name $dep_version; then
#         echo "Dependency ${dep} is missing"
#         exit 1
#     else
#         echo "Dependency ${dep} found"
# fi
# done

# do_check_formula $1
# exit

# do_source_get ${package_src_location} ${package_name} ${package_version}
# #do_source_configure ${package_name} ${package_version} ${package_src_build_configure}
# #do_source_build ${package_name} ${package_version}
# do_package ${package_name} ${package_version}

# ----------------------------------------------------------------------
# Entry point for 'build'
#
vntg_build () {
    # Paramaters passed to the build command
    if test $# -gt 0; then shift; fi
    PARAMS=$*

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

        echo "Building package:"
        echo " o Package File     = " ${_file}
        echo " o Package Name     = " ${package_name}
        echo " o Package Version  = " ${package_version}
        echo " o Package Location = " ${package_location}
        echo " o Package Deps     = " ${package_deps}
    fi

    # Check package build dependencies
    echo 
    echo "Checking build dependencies..."
    for dep in $(echo $package_deps | sed "s/,/ /g")
    do
        # split dependency into name and version
        dep_name=$(echo $dep | cut -f1 -d-)
        dep_version=$(echo $dep | cut -f2 -d-)

        if ! do_check_dep $dep_name $dep_version; then
            echo " o ${dep} is missing"
            exit 1
        else
            echo " o ${dep} found"
    fi
done
}

# ----------------------------------------------------------------------
# Display help 
#
vntg_build_help () {
    echo """${bold}vntg build${normal} [--install] [--dist] [--verbose] ${underline}formula${normal}:

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