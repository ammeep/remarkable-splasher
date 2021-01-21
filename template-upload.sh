#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Author        :  Aims Palamountain,

# Description   : Copy template images to the remarkable2 device.

# Dependencies  : ssh, nc, jq

# Notations     : This script performs uni-directional synchronisation of
#                 new templates

# Current version (MAJOR.MINOR)
VERSION="1.0"
# Remarkable2 SSH Address. The device must be plugged in to the machine and
# turned on.
SSH_ADDRESS="10.11.99.1"
# The expected name of the templates json file to be pulled down, and 
# uploaded to the Remarkable2 device.
TEMPLATE_NAME="templates.json"
# This directory is where we find out template images. These images are
# organised in sub directories which represent the category which the 
# template will apear under, on the device. 
LOCAL_TEMPLATE_DIR="./templates"
# When set to true only generate the new template.json file locally.
# No ssh connection to the device will be made. This is useful when
# needing to verify output of the script before making changes
# to the device itself. 
DRY_RUN=false
# When running in dry run mode, output templates and configurations here.
DRY_RUN_DIR="./dry-run"
# This file will be used during execution to store the newly generated 
# templates.json file contents before it is copied to the device. This 
# file is deleted after the script is executed.
TEMP_FILE="new.json"
# Colors and formatting to aid in clear script output
red=$'\e[1;31m' # Error
grn=$'\e[1;32m' # Device interaction
cyn=$'\e[1;36m' # Dry Run
white=$'\e[0m'  # Everything else
indent="           " #Indent 5 tabs

# Kills SSH session and exits with return 1
function exit_failed {
  ssh -S root@"$SSH_ADDRESS" -O exit root@"$SSH_ADDRESS"
  rm ${TEMP_FILE_NAME}
  exit 1
}
trap 'exit_failed' ERR
# Display the usage options for this script
function usage {
  echo "Usage: template-upload.sh [-v | -h | ssh address]"
  echo
  echo "Options:"
  echo -e "-v\t\t\tDisplay version and exit"
  echo -e "-h\t\t\tDisplay usage and exit"
  echo -e "-d\t\t\tRun script in dry run mode, without ssh access to the device"
  echo -e "-dc\t\t\tClean up previous dry runs"
  echo -e "-r\t\t\tReset the templates.json file on the device"
  echo -e "ip\t\t\tSSH address of the device (default set to 10.11.99.1)"
  echo
}

# Attempt to make an ssh connection to the device.
# If the device is not plugged in, or ssh fails, exit.
function test_device_connection {
  echo "$grn Attempting to establish connection with the device...$white"
  ssh -q root@"$SSH_ADDRESS" exit

  if [ "$?" -ne 0 ]; then
    echo "$red Failed to establish connection $white"
    exit -1
  fi
  echo
  echo "${indent}established an ssh connection to ${SSH_ADDRESS}"
  echo "${indent}please do not lock your device until the script has completed!"
  echo
}

# For all templates found in the ./templates directory, generate a new
# temporary json file with remarkable2 template json objects. This new 
# file will be uploaded to the device, or copied to the dry run directory
function generate_new_templates {
  TEMPLATES_JSON=`jq '.' ${TEMPLATE_NAME}`
  for FILE in $LOCAL_TEMPLATE_DIR/*
  do  
    BASENAME=$(basename "${FILE%.*}")
    IFS='|' read -r CATEGORY NAME <<< "$BASENAME"
    
    JSON="{
      name: \"$NAME\",
      filename: \"$FILE\",
      iconCode: \"\\ue98c\",
      categories: [\"$CATEGORY\"]
    }"
    ITEM=".templates += [${JSON}]"
    TEMPLATES_JSON=`jq "$ITEM" <<< "${TEMPLATES_JSON}"`
  done
  echo $TEMPLATES_JSON | jq . > new.json
}

# Copy newly generated templates to the remarkable, or to the dry
# run directory.
function copy_new_templates {
  # test this scp to another directory on the remarkable first!!
  if [ "$DRY_RUN" = false ] ; then
  echo
    read -rp "$grn Upload new templates [y/N]: $white" input
    if [[ "$input" =~ [yY] ]]; then
      echo
      echo "${indent}copying new templates to the device"
      scp -r ./templates/* root@"$SSH_ADDRESS":/usr/share/remarkable/templates/
      scp ./new.json root@"$SSH_ADDRESS":/usr/share/remarkable/templates/${TEMPLATE_NAME}
    fi
  else 
    echo "${indent}copying new templates to ${DRY_RUN_DIR}"
    scp -r ./templates/ ${DRY_RUN_DIR}
    scp ./new.json ${DRY_RUN_DIR}/${TEMPLATE_NAME}
  fi
}

# Remove temporary templates config file, that was generated as an 
# intermediary step before the new config file is copied to the device.
function clean_up {
  echo "${indent}cleaning up"
  rm ${TEMP_FILE}
}

# Reset the device template.json file to it's original state.
# Note: this does not remove old template images from disk.
function reset_template_config {
  echo "$grn Resetting template config file on the device$white"
  scp ./templates.json root@"$SSH_ADDRESS":/usr/share/remarkable/templates/${TEMPLATE_NAME}
  echo "$grn Success. $white Original template config restored"
}

# Enable dry run mode
function switch_to_dry_run {
  echo
  echo "$cyn Dry Run: $white no ssh connection will be attempted to the device."
  echo "${indent}templates and configuration will be copied to disk (${DRY_RUN_DIR}) for verification"
  echo
  echo "${indent}starting dry run..."
  echo
  DRY_RUN=true
}

# Remove all dry run artifacts
function clean_up_dry_run {
  if [ -d "$DRY_RUN_DIR" ]; then rm -Rf $DRY_RUN_DIR; fi
  echo "$cyn Dry Run: $white clean up complete"
  echo
}

echo
echo "----------------------- Remarkable Splasher -----------------------"
echo

# Check Arguments
if [ "$#" -gt 1 ] || [[ "$1" == "-h" ]]; then
  usage
  exit -1
elif [[ "$1" == "-v" ]]; then
  echo "template-upload version: $VERSION"
  exit -1
elif [[ "$1" == "-r" ]]; then
  test_device_connection 
  reset_template_config
  exit -1
elif [[ "$1" == "-d" ]]; then
  switch_to_dry_run
elif [[ "$1" == "-dc" ]]; then
  clean_up_dry_run
  exit -1
elif [ "$#" -eq 1 ]; then
  SSH_ADDRESS="$1"
fi

if [ "$DRY_RUN" = false ] ; then
    test_device_connection   
fi

generate_new_templates
copy_new_templates
clean_up
echo
echo "$grn Done!"
echo