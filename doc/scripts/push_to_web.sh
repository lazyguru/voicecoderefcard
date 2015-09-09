#!/bin/sh

# Anthony Bradford Texinfo Website Publishing.
# Copyright (C) 2012 Anthony Bradford.

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
#
# This is free and unencumbered software released into the public domain.
# See file 'COPYING' for more information.

echo
echo "Copyright (C) 2012 Anthony Bradford."

rm -f ftp.error

echo
echo
echo Generated content prior to running this command
echo with \"make\", \"make all\" or \"make html2\"
echo
echo

read -p "FTP website   : " HOST
read -p "FTP login     : " USER
read -p "FTP password  : " PASSWD

SUBDIRECTORY=0

while true; do
    echo
    read -p "Publish to a subdirectory under public_html\\ (y/n)? " yn 
    case $yn in 
        [Yy]* ) SUBDIRECTORY=1 break;; 
        [Nn]* ) SUBDIRECTORY=0 break;; 
        * ) echo "Please answer yes or no.";; 
    esac 
done

if [ "$SUBDIRECTORY" = "1" ]; then
    read -p "FTP Directory : " DIRECTORY
fi

if [ "$SUBDIRECTORY" = "0" ]; then
    echo
    echo "WARNING: You will be overwriting the main part of the website."

while true; do 
    read -p "continue to publish to  public_html\\ (y/n)? " yn 
    case $yn in 
        [Yy]* ) break;; 
        [Nn]* ) exit;; 
        * ) echo "Please answer yes or no.";; 
    esac 
done

fi

PUBLISH=0

echo

while true; do 
    read -p "Publish HTML/.pdf/.zip/.txt/.epub/tar.gz to the website (y/n)? " yn 
    case $yn in 
        [Yy]* ) PUBLISH=1 break;; 
        [Nn]* ) break;; 
        * ) echo "Please answer yes or no.";; 
    esac 
done 
if [ "$PUBLISH" != "1" ]; then
    echo
    exit
fi

if [ "$PUBLISH" = "1" ]; then
    if [ -e index.html ]
    then
        echo "HTML exists"
    else
        make all
    fi
fi

echo
echo
echo This might take some time. 
echo Directory creation errors are normal after initial run.
echo
echo

if [ "$SUBDIRECTORY" = "1" ]; then

ftp -nv $HOST <<END_SCRIPT 2>> ftp.error
quote USER $USER
quote PASS $PASSWD
binary
cd public_html
mkdir $DIRECTORY
cd $DIRECTORY
prompt
mput *
quit
END_SCRIPT

fi

if [ "$SUBDIRECTORY" = "0" ]; then

ftp -nv $HOST <<END_SCRIPT 2>> ftp.error
quote USER $USER
quote PASS $PASSWD
binary
cd public_html
prompt
mput *
quit
END_SCRIPT

fi

IMAGES=0

echo

while true; do 
    read -p "Publish directories \"images\" and \"files\" to website (y/n)? " yn 
    case $yn in 
        [Yy]* ) IMAGES=1 break;; 
        [Nn]* ) break;; 
        * ) echo "Please answer yes or no.";; 
    esac 
done 
if [ "$IMAGES" = "1" ]; then

ftp -nv $HOST <<END_SCRIPT 2>> ftp.error
quote USER $USER
quote PASS $PASSWD
binary
cd public_html
prompt
cd $DIRECTORY
mkdir images
cd images
lcd images
mput *
cd ..
mkdir files
cd files
lcd ..
lcd files
mput *
quit
END_SCRIPT

fi

echo done

if [ -e ftp.error ]; then
    cat ftp.error
    rm -r ftp.error
fi
