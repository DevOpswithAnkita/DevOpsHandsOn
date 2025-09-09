# Ansible + Terraform AWS Webserver Deployment

This project demonstrates how to **install Ansible on EC2 instances using Terraform**, configure SSH access, and deploy a simple Nginx webserver using Ansible playbooks.

---

## Steps Performed

### 1. Install Ansible via  under Terraform main.tf file  `user_data`

Terraform EC2 instances were configured to install Ansible automatically using `user_data`:

```hcl
user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install software-properties-common -y
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt-get install ansible -y
EOF
```

- This ensures that Ansible is installed during EC2 instance provisioning.

---

### 2. Setup SSH Access

- Copy the private key (`.pem` file) to local machine.
- Use `scp` to copy it to both servers (if needed for automation):

```bash
scp -i devops-key.pem devops-key.pem ubuntu@<EC2-IP>:/home/ubuntu/.ssh/
```

- Ensure permissions are correct:

```bash
chmod 400 devops-key.pem
```

---

### 3. Configure Ansible Inventory

- Create `host.ini` file with both EC2 server details:

```ini
[ec2-users]
Ansible-user-1 ansible_host=184.72.182.161
Ansible-user-2 ansible_host=54.198.110.71

[ec2-users:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/Users/ankita/terraform/devops-key.pem
ansible_python_interpreter=/usr/bin/python3
```

---

### 4. Ansible Playbook

- Create a playbook `deploy-nginx.yml` to install and start Nginx, and deploy `index.html`:

```yaml
- name: Install and Deploy Nginx server
  hosts: ec2-users
  become: yes
  tasks:
    - name: Update apt cache and install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Start nginx service and enable at boot
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy webserver index.html
      copy:
        src: index.html
        dest: /var/www/html/index.html
```

- `index.html` can contain your content:

```html
<h1>Welcome to the world of automation and cloud!</h1>
```

---

### 5. Run Playbook

Execute the playbook:

```bash
ansible-playbook -i host.ini deploy-nginx.yml
```

- This installs Nginx, starts the service, and deploys the web page on all EC2 instances.

---

### Outcome

- EC2 instances provisioned via Terraform main.tf.
- Ansible installed automatically using `user_data`.
- SSH access configured using PEM key.
- Nginx installed and running on all EC2 servers.
- `index.html` deployed successfully.

---

This setup automates webserver deployment with **Terraform + Ansible** efficiently.
