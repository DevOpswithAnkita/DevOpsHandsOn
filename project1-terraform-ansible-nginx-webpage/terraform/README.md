# Project 1: Terraform + Ansible - Nginx Deployment

This main.tf file demonstrates how to provision AWS infrastructure using Terraform and configure EC2 instances.

---

## Features

- Create a **VPC** with public and private subnets.
- Create an **Internet Gateway** and **NAT Gateway**.
- Configure **Route Tables** for public and private subnets.
- Create a **Security Group** allowing HTTP (80) and SSH (22) access.
- Generate an **AWS Key Pair** for SSH access.
- Launch **1 Master EC2 instance** and **2 Worker EC2 instances**.

---

## AWS Infrastructure

1. **VPC:** 10.0.0.0/16  
2. **Public Subnet:** 10.0.1.0/24  
3. **Private Subnet:** 10.0.2.0/24  
4. **Security Group:** Allows TCP 22 and 80  
5. **EC2 Instances:**  
   - Master: `Ansible-master`  
   - Workers: `Ansible-user-1`, `Ansible-user-2`  

---

## Terraform Commands Used

```bash
   terraform init         # Initialize Terraform
   terraform validate     # Validate configuration
   terraform plan         # Show execution plan
   terraform apply        # Apply configuration
   terraform destroy      # Remove infrastructure
```
## Terraform Apply Output
![Terraform Apply Output](project1-terraform-ansible-nginx-webpage/terraform/Images/terraform-apply-output.png)
## Terraform destroy Output
![Terraform destroy Output](project1-terraform-ansible-nginx-webpage/terraform/Images/terraform-destroy-output.png)
## ec2 Instances 
![Terraform Apply Output](project1-terraform-ansible-nginx-webpage/terraform/Images/Ec2-Instances.png)
 
