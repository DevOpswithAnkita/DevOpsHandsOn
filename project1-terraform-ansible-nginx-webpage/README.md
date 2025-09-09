# Project 1: Terraform + Ansible - Nginx Deployment

This project demonstrates how to provision AWS infrastructure using Terraform and configure EC2 instances using Ansible to deploy an HTML webpage.

---

## Tech Stack

- **Infrastructure as Code:** Terraform  
- **Configuration Management / Orchestration:** Ansible  
- **Cloud Provider:** AWS (EC2, VPC, Subnets, Security Groups)  
- **Web Server:** Nginx  
- **Version Control:** Git & GitHub  
- **Operating System:** Ubuntu (for EC2 instances)  

---

## Installation

### Prerequisites (on local machine)
1. **Terraform**
   ```bash
       # For macOS
       brew tap hashicorp/tap
       brew install hashicorp/tap/terraform
       terraform -v
    
       # For Linux (Ubuntu/Debian)
       sudo apt-get update && sudo apt-get install -y terraform
       terraform -v
2. **Ansible**
   ```bash
       # macOS
        brew install ansible
        ansible --version
        
        # Linux
        sudo apt-get update && sudo apt-get install -y ansible
        ansible --version

3. **AWS configured**
   ```bash
        # macOS
        brew install awscli
        aws --version
        # Linux ubuntu
        sudo apt-get update
        sudo apt-get install -y awscli
        aws --version
        aws configure
 

