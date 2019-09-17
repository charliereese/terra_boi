# TerraBoi

The TerraBoi gem contains rails generators to create Terraform infrastructure as code. The generators create infrastructure code for load balancing / auto scaling / zero-downtime deployments, (rails) web apps (EC2 instances), DBs, and S3 buckets.

This gem was created because I got tired of creating basic infrastructure to house small SaaS applications on AWS over and over again. Now I use the generators in this gem and I don't have to :)

## Pre-requisites

* [Terraform](https://www.terraform.io/) installed on your computer. 
* [Amazon Web Services (AWS) account](http://aws.amazon.com/).

Set up your [AWS access / secret access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

## Installation

Add this line to your (Rails) application's Gemfile:

```ruby
gem 'terra_boi'
```

And then execute:
```bash
$ bundle
```

## Usage

To deploy infrastructure to AWS, cd from root into `terraform/prod` or `terraform/staging`, then follow the following steps:

Deploy infrastructure:

```
terraform init
terraform apply
```

Clean up when done (DANGER FOR PROD, WILL DESTROY INFRASTRUCTURE):

```
terraform destroy
```

## Infrastructure created

The aforementioned generators create a `terraform` directory with `prod` and `staging` subdirectories. 

The `prod` and `staging` subdirectories contain `data` (DB + S3) and `web_servers` (SSL cert, load balancing, autoscaling, EC2) directories.

## Running tests

From the root directory:

```
rake test
```

## Contributing

This gem is currently not accepting contributions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
