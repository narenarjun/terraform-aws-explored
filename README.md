# Terraform with AWS explored

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool, with which
aws infrastructure can be created and managed.

## AWS credentials

Since aws credentials are sensitive info, they are not added in the `main.tf` file,
they are set and exported in the environment variable in bash.

```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

### AWS specific terminology

#### Amazon VPC

Amazon VPC is the networking layer for Amazon EC2.

`Virtual private cloud (VPC)` --> virtual network dedicated to your AWS account.
VPC isolates the instances on a network level.[It's like a your own private network in the cloud]

> ### 📚 Note:
>
> An instance launched in one vpc can never communicate with an instance in an other VPC using their private IP addresses.
>
> - They could communicate still, but using their public IP [not recommended]
> - Those 2 VPCs can be linked, it's called `peering` [VPC peering].

`Subnet` —-> A range of IP addresses in your VPC.
Two types of subnets:

- Private subnet
- Public subnet
  > ### 📚 Note:
  >
  > Subnetting is the process of dividing a network into smaller network sections. This helps to isolate groups of hosts together.
  > For us-east-1 region , subnets can currently only be created in the
  > following availability zones:
  >
  > - us-east-1a
  > - us-east-1b
  > - us-east-1c
  > - us-east-1d
  > - us-east-1e
  > - us-east-1f.

`Public subnet` --> A subnet's traffic is routed to an internet gateway.

`Private subnet` --> A subnet doesn't have a route to the internet gateway.

These are private subnets range:

|     Range      |    From     |       To        |
| :------------: | :---------: | :-------------: |
|   10.0.0.0/8   |  10.0.0.0   | 10.255.255.255  |
| 172.16.0.0/12  | 172.16.0.0  | 172.31.255.255  |
| 192.168.0.0/16 | 192.168.0.0 | 192.168.255.255 |

> ### 📚 Note :
>
> `Private subnets` are only to be used within a VPC.

> Typically , `public subnets` are used for inter-facing services/applications and `private subnets` are used for databases, caching and backends respectively.

`Subnet mask` --> A subnet mask is another netmask within used to further divide the network.

|    Range     |  Network Mask   | Total Addresses |                   Description                   |                  Examples                   |
| :----------: | :-------------: | :-------------: | :---------------------------------------------: | :-----------------------------------------: |
|  10.0.0.0/8  |    255.0.0.0    |   16,777,214    |               Full 10.x.x.x range               |      **10**.0.0.1 , **10**.100.200.20       |
| 10.0.0.0/16  |   255.255.0.0   |     65,536      |                 10.0.x.x range                  | **10.0**.5.1, **10.0**.20.2, **10.0**.100.3 |
| 10.6.0.0/16  |   255.255.0.0   |     65,538      |                 10.6.x.x ranges                 | **10.6**.5.1, **10.6**.20.2, **10.6**.100.3 |
| 10.0.0.0/24  |  255.255.255.0  |       256       |  All addresses within from 10.0.0.0-10.0.0.255  |         **10.0.0**.6,**10.0.0**.82          |
| 10.0.63.0/24 |  255.255.255.0  |       256       | All addresses within from 10.0.63.0-10.0.63.255 |        **10.0.63**.6,**10.0.63**.82         |
| 10.0.0.5/32  | 255.255.255.255 |        1        |                   Single Host                   |                **10.0.0.5**                 |

> ### 📚 Note :
>
> To isolate a single host in a security group `/32` can be used to specify that.

Every Availability zone has its own public and private subnet.

`CIDR block` --> **CIDR** stands-for **C**lassless **I**nter-**D**omain **R**outing. **CIDR** is a method for allocating IP addresses and routing Internet Protocol packets.

`NAT gateways` --> **NAT** stands-for **N**etwork **A**ddress **T**ranslation . **NAT** gateway to enable instances in a private subnet to connect to the internet or other AWS services, but prevent the internet from initiating a connection with those instances

## SSH keys

The SSH protocol uses public key cryptography for authenticating hosts and users. The authentication keys, called SSH keys, are created using the keygen program

`ssh-keygen` cli can be used to create ssh-key pairs.A ssh key pair consist of :

- a public key
- a private key corresponding to the public key

SSH supports several public key algorithms for authentication keys. They are :

- rsa
- dsa
- ecdsa
- ed25519

```bash
ssh-keygen -t rsa -b 4096
ssh-keygen -t dsa
ssh-keygen -t ecdsa -b 521
ssh-keygen -t ed25519
```

based on the security needs any one such algorithm is selected to generate the ssh keys.

### [Userdata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

- Userdata in AWS can be used to do any customization at launch
  - we can install extra software
  - prepare the instance to join a cluster. eg: consul cluster, K8s cluster [as a node or master]
  - Execute commands/scripts
  - mount volumes
- Userdata is only executed at the creation of the instance, not when the instance reboots
- Terraform allows us to add userdata to the `aws_instance` resource
  - Just a a string (for simple commands)
  - Using templated (for more complex instructions)

### Static private IPs

- Private IP addresses will be auto-assigned to EC2 instances.
- Every subnet within the vpc has its own range (e.g : 10.0.1.0 - 10.0.1.255)
- By specifying the private IP, we can make sure the EC2 instance always uses the same IP addresses

### EIP (Elastic IP) address

- To use a public IP address, we can use EIPs (Elastic IP addresses)
- This is a public, static IP address that we can attach to our instance.

### Route53

- Typically, we'll not use IP addresses, but hostnames
- This is where route53 comes in
- We can host a domain on AWS using **Route53**
- We first need to register a domain name using AWS or any accredited registrar
- We can then create a zone in route53 (e.g: example.com) and add DNS records (e.g: server1.example.com)

### RDS

- RDS stands for Relational Database Services
- It's a managed database solution :
  - we can easily setup replication (high availability)
  - automated snapshots (for backups)
  - automated security updates
  - Easy instance replacement (for vertical scaling)
- Supported databases are:
  - MySQL
  - MariaDB
  - PostgreSQL
  - Microsoft SQL
- Steps to create an RDS instance:
  - create a **subnet group**
    - Allows you to specify in what subnets the databes will be in
  - create a **Parameter group**
    - Allows you to specify parameters to change settings in the database
  - create a security group that allows incoming traffic to the RDS instance

### IAM

- IAM is AWS' **Identity & Access Management**
- It's a service that helps us to control access to our AWS resources
- In AWS with IAM we can create:
  - Groups
  - Users
  - Roles
- Users can have **groups**
  - for instance an "Administrators" group can give **admin privileges** to users
- Users can authenticate

  - Using a login/password
    - optionally using a **token**: multifactor authentication (MFA) using Google authenticator compatible software
  - an **access key** and **secret key** (the API keys)

  ### IAM roles

  - Roles can give users/services (temporary) access that they normally wouldn't have
  - The roles can be for instance **attached** to EC2 instances
    - From that instance, a user or service can obtain access credentials
    - Using those access crendentials the user or service can assume the role, which gives them permission to do something
  - IAM roles only work on **EC2 instances** and not for instances outside AWS
  - The temporary access credentials also need to be **renewed**, they are only valid for a predefined amount of time
    - This is also something the AWS SDK will take care of

- To create a IAM administrators group in AWS, we can create the group and attach the AWS managed Administrator policy to it.
- We can also create our own custom policy.

### Autoscaling

- In AWS autoscaling groups can be created to **automatically add/remove** instances when creatain threshold are reached
  - e.g: application layer can be **scaled out** when we have more visitors
- To set up autoscaling in AWS we need to setup at least **2 resources**
  - An AWS **launch configuration**
    - specifies the properties of the instance to be launched (AMI ID, security group etc)
  - An **autoscaling group**
    - Specifies the scaling properties (min instances, health checks)
- Once the autoscaling group is setup, we can create autoscaling policies
  - A policy is triggered based on a threshold (CloudWatch alarm)
  - An adjustment will be executed
    - e.g: if the average CPU utilization is more than 20% then scale up by +1 instances
    - e.g: if the average CPU utilization is less than 5% then scale down by -1 instances
