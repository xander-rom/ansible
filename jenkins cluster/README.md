# Jenkins installation made by Aliaksandr Ramanovich

# INFO:
# Vagrantfile:
starts 4 VMs: jen for jenkins&nginx servers, jensl-1 for sonar server, jensl-2 for nexus repo and tomcat for app server
Includes provision with playbook

# Ansible playbook:
# Roles:
USERS: 
- dictionary of default users for each server.

USER_CREATION:
- creates users, using vars and role users

PRE-STEPS:
- installs software: java, build tools (maven, gradle) and other useful packages (git, net-tools, etc.)
- saves versions of installed software in ansible_local

JENKINS:
- installs and configure jenkins server
- includes configuration file to use nexus server as a proxy
- saves facts about jenkins version in ansible_local

NGINX:
- installs nginx server and configure it to be a proxy for all servers
- gathers facts about nginx version

SONAR:
- installs sonarqube server with postgresql and sonar-scanner
- gathers facts about software versions

NEXUS:
- installs nexus server and configure it
- gathers facts about nexus

TOMCAT:
- installs tomcat server and configures it
- gather facts about tomcat

DEPLOY:
- deploys java app, dowloading the artifact from nexus repo, to tomcat app server
- rollback web app to choosen version on tomcat app server
- gather facts about stable deploys

# Usage:
- To run cluster 
'''
vagrant up
'''
- To run playbook
'''
ansible-playbook jen.yaml
'''
- to gather facts
'''
ansible all -m setup -a "filter=ansible-local"
'''

