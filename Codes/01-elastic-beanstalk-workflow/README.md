# **Elastic Beanstalk CD Pipeline with Terraform and GitHub Actions**

This repository provides a **continuous deployment (CD) pipeline** for deploying an application to **AWS Elastic Beanstalk** using **Terraform** and **GitHub Actions**. The pipeline is triggered when changes are made to the `helloworld_test.js` file inside the `aws codes/01-elastic-beanstalk-workflow/` directory.

---

## **Introduction**

The **Elastic Beanstalk CD Pipeline** is designed to automate the deployment of applications to **AWS Elastic Beanstalk** whenever relevant changes are pushed to the `main` branch of the repository.

This workflow combines **Terraform** for infrastructure provisioning and **GitHub Actions** for automating deployments. Specifically, the pipeline only triggers when changes are made to `helloworld_test.js`, ensuring that only relevant updates initiate a new deployment.

---

## **How It Works**

1. **Push Trigger**: The workflow is triggered when there is a **push event** to the `main` branch, specifically when changes are made to `aws codes/01-elastic-beanstalk-workflow/helloworld_test.js`.
   
2. **Terraform Initialization**: The workflow initializes **Terraform** by setting up the environment with the necessary providers and modules.

3. **Terraform Apply**: After initialization, the **Terraform apply** command is executed to deploy changes to **AWS Elastic Beanstalk**.

---

## **GitHub Actions Workflow**

### **Triggering Conditions**

The workflow is set up to trigger on the following event:
- **Push to `main` branch**
- **Changes made to `aws codes/01-elastic-beanstalk-workflow/helloworld_test.js`**

This ensures that the pipeline is only triggered for relevant changes to the application code.

### **Workflow File:**

```yaml
name: Deploy to Elastic Beanstalk

on:
  push:
    paths:
      - 'aws codes/01-elastic-beanstalk-workflow/helloworld_test.js'
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1

      - name: Initialize Terraform
        run: terraform init

      - name: Apply Terraform
        run: terraform apply -auto-approve
```

---

## **Pre-requisites**

Before using this pipeline, ensure you have:

1. **AWS Elastic Beanstalk Application**: An existing Elastic Beanstalk application and environment to deploy to. If you don't have one, you can easily create it via the AWS Console.
   
2. **AWS Credentials**: Set up AWS credentials using GitHub Secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`), which will be used by Terraform to interact with AWS resources.

3. **Terraform Setup**: The repository should contain the necessary Terraform configurations to manage your Elastic Beanstalk resources (e.g., application, environment, IAM roles).

---

## **Setup**

### **1. Create GitHub Secrets**

In order to allow GitHub Actions to interact with AWS, create the following GitHub secrets in your repository:

- **`AWS_ACCESS_KEY_ID`**: Your AWS Access Key ID.
- **`AWS_SECRET_ACCESS_KEY`**: Your AWS Secret Access Key.
  
These secrets are used by **Terraform** to authenticate and deploy to AWS.

### **2. Terraform Configuration**

Ensure your repository has the necessary Terraform configurations to provision Elastic Beanstalk resources (e.g., `aws_elastic_beanstalk_application`, `aws_elastic_beanstalk_environment`). These should be included in your Terraform files.

---

## **How to Trigger the Deployment**

The pipeline will automatically run under the following conditions:

- A **push** is made to the `main` branch.
- Changes are made specifically to `aws codes/01-elastic-beanstalk-workflow/helloworld_test.js`.

This ensures that only relevant changes trigger the deployment process.

---

## **Conclusion**

This **Elastic Beanstalk CD Pipeline** enables a fully automated, infrastructure-as-code-based deployment pipeline using **Terraform** and **GitHub Actions**. It streamlines the deployment process, ensures consistent and reproducible deployments, and eliminates manual intervention.
