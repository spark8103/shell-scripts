#!/bin/bash

#
# Purpose: Setup console for Elastos development
# Date:    2012-02-13
# Author:  li.bin@kortide.com.cn
#

echo ================================
echo Install tools if required...
echo ================================

GIT_VERSION=`git --version 2>/dev/null`

if [ -z "$GIT_VERSION" ]; then
    sudo apt-get update
    sudo apt-get install -y git-core
fi

GIT_VERSION=`git --version 2>/dev/null`
echo $GIT_VERSION [OK]

echo
echo ================================
echo Configuring Git...
echo ================================

fullname_old=`git config --get user.name`
fullname=
read -p "Your Full Name [$fullname_old]: " fullname
if [ -z "$fullname" ]; then
    fullname="$fullname_old"
fi
git config --global user.name "$fullname"

email_old=`git config --get user.email`
read -p "Your Email [$email_old]: " email
if [ -z "$email" ]; then
    email="$email_old"
fi
git config --global user.email "$email"

git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global remote.origin.push refs/heads/*:refs/for/*

#git config -l

#echo
#echo ================================
#echo Configuring Gerrit...
#echo ================================

loginame=
while [ -z "$loginame" ]; do
    read -p 'Your Username: ' loginame
done

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo Generating key...
    ssh-keygen -f ~/.ssh/id_rsa -N '' 1>/dev/null
fi

##sudo sed -i "$ a 192.168.7.128\te" /etc/hosts
echo -e "Host elastos.org\n  Hostname elastos.org\n  Port 29418\n  User $loginame" >~/.ssh/config


echo
echo ================================
echo Your Account Summary
echo ================================

echo Full Name: $fullname
echo SSH Public Keys: `cat ~/.ssh/id_rsa.pub`
