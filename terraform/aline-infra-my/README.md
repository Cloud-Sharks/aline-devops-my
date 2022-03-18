Project to provision infrastructure necessary to deploy an EKS cluster

# Define Modules and Variables
Ensure variables in modules/networking/main.tf are defined in deploy/networking/terraform.tfvars and included in deploy/networking/main.tf

Ensure variables are included in modules/networking/variables.tf and deploy/networking/variables.tf

Define any needed outputs in modules/networking/output.tf and deploy/networking/output.tf

# Init and Apply
In directory deploy/networking use terraform init to ensure config is set up

Use terraform verify and/or terraform apply to check correctness

Use terraform apply -auto-approve to begin provisioning

# Integration with Jenkins
Jenkinsfile utilizes secret file credentials for tfvars file and AWS credentials secrets for security

Jenkinsfile uses environment variable for directory path for -chdir command

Jenkinsfile is not in the repo main directory. Ensure path for pipeline from SCM is correctly defined