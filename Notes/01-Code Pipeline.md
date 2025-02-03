---
cssclasses:
  - image-border
tags:
  - aws-review
---
# AWS CodePipeline Artifact Management

AWS CodePipeline is a service for automating software release pipelines. Here's how it handles artifacts:

- **Artifacts:** These are the files or sets of files that actions operate on within a pipeline. They can be source code, build outputs, or configurations.
    
- **Input Artifacts:** These are the files used as input by an action.
    
- **Output Artifacts:** These are the files produced as output by an action.
    
- **Artifact Store:** A designated **S3 bucket** stores artifacts for all pipelines in the same AWS Region.
    
- **Pipeline Stages** CodePipeline uses stages, which are logical divisions in a workflow, and each stage is made up of a sequence of actions.
    
    - The first stage is always a **source stage** that retrieves source code. Supported sources include AWS CodeCommit, GitHub, Amazon ECR, or Amazon S3.
    - Subsequent stages can be **build or deployment** stages.
    - A **build stage** can use **AWS CodeBuild** to run builds and unit tests, taking build input artifacts and producing build output artifacts which can be stored in an S3 bucket.
    - A **deployment stage** can deploy changes using various AWS services such as CodeDeploy, Elastic Beanstalk, ECS, Fargate, S3, CloudFormation and others
    - **AWS CodeDeploy** uses an application specification file (AppSpec.yml) to deploy build artifacts.
- **YAML Configuration:** Pipelines can be defined using YAML.
    
    - A YAML example shows a source stage using CodeStarSourceConnection, specifying a branch, connection ARN, and repository.
    - The same YAML example shows a Beta stage using CodeBuild, taking an artifact from the source stage as an input.
- **Triggers:** Pipelines can be triggered by Git events like pushes or pull requests.
    
    - Triggers can be configured to include or exclude specific branches, tags, or file paths.

---

An **AppSpec file** is a YAML- or JSON-formatted file used by AWS CodeDeploy to manage deployments as a series of lifecycle event hooks. The content of the AppSpec file varies depending on the compute platform being used.

Here's a breakdown of AppSpec file usage for different compute platforms, according to the sources:

- **For EC2/On-Premises deployments**, the AppSpec file is always written in YAML. It is used to:
    - Map source files in the application revision to their destinations on the instance.
    - Specify custom permissions for deployed files.
    - Specify scripts to run on each instance at various stages of the deployment process.
    - The AppSpec file, along with source code, webpages, executable files and deployment scripts are packaged as an archive file which is considered the revision for the deployment.
    - The revision can be stored in Amazon S3 buckets or GitHub repositories.
- **For AWS Lambda deployments**, the AppSpec file is a YAML- or JSON-formatted application specification file that specifies:
    - Information about the Lambda function to deploy.
    - Functions to use as validation tests.
    - The revision for an AWS Lambda deployment is stored in Amazon S3 buckets.
- **For Amazon ECS deployments**, the AppSpec file is a YAML- or JSON-formatted file that specifies:
    - The Amazon ECS task definition used for the deployment.
    - A container name and port mapping used to route traffic.
    - Optional Lambda functions to run after deployment lifecycle events.
    - The revision for an Amazon ECS deployment is stored in Amazon S3 buckets.

In all cases, the **target revision** is the most recent version of the application revision that you have uploaded to your repository and want to deploy to the instances in a deployment group. The AppSpec file specifies the function revision that should be deployed to the deployment group.

The AppSpec file uses **lifecycle event hooks** to manage each deployment.

You can use the CodeDeploy console or the `create-deployment` command to deploy the function revision specified in the AppSpec file to the deployment group.

---

# EVENTS vs WEBHOOKS VS POLLING

### EVENTS
![[Pasted image 20250203095505.png]]

### WEBHOOKS
![[Pasted image 20250203095528.png]]

### POLLING:
![[Pasted image 20250203095536.png]]

---

# ACTION TYPES CONSTRAINT FOR ARTIFACTS

### OWNER
- AWS - AWS SERVICE
- 3RD PARTY - GITHUB
- CUSTOM - JENKINS
### ACTION TYPE
- SOURCE
- BUILD
- TEST
- APPROVAL
- INVOKE
- DEPLOY
![[Pasted image 20250203095757.png]]

---
# CODEPIPELINE - MANUAL APPROVAL STAGE

![[Pasted image 20250203095905.png]]

---

# CODEPIPELINE - CLOUDFORMATION AS A TARGET


![[Pasted image 20250203100238.png]]


- **CloudFormation Deploy Action**: Used to deploy AWS resources automatically
    - Example: Deploy Lambda Functions using tools like CDK or SAM
- **Works with CloudFormation StackSets**: Can deploy across multiple AWS accounts and regions at once
- **Configurable Settings**:
    - **Stack Name**: Name for the CloudFormation stack
    - **Change Set Name**: Name for any changes applied to the stack
    - **Template**: The CloudFormation template defining the resources
    - **Parameters**: Values that can customize the stack
    - **IAM Role**: Defines permissions for CloudFormation to act
    - **Action Mode**: Specifies how the stack should be handled

### WHAT AND IMPORTANCE OF CLOUDFORMATION

- **Infrastructure as Code (IaC)**: Automates the setup of AWS resources
    - Makes it easy to recreate and track infrastructure changes
- **Consistency and Standardization**: Ensures the same setup every time
    - Reduces the risk of errors from manual configuration
- **Stack Management**: Groups related AWS resources together
    - Simplifies creation, updates, or deletion of resources
- **Integration with DevOps Pipelines**: Automates deployment and testing processes
    - Easily works with tools like CodePipeline and CodeBuild

### ACTION MODES IN CLOUDFORMATION

- **CREATE/REPLACE A CHANGE SET**: Propose and apply changes to a stack
- **EXECUTE A CHANGE SET**: Apply the proposed changes
- **CREATE/UPDATE A STACK**: Set up or update a collection of AWS resources
- **DELETE A STACK**: Remove the stack and all its resources
- **REPLACE A FAILED STACK**: Replace a stack that encountered an error during creation or update

### TEMPLATE PARAMETER OVERRIDES

- **Specify JSON**: Use a JSON file to modify parameter values
- **Retrieve from CodePipeline Input Artifact**: Automatically fetch parameter values from the pipeline
- **Parameter Names Must Be Present**: All expected parameters must be defined
- **Static Parameters**: Use fixed values defined in the template
- **Dynamic Parameters**: Override values at runtime using parameter overrides

# CLOUDFORMATION INTEGRATION

![[Pasted image 20250203100605.png]]

### EXPLANATION OF SAMPLE FLOW

- **CODEBUILD (BUILDAPP)**:
    
    - Builds the application code
    - Compiles and packages artifacts for deployment
- **CLOUDFORMATION (DEPLOY INFRA AND APP)**:
    
    - **Create/Update CloudFormation Stack**: Deploys infrastructure (e.g., ALB with Auto Scaling Group of EC2 instances)
    - Creates or updates AWS resources based on CloudFormation template
- **CODEBUILD TEST AGAINST THE STACK**:
    
    - Tests the application against the deployed stack
    - Validates if the infrastructure and application are functioning as expected
- **IF WORKING**:
    
    - Proceed with the next steps if the tests pass
- **DELETE TEST INFRA**:
    
    - Deletes temporary infrastructure used for testing purposes to avoid unnecessary costs
- **DEPLOY PROD INFRA (CREATE/UPDATE CLOUDFORMATION STACK)**:
    
    - Deploys or updates production infrastructure using CloudFormation
    - Ensures that the infrastructure is ready for live application use

