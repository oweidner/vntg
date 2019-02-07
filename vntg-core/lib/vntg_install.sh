#!/bin/sh

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