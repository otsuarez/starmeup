all: get-conf-job

save: get-conf-job

get-conf-job:
	java -jar /var/lib/jenkins/jenkins-cli.jar -s http://jenkins.acme.com -i rls-manager-acme get-job Create_Package_Conf > jobs/Create_Package_Conf.xml
