# task1
aws-terraform-ansible
Integration of Ansible, Terraform and Github for installing Infrastructure on AWS
 

Task : Have to create/launch Application using Terraform
1. Create the key and security group which allow the port 80.
2. Launch EC2 instance.
3. In this Ec2 instance use the key and security group which we have created in step 1.
4. Launch one Volume (EBS) and mount that volume into /var/www/html.
5. Developer have uploded the code into github repo also the repo has some images.
6. Copy the github repo code into /var/www/html.
7. Create S3 bucket, and copy/deploy the images from github repo into the s3 bucket and change the permission to public readable.
8. Create a Cloudfront using s3 bucket(which contains images) and use the Cloudfront URL to  update in code in /var/www/html.

Prerequisite:

In your system Ansible, Terraform and aws cli software installed.

Questions Arises:

Why we use Ansible or Terraform both for completing this tasks when we can complete this tasks using one of those Tools?

-  For doing  configuration part use Ansible, as ansible is an intelligent tool we doesn't need to tell ansible how to do task , we just only need to tell what to do and ansible do this for us, meaning we doesn't need to learn commands for every operating system we just need to type simple syntex or create .yml file for whatever task to be perform and this file we can use for every operating system but when we use Terraform then for Configuration to every operating system we need to know about commands of that operating system. 

Now Question arises  then why can we use only ansible?

We don't use, because Terraform is best in provisioning infrastructure , in handling cloud and provides some extra features which ansible doesn't provide and also we  just need to learn how to write code in terraform and terraform do same tasks on every cloud platform we doesn't need to learn command for every cloud.

Also terraform is idempotent means if same work is already done then it won't do it again in case of provisioning but while configuration  terraform run those commands again, for eg: if software is already installed then terraform again install it but ansible won't.  

So, conclusion is that Integrating Terraform and Ansible is best use case for us to getover from such tasks.

For more information refer this link:

https://www.hashicorp.com/resources/ansible-terraform-better-together/

 
Step-1:

Create profile using AWS cli Command.

cmd used : # aws configure --profile YOUR_PROFILE_NAME
 
Step-2:

Create Key Pair using Terraform.

For this use file key.tf.
 
Step-3:

Create Security Group using Terraform.

For this use file securitygrp.tf.

In this file create security group allowing SSH,HTTP as Inbound Rule.

So for this we allow Port No. 22 and 80 .


Step-4:

Create S3 bucket for  storing  images used in Source Code uploaded by Developer in Github Directory and download this image to local system and make this bucket publically accessable.

For this use file s3.tf.

 
Step-5:

Upload image from local system to S3 bucket that we create .

For this use file s3-object.tf .

 
Step-6:

Create a CloudFront using S3 bucket as source.

For this use file s3-cloudfront.tf .

 
Step-7:

Create EC2 instance on AWS using Terraform which consist of Key and Security Group created in above steps.

For this use file ec2.tf .

 
Step-8:

Create EBS volume using Terraform.

For this use file ebs.tf .

 
Step-9:

Connect created EBS volume to EC2 instance using Terraform.

For this use file ebs-connect.tf .

 
Step-10:

Create partition of EBS Volume ,format partition and then mount this partition to /var/www/html folder.

For this use file configuration.tf .

 
Now here we use Ansible in backgroud where software.yml, partition.yml, remove.yml and git.yml files we use .


Before running this yml  files we have to do setup for Ansible and for this copy ansible.cfg file and hosts file to your directory where you have all files of  terraform.

In my case i put all files in /root/terraform/test/ folder.


For copying inventory file and hosts file use:

cmd # cp /etc/ansible/ansible.cfg    /root/terraform/test/

cmd # cp /etc/ansible/hosts    /root/terraform/test/


Now make changes in inventory file (ansible.cfg file):

1. Go to line no. 14 or search for keyword inventory:

    In this change we tell ansible that our hosts file (list of hosts) is at which location.
    
2. Go to line no. 62 or search for keyword host key checking:

     When we connect to any system via ssh for the first time ssh checking host key and ask for an option do you want to connect or not, so if we run script using ansible then because of that script get failed,  so we disable this option. 
     
3. Go to line no. 94 and 98 or search for keyword timeout and remote user:

     Here we make remote user as ec2-user  because our script goes to instance and we have to provide  from which user your script connect. 
     
 
4. Go to line no. 323 or search for keyword priviledge escalation:

    Here we say ansible that remote user from which you connect have power of sudo so you can perform every task which root user can.
    
 
After this setup run configuration.tf file.

Here following ansible scripts  run:

- software.yml:

     For installing Softwares required for hosting Website.
     
 
- partition.yml:

    For creating partition of EBS and mounting on /var/www/html Folder. 
    
 
- remove.yml:

  For removing all the files and folder if exists in /var/www/html folder so if we run git clone command for downloading source code from Github won't Fail.
      
 
- git.yml:

   For  downloading source code from Github.
       
 
For Complete Setup in single file :

  Use following files maincode.tf and s3-cloudfront-combine.tf .
      
And after run following Commands:

cmd # terraform init 

  For installing plugins of terraform for resources used in whole setup.
       
cmd # terraform apply

  For building setup byrunning those files.
       
cmd # terraform destroy

  For destroying whole setup which we build.
       
       







  



 













