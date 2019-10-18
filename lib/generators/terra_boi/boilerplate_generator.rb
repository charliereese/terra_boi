module TerraBoi
	class BoilerplateGenerator < Rails::Generators::Base
		attr_accessor :application_name, :class_options
		class_option :ruby_version, type: :string, default: "2.5.1"
	  class_option :domain_name, type: :string, default: 'example.com'
	  source_root File.expand_path('templates', __dir__)

	  desc (<<-EOF
		  This generator runs the terra_boi web_servers, data, 
		  and state generators. It sets up all boilerplate 
		  terraform infrastructure needed for a standard web app: 
		  DB + load balancer + zero downtime, scalable web app 
		  launch config + S3 bucket.

		  To execute, run rails generate terra_boi:boilerplate --domain_name example.com
	 		EOF
	 		.gsub(/[\t]/, '')
	 	)

	 	def init
	  	self.class_options = options
	  	puts application_name
	  end

	  def run_other_generators
	  	generate "terra_boi:web_servers --domain_name #{class_options[:domain_name]}"
	  	generate "terra_boi:data"
	  	generate "terra_boi:state"
	  	generate "terra_boi:dockerfile --ruby_version #{class_options[:ruby_version]}"
	  	generate "terra_boi:host_initializer --domain_name #{class_options[:domain_name]}"
	  	generate "terra_boi:db_config"
	  	generate "terra_boi:data_config"
	  	generate "terra_boi:packer"
	  	generate "terra_boi:master_worker"
	  end

	end
end