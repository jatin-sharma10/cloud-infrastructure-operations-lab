# Cloud Infrastructure Operations Lab

A cloud infrastructure project deployed on Amazon Web Services using Amazon EC2, Ubuntu Linux, Docker, Nginx, IAM, Security Groups, and Amazon CloudWatch.

## Project Overview

This project demonstrates the deployment and operation of a containerized web application on AWS.

The application runs inside an Nginx Docker container hosted on an Ubuntu EC2 instance. The environment includes secure SSH administration, IAM-based AWS permissions, centralized CloudWatch logging, host-level monitoring, Docker health checks, and automatic container restart behavior.

## Architecture

```text
Internet
   |
   v
AWS Security Group
   |
   v
Amazon EC2
Ubuntu Linux
   |
   v
Docker Engine
   |
   v
Nginx Container
   |
   v
Static Web Application

EC2 Host
   |
   v
Amazon CloudWatch
Metrics and Centralized Logs
```

## Technologies Used

- Amazon EC2
- Ubuntu Linux 24.04 LTS
- Docker
- Nginx
- Amazon CloudWatch
- AWS IAM
- AWS Security Groups
- SSH
- Linux CLI
- Bash

## Features Implemented

- Provisioned an Ubuntu EC2 instance in AWS
- Configured inbound access through AWS Security Groups
- Secured remote administration using SSH key authentication
- Created and attached an IAM role for CloudWatch integration
- Installed and configured Docker Engine
- Containerized a static Nginx web application
- Implemented Docker health checks
- Configured an automatic container restart policy
- Built and deployed versioned Docker images
- Installed and configured the Amazon CloudWatch Agent
- Collected CPU, memory, disk, disk I/O, network, and swap metrics
- Streamed system and Nginx logs to Amazon CloudWatch
- Configured 30-day retention for CloudWatch log groups
- Practiced Linux user, group, ownership, and permission management
- Tested and troubleshot application and infrastructure failures

## Repository Structure

```text
cloud-infrastructure-operations-lab/
├── architecture/
├── docs/
│   ├── deployment-guide.md
│   └── troubleshooting.md
├── screenshots/
├── .gitignore
├── Dockerfile
├── index.html
├── LICENSE
└── README.md
```

## Docker Image

The application uses the lightweight Alpine-based Nginx image.

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
CMD wget -q --spider http://localhost/ || exit 1
```

## Build and Run

Build the Docker image:

```bash
docker build -t cloud-ops-web:v2 .
```

Run the container:

```bash
docker run -d \
  --name cloud-ops-web \
  --restart unless-stopped \
  -p 80:80 \
  cloud-ops-web:v2
```

Verify the container:

```bash
docker ps
```

Test the application locally from the EC2 instance:

```bash
curl http://localhost
```

Inspect the container health status:

```bash
docker inspect \
  --format='{{json .State.Health}}' \
  cloud-ops-web
```

## Monitoring and Logging

The Amazon CloudWatch Agent collects the following host metrics:

- CPU utilization
- Memory utilization
- Disk utilization
- Disk I/O
- Network connection statistics
- Swap utilization

The following log files are streamed to CloudWatch Logs:

```text
/var/log/syslog
/var/log/nginx/access.log
/var/log/nginx/error.log
```

CloudWatch log groups:

```text
syslog
nginx-access
nginx-error
```

## Security Practices

- Restricted SSH access through the EC2 Security Group
- Used SSH key-based authentication
- Protected private keys with restrictive file permissions
- Used an EC2 IAM role instead of storing AWS credentials on the server
- Limited HTTP exposure to the required application port
- Excluded private keys, environment files, and logs through `.gitignore`

## Troubleshooting Experience

During implementation, I diagnosed and resolved several operational issues, including:

- Incorrect SSH private-key permissions
- CloudWatch Agent package installation
- Invalid CloudWatch configuration input
- CloudWatch log-file permission access
- Host Nginx and Docker port 80 conflicts
- Docker command syntax errors
- Failed containers caused by launching the wrong image
- Application downtime after removing the existing container

Detailed incident notes are available in:

[`docs/troubleshooting.md`](docs/troubleshooting.md)

## Documentation

- [Deployment Guide](docs/deployment-guide.md)
- [Troubleshooting Guide](docs/troubleshooting.md)

## Screenshots

Screenshots of the running application, EC2 instance, Docker container, CloudWatch metrics, and CloudWatch logs will be added to the `screenshots` directory.

## Skills Demonstrated

- AWS cloud infrastructure
- Linux system administration
- Docker containerization
- Identity and access management
- Network security
- Infrastructure monitoring
- Centralized logging
- Troubleshooting and incident recovery
- Technical documentation
- Version-controlled development

## Planned Improvements

- Add Docker Compose
- Create CloudWatch alarms
- Provision the infrastructure using Terraform
- Add a GitHub Actions CI pipeline
- Add HTTPS and a custom domain
- Evaluate deployment using Amazon ECS Fargate

## Author

**Jatin Sharma**

Cloud and Infrastructure Engineering Portfolio Project

## License

This project is licensed under the MIT License.