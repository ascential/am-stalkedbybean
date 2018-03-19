# What Goes in Your Config File

A short guide as to what needs to go in your config file for deployment as well as where you might find them.

## Mandatory Options
* **aws_profile**

* **aws_region**

The region where your resource is going to reside in. This is up to you but **please** ensure that it is consistent throughout your app. You can find more details as well the list of possible regions [at this link](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html).

* **kms_arn**

You should have created a key [as detailed here](./README.md#handling-secrets) to handle any secrets within Credstash. To get the ARN of your key, go to the IAM service page --> Encryption Keys and find the key that you have created. Copy the entire ARN of your key for this field.

## Not-so-mandatory Options

* **vpc_id**

VPC (Virtual Private Cloud) is an isolated virtual network in the AWS cloud. You can find your **VPC ID** by going to the VPC service page and searching the table in **Your VPCs**.

* **vpc_security_groups**

Find your relevant security group by going to the VPC service page and searching the table in **Security Groups** for the groups relevant to your app. You might have more than one security group. You will need to copy their group IDs.

If your application has a database, you will also need to include your [RDS security group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html) by looking up your DB instance on AWS RDS.

* **instance_count**

* **instance_size**

You can specify the instance type and instance size which best fits your app. More details on the different types/sizes which exist [can be found here](https://aws.amazon.com/ec2/instance-types/).

* **platform_arn**

The ARN of the custom platform you are using. We offer two versions of custom platforms so far for the regions eu-west-1 and eu-west-2.

eu-west-1: arn:aws:elasticbeanstalk:eu-west-1:160153085320:platform/AscentialPlatform_Ubuntu/1.0.42
eu-west-2: arn:aws:elasticbeanstalk:eu-west-2:160153085320:platform/AscentialPlatform_Ubuntu/1.0.2

If this does not fit your requirements, you can [create your own custom beanstalk platform](./Beanstalk_custom_platform.md).

* **environment**

Specify the name of the environment you are deploying (e.g. test, deployment, production etc). You can create and manage separate environments for your application.

* **vpc_ec2_subnets**

Your private subnet IDs belong here. Find your relevant private subnet IDs by going to the VPC service page and searching under **Subnets**. You might have more than one security group. An easy way to narrow things down would be to search the subnets by your VPC id.

* **vpc_elb_subnets**

Your public subnet IDs belong here. Find your relevant private subnet IDs by going to the VPC service page and searching under **Subnets**. You might have more than one security group. An easy way to narrow things down would be to search the subnets by your VPC id.

* **key_name**
