# AWS Lesson 3 - VPC Review, SSM, Security Groups, and S3-to-EC2 Web App

Date: 2026-05-07  
Module: 07-aws  
Lesson type: Live AWS class + hands-on lab  
Main flow: VPC review -> SSM Session Manager -> Security Groups -> S3 artifact -> EC2 Apache deployment

---

## 1. Lesson Context

This lesson continued from the previous 2-AZ VPC lab.

The starting architecture was:

- Region: us-east-1
- VPC CIDR: 10.0.0.0/16
- Two Availability Zones:
  - us-east-1a
  - us-east-1b
- Public subnets:
  - 10.0.1.0/24
  - 10.0.2.0/24
- Private app subnets:
  - 10.0.11.0/24
  - 10.0.12.0/24
- Private data subnets:
  - 10.0.21.0/24
  - 10.0.22.0/24
- Internet Gateway attached to the VPC
- NAT Gateway in the public subnet
- Bastion host in the public subnet
- App server in the private app subnet
- Data server in the private data subnet

The previous SSH flow was:

Local machine -> Bastion host -> App server -> Data server

The previous internet test showed:

- App server could access the internet through NAT Gateway.
- Data server could not access the internet because its route table had only the local route.

---

## 2. VPC and Subnet Review

The class reviewed what makes each part of the VPC public or private.

Important points:

- A VPC is regional.
- A subnet is zonal.
- EC2 instances are zonal.
- IAM is global.
- A subnet is not public because of its name.
- A subnet is public when its route table has a default route to an Internet Gateway.
- A resource also needs a public IP and a matching Security Group rule to be reachable from the internet.

Rule earned:

Public subnet = route table with 0.0.0.0/0 -> Internet Gateway.

Private subnet = no direct route to Internet Gateway.

---

## 3. Internet Gateway vs NAT Gateway

Internet Gateway:

- Attached to the VPC.
- Allows public resources to communicate directly with the internet.
- Used by public subnets through a route table.

NAT Gateway:

- Placed in a public subnet.
- Uses an Elastic IP.
- Allows private resources to initiate outbound internet traffic.
- Does not allow inbound traffic from the internet to private instances.

In the lab:

App server -> NAT Gateway -> Internet

Data server -> no default route -> isolated from internet

Rule earned:

NAT Gateway serves private subnets but must live in a public subnet.

---

## 4. Elastic IP

Elastic IP was reviewed as a static public IPv4 address.

Main idea:

Even though the name is Elastic, the useful property is that the IP is stable.

Used for:

- NAT Gateway public identity
- DNS records
- Firewall allowlists
- External systems that expect a fixed source IP

In the lab, the NAT Gateway used an Elastic IP so outbound traffic from private app instances would exit through a stable public address.

Cost note:

Elastic IP and NAT Gateway can cost money. Unused Elastic IPs and running NAT Gateways should not be left around without a reason.

---

## 5. Bastion vs SSM Session Manager

The lesson compared Bastion-based SSH access with AWS Systems Manager Session Manager.

Bastion model:

User -> SSH 22 -> Bastion -> SSH 22 -> Private EC2

Problems:

- Requires a public bastion host.
- Requires opening SSH inbound to the bastion.
- Requires key pair management.
- The bastion itself must be patched, secured, and monitored.

SSM Session Manager model:

EC2 SSM Agent -> outbound HTTPS 443 -> AWS Systems Manager <- user through console or AWS CLI

Benefits:

- No inbound SSH port required.
- No bastion required.
- No SSH key pair required for the session.
- Access can be audited.
- Sessions can be logged to S3 or CloudWatch Logs.
- Works through IAM permissions.

Requirements for SSM:

- SSM Agent installed and running.
- IAM Role attached to EC2.
- Policy: AmazonSSMManagedInstanceCore.
- Outbound HTTPS 443 access to AWS services.
- For private instances: NAT Gateway or VPC Endpoints.

Rule earned:

SSM replaces inbound SSH with outbound agent-based access.

---

## 6. Security Groups

Security Groups were reviewed as virtual firewalls attached to resources such as EC2 instances or ENIs.

Security Groups are not attached to subnets.

They control:

- Inbound traffic
- Outbound traffic
- Protocol
- Port
- Source or destination

Important behavior:

Security Groups are stateful.

This means:

- If an inbound request is allowed, the response is allowed automatically.
- If an outbound request is allowed, the response is allowed automatically.
- No separate response rule is needed.

Example:

If an EC2 instance initiates outbound HTTPS to port 443, the response comes back to an ephemeral client port. Security Group state tracking allows the return traffic automatically.

---

## 7. Security Group Chaining

A key feature reviewed was using a Security Group as a source instead of using IP addresses.

Example 3-tier model:

Web tier:

- Inbound 443 from 0.0.0.0/0

App tier:

- Inbound 80 from Web Security Group

Data tier:

- Inbound 3306 from App Security Group

Why this matters:

- No need to chase changing private IPs.
- Rules follow resource identity by Security Group.
- Better fit for cloud environments.
- Cleaner tier-based access.

In the previous lab, the same idea was used:

- Bastion SG allowed SSH from David's public IP.
- App SG allowed SSH from Bastion SG.
- Data SG allowed SSH from App SG.

Rule earned:

Use Security Group IDs for internal AWS-to-AWS traffic instead of hardcoded IPs when possible.

---

## 8. Security Group vs NACL

Security Group:

- Attached to EC2 / ENI.
- Stateful.
- Easier to manage.
- Controls instance-level access.

Network ACL:

- Attached to subnet.
- Stateless.
- Requires rules for both request and response paths.
- Can block traffic at subnet level.
- More powerful but harder to manage.

Practical conclusion from class:

Use Security Groups first. Touch NACLs only when there is a clear subnet-level security requirement.

---

## 9. Web Access vs SSH Access

The instructor separated developer/admin access from user/browser access.

SSH:

- Used by developers/admins.
- Port 22.
- Should never be open to customers.
- Prefer SSM when possible.

HTTP/HTTPS:

- Used by clients through browsers.
- HTTP: port 80.
- HTTPS: port 443.
- Used for web applications.

Important production pattern:

Internet -> ALB in public subnet -> App servers in private subnets -> DB in private data subnets

In the class lab, the instructor intentionally moved one step back from production security and asked students to deploy a web app directly on a public EC2 instance.

---

## 10. Hands-on Lab: Deploy EC2 Web App from GitHub and S3

Goal:

Deploy a static HTML dashboard on an EC2 instance.

Required flow:

GitHub -> local machine -> private S3 bucket -> EC2 with IAM Role -> Apache web server -> browser

Scenario:

The development team stored an HTML dashboard in GitHub. Infrastructure uses S3 as a private artifact repository and EC2 as the web server.

---

## 11. Lab Actions Completed

Downloaded the application from GitHub:

- File: index.html
- Size: 8309 bytes
- Title found: DataBite Cloud Dashboard

Created private S3 bucket:

- Bucket: databite-webapp-david-rubin-07052026
- Region: us-east-1
- Public access block enabled
- Server-side encryption: AES256

Uploaded artifact to S3:

- Object: index.html
- ContentType: text/html

Created IAM Role:

- Role name: databite-ec2-s3-read-role
- Trusted entity: EC2
- Policies:
  - AmazonS3ReadOnlyAccess
  - AmazonSSMManagedInstanceCore

Created EC2 instance:

- Name: databite-webapp-server
- Instance ID: i-0f812ac6ab91bf8a3
- Instance type: t3.micro
- AMI: Amazon Linux 2023
- VPC: vpc-069b8c7434bcbfdfd
- Subnet: public-subnet-a
- Subnet ID: subnet-08acbbab7a9e2ff33
- Availability Zone: us-east-1a
- Public IP: 44.193.7.10
- Private DNS: ec2-44-193-7-10.compute-1.amazonaws.com
- Security Group: sg-0abc7f38deb9f3ec5

Initial issue found:

- EC2 was launched without the IAM instance profile attached.
- IAM instance profile was then associated manually.
- SSM initially showed Offline due to missing SSM permissions.
- AmazonSSMManagedInstanceCore was added to the role.
- EC2 was rebooted.
- SSM changed to Online.

SSM verification:

- Instance ID: i-0f812ac6ab91bf8a3
- PingStatus: Online
- Agent version: 3.3.4108.0
- Platform: Amazon Linux 2023

Security Group issue found:

- Only SSH 22 from David's IP was open at first.
- HTTP 80 needed to be opened to 0.0.0.0/0 for browser access.

---

## 12. Apache Deployment Plan

Inside the EC2 instance through SSM Session Manager:

1. Update packages.
2. Install Apache and AWS CLI.
3. Start Apache.
4. Enable Apache on boot.
5. Pull index.html from S3.
6. Copy it into /var/www/html/index.html.
7. Fix permissions.
8. Restart Apache.
9. Test with curl localhost.
10. Test from browser using the EC2 public IP.

Expected browser URL:

http://44.193.7.10

Expected result:

The DataBite Cloud Dashboard page loads.

---

## 13. Key Commands Used

Local PowerShell:

- aws s3 mb
- aws s3 cp
- aws s3 ls
- aws s3api get-public-access-block
- aws s3api head-object
- aws ec2 describe-instances
- aws ec2 associate-iam-instance-profile
- aws iam attach-role-policy
- aws iam list-attached-role-policies
- aws ec2 reboot-instances
- aws ssm describe-instance-information

Inside EC2:

- sudo dnf update -y
- sudo dnf install -y httpd awscli
- sudo systemctl start httpd
- sudo systemctl enable httpd
- sudo systemctl status httpd --no-pager
- aws s3 cp
- sudo cp
- sudo chown
- sudo chmod
- sudo systemctl restart httpd
- curl localhost

---

## 14. Discussion Questions

Why upload the application to S3 instead of copying it manually to EC2?

Because S3 acts as a private artifact repository. The EC2 instance pulls a known artifact from a central place, making the deployment more repeatable, auditable, and automation-friendly.

Why is an IAM Role safer than storing AWS access keys on EC2?

Because the EC2 receives temporary credentials through AWS-managed metadata mechanisms. There are no long-lived access keys stored on disk, and AWS handles credential rotation.

Why did SSM need an IAM policy?

Because the SSM Agent needs permission to register the instance and communicate with Systems Manager. The managed policy AmazonSSMManagedInstanceCore provides those required permissions.

Why did HTTP not work immediately?

Because the Security Group initially allowed only SSH 22. A browser uses HTTP 80 or HTTPS 443, so HTTP 80 had to be allowed from 0.0.0.0/0.

---

## 15. Iron Rules Earned

- Public subnet is defined by routing, not by name.
- NAT Gateway serves private resources but must live in a public subnet.
- NAT allows outbound traffic, not inbound access.
- Security Group is attached to ENI/resources, not to subnets.
- Security Group is stateful. Response traffic returns automatically.
- NACL is subnet-level and stateless. More control, more pain.
- SSM is usually better than Bastion for admin access.
- Never store AWS access keys on EC2. Use IAM Roles.
- S3 can be used as a private artifact repository.
- A web app needs HTTP/HTTPS access, not SSH access.
- If the browser cannot reach EC2, check Apache, route table, public IP, and Security Group port 80.

---

## 16. Class Summary

The lesson connected the previous VPC architecture to a real deployment pattern.

The important transition was:

Networking theory -> secure access model -> artifact delivery -> running service

Final mental model:

GitHub stores the source artifact.  
S3 stores the private deployment artifact.  
IAM Role gives EC2 permission to read the artifact.  
SSM gives secure admin access without SSH.  
Apache serves the artifact to users through HTTP.  
Security Group decides whether the browser can reach the server.

Production-grade version of this design would usually replace public EC2 web access with:

Internet -> ALB -> private EC2 app servers -> private DB
