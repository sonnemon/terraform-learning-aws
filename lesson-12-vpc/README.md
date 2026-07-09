# Lesson 12 — VPC from scratch · $0.00

## Services

- **VPC:** your private network in AWS. An IP range (e.g. `10.0.0.0/16`) where everything else lives.
- **Subnets:** subdivisions of the VPC per Availability Zone (AZ). *Public* = with a route to the internet; *private* = without one.
- **Internet Gateway:** the VPC's door to the internet. Free.
- **Route Tables:** decide where each subnet's traffic goes (the public one routes `0.0.0.0/0` to the Internet Gateway).
- **NACLs:** subnet-level firewall (stateless), complementing Security Groups.
- **NAT Gateway:** ❌ NOT CREATED. It's what gives private subnets internet access and costs ~$33/month just for existing.

## Example project

The network the rest of the repo will use:

```
VPC 10.0.0.0/16
├── AZ a: public subnet 10.0.1.0/24  +  private subnet 10.0.11.0/24
├── AZ b: public subnet 10.0.2.0/24  +  private subnet 10.0.12.0/24
└── Internet Gateway + route tables
```

1. Create the VPC, 2 public and 2 private subnets across 2 AZs.
2. Internet Gateway + public route table associated with the public subnets.
3. Private route table with no internet route (no NAT).
4. Outputs with the IDs (lessons 13-18 reuse this VPC).

## What you learn

- THE infra interview question: how to build a network in AWS.
- Public vs private, routes, multi-AZ.
- All free as long as you don't create a NAT Gateway.
