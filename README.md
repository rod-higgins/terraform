# Drupal Deployment on AWS using Terraform 

**Drupal** :- Drupal is an open source content management platform supporting a variety of
websites ranging from personal weblogs to large community-driven websites. For
more information, visit the Drupal website, [Drupal.org][Drupal.org], and join
the [Drupal community][Drupal community].

**Terraform** :-Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.

**AWS**:- Deploying Drupal on AWS makes it easy to use AWS services to further enhance the performance and extend functionality of your content management framework.

The goal of this project is to host Drupal site on AWS via Terraform  it's a cross-platform, extensible tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.


## What are we trying to implement?

- A virtual private cloud (VPC) that is configured across two Availability Zones. For each Availability Zone, this Quick Start provisions one public subnet and one private subnet, according to AWS best practices.

- In the public subnets, Linux bastion hosts in an AWS Auto Scaling group to provide secure access to allow inbound Secure Shell (SSH) access to Amazon EC2 instances in the private subnets.

- In the public subnets, managed network address translation (NAT) gateways to provide outbound internet connectivity for instances in the private subnets.

- In the private subnets, a web server instance (Amazon Machine Image, or AMI) in an AWS Auto Scaling group to host the Drupal servers and Amazon Aurora database instances.

- AWS Auto Scaling, which allows the Drupal cluster to add or remove servers based on use.
Integration of AWS Auto Scaling with Elastic Load Balancing, which automatically adds and removes instances from the load balancer. The default installation sets up low and high CPU-based thresholds for scaling the instance capacity up or down.

- An AWS Identity and Access Management (IAM) role to enable AWS resources created through the Quick Start to access other AWS resources when required.

- Out-of-box integration with load balancing and performance monitoring to be able to tune for cost/performance.




#### The different areas taken into account involves:
-  Application Load Balancer with Autoscaling 
-  MySql Database
-  Monitoring using Prometheus and Grafana

Also, a dedicated module named Network aims to provide desired information to implement all combinations of arguments supported by AWS and latest stable version of Terraform

## Requirements

-  Install Terraform
- Sign up for AWS 
- A valid AMI, followed by next section

## AMI
If you run AWS EC2 instances in AWS, then you are probably familiar with the concept of pre-baking Amazon Machine Images (AMIs). 
That is, preloading all needed software and configuration on an EC2 instance, then creating an image of that. The resulting image
can then be used to launch new instances with all software and configuration pre-loaded. This process allows the EC2 instance to come 
online and be available quickly. It not only simplifies deployment of new instances but is especially useful when an instance is part of 
an Auto Scaling group and is responding to a spike in load. If the instance takes too long to be ready, it defeats the purpose of dynamic scaling.

## Summary of Resources
-  3 Security Groups
-  2 Running Instance in ASG
-  2 RDS(Primary & Replica) 

# Terraform Modules

> A curated help menu of terraform modules used in the project.

[<img src="https://www.terraform.io/assets/images/logo-hashicorp-3f10732f.svg" align="right" width="600">](https://terraform.io)

[**Module 1**](#mod1): Autoscaling

[**Module 2**](#mod2): Application Load Balancer

[**Module 3**](#mod3): Database

[**Module 4**](#mod4): Network Configurations

<a id='mod1'></a>
## Module 1: Autoscaling

<a href="https://img.shields.io/badge/autoscaling-v4.1.0-%23c7c91c">
<img src="https://img.shields.io/badge/autoscaling-v4.1.0-%23c7c91c" /></a>

### Terraform module which creates autoscaling resources on AWS with launch template

<details>
  <summary><b>Variables</b></summary>
  
```
1. vpc_zone_identifier : Inputs a list of availability zones from network's 'security_group_asg' module
2. security_groups     : Inputs a list of security group ID's from network's 'security_group_id_asg' module
3. rds_endpt           : Inputs a string of RDS endpoint from db's 'rds_endpoint' output and passes it to userdata script   
4. target_group_arns   : Inputs a set of 'aws_alb_target_group' ARNs from alb's tg output
```
</details>

<details>
  <summary><b>Constants</b></summary>
  
```
1. min_size = 1                  #Minimun size of autoscaling group
2. max_size = 5                  #Maximum size of autoscaling group
3. desired_capacity = 2          #Number of concurrently running EC2 instances   
4. instance_type = "t2.micro"    #The type of the instance to launch
```
</details>

<a id='mod2'></a>
## Module 2: Application Load Balancer

<a href="https://img.shields.io/badge/alb-v6.0.0-%238c66d9">
<img src="https://img.shields.io/badge/alb-v6.0.0-%238c66d9" /></a>

### Terraform module which creates Application load balancer on AWS

<details>
  <summary><b>Variables</b></summary>
  
```
1. vpc_id           : Inputs the VPC id where all resources will be deployed from networks's 'vpc_id_all' module
2. subnets          : Inputs a list of subnets to associate with the load balancer from network's 'public_sn_asg' module
3. security_groups  : Inputs a list of security group ID's from network's 'security_group_id_asg' module   
```
</details>

<details>
  <summary><b>Constants</b></summary>
  
```
1. load_balancer_type = "application"         #Type of load balancer to create (application/network)
2. target_groups.backend_protocol = "HTTP"    #Protocol to be used by target groups
3. target_groups.backend_port = 80            #Port to be used by the target groups   
4. target_groups.target_type = "instance"     #Type of target group
```
</details>

<details>
  <summary><b>Outputs</b></summary>
  
```
1. tg : module.alb.target_group_arns    #ARNs of the target groups passed onto scaling group
```
</details>

<a id='mod3'></a>
## Module 3: Database

<a href="https://img.shields.io/badge/terraform--aws--rds--source-v3.0.0-ff69b4">
<img src="https://img.shields.io/badge/terraform--aws--rds--source-v3.0.0-ff69b4" /></a>
<a href="https://img.shields.io/badge/terraform--aws--rds--read-v3.0.0-ad7521">
<img src="https://img.shields.io/badge/terraform--aws--rds--read-v3.0.0-ad7521" /></a>

### Terraform module which creates RDS resources on AWS and reads from it

<details>
  <summary><b>Variables</b></summary>
  
```
  
```
</details>

<details>
  <summary><b>Constants</b></summary>
  
```

```
</details>

<details>
  <summary><b>Outputs</b></summary>
  
```

```
</details>


<a id='mod4'></a>
## Module 4: Network Configurations

<a href="https://img.shields.io/badge/vpc-v3.2.0-red">
<img src="https://img.shields.io/badge/vpc-v3.2.0-red" /></a>
<a href="https://img.shields.io/badge/security__group__asg-v4.0.0-brightgreen">
<img src="https://img.shields.io/badge/security__group__asg-v4.0.0-brightgreen" /></a>
<a href="https://img.shields.io/badge/security__group__rds-v4.0.0-important">
<img src="https://img.shields.io/badge/security__group__rds-v4.0.0-important" /></a>

### Terraform module which create VPC, security groups for auto scaling groups and RDS on AWS

<details>
  <summary><b>Variables</b></summary>
 
  ```
1.vpc_name             : Inputs the vpc name.
2. security_groups     : Inputs a list of security group ID's from network's 'security_group_id_asg' module  
 ```
</details>

<details>
  <summary><b>Constants</b></summary>
  
  ```
  1. cidr  : #cidr address
  2. egress port : #0-65535 open internet
  3. ingress port : #80 , 8080 , 2049 etc.
  ```

</details>

<details>
  <summary><b>Outputs</b></summary>
  
```
  1.vpc_id_all : #name of all vpc_id
  2.public_sn_asg : #all public subnets
  3.private_sn_asg :#all private subnets
  4.security_group_id_asg :#all security group id 
  5.security_group_id_rds :#all security group for rds

```
</details>

