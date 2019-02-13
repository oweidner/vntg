# Development Notes

## Installation and Bootstrap

In addition to installing the vntg scrips, we also need to bootstrap a minimal
set of tools that are required to download and install packages from the vntg
repository. These tools and packages are:

  * **curl** for downloading files via ftp and http
  * **gnu tar** for unpacking things
  * **xz** for decompressing things
  * **git** for updating the vntg package repository

The bootstrap process works as follows:

    1. Create a new directory structure under `/opt/vntg/`

    2. Download and unpack the vntg core distribution via ftp 
       (installed on IRIX) into:

       `/opt/vntg/packages/vntg-core/<VERSION>/`

       The core distribution contains the following components:

        - bin/vntg       - vntg binary (sym-linked to /opt/vntg/bin/vntg)
        - bin/vntg-curl  - curl binary
        - bin/vntg-git   - git binary 
        - etc/vntg.cfg   - vntg configuration file

    3. Pull the repository from GitHub

    4. Add /opt/vntg to the relevant paths
