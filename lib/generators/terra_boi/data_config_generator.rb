require "generators/extensions"

module TerraBoi
	class DataConfigGenerator < Rails::Generators::Base
	  attr_accessor :application_name
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate storage.yml (default S3 config)
		  
		  To execute, run rails generate terra_boi:data_config
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  end

	  def create_data_config_file
	  	template "data_storage_config.erb", "config/storage.yml"
	  end
	end
end