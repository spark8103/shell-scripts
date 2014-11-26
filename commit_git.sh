#!/bin/bash

#
# Purpose:     Auto commit to git
# Date:        2013-06-20
# Author:      xtso520ok@gmail.com
# Environment: OS Linux, gcc, gcc-c++, make, zlib
# Des:         ...
#

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

read -p "Commit dir: " dir
if [ ! -e $dir ]; then
    echo "$dir not found."
    exit 0
fi
cd $dir
echo "Start commit $dir"
echo "Before operate view status -- "
git status -s
git add *
echo "After add view status -- "
git status -s
read -p "Commit description: " comment
git commit -m "$comment"
echo "After commit view status -- "
git status -s
git push origin master


