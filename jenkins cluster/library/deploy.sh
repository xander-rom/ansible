 #! /bin/bash
 
[ -f "$1" ] && source $1

#### functions
deploy {
	curl -IL $tomcat_url$dep_path > cur_page
	dep_res=$(curl -T 'tmp/helloworld-ws/target/helloworld-ws.war'\
  				"http://$tom_user:$tom_pass@$tomcat_url/manager/text/deploy?path=/$path&tag=$build&update=true")
	if [[ "$dep_res" == *FAIL* ]]
		then res="Deploy failed with message: $dep_res"
	elif [[ "$dep_res" == *OK* ]] && [[ $(cat cur_page) == *404* ]]
		then res="Deploy is succesful. Actual page is $tomcat_url$dep_path. Actual build is $build"
	else
		curl -IL $tomcat_url$dep_path | grep Last-Modified > cur_page
		curl -IL $tomcat_url$dep_path | grep Last-Modified > new_page
		if [[ $(cat cur_time) == $(cat new_page)]]
			then res="Deploy failed or you deployed the same app"
			else res="Deploy is succesful. Actual page is $tomcat_url$dep_path. Actual build is $build"
		fi
	fi  
}


######### check url
url_ready=$(echo $tomcat_url | sed 's|https://||') && tomcat_url=$url_ready
url_ready=$(echo $tomcat_url | sed 's|http://||') && tomcat_url=$url_ready
######## get the artifact from nexus
mkdir ./tmp
nexus_url="http://nexus-ci.playpit.by/repository/MNT-pipeline-training/\
	aramanovich/pipeline-aramanovich/$build/pipeline-aramanovich-$build.tar.gz"
wget $nexus_url 
tar -zxf pipeline-aramanovich-$build.tar.gz -C tmp

########## Actions 
case $act in
	deploy)
 		curl -T 'tmp/helloworld-ws/target/helloworld-ws.war'\
  		"http://$username:$user_pass@$url/manager/text/deploy?path=/$path&update=true&tag=$build"
  	;;
  	rollback)
 		curl -X PUT "http://$username:$user_pass@$url/manager/text/deploy?path=/$path&update=true&tag=$stable"
 	;;
 	*)
 		res="FAILED: action can be 'deploy' or 'rollback' only!"
 	;;
 esac

 # tests

 curl 

















 curl -T 'tmp/new/helloworld-ws/target/helloworld-ws.war'\
  'http://deployer:s3cret@application.playpit.by/manager/text/deploy?path=/helloworld-ws-{{ branch }}&update=true'