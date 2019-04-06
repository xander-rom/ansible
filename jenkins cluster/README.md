Jenkins installation made by Aliaksandr Ramanovich


vagrant up

or

ansible-playbook jen.yaml -i inventory

Playbook manages 4 servers: jenkins, sonar, nexus and tomcat

jenkins: install jenkins and nginx. Get facts 
ansible master -i inventory -m setup -a "filter=ansible_local"

sonar: install sonar&sonar-scanner
ansible sonar -i inventory -m setup -a "filter=ansible_local"

nexus: install nexus 
ansible nexus -i inventory -m setup -a "filter=ansible_local"

tomcat: install tomcat
ansible tomcat -i inventory -m setup -a "filter=ansible_local"


Roles user-creation and pre-task are inluded in all server-roles