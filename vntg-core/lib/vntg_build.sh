#!/bin/sh

REPO_PATH="/Users/architeuthis/Code/vntg/vntg-formulae"
CONFIG_FILE="/Users/architeuthis/Code/vntg/vntg-formulae/irix64-mips4-cc.cfg"

# do_check_formula(): Parse a formula file
#   o param 1: formula name
#
do_check_formula() {
    
    typeset _formula_name=$1

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
    typeset _name=$1
    typeset _version=$2

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
    # Parse build options. Adopted from
    # https://stackoverflow.com/questions/4882349/parsing-shell-script-arguments#4882493
    #
    if test $# -gt 0; then shift; fi

    while [[ $1 == -* ]]; do
        case "$1" in
        -h|--help|-\?) vntg_build_help; exit 0;;
        -i|--install)  opt_install=1; shift;;
        -d|--dist)     opt_dist=1; shift;;
        --no-prune)    opt_noprune=1; shift;;
        -v|--verbose)  opt_verbose=1; shift;;
        -*) odie "Unknown option $1";;
        esac
    done

    # Parse the build environment config file
    # TODO: Move this to separate function
    if [ ! -f "${CONFIG_FILE}" ]
    then
        echo "Build environment $CONFIG_FILE not found."
        exit -1
    else
        while IFS='=' read -r key value
        do
            # skip empty lines
            [ -z $key ] && continue

            key=$(echo $key | tr '.' '_')
            eval typeset ${key}=\${value}
        done < "$CONFIG_FILE"

        # Prune whitespaces
        # TODO - find a more elegant solution
        buildenv_name=$(echo ${buildenv_name} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_srcrep=$(echo ${buildenv_srcrep} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_pkgrep=$(echo ${buildenv_pkgrep} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_PATH=$(echo ${buildenv_PATH} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_LD_LIBRARY_PATH=$(echo ${buildenv_LD_LIBRARY_PATH} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_ABI=$(echo ${buildenv_compiler_ABI} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CC=$(echo ${buildenv_compiler_CC} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CFLAGS=$(echo ${buildenv_compiler_CFLAGS} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CXX=$(echo ${buildenv_compiler_CXX} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CXXFLAGS=$(echo ${buildenv_compiler_CXXFLAGS} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CXX=$(echo ${buildenv_compiler_CXX} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_compiler_CXXFLAGS=$(echo ${buildenv_compiler_CXXFLAGS} | sed -e 's/^ *//g;s/ *$//g')
        buildenv_linker_LDFLAGS=$(echo ${buildenv_linker_LDFLAGS} | sed -e 's/^ *//g;s/ *$//g')

        echo ""
        echo "${TEXT_B}Using environment ${buildenv_name}:${TEXT_R}"
        echo ""
        echo "  o Source repo     = "${buildenv_srcrep}
        echo "  o Package repo    = "${buildenv_pkgrep}
        echo "  o PATH            = "${buildenv_PATH}
        echo "  o LD_LIBRARY_PATH = "${buildenv_LD_LIBRARY_PATH}
        echo "  o ABI             = "${buildenv_compiler_ABI}
        echo "  o CC              = "${buildenv_compiler_CC}
        echo "  o CFLAGS          = "${buildenv_compiler_CFLAGS}
        echo "  o CXX             = "${buildenv_compiler_CXX}
        echo "  o CXXFLAGS        = "${buildenv_compiler_CXXFLAGS}
        echo "  o LDFLAGS         = "${buildenv_linker_LDFLAGS}

    fi


    # TODO - fix the path.
    typeset formula_name=$1
    typeset formula_file="${REPO_PATH}/${formula_name}.vf" 

    if [ ! -f "${formula_file}" ]
    then
        echo "Formula $formula_file not found."
        exit -1
    else
        while IFS='=' read -r key value
        do
            # skip empty lines
            [ -z $key ] && continue

            key=$(echo $key | tr '.' '_')
            eval typeset ${key}=\${value}
        done < "$formula_file"

        package_name=$(echo ${package_name} | sed -e 's/^ *//g;s/ *$//g')
        package_deps=$(echo ${package_deps} | sed -e 's/^ *//g;s/ *$//g')
        package_version=$(echo ${package_version} | sed -e 's/^ *//g;s/ *$//g')
        package_src_location=$(echo ${package_src_location} | sed -e 's/^ *//g;s/ *$//g')
        package_src_build_deps=$(echo ${package_src_build_deps} | sed -e 's/^ *//g;s/ *$//g')
        package_src_build_configure=$(echo ${package_src_build_configure} | sed -e 's/^ *//g;s/ *$//g')
        package_src_build_configure_script=$(echo ${package_src_build_configure_script} | sed -e 's/^ *//g;s/ *$//g')

	# Use custom configure script if defined
        if [ -n ${package_src_build_configure_script} ];
        then 
            configure="${package_src_build_configure_script} ${package_src_build_configure}"
        else
            configure="./configure --prefix=/opt/vntg/pkg/${package_name}/${package_version} --libdir=/opt/vntg/pkg/${package_name}/${package_version}/lib64 ${package_src_build_configure}"
        fi

        echo ""
        echo "${TEXT_B}Building formula ${package_name} (${package_version}):${TEXT_R}"
        echo ""
        echo "  o Source location = " ${package_src_location}
        echo "  o Dependencies    = " ${package_src_build_deps} ${package_deps}
        echo "  o Config options  = " ${configure}
        echo ""

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

    export ABI=64
    export CC=c99
    export CXX=CC
    export CFLAGS='-64 -mips4 -c99 -O2 -LANG:anonymous_unions=ON -I/opt/vntg/include:/usr/include -L/opt/vntg/lib64 -L/usr/lib64'
    export CXXFLAGS='-64 -mips4 -c99 -O2 -LANG:anonymous_unions=ON -I/opt/vntg/include:/usr/include -L/opt/vntg/lib64 -L/usr/lib64'
    export CPPFLAGS='-64 -mips4 -c99 -O2 -LANG:anonymous_unions=ON -I/opt/vntg/include -L/opt/vntg/lib64 -L/usr/lib64'

    export LD_LIBRARY_PATH='/opt/vntg/lib64:/usr/lib64'
    export LDFLAGS='-64 -L/opt/vntg/lib64 -L/usr/lib64'
    export PATH=/opt/vntg/bin:$PATH
    export PKG_CONFIG=/opt/vntg/bin/pkg-config

    # prune dead links
    if [ "$opt_noprune" == "1" ]; then
        echo "==> pruning... SKIPPED. "
    else
        echo "==> pruning... "
        cd /opt/vntg/
        find * -type l -exec sh -c '! test -e $0 && unlink $0' {} \;
    fi 


    echo "==> unpacking"
    mkdir -p "/tmp/vntg-build/"
    cd /tmp/vntg-build/
    cp ${package_src_location} /tmp/vntg-build/
    tar xf /tmp/vntg-build/${package_name}-${package_version}.tar
    rm /tmp/vntg-build/${package_name}-${package_version}.tar
    cd /tmp/vntg-build/${package_name}-${package_version}/
    ls /tmp/vntg-build/

    [ -d /opt/vntg/pkg/${package_name}/${package_version}/ ] && echo "exists" && exit 1
    
    echo "==> configuring"
    ${configure} || exit 1

    make || exit 1
    make install || exit 1

    echo "==> activating"
    # Create directory structure and symlinks in /opt/vntg/
    cd /opt/vntg/pkg/${package_name}/${package_version}/
    find . -type d -depth | cpio -dumpl /opt/vntg/
    find * -type f -depth -exec sh -c 'ln -fs `pwd`/$0 /opt/vntg/$0' {} \;
    find * -type l -depth -exec sh -c 'ln -fs `pwd`/$0 /opt/vntg/$0' {} \;

    echo "==> packaging"
    cd /opt/vntg/pkg/
    tar cf /opt/vntg/rep/vntg-${package_name}-${package_version}-n64.tar ${package_name}/${package_version}
}

# ----------------------------------------------------------------------
# Display help 
#
vntg_build_help () {
    echo """${TEXT_B}vntg build${TEXT_R} [options] ${TEXT_U}formula${TEXT_R}:

    Build ${TEXT_U}formula${TEXT_R} from source.

    ${TEXT_U}formula${TEXT_R} is the name of the formula to build.

    ${TEXT_B}--install${TEXT_R}       Install ${TEXT_U}formula${TEXT_R} under /opt/vntg after the build was successful.

    ${TEXT_B}--dist${TEXT_R}          Create distribution archive after build was successful

    ${TEXT_B}--no-prune${TEXT_R}      Omitt dead link pruning in /opt/vntg before build. 
                    WARNING: this can lead to unwanted side-effects.

    ${TEXT_B}--verbose${TEXT_R}       Print the output of all build steps to STDOUT.

    ${TEXT_B}--help${TEXT_R}          Show this message.
    --------------------------------------------------------------------------------
    """
    
    return 0
}
