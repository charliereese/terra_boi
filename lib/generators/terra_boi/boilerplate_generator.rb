module TerraBoi
	class BoilerplateGenerator < Rails::Generators::Base
		attr_accessor :application_name, :class_options
		class_option :ruby_version, type: :string, default: "2.7.1", aliases: ["r"]
		class_option :domain_name, type: :string, default: 'example.com', aliases: ["d"]
		class_option :envs, type: :array, default: ['staging', 'prod'], aliases: ["e"]
		source_root File.expand_path('templates', __dir__)

		desc (<<-EOF
			This generator runs the terra_boi web_servers, data, 
			and state generators. It sets up all boilerplate 
			terraform infrastructure needed for a standard web app: 
			DB + load balancer + zero downtime, scalable web app 
			launch config + S3 bucket.

			To execute, run rails g terra_boi:boilerplate --domain_name example.com --ruby_version 2.7.1 --envs staging prod

			OR

			rails g terra_boi:boilerplate --d example.com --r 2.7.1 -e staging prod

			Note: --ruby_version option is for base Dockerfile ruby image. Defaults to 2.7.1.
			EOF
			.gsub(/[\t]/, '')
		)

		def init
			self.class_options = options
			puts application_name
		end

		def run_other_generators
			generate "terra_boi:tf_cert -d #{class_options[:domain_name]}"
			generate "terra_boi:tf_ecr"
			generate "terra_boi:tf_lib -d #{class_options[:domain_name]}"
			generate "terra_boi:tf_env -e #{class_options[:envs].join(' ')} -d #{class_options[:domain_name]}"
			generate "terra_boi:tf_state"
			generate "terra_boi:dockerfile --ruby_version #{class_options[:ruby_version]}"
			generate "terra_boi:host_initializer -d #{class_options[:domain_name]}"
			generate "terra_boi:db_config"
			generate "terra_boi:data_config"
		end

	end
end