#!/bin/bash

# get the gitflow-mul-ver
if [ ! -d "gitflow-mul-ver" ];then
	git clone https://github.com/myzero1/gitflow-mul-ver.git
else
	cd gitflow-mul-ver;
	git pull;
	cd ..;
fi

# overwrite the .git/hooks/post-checkout
#cp -f post-checkout .git/hooks/post-checkout;
cp -f gitflow-mul-ver/post-checkout .git/hooks/post-checkout;
