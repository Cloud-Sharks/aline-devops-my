# aline-devops-my
### DevOps work for Aline Financial project by Mark. This repo contains sample implementation of the following technologies and tools

---

## Ansible
Ansible is a configuration management tool that allows a controller to manage several other nodes. The playbooks here are sample plays to deploy and manage working environments.

## Cloudformation Templates
Cloudformation is a tool used by AWS to provision and manage various AWS resources. The templates here create a VPC designed to host either an ECS or an EKS cluster with a peering connection to another VPC hosting a remote database and a sample ECS cluster.

## Docker Compose
Docker Compose is a container deployment tool that helps in the creation of working deployment stacks. The compose files here can be deployed locally or on the AWS resource ECS with an ECS Docker context.

## Kubernetes
Kubernetes is a container orchestration platform that facilitates application deployment, management, and scaling. The manifest files here can be deployed locally or on the AWS resource EKS with the eksctl cli tool.

## Terraform
Terraform is an infrastructure as code tool that defines and provisions infrastructure. The terraform files here are designed to create infrastucture on AWS to be used by an EKS cluster.