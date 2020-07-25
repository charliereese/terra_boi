require 'colorize'

desc """
Generate terraform (AWS) infrastructure code for your rails application.

Creates infrastructure code for RDS DBs, ALBs, ECRs, ECS clusters, services, 
and tasks, and various security groups and other resources for each 
deployment environment (e.g. staging and prod)
"""
namespace :terra_boi do	
	task generate_infra: [:environment] do
		# Do steps in README for each env
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

# Helper methods

def get_ruby_docker_base_image
	print "Question 1: ".red
	puts "Which ruby Docker base image would you like to use (https://hub.docker.com/_/ruby/)?"
	puts "Recommended answer: 2.7.1"
	
	ruby_docker_base_image = ""
	until ruby_docker_base_image.length > 0
		print "==> ".red
		ruby_docker_base_image = STDIN.gets.gsub(/[^0-9\.]/, "")
	end

	puts "\nGreat! Using #{ruby_docker_base_image} as the base Docker image for your infrastructure.\n".bold
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