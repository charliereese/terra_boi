require "generators/extensions"

module TerraBoi
	class WebServersGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :id_rsa_pub, :class_options
	  class_option :domain_name, type: :string
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate staging and production terraform web server files
		  
		  To execute, run rails generate terra_boi:web_servers --domain_name example.com
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  	self.id_rsa_pub = open(ENV['HOME'] + "/.ssh/id_rsa.pub").read.chomp
	  	self.class_options = options
	  end

	  def create_main_terraform_file
	  	generate_terraform_files({
	  		template: 'web_servers_main.erb',
	  		file_path: 'web_servers/main.tf',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_output_terraform_file
	  	generate_terraform_files({
	  		template: 'web_servers_output.erb',
	  		file_path: 'web_servers/output.tf',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_user_data_terraform_file
	  	generate_terraform_files({
	  		template: 'web_servers_user_data.erb',
	  		file_path: 'web_servers/user-data.sh',
	  		env: ['staging', 'prod']
	  	})
	  end
	end
end