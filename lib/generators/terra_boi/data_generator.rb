require "generators/extensions"

module TerraBoi
	class DataGenerator < Rails::Generators::Base
	  attr_accessor :application_name, :class_options
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate staging and production DB and S3 bucket
		  
		  To execute, run rails generate terra_boi:data
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  	self.class_options = options
	  end

	  def create_main_terraform_file
	  	generate_terraform_files({
	  		template: 'data_main.erb',
	  		file_path: 'data/main.tf',
	  		env: ['staging', 'prod']
	  	})
	  end

	  def create_output_terraform_file
	  	generate_terraform_files({
	  		template: 'data_output.erb',
	  		file_path: 'data/output.tf',
	  		env: ['staging', 'prod']
	  	})
	  end
	end
end