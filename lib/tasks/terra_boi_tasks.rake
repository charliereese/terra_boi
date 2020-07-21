desc """
Provision AWS infrastructure for your rails application from generated terraform code in terraform dir.

Creates RDS DBs, ALBs, ECRs, ECS clusters, services, and tasks, and various
security groups and other resources for each deployment env (default envs are staging and prod)

Before running this rake task you should have run something similar to:
rails g terra_boi:boilerplate -d DOMAIN.com -r 2.7.1 -e staging prod
"""
namespace :terra_boi do	
	task provision_infra: [:environment] do
		puts "TBU"
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