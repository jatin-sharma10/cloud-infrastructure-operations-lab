# Deployment Guide

This guide documents how the Cloud Infrastructure Operations Lab was deployed on Amazon Web Services.

## Prerequisites

Before starting, ensure you have:

- An AWS account
- An EC2 key pair
- SSH access from your computer
- Basic familiarity with Linux commands
- An AWS Security Group allowing:
  - SSH on port 22 from your IP address
  - HTTP on port 80

## 1. Launch the EC2 Instance

Create an Amazon EC2 instance with the following configuration:

| Setting | Value |
|---|---|
| Region | us-east-2 |
| Operating System | Ubuntu Server 24.04 LTS |
| Instance Type | t3.micro |
| Storage | Default EBS volume |
| HTTP Port | 80 |
| SSH Port | 22 |

Attach an IAM role with the following managed policy:

```text
CloudWatchAgentServerPolicy
```

## 2. Connect to the Instance

Protect the private key on the local computer:

```bash
chmod 400 cloud-ops-lab-key.pem
```

Connect to the EC2 instance:

```bash
ssh -i "cloud-ops-lab-key.pem" ubuntu@YOUR_EC2_PUBLIC_DNS
```

Verify the operating system:

```bash
cat /etc/os-release
```

## 3. Update the Server

Update the package index:

```bash
sudo apt update
```

Install available package updates:

```bash
sudo apt upgrade -y
```

## 4. Install Docker

Install Docker:

```bash
sudo apt install docker.io -y
```

Enable Docker at startup:

```bash
sudo systemctl enable docker
```

Start Docker:

```bash
sudo systemctl start docker
```

Verify Docker:

```bash
docker --version
sudo systemctl status docker
```

Add the Ubuntu user to the Docker group:

```bash
sudo usermod -aG docker ubuntu
```

Apply the new group membership:

```bash
newgrp docker
```

Test Docker:

```bash
docker run --rm hello-world
```

## 5. Create the Application Directory

Create the project directory:

```bash
mkdir -p ~/docker-web
cd ~/docker-web
```

The directory contains:

```text
Dockerfile
index.html
```

## 6. Build the Docker Image

Build the image:

```bash
docker build -t cloud-ops-web:v2 .
```

Verify that the image exists:

```bash
docker images
```

## 7. Run the Container

Run the application:

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

After the health check completes, the status should display:

```text
healthy
```

## 8. Test the Application

Test from inside the EC2 instance:

```bash
curl http://localhost
```

Open the application in a browser:

```text
http://YOUR_EC2_PUBLIC_IP
```

## 9. Install the CloudWatch Agent

Download the CloudWatch Agent package:

```bash
wget https://amazoncloudwatch-agent-us-east-2.s3.us-east-2.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
```

Install it:

```bash
sudo dpkg -i amazon-cloudwatch-agent.deb
```

Verify installation:

```bash
dpkg -l | grep amazon-cloudwatch-agent
```

## 10. Configure Monitoring and Logging

Run the CloudWatch configuration wizard:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Configure the agent to collect:

- CPU metrics
- Memory metrics
- Disk metrics
- Disk I/O metrics
- Network statistics
- Swap metrics

Configure these log files:

```text
/var/log/syslog
/var/log/nginx/access.log
/var/log/nginx/error.log
```

Validate the JSON configuration:

```bash
sudo python3 -m json.tool \
  /opt/aws/amazon-cloudwatch-agent/bin/config.json \
  > /dev/null
```

Apply the configuration:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

Check the agent status:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a status
```

## 11. Verify CloudWatch

In the AWS Console, verify:

```text
CloudWatch → Metrics → CWAgent
```

Confirm that system metrics are being published.

Then verify:

```text
CloudWatch → Logs → Log groups
```

Confirm the following log groups exist:

```text
syslog
nginx-access
nginx-error
```

## 12. Verify Container Health

Inspect the container health:

```bash
docker inspect \
  --format='{{json .State.Health}}' \
  cloud-ops-web
```

Review the container logs:

```bash
docker logs cloud-ops-web
```

## 13. Update the Application

After modifying `index.html`, build a new image version:

```bash
docker build -t cloud-ops-web:v3 .
```

Stop and remove the existing container:

```bash
docker stop cloud-ops-web
docker rm cloud-ops-web
```

Start the new version:

```bash
docker run -d \
  --name cloud-ops-web \
  --restart unless-stopped \
  -p 80:80 \
  cloud-ops-web:v3
```

Verify the deployment:

```bash
docker ps
curl http://localhost
```

## Deployment Validation Checklist

- [ ] EC2 instance is running
- [ ] SSH access works
- [ ] Docker service is active
- [ ] Docker image builds successfully
- [ ] Container is running
- [ ] Container health status is healthy
- [ ] Website loads through the EC2 public IP
- [ ] CloudWatch Agent is running
- [ ] Metrics appear in CloudWatch
- [ ] Logs appear in CloudWatch Logs
- [ ] Restart policy is configured