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
> An instance launched in one vpc can never communicate with an instance in an other VPC using their private IP addresses.
>    - They could communicate still, but using their public IP [not recommended]
>   - Those 2 VPCs can be linked, it's called `peering` [VPC peering].


`Subnet` —-> A range of IP addresses in your VPC.
Two types of subnets:
   - Private subnet
   - Public subnet
> ### 📚 Note:
> Subnetting is the process of dividing a network into smaller network sections. This helps to isolate groups of hosts together.
> For us-east-1 region , subnets can currently only be created in the 
> following availability zones: 
> * us-east-1a 
> * us-east-1b 
> * us-east-1c
> * us-east-1d
> * us-east-1e
> * us-east-1f.

`Public subnet` --> A subnet's traffic is routed to an internet gateway.

`Private subnet` --> A subnet doesn't have a route to the internet gateway.

These are private subnets range:

| Range     |  From   | To    |
|:---------:|:-------:|:-------:| 
| 10.0.0.0/8 |10.0.0.0 | 10.255.255.255 |
| 172.16.0.0/12 | 172.16.0.0 | 172.31.255.255 |
| 192.168.0.0/16 | 192.168.0.0 | 192.168.255.255 |


> ### 📚 Note :
> `Private subnets` are only to be used within a VPC.

> Typically , `public subnets` are used for inter-facing services/applications and `private subnets` are used for databases, caching and backends respectively.



`Subnet mask` -->  A  subnet mask is another netmask within used to further divide the network.

|Range|Network Mask|Total Addresses|Description|Examples|
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
| 10.0.0.0/8 | 255.0.0.0 | 16,777,214 | Full 10.x.x.x range| **10**.0.0.1 , **10**.100.200.20 |
|10.0.0.0/16| 255.255.0.0 | 65,536 | 10.0.x.x range | **10.0**.5.1, **10.0**.20.2, **10.0**.100.3 |
| 10.6.0.0/16 | 255.255.0.0 | 65,538 | 10.6.x.x ranges | **10.6**.5.1, **10.6**.20.2, **10.6**.100.3 |
|10.0.0.0/24 | 255.255.255.0 | 256 | All addresses within from 10.0.0.0-10.0.0.255 | **10.0.0**.6,**10.0.0**.82 |
|10.0.63.0/24 | 255.255.255.0 | 256 | All addresses within from 10.0.63.0-10.0.63.255 | **10.0.63**.6,**10.0.63**.82 |
|10.0.0.5/32 | 255.255.255.255 | 1 | Single Host | **10.0.0.5**

> ### 📚 Note :
> To isolate a single host in a security group `/32` can be used to specify that.

Every Availability zone has its own public and private subnet.

`CIDR block` --> **CIDR** stands-for  **C**lassless **I**nter-**D**omain **R**outing. **CIDR**  is a method for allocating IP addresses and routing Internet Protocol packets. 

`NAT gateways` --> **NAT** stands-for **N**etwork **A**ddress **T**ranslation  . **NAT** gateway to enable instances in a private subnet to connect to the internet or other AWS services, but prevent the internet from initiating a connection with those instances

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
      