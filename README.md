# Terraform Task 2 - EC2 with Nginx in Two Regions

## Task Overview
Create 2 EC2 instances in 2 different AWS regions and automatically
install nginx using Terraform user_data script.

## Tech Stack
- AWS EC2
- Terraform
- AWS CLI
- Nginx

## Regions Used
| Region | Location | Instance Name |
|--------|----------|---------------|
| ap-southeast-2 | Sydney, Australia | terraform-nginx-sydney |
| ap-southeast-1 | Singapore | terraform-nginx-singapore |

## Key Concept - user_data
user_data is a startup script that runs automatically when EC2 boots.
We used it to install and start nginx without manually SSHing into instances.

## Project Structure
## Resources Created
- 2 EC2 instances (t2.micro) in different regions
- 2 Security Groups allowing HTTP (80) and SSH (22)
- Nginx auto-installed via user_data on both instances

## Key Commands
| Command | Description |
|---------|-------------|
| `terraform init` | Initialize providers |
| `terraform plan` | Preview changes |
| `terraform apply` | Create infrastructure |
| `terraform destroy` | Delete everything |

## Screenshots
See /screenshots folder for all output proofs.
