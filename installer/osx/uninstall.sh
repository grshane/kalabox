#!/bin/bash

set -e

# Uninstall Script

# Make sure we are root
if [ "${USER}" != "root" ]; then
  echo "$0 must be run as root!"
  exit 2
fi

# Get our options
FORCE=false
while getopts 'f' flag; do
  case "${flag}" in
    f) FORCE='true' ;;
  esac
done

# Find out our user
APPLICATION="/Applications/Kalabox.app/Contents/MacOS"

CONSOLE_USER=$(stat -f '%Su' /dev/console)
CONSOLE_USER_HOME=$(su $CONSOLE_USER -c 'echo $HOME')

DOCKER_MACHINE="$APPLICATION/bin/docker-machine"

#
# Uninstall function
#
uninstall() {

  echo "Removing Kalabox VM..."
  sudo -u "${CONSOLE_USER}" "${DOCKER_MACHINE}" rm -f Kalabox2 || "${DOCKER_MACHINE}" rm -f Kalabox2

  echo "Removing Application..."
  rm -rf /Applications/Kalabox.app

  echo "Removing DNS"
  rm -f /etc/resolver/kbox

  echo "All Done!"

}

# Primary logic
while true; do
  if [ $FORCE == false ]; then
    read -p "Completely remove Kalabox? (Y/N): " yn
  else
    yn=y
  fi
  case $yn in
    [Yy]* ) uninstall; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no."; exit 1;;
  esac
done

