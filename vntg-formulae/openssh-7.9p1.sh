PACKAGE_NAME="openssh"
PACKAGE_VERSION="7.9p1"
PACKAGE_LOCATION="http://localhost:8000/vntg/openssh-7.9p1.tgz"
PACKAGE_DEPS="libressl[2.9.0]"
PACKAGE_POSTINSTALL=$(cat <<EOF
# This links the init script from /opt/vntg to the appropriate \n
chmod 755 /opt/vntg/etc/init.d/sshd
ln -s /opt/vntg/etc/init.d/sshd /etc/rc2.d/S61sshd
ln -s /opt/vntg/etc/init.d/sshd /etc/rc0.d/K26sshd 
EOF
)

# Source build instructions
BUILD_N64_DEPS="make[x.x.x],m4[x.x.x]"
BUILD_N64_EXTRA_CFLAGS=""
BUILD_
BUILD_N64_CONFIGURE_FLAGS="--with-ssl-dir=/opt/vntg/ --with-pam --with-xauth"
BUILD_POSTINSTALL_SCRIPT="cat >> greetings.txt << _EOF_ 
#!/bin/sh                                               
                                                      
        SSH_ROOT=/opt/vntg/                                     
        SSH_BIN=$SSH_ROOT/bin                                   
        SSH_ETC=$SSH_ROOT/etc
        SSH_SBIN=$SSH_ROOT/sbin             

case "$1" in
\'start\')
   if [ ! (-d $SSH_ETC) ]; then
      echo -n "sshd:  Cannot access directory "
      echo -n "$SSH_ETC" 
      echo ".  Skipping ssh startup."
      exit 0
   fi

   if [ ! (-d $SSH_BIN) ]; then
      echo -n "sshd:  Cannot access directory "
      echo -n "$SSH_BIN" 
      echo ".  Skipping ssh startup."
      exit 0
   fi

   if [ ! (-d $SSH_SBIN) ]; then
      echo -n "sshd:  Cannot access directory "
      echo -n "$SSH_SBIN" 
      echo ".  Skipping ssh startup."
      exit 0
   fi

   if [ ! -f $SSH_ETC/ssh_host_key ]; then
      echo \' creating ssh RSA host key\';
      $SSH_BIN/ssh-keygen -N "" -f $SSH_ETC/ssh_host_key
   fi
   if [ ! -f $SSH_ETC/ssh_host_dsa_key ]; then
      echo \' creating ssh DSA host key\';
      $SSH_BIN/ssh-keygen -d -N "" -f $SSH_ETC/ssh_host_dsa_key
   fi

   echo -n "sshd: Starting the ssh daemon..."
   $SSH_SBIN/sshd
   echo "done."
   exit 1
   ;;

\'stop\')
   echo -n "sshd: Stopping the ssh daemon..."
   killall sshd
   echo "done."
   ;;

*)
   echo "usage: $0 {start|stop}"
   ;;
esac
_EOF_'
