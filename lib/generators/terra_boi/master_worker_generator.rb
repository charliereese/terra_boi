require "generators/extensions"
require 'fileutils'

module TerraBoi
	class MasterWorkerGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :id_rsa_pub, :class_options
	  class_option :domain_name, type: :string
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate staging and production terraform master worker server files
		  
		  To execute, run rails generate terra_boi:master_worker
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  	self.id_rsa_pub = open(ENV['HOME'] + "/.ssh/id_rsa.pub").read.chomp
	  end

	  def create_main_terraform_file
	  	generate_terraform_files({
	  		template: 'master_worker_main.erb',
	  		file_path: 'master_worker/main.tf',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_output_terraform_file
	  	generate_terraform_files({
	  		template: 'master_worker_output.erb',
	  		file_path: 'master_worker/output.tf',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_user_data_terraform_file
	  	generate_terraform_files({
	  		template: 'master_worker_user_data.erb',
	  		file_path: 'master_worker/user-data.sh',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_master_worker_docker_entrypoint_script
	  	filename = "scripts/start_master_worker.sh"
	  	template "master_worker_start_script.erb", filename
			FileUtils.chmod 0755, filename 	
	  end
	end
end