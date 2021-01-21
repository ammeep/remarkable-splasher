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

# Description   : Compress template images before uploading to the device

# Dependencies  : pngquant

# Current version (MAJOR.MINOR)
VERSION="1.0"
# This directory is where we find out template images. These images are
# organised in sub directories which represent the category which the 
# template will apear under, on the device. 
LOCAL_TEMPLATE_DIR="./templates"

# Kills SSH session and exits with return 1
function exit_failed {
  ssh -S root@"$SSH_ADDRESS" -O exit root@"$SSH_ADDRESS"
  rm ${TEMP_FILE_NAME}
  exit 1
}
trap 'exit_failed' ERR
# Display the usage options for this script

function usage {
  echo "Usage: template-compress.sh [-v | -h ]"
  echo
  echo "Options:"
  echo -e "-v\t\t\tDisplay version and exit"
  echo -e "-h\t\t\tDisplay usage and exit"
  echo
}


echo
echo "----------------------- Remarkable Template Compressor -----------------------"
echo

# Check Arguments
if [ "$#" -gt 1 ] || [[ "$1" == "-h" ]]; then
  usage
  exit -1
elif [[ "$1" == "-v" ]]; then
  echo "template-compressor version: $VERSION"
  exit -1
fi

for FILE in $LOCAL_TEMPLATE_DIR/*
do  
  FILE_NAME=$(basename "${FILE%.*}")
  ORIGINAL_SIZE=`ls -lah "$FILE" | awk '{print $5}'`
  echo "Found file \"$FILE_NAME\" - $ORIGINAL_SIZE"
  read -rp "Do you want to compress? [y/N]:" input

  if [[ "$input" =~ [yY] ]]; then
      echo "Compressing... "
      pngquant --quality 10-30 "$FILE" -f -o "$FILE"
      NEW_SIZE=`ls -lah "$FILE" | awk '{print $5}'`
      echo "Compressed file to $NEW_SIZE"
  fi  
  echo
done