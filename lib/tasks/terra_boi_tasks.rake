require 'colorize'

namespace :terra_boi do	
	desc """
	Generate terraform (AWS) infrastructure code for your rails application.

	Creates infrastructure code for RDS DBs, ALBs, ECRs, ECS clusters, services, 
	and tasks, and various security groups and other resources for each 
	deployment environment (e.g. staging and prod)

	Usage without ENVS arg (creates staging and prod envs by default):
	rake \"terra_boi:generate_infra\"

	Usage with ENVS arg:
	rake \"terra_boi:generate_infra[ENV1 ENV2 ENVn]\"
	e.g. rake \"terra_boi:generate_infra[dev staging prod]\"

	Takes one optional arg:
	arg 1: envs (default value: staging prod)
	"""
	task :generate_infra, [:envs] => [:environment] do |_, args|
		ENVS = get_envs(args)

		create_boilerplate_files
		apply_terraform_state
		apply_terraform_cert
		apply_ecr
		apply_data
		push_container_to_ecr
		apply_web_app_and_worker
		puts_urls_for_alb
		puts_how_to_connect_domain_and_load_balancer
		puts_twitter_plug
	end

	desc """
	Destroy terraform (AWS) infrastructure code for your rails application.

	Usage without ENVS arg (creates staging and prod envs by default):
	rake \"terra_boi:destroy_infra\"

	Usage with ENVS arg:
	rake \"terra_boi:destroy_infra[ENV1 ENV2 ENVn]\"
	e.g. rake \"terra_boi:destroy_infra[dev staging prod]\"

	Takes one optional arg:
	arg 1: envs (default value: staging prod)
	"""
	task :destroy_infra, [:envs] => [:environment] do |_, args|
		ENVS = get_envs(args)
		
		ENVS.each do |env|	
			puts "\nDestroying application infrastructure for #{env}...\n".cyan.bold
			
			directories = [:head_worker, :web_app, :ecs_cluster, :data]
			directories.each do |dir_name|
				sh "cd terraform/#{env}/#{dir_name} && terraform destroy"
			end
		end

		sh "cd terraform/ecr && terraform destroy"
		sh "cd terraform/cert && terraform destroy"
		sh "cd terraform/state && terraform destroy"
	end
end

desc """
Deploy your rails application.

By default, deploys to staging and prod.

Usage without ENVS arg (deploys to staging and prod envs by default):
rake \"terra_boi:deploy\"

Usage with ENVS arg:
rake \"terra_boi:deploy[ENV1 ENV2 ENVn]\"
e.g. rake \"terra_boi:deploy[staging prod]\"

Takes one arg:
arg 1: envs (default value: staging prod)
"""
task :deploy, [:envs] => [:environment] do |task, args|
	ENVS = get_envs(args)
	puts "\nDeploying rails application to #{ENVS.to_sentence} infrastructure\n".cyan.bold

	conditional_push_container_to_ecr
	
	ENVS.each do |env|		
		ecs_tasks = [:web_app, :head_worker]
		ecs_tasks.each do |task_name|
			puts "\nDeploying #{env} #{task_name} task\n".cyan.bold
			sh "./terraform/lib/scripts/update_service_pull_from_ecr.sh #{env} #{task_name}"
		end
	end
end

# ---------------------------------
# Helper methods
# ---------------------------------

def get_envs(args)
	if args[:envs]
		args[:envs].split(' ')
	else
		[:staging, :prod]
	end
end

def create_boilerplate_files
	config = {}

	puts "\nGenerating boilerplate infrastructure as code with terra_boi for your rails project...\n".cyan.bold
	sleep 1
	config[:ruby_version] = get_ruby_docker_base_image
	sleep 1
	config[:domain_name] = get_domain_name 
	sleep 1

	puts "\nGenerating infrastructure code using the configuration you provided...\n".cyan.bold
	sleep 1

	sh "rails g terra_boi:boilerplate -d #{config[:domain_name]} -r #{config[:ruby_version]}"

	sleep 1
	puts "\nMarking deployment scripts executable...\n".bold
	sh "chmod +x ./terraform/lib/scripts/*"
end

def apply_terraform_state
	puts "\nCreating terraform state...\n".cyan.bold
	sh "cd terraform/state && terraform init && terraform apply"
end

def apply_terraform_cert
	puts "\nCreating HTTPS certificate in AWS Certificate Manager...\n".cyan.bold
	sh "cd terraform/cert && terraform init"

	print_certificate_validation_instructions
	sleep 2
	sh "cd terraform/cert && terraform apply"
	confirm_certificate_successfully_validated
end

def apply_data
	ENVS.each do |env|
		puts "\nCreating RDS DB instance and S3 bucket for #{env}...\n".cyan.bold
		sh "cd terraform/#{env}/data && terraform init && terraform apply"
	end
end

def apply_ecr
	puts "\nCreating AWS ECR (Elastic Container Registry) for your application's docker images...\n".cyan.bold
	sh "cd terraform/ecr && terraform init && terraform apply"
end

def push_container_to_ecr
	puts "\nBuilding application docker container then pushing to ECR...\n".cyan.bold
	sh "./terraform/lib/scripts/push_to_ecr.sh" do |ok, res|
		if !ok
			puts "\nDocker container build and push failed (status = #{res.exitstatus})".cyan.bold
			puts "\nPruning docker (to create more memory) and retrying...\n".cyan.bold
			sh "docker system prune -a && ./terraform/lib/scripts/push_to_ecr.sh"
		end
	end
end

def apply_web_app_and_worker
	directories = [:ecs_cluster, :web_app, :head_worker]
	ENVS.each do |env|	
		puts "\nBuilding web app and worker ECS infrastructure for #{env}...\n".cyan.bold
		directories.each do |dir_name|
			sh "cd terraform/#{env}/#{dir_name} && terraform init && terraform apply"
		end
	end
end

def puts_urls_for_alb
	ENVS.each do |env|
		url = `cd terraform/#{env}/web_app && terraform output alb_dns`
		puts "\nPublic application load balancer URL for #{env}:".cyan.bold
		puts "#{env} alb_dns: #{url}"
	end
end

def puts_how_to_connect_domain_and_load_balancer
	puts "\nGIDDY UP! TERRA_BOI HAS FINISHED CREATING INFRASTRUCTURE FOR YOUR RAILS APPLICATION!\n".cyan.bold

	puts "\nTo connect your domain name to your application's new AWS infrastructure:".red
	puts "1) Go to your domain register (e.g. Namecheap)"
	puts "2) Add the alb_dns output value (i.e. the public URL for your load balancer) to your domain's DNS records. alb_dns public URL values are output above"
	puts """E.g. to redirect staging.YOUR_DOMAIN_NAME to the load balancer you just deployed, add the following record to your DNS records: 
	TYPE: ALIAS
	HOST: staging
	VALUE: alb_dns output value (something like app-staging-725123955.us-east-2.elb.amazonaws.com)"""

	puts "\nNote: you can have multiple ALIAS records for different subdomains\n"
end

def puts_twitter_plug
	puts "\nLet me know what you think about terra_boi on Twitter @charlieinthe6!".cyan.bold
end

def conditional_push_container_to_ecr
	print "Question: ".red
	puts "Build and push container updates to ECR first (y/n)?"
	puts "Answer y if you haven't built and pushed most recent updates to ECR yet."
	puts "...and answer y if you aren't sure."
	print "==> ".red
	answer = STDIN.gets.downcase.gsub(/[^yn]/, "")

	push_container_to_ecr if answer == 'y'
end

# ---------------------------------
# Helper^2 methods
# ---------------------------------

def print_certificate_validation_instructions
	puts "\nCertificate validation instructions:".red
	puts "1) Log into AWS Console and go to AWS Certificate Manager (default region is us-east-2)"
	puts "2) Expand issued certificate for your domain, and find CNAME record for domain validation"
	puts "3) Add CNAME record listed for your domain to your domain's DNS records (i.e. log into where you purchased your domain and add CNAME record to it)\n\n"
	puts "NOTE: the Host field for your CNAME record will be something like _123f2cc99f15298ff717ac26dd6993. The Value field for your CNAME record will be something like _bf123a01234a134123412341324.dasfjkhasd.acm-validation.aws.\n\n".bold
end

def confirm_certificate_successfully_validated
	answer = ''
	until answer == 'y'
		print "Question 3: ".red
		puts "Has your HTTPS / SSL certificate successfully validated in AWS Console - AWS Certificate Manager (y/n)?"
		print "==> ".red
		answer = STDIN.gets.downcase.gsub(/[^yn]/, "")
		
		if answer == 'y' 
			next
		else
			print_certificate_validation_instructions
			sleep 5
		end
	end
end

def get_ruby_docker_base_image
	print "Question 1: ".red
	puts "Do you want to use the default ruby Docker base image 2.7.1 (y/n)?"
	print "==> ".red
	answer = STDIN.gets.downcase.gsub(/[^yn]/, "")

	if answer == 'y'
		ruby_docker_base_image = "2.7.1"
	else
		ruby_docker_base_image = ""
		print "\nQuestion 1 follow-up: ".red
		puts "Which ruby Docker base image would you like to use (https://hub.docker.com/_/ruby/)?"
		puts "Recommended answer: 2.7.1"
		
		until ruby_docker_base_image.length > 0
			print "==> ".red
			ruby_docker_base_image = STDIN.gets.gsub(/[^0-9\.]/, "")
		end
	end

	puts "\nGreat! Using #{ruby_docker_base_image} as the base Docker image for your infrastructure.".bold
	return ruby_docker_base_image
end

def get_domain_name
	print "\nQuestion 2: ".red
	puts "What domain name will you be using for your project?"
	puts "E.g. example.com (do not include a subdomain or 'www')"
	
	domain_name = ""
	until domain_name.length > 2
		print "==> ".red
		domain_name = STDIN.gets.chomp
	end

	puts "\nRad! Setting #{domain_name} as your domain_name.".bold
	return domain_name
end