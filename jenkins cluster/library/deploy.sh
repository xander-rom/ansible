#! /bin/bash
 
 [ -f "$1" ] && source $1
# tom_url="http://application.playpit.by/"
# tom_user=deployer
# tom_pass=s3cret
# dep_path=aramanovich
# build=50
# stable=56
# act=deploy
#### functions
function deploy {
	if [[ $tom_url ]] && [[ $dep_path ]] && [[ $tom_user ]] && [[ $tom_pass ]] && [[ $build ]]
	then
		curl -s -IL $tom_url$dep_path > cur_page
		if [[ -z "tmp/helloworld-ws/target/helloworld-ws.war" ]]; then touch fuck; fi
		curl -s --upload-file "tmp/helloworld-ws/target/helloworld-ws.war" "http://$tom_user:$tom_pass@$tom_url/manager/text/deploy?path=/$dep_path&tag=$build&update=true" > dep_res
		if [[ $(cat dep_res) == *FAIL* ]] || [[ $(cat dep_res) == '' ]]
		then res="Deploy failed with message: $dep_res"
		elif [[ $(cat dep_res) == *OK* ]] && [[ $(cat cur_page) == *404* ]]
		then res="Deploy is succesful. Actual page is $tomcat_url$dep_path. Actual build is $build"
		else
			cat cur_page | grep Last-Modified > cur_time
			curl -s -IL $tom_url$dep_path | grep Last-Modified > new_time
			if [[ $(cat cur_time) == $(cat new_time) ]]
				then res="Deploy failed or you deployed the same app"
				else res="Deploy is succesful. Actual page is $tomcat_url$dep_path. Actual build is $build"
			fi
		fi
	else res="Not enough parameters - failed"
	fi  
}
function rollback {
	if [[ $tom_url ]] && [[ $dep_path ]] && [[ $tom_user ]] && [[ $tom_url ]] && [[ $tom_pass ]] && [[ $stable ]]
	then
		curl "http://$tom_user:$tom_pass@$tom_urlmanager/text/deploy?path=/$dep_path&update=true&tag=$stable" > roll
		if [[ $(cat roll) == *OK* ]]
			then res="Rollback is successful. Actual page is $tomcat_url$dep_path. Actual build is $stable"
			else res="Rollback failed"
		fi
	else res="Not enough parameters - failed"
	fi
}

######### check url
url_ready=$(echo $tom_url | sed 's|https://||') && tom_url=$url_ready
url_ready=$(echo $tom_url | sed 's|http://||') && tom_url=$url_ready

########## Actions 
case $act in
	deploy)
	 ######## get the artifact from nexus
		if ! [[ -d tmp ]]; then mkdir ./tmp
		fi
		nexus_url="http://nexus-ci.playpit.by/repository/MNT-pipeline-training/aramanovich/pipeline-aramanovich/$build/pipeline-aramanovich-$build.tar.gz"
		wget -q $nexus_url 
		tar -zxf pipeline-aramanovich-$build.tar.gz -C tmp
 		deploy
  	;;
  	rollback)
 		rollback
 	;;
 	*)
 		res='action can be 'deploy' or 'rollback' only! - failed'
 	;;
 esac

### output

if [[ "$res" == *failed* ]]
then printf '{"failed":"true", "msg": "%s"}' "$res"
else printf '{"changed": "true", "msg": "%s"}' "$res"
fi