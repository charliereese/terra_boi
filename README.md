# TerraBoi

## Introduction

This ruby / rails gem was created by [Charlie Reese](https://charliereese.ca/about) for [Clientelify](https://clientelify.com). It creates AWS infrastructure for your rails application and deploys it in 5 steps (3 installation steps and 2 rake tasks). It is free to use.

Out of the box, terra_boi provides remote state locking, load-balancing, simple scaling, zero-downtime deployments, CloudWatch logging, DBs, and S3 buckets for multiple infrastructure environments: by default, terra_boi creates staging and prod environments for your web app.


## Installation

#### Installation A: pre-requisites

* [Terraform](https://www.terraform.io/) installed on your computer
* [Amazon Web Services (AWS) account](http://aws.amazon.com/)
* [AWS access key and secret key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) (to be used below shortly)
* Rails ~> 6.0

#### Installation B: install ruby gems

Add these lines to your (Rails) application's Gemfile:

```ruby
group :development do
	gem 'terra_boi'
end

gem 'pg' # Postgresql
gem 'whenever', require: false # For cron jobs set in config/schedule.rb
```

And then execute:

```bash
$ bundle && bundle exec wheneverize .
```

#### Installation C: set environment variables

Set and export terraform AWS and data-related environment variables in ~/.zprofile (or your respective shell dotfile e.g. ~/.bashrc)

```
TF_VAR_db_password=your_password # whatever you want it to be
TF_VAR_db_username=your_username # whatever you want it to be
export TF_VAR_db_password TF_VAR_db_username 

AWS_ACCESS_KEY=your_access_key
TF_VAR_aws_access_key=$AWS_ACCESS_KEY
export AWS_ACCESS_KEY TF_VAR_aws_access_key

AWS_SECRET_KEY=your_secret_access_key
TF_VAR_aws_secret_key=$AWS_SECRET_KEY
export AWS_SECRET_KEY TF_VAR_aws_secret_key
```

After you've set and export the above environment variables, run `source ~/.zprofile` (or source your respective shell dotfile).

#### Installation D: recommendations

- Uncomment `config.force_ssl = true` in `config/environments/production.rb` file.


## Usage

#### Usage A: generate infrastructure rake task

```
rake terra_boi:generate_infra
```

Note: the above rake task takes an optional argument for environments (e.g. `rake \"terra_boi:generate_infra[dev staging prod]\"`). Infrastructure environments default to staging and prod.

Note: this command will also deploy your application after infrastructure has been created. If you only wish to deploy an update, use the below command.

#### Usage B: deploy application updates rake task

```
rake deploy

# Alternatively: rake "deploy[staging]", rake "deploy[staging prod]", etc.
```

Note: the above rake task takes an optional argument for environments (e.g. `rake \"deploy[staging prod]\"`). By default, it will deploy to staging then prod infrastructure.

## Infrastructure customization

Because terra_boi uses Terraform modules, small customizations can be made by changing variables in .tf files. 

For example, if you wanted to run 10 web app instances behind the load balancer in your prod environment (instead of the default 2), you could change the web_app_task => desired_count argument from 2 to 10 in the file `terraform/prod/web_app/ecs.tf`. Similarly, if your web app task container requires more memory, you could change the web_app_task => memory argument in the file `terraform/prod/web_app/ecs.tf`.

**Note**: if your rails application has more advanced infrastructure customization needs (e.g. Redis / Solr instances), you may add the resources required to the Terraform files created by terra_boi.

## Appendix

#### Appendix - infrastructure / code generated by terra_boi

- AWS Elastic Container Registry (ECR)
- AWS Application Load Balancer (ALB)
- AWS Elastic Container Services (for your web app and worker)
- AWS Fargate tasks (for your web app and worker)
- AWS CloudWatch logging
- AWS Security Groups
- AWS DynamoDB for remote state locking 
- AWS RDS Postgresql DBs
- Rails DB config file
- Rails data config file
- Rails initializer file (for setting up config.hosts)
- Dockerfile
- HTTPS / SSL certificate

#### Appendix - destroying your infrastructure

To destroy infrastructure created by terra_boi, run `terraform destroy` in the following directories in the following order:

- terraform/ENV/head_worker
- terraform/ENV/web_app
- terraform/ENV/ecs_cluster
- terraform/ENV/data
- terraform/ecr
- terraform/cert
- terraform/state

OR 

```
rake terra_boi:destroy_infra
```

Note: the above rake task takes an optional argument for environments (e.g. `rake \"terra_boi:destroy_infra[dev staging prod]\"`). Infrastructure environments default to staging and prod.

#### Appendix - license

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

#### Appendix - contributing

If you'd like to make a fix / change, please create a pull request! When I have a moment, I'll have a look!

Recommended contribution: terraform infrastructure generation testing

#### Appendix - other tips

**Something didn't work and you aren't sure why?** If you're running `rake terra_boi:generate_infra`, try running it again. Sometimes Terraform / the AWS API will throw sporadic errors without reason!

**For extra security in staging / internal applications:** update Terraform security groups to only allow ingress web_app connections from your team's IP addresses

#### Appendix - updating gem version (for maintainers)

**1. Update version**

In `lib/terra_boi/version.rb` update version.

**2. Build gem**

`gem build terra_boi.gemspec`

**3. Push gem**

`gem push terra_boi-X.X.X.gem` (replace X's with version)

**4. Tag GitHub**

`git add -A`
`git commit -m "Msg"`
`git tag -a vX.X.X -m "Msg"`
`git push && git push --tags`