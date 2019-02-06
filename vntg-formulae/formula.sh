#!/bin/sh


echo '____   ______________________________ '
echo '\   \ /   /\      \__    ___/  _____/ '
echo ' \   Y   / /   |   \|    | /   \  ___ '
echo '  \     / /    |    \    | \    \_\  \'
echo '   \___/  \____|__  /____|  \______  /'
echo '                  \/               \/ '

FORMULAE="/Users/dkolewei/vntg/vntg-formulae"

# Find and prse the formula file
if [ -f "${FORMULAE}/${1}" ]
then
  echo "$file found."

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

else
  echo "$file not found."
  exit -1
fi

do_check_dep() {
    _name=$1
    _version=$2

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
package_name=$(echo ${package_name} | sed -e 's/^ *//g;s/ *$//g')
package_deps=$(echo ${package_deps} | sed -e 's/^ *//g;s/ *$//g')
package_version=$(echo ${package_version} | sed -e 's/^ *//g;s/ *$//g')
package_src_build_configure=$(echo ${package_src_build_configure} | sed -e 's/^ *//g;s/ *$//g')
package_src_location=$(echo ${package_src_location} | sed -e 's/^ *//g;s/ *$//g')

# check dependencies
# for each dependecy, do the following:
# 1. check if depdent package is installed

for dep in $(echo $package_deps | sed "s/,/ /g")
do
    # split dependency into name and version
    dep_name=$(echo $dep | cut -f1 -d-)
    dep_version=$(echo $dep | cut -f2 -d-)

    if ! do_check_dep $dep_name $dep_version; then
        echo "Dependency ${dep} is missing"
        exit 1
    else
        echo "Dependency ${dep} found"
fi
done

do_source_get ${package_src_location} ${package_name} ${package_version}
#do_source_configure ${package_name} ${package_version} ${package_src_build_configure}
#do_source_build ${package_name} ${package_version}
do_package ${package_name} ${package_version}

