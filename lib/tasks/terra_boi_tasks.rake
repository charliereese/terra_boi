require 'colorize'

desc """
Generate terraform (AWS) infrastructure code for your rails application.

Creates infrastructure code for RDS DBs, ALBs, ECRs, ECS clusters, services, 
and tasks, and various security groups and other resources for each 
deployment environment (e.g. staging and prod)
"""
namespace :terra_boi do	
	task generate_infra: [:environment] do
		# create_boilerplate_files
		# apply_terraform_state
		apply_terraform_cert
	end
end

desc """
Deploy your rails application.

Usage:
rake terra_boi:deploy[ENV]
e.g. rake \"terra_boi:deploy[staging]\"

Takes one arg:
arg 1: env (i.e. staging or prod)
"""
task :deploy, [:env] => [:environment] do |task, args|
	puts "test"
	puts "#{args[:env]}"
end

# ---------------------------------
# Helper methods
# ---------------------------------

def create_boilerplate_files
	config = {}

	puts "\nGenerating boilerplate infrastructure as code with terra_boi for your rails project...\n".green.bold
	sleep 1
	config[:ruby_version] = get_ruby_docker_base_image
	sleep 1
	config[:domain_name] = get_domain_name 
	sleep 1

	puts "\nRad. Generating infrastructure code using the configuration you provided...\n".green.bold
	sleep 1

	sh "rails g terra_boi:boilerplate -d #{config[:domain_name]} -r #{config[:ruby_version]}"

	sleep 1
	puts "\nMarking deployment scripts executable...\n".bold
	sh "chmod +x ./terraform/lib/scripts/*"
end

def apply_terraform_state
	puts "\nCreating terraform state...\n".green.bold
	sh "cd terraform/state && terraform init && terraform apply"
end

def apply_terraform_cert
	puts "\nCreating HTTPS certificate in AWS Certificate Manager...\n".green.bold
	sh "cd terraform/cert && terraform init"

	print_certificate_validation_instructions
	sleep 2
	sh "cd terraform/cert && terraform apply"
	confirm_certificate_successfully_validated
end

# ---------------------------------
# Helper^2 methods
# ---------------------------------

def print_certificate_validation_instructions
	puts "\nCertificate validation instructions:".red
	puts "1) Log into AWS Console and go to AWS Certificate Manager (default region is us-east-2)"
	puts "2) Expand issued certificate for your domain, and find CNAME record for domain validation"
	puts "3) Add CNAME record listed for your domain to your domain's DNS records (i.e. log into where you purchased your domain and add CNAME record to it)\n\n"
end

def confirm_certificate_successfully_validated
	answer = ''
	until answer == 'y'
		print "Question 3: ".red
		puts "Has your HTTPS / SSL certificate successfully validated (in AWS Console - AWS Certificate Manager)?"
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

	puts "\nCool! Setting #{domain_name} as your domain_name.\n".bold
	return domain_name
end