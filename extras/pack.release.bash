#!/bin/bash

#  pack.*.bash - Bash script to help packaging samd core releases.
#  Copyright (c) 2015 Arduino LLC.  All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

VERSION=`grep version= platform.txt | sed 's/version=//g'`
echo $VERSION

PWD=`pwd`
FOLDERNAME=`basename $PWD`
echo $FOLDERNAME
THIS_SCRIPT_NAME=`basename $0`

rm -f c2000-$VERSION.tar.bz2

cd ..
gnutar --transform "s|$FOLDERNAME|$FOLDERNAME-$VERSION|g"  --exclude=extras/** --exclude=.git* --exclude=.idea -cjf c2000-$VERSION.tar.bz2 $FOLDERNAME
cd -

mv ../c2000-$VERSION.tar.bz2 .

shasum -a 256 c2000-$VERSION.tar.bz2
stat -f%z c2000-$VERSION.tar.bz2

read -r -p "Are you sure? [Y/n]" response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ $response =~ ^(yes|y| ) ]]; then
    scp c2000-$VERSION.tar.bz2 robertinant@energia.nu:html/cores/
fi
