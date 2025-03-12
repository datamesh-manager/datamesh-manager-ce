# AWS CloudFormation Template

The cloud formation template for the AWS infrastructure is available in `template.yaml` and in a public S3 bucket: https://datamesh-manager-ce.s3.us-east-1.amazonaws.com/template.yaml.

It uses the Docker Image hosted on AWS Public ECR: `public.ecr.aws/z3b7c0x3/datamesh-manager-ce:latest` (see more on https://gallery.ecr.aws/z3b7c0x3/datamesh-manager-ce).

[Quick-Create Link](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/review?templateURL=https://datamesh-manager-ce.s3.us-east-1.amazonaws.com/template.yaml)

## Constraints

Using a public image from Docker Hub in AWS AppRunner comes with many constraints on AWS.

- AppRunner does not support public images from Docker Hub, only from ECR Public.
- AppRunner does not support automated deployment from images on ECR Public.

The alternative requires a private ECR repository, which either gets the image pushed or configures a pull-through cache.
The pull-through cache always requires credentials configured in the AWS Secrets Manager, even for public docker images on Docker Hub.

Because of that, the CloudFormation template uses `public.ecr.aws/z3b7c0x3/datamesh-manager-ce:latest` from ECR Public. But be aware that it does not automatically upgrade to newer versions of the Data Mesh Manager!

## Testing the CloudFormation Template

### Installation of Taskcat

```bash
python3.11 -m venv venv
source venv/bin/activate

pip install taskcat
```

### Running Taskcat

```bash
# requires AWS credentials via environment variables
taskcat test run
```
