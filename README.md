# TerraBoi

This gem was created to get rails applications deployed into production as quickly and easily as possible.

Raison d'etre: Creating basic infrastructure to house production SaaS applications on AWS is tedious and boring. It's often a similar process every time, and every time it sucks.

List of items created by this gem's generators:
- Dockerfile
- Rails initializer file (for setting up config.hosts)
- Packer repository (for creating AMIs)
- Terraform repository (for creating infrastructure as code to immediately deploy staging / prod infrastructure as well as rolling out application updates)

Note: Generated Terraform files create / support remote state locking, load-balancing, auto-scaling, zero-downtime web app deployments, DBs, and S3 buckets.

Note: After infrastructure files are generated, you will be ready to deploy your application to staging / production on AWS. If you have more advanced infrastructure needs (e.g. Redis / Solr instances), you may add to the generated Terraform files to support this.



## Pre-requisites

* [Terraform](https://www.terraform.io/) installed on your computer. 
* [Amazon Web Services (AWS) account](http://aws.amazon.com/)



## Installation

Note: below installation steps should be completed in order.

#### Installation - gem

Add this line to your (Rails) application's Gemfile:

```ruby
gem 'terra_boi'
```

And then execute:

```bash
$ bundle
```

#### Installation - AWS access

Set up your [AWS access / secret access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) in `~/.zprofile` (or equivalent file for your shell if not using .zsh) as environment variables:

```
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

Then run `source ~/.zprofile` (or equivalent command for your shell if not using .zsh)

#### Installation - generate infrastructure code

To generate boilerplate infrastructure code (config.host initializer filer, Dockerfile, Packer repository, and terraform repository):

`rails generate terra_boi:boilerplate --domain_name DOMAIN.COM --dockerhub_image username/image:latest`

#### Installation - Packer (creating web server AMIs)

**A. Create private DockerHub repository**

Create private DockerHub repository for your rails application (if possible, use the exact same name as your rails application).

Note: packer generator will assume your DockerHub repository has the same name as your rails application folder. If this isn't true, update generated Packer `ami_build.json` file after it is generated.

**B. Setup DockerHub access:**

Add DockerHub access key to `~/.zprofile` (or equivalent file for your shell if not using .zsh) as environment variable (if your image is in a private repository):

```
DOCKERHUB_ACCESS_TOKEN=myAccessToken
export DOCKERHUB_ACCESS_TOKEN
```

Then run `source ~/.zprofile` (or equivalent command for your shell if not using .zsh)

Note: DockerHub access key can be found at https://hub.docker.com/settings/security

#### Installation - Terraform (Deploying DBs + web server AMIs)

**A. Set up remote state:**

`cd terraform/state`

Run `terraform init` and then `terraform apply` to set up s3 bucket and dynamoDB for remote state and locking (this will work for both prod and staging).

**B. Set up DB / S3:**

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

**C. Set up web servers:**

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



## Usage

Note: below usage steps should be completed in order

#### Usage - Packer (creating web server AMIs)

**A. Push latest application image to DockerHub**

You can automatically trigger DockerHub image builds when new code is pushed to a repository's master branch using DockerHub's free Github integration. 

Otherwise, `docker push [DOCKER_USERNAME]/[APPLICATION_NAME]:latest`. Make sure you are pushing to a private repository.

**B. Create Packer AMI:**

```
cd packer 

packer build -var DOCKERHUB_ACCESS_TOKEN=$DOCKERHUB_ACCESS_TOKEN application.json
```

**B. Clean Up:**

Every so often you'll want to remove old AMIs created by Packer (unless you want to be charged a couple cents a month).

To remove them, deregister them on the [AWS AMI management page](https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#Images:sort=name), then delete the associated snapshot on the [AWS snapshot management page](https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#Snapshots:sort=snapshotId).

#### Usage - Terraform (update web server AMIs)

**A. Update Terraform web server AMIs:**

`cd terraform/[ENV]/web_servers`

To deploy infrastructure to AWS:

```
terraform init # IF NOT ALREADY RUN
terraform apply
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



## Other tips:

Clean up terraform infrastructure when no longer planning to use (DANGER FOR PROD, WILL DESTROY INFRASTRUCTURE):

`terraform destroy`

**For extra security in staging:** update Terraform web_servers `main.tf` file to only allow ingress web_server connections from your IP / your team's IPs



## Contributing

This gem is currently not actively accepting contributions. 

With that in mind, if you'd like to make a fix / change, please create a pull request (and when I have a moment - probably in a couple weeks time - I'll have a look)!



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).