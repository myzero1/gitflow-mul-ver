#!/bin/bash

# cd /path/to/gitrepo;  bash /C/Users/woogle/Desktop/replace_gitflow_branch.sh &
# master_qq,master_sina
# develop_qq,develop_sina
# feature/_qq_feature1
# hotfix/_qq_hotfix1
# create by woolge,Email:917595913@qq.com

if [[ $1='' ]]; then
	REPO_PATH=""
else
	REPO_PATH="${1}/"
fi

echo "$REPO_PATH"

#the function get_curent_branch
get_curent_branch(){
	# get the current branch
	current_branch=$(git branch | sed -e '/^[^*]/d' | sed -e 's/\s//g')
	current_branch=${current_branch:1}
}

#the function of select_gitflow_branch
select_gitflow_branch(){
	# get the current branch
	get_curent_branch
	current_branch_rel=`echo $current_branch|cut -d "/" -f2` 
	version=`echo $current_branch_rel|cut -d "_" -f2` 

	master_tem="master_${version}"
	master_tem_branch=$(git branch | sed -e 's/\s//g' | sed -e "/$master_tem/!d")
	if [ "$master_tem_branch" != "" ]  
	then  
	    gitflow_branch_master=$master_tem
	else  
	    gitflow_branch_master="master"
	fi  

	develop_tem="develop_${version}"
	develop_tem_branch=$(git branch | sed -e 's/\s//g' | sed -e "/$develop_tem/!d")
	if [ "$develop_tem_branch" != "" ]  
	then  
	    gitflow_branch_develop=$develop_tem
	else  
	    gitflow_branch_develop="develop"
	fi  

}

# the fucntion of replace_gitflow_branch
replace_gitflow_branch(){
	config="${REPO_PATH}.git/config"
	select_gitflow_branch
	sed -i "10c master = $gitflow_branch_master" $config
	sed -i "11c develop = $gitflow_branch_develop" $config
}

# the fucntion of monitor_current_branch
monitor_current_branch(){

	current_branch_old=''

	int=1
	# while(( $int<=50 ))
	while(( $int>0 ))
	do
		# echo $int
		let "int++"
		sleep 1

		get_curent_branch

		if [ "$current_branch_old" != "$current_branch" ]  ; then
			current_branch_old="$current_branch"
			# echo $current_branch_old
			replace_gitflow_branch
		fi

	done
}

echo -e "---we will open sourcetree_gitflow_Multi-Version-Concurrency---\n"

eval "monitor_current_branch" &

echo -e "---it has opened.you can close this window and use sourcetree_gitflow_Multi-Version-Concurrency---\n"

