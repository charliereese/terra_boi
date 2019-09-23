require "generators/extensions"

module TerraBoi
	class DbConfigGenerator < Rails::Generators::Base
	  attr_accessor :application_name
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  Generate database.yml (default DB config)
		  
		  To execute, run rails generate terra_boi:db_config
		  EOF
	  	.gsub(/\t/, '')
	  )

	  def init
	  	# defined in lib/generators/extensions
	  	self.application_name = generate_application_name
	  end

	  def create_db_config_file
	  	template "db_config.erb", "config/database.yml"
	  end
	end
end