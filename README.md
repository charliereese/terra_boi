# TerraBoi

The TerraBoi gem contains rails generators to create Terraform infrastructure as code. The generators create infrastructure code for load-balancing / auto-scaling / zero-downtime web app deployments, (rails) web apps (EC2 instances), DBs, and S3 buckets.

This gem was created because I got tired of creating basic infrastructure to house small SaaS applications on AWS over and over again. Now I use the generators in this gem and I don't have to :)

## Pre-requisites

* [Terraform](https://www.terraform.io/) installed on your computer. 
* [Amazon Web Services (AWS) account](http://aws.amazon.com/).

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

**A. Setup AWS access:**

Set up your [AWS access / secret access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

Then run `source ~/.zprofile` (or equivalent command if not using .zsh)

**B. Set up boilerplate infrastructure (remote state, data, web servers):**

`rails generate terra_boi:boilerplate --domain_name DOMAIN.COM`

**C. Set up remote state:**

`cd terraform/state`

Run `terraform init` and then `terraform apply` to set up s3 bucket and dynamoDB for remote state and locking (this will work for both prod and staging).

**D. Set up DB / S3:**

`cd terraform/[ENV]/data`

Set terraform data-related environment variables in .zprofile (or your respective shell dotfile)

```
TF_VAR_db_password=your_password
TF_VAR_db_username=your_username
```

To deploy infrastructure to AWS:

```
terraform init # IF NOT ALREADY RUN
terraform apply
```

**E. Set up web servers:**

`cd terraform/[ENV]/web_servers`

To deploy infrastructure to AWS:

```
terraform init # IF NOT ALREADY RUN
terraform apply
```

While aws_acm_certificate_validation.cert is creating (it will hang if you don't add CNAME verification record in ACM):

i. Log into AWS console, go to certificate management, and add the created CNAME record specified to the DNS configuration for your domain
ii. Redirect domain name to Application load balancer:
	- Go to your domain registrar of choice
	- Create alias record that points to the dns name of the application load balancer (use subdomain in alias record like STAGING.example.com for staging)
	- Create URL redirect record for prod (redirect www.site.com to site.com)

After these changes propogate (should take about an hour or two locally), your webservers should be set up, https should be working, and you should be good to go!

**F. Other tips:**

Clean up when done (DANGER FOR PROD, WILL DESTROY INFRASTRUCTURE):

```
terraform destroy
```

## Infrastructure created

The aforementioned generators create a `terraform` directory with `state`, `prod`, and `staging` subdirectories. 

The `state` directory contains an S3 bucket and a DynamoDB table to store and lock state (for both prod and staging).

The `prod` and `staging` subdirectories contain `data` (DB + S3) and `web_servers` (SSL cert, load balancing, autoscaling, EC2) directories.

## Running tests

From the root directory:

```
rake test
```

## Contributing

This gem is currently not actively accepting contributions. 

With that in mind, if you'd like to make a fix / change, please create a pull request (and when I have a moment - probably in a couple weeks time - I'll have a look)!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
