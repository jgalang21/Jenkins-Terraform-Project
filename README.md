# Full CI/CD Project using Jenkins, Terraform, Docker and SonarQube

## General workflow Diagram
![Screen Shot 2024-10-20 at 4 27 28 PM](https://github.com/user-attachments/assets/6ebc1ffe-a11a-46f9-8425-4e6f17caa3a0)



This project is a simple static website that has a full CI/CD pipeline. 

The static website repo can be found [here](https://github.com/jgalang21/static-website). (This is simply just a basic HTML website template)

### Relevant technologies used:
* AWS - EC2 Instances to host Jenkins, SonarQube and Docker.
* Terraform - Automate the EC2 builds and install respective software instead of manually creating each instances.
* SonarQube - Scan the code for vulnerabilites.
* Docker - Host the static website using nginx container


## Screenshots of application


## Installation

(Please note this is still a work in progress, still in a rough draft)

1. Clone the repository, and ensure Terraform is installed in your machine.
2. You'll need to ensure the AWS CLI is configured on your machine and you have an AWS account. If you do not have that please refer to this [link](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html)
3. Run `terraform init` and then `terraform apply`
4. The EC2 instances should appear in **us-west-2**
5. Copy the public ip of the Jenkins EC2 instance, and paste it into your browser, with the port 8080. So your IP could look like http://127.0.0.0:8080 (Remove the "S" in https)
6. Configure Jenkins with the default values. 
7. Create a freestyle pipeline project.
8. Create a Github webhook on your Jenkins project to check for any push/pulls on your repository.
9. Go to your Github repository and add a Webhook, and add the IP of the jenkins server to your repository.
10. Now, when you push to the repository, Jenkins should run.
11. (TO FIX) SSH into the SonarQube server and navigate to /home/ec2-user/sonarqube-9.9.0.65466/bin/linux-x86-64, and run `./sonar start` to start the SonarQube server.
12. Configure the sonarqube server and create the necessary access keys
13. Go back into Jenkins, under Manage, add the Sonarqube keys into the settings to it can trigger SonarQube when new code is pushed.
14. Now that you have it scanning code after every push, we need to configure Docker.
15. (TO FIX AND AUTOMATE) Spin up an EC2 instance and install docker, make sure to give the user permissions (usergrp) to use Docker properly and ensure it can build appropriately.
16. On the docker server, create an empty folder. In my case I named it *newSite*
17. We'll need to copy the files from where Jenkins stores the contents of the Github repo. SSH into the Jenkins server. You'll need to setup key pairs for the Jenkins user to connect to the Docker server.
18. Create a build step on the Jenkins pipeline. 
19. Run this command to copy the contents of the repo (from Jenkins) to the Docker server
20. `scp -o StrictHostKeyChecking=no -r /var/lib/jenkins/workspace/automated-pipeline/* ec2-user@<DOCKER IP>:/home/ec2-user/newSite`
21. Create another build step but have the Docker server be the remote shell. Paste in this script:

cd /home/ec2-user/newSite

docker build -t mywebsite .

if [ $(docker ps -aq -f name=Onix-Website) ]; then
    docker stop Onix-Website
    docker rm Onix-Website
fi

docker run -d -p 8085:80 --name=Onix-Website mywebsite

22. Navigate to the pubilc IP of the website and you should see your new site!
23. To further test, you can update your code on the github repo and see if it reflects on the site. It should trigger a new Jenkins pipeline and update the changes once everything passes

  

