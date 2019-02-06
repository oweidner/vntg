#!/bin/sh

echo '____   ______________________________ '
echo '\   \ /   /\      \__    ___/  _____/ '
echo ' \   Y   / /   |   \|    | /   \  ___ '
echo '  \     / /    |    \    | \    \_\  \'
echo '   \___/  \____|__  /____|  \______  /'
echo '                  \/               \/ '

file="$1"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
  done < "$file"

  echo "\PACKAGE INFO"
  echo "==================="
  echo "Package Name     = " ${package_name}
  echo "Package Version  = " ${package_version}
  echo "Package Location = " ${package_location}
  echo "Package Deps     = " ${package_deps}

else
  echo "$file not found."
fi

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
    make
    make install
    #make clean
}

do_package () {
    name=$1
    version=$2

    cd /opt/vntg/pkg/
    tar cfz vntg-${name=}-${version}.tgz ${name=}/${version}
}

do_install_from_source () {
    do_source_get ${package_src_location} ${package_name} ${package_version}
    do_source_configure ${package_name} ${package_version} ${package_src_build_configure}
    do_source_build ${package_name} ${package_version}
}

# Strip leading and trailing whitespaces
package_name=$(echo ${package_name} | sed -e 's/^ *//g;s/ *$//g')
package_version=$(echo ${package_version} | sed -e 's/^ *//g;s/ *$//g')
package_src_build_configure=$(echo ${package_src_build_configure} | sed -e 's/^ *//g;s/ *$//g')
package_src_location=$(echo ${package_src_location} | sed -e 's/^ *//g;s/ *$//g')

# check dependencies
# for each dependecy, do the following:
# 1. check if depdent package is installed

do_source_get ${package_src_location} ${package_name} ${package_version}
do_source_configure ${package_name} ${package_version} ${package_src_build_configure}
do_source_build ${package_name} ${package_version}
do_package ${package_name} ${package_version}

cd -
