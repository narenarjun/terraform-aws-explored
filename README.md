# Terraform with AWS explored

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool, with which
aws infrastructure can be created and managed.

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

`CIDR block` --> CIDR stands-for  Classless Inter-Domain Routing. CIDR  is a method for allocating IP addresses and routing Internet Protocol packets. 