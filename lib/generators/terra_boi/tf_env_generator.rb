require "generators/extensions"

module TerraBoi
	class TfEnvGenerator < Rails::Generators::Base
		attr_accessor :application_name, :class_options
		class_option :envs, type: :array, default: ['staging', 'prod'], aliases: ["e"]
		class_option :domain_name, type: :string, default: 'example.com', aliases: ["d"]
		source_root File.expand_path('templates', __dir__)

		TEMPLATES = {
			ecs_cluster: [
				"ecs_cluster.tf",
			],
			head_worker: [
				"ecs.tf",
			],
			web_app: [
				"ecs.tf",
			],
			data: [
				"main.tf",
				"output.tf",
			]
		}

		desc (<<-EOF
			Generate ecs directory (with cluster, web app service and head worker service) for each env
			
			To execute, run rails generate terra_boi:tf_ecs

			Note: use -e or --env flag to specify list of infrastructure environments. Defaults to staging and prod
			EOF
			.gsub(/\t/, '')
		)

		def init
			# defined in lib/generators/extensions
			self.application_name = generate_application_name
			self.class_options = options
		end

		def create_ecs
			class_options[:envs].each do |env|
				TEMPLATES.each do |dir, file_arr|
					file_arr.each do |filename|
						template "env/#{dir}/#{filename}.erb", "terraform/#{env}/#{dir}/#{filename}", {
							env: env,
						}
					end
				end
			end
		end
	end
end