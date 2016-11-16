# Laravel CodeDeploy Template
A template for deploying Laravel applications with AWS CodeDeploy across an autoscaling group.

## IAM Roles
The following roles should be created **BEFORE** any launch configurations, autoscaling groups or CodeDeploy applications are created as they'll be needed during that creation process.

`code-deploy-role`

 - Requires the pre-baked policy **AWSCodeDeployRole**

`code-deploy-ec2-instance-role`

 - Requires the pre-baked policy **AmazonEC2FullAccess**
 - Requires a custom policy **code-deploy-ec2-permissions** with the following:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

## Requirements
 - A compatible **Ubuntu 16.04** AMI (use the provided **provision.sh** script on a fresh instance and save an AMI image from that)
 - A classic load balancer (preferably with sticky connections [5mins+])
 - An AWS launch configuration (using the aforementioned AMI) and an autoscaling group
 - A CodeDeploy application and deployment group that references the aforementioned autoscaling group
 - A S3 bucket for your application with two folders contained within: `bundles` and `env`

## Setup
 - Copy the `scripts` directory into the root of your Laravel application, as well as the `bundle.sh` and `appspec.yml` files
 - Replace the `XXX` placeholder inside of `bundle.sh` and `scripts/finish_install.sh` with your S3 bucket name
 - Inside of the S3 bucket folder `env` place a `production.env` file that contains your production settings. This will be copied to each instance as a `.env` file during each deployment cycle

## Usage
 - Make sure `composer` and `npm` have been run and all dependencies are up to date and that the application works as expected locally and on staging
 - Use `bundle.sh` to automatically create a `tar.gz` archive of your Laravel application and upload it to the S3 bucket folder `bundles`
 - The `bundle.sh` will tar only the directories and files listed in `bundle.conf`
 - Create a new CodeDeploy revision deployment using S3 as the source and point the endpoint to the one provided by the `bundle.sh` script

## Provisioner overview
The provided `provision.sh` script used to generate the instance needed for the AMI does the following:
 - Installs **NGINX**, **PHP7.0-FPM**, **Composer**, **NPM**, the **CodeDeploy Agent**, the **AWS CLI** and a bunch of related/required dependencies
 - Configures NGINX to serve content out of the `/var/www/public` directory
 - Only allows `index.php` to be executed via `PHP7.0-FPM`
